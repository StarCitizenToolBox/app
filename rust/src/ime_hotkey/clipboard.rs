//! Clipboard snapshot for the paste: the previous content is saved and restored inside single
//! OpenClipboard sessions (clipboard-rs reopens the clipboard per image and silently drops the
//! other formats).

use std::time::Duration;

use windows::core::PCWSTR;
use windows::Win32::Foundation::{GlobalFree, HANDLE, HGLOBAL, HWND};
use windows::Win32::System::DataExchange::{
    CloseClipboard, EmptyClipboard, EnumClipboardFormats, GetClipboardData, OpenClipboard,
    RegisterClipboardFormatW, SetClipboardData,
};
use windows::Win32::System::Memory::{GlobalAlloc, GlobalLock, GlobalSize, GlobalUnlock, GMEM_MOVEABLE};

const CF_UNICODETEXT: u32 = 13;

/// Formats whose data is not an HGLOBAL (GDI / metafile handles, owner display, private
/// handles) or that Windows synthesizes from another saved format (CF_TEXT, CF_OEMTEXT).
fn is_copyable(format: u32) -> bool {
    !matches!(
        format,
        1 // CF_TEXT
            | 2 // CF_BITMAP
            | 3 // CF_METAFILEPICT
            | 7 // CF_OEMTEXT
            | 9 // CF_PALETTE
            | 14 // CF_ENHMETAFILE
            | 0x80 // CF_OWNERDISPLAY
            | 0x82 // CF_DSPBITMAP
            | 0x83 // CF_DSPMETAFILEPICT
            | 0x8E // CF_DSPENHMETAFILE
    ) && !(0x200..=0x3FF).contains(&format) // CF_PRIVATEFIRST..CF_GDIOBJLAST
}

struct Opened;

impl Opened {
    /// The owner must be a window: with no owner EmptyClipboard makes SetClipboardData fail.
    fn open(owner: HWND) -> Option<Self> {
        for _ in 0..10 {
            if unsafe { OpenClipboard(Some(owner)) }.is_ok() {
                return Some(Self);
            }
            std::thread::sleep(Duration::from_millis(10));
        }
        None
    }
}

impl Drop for Opened {
    fn drop(&mut self) {
        unsafe {
            let _ = CloseClipboard();
        }
    }
}

fn read_global(handle: HANDLE) -> Option<Vec<u8>> {
    let global = HGLOBAL(handle.0);
    unsafe {
        let size = GlobalSize(global);
        let ptr = GlobalLock(global);
        if size == 0 || ptr.is_null() {
            return None;
        }
        let bytes = std::slice::from_raw_parts(ptr as *const u8, size).to_vec();
        let _ = GlobalUnlock(global);
        Some(bytes)
    }
}

fn write_global(format: u32, bytes: &[u8]) -> bool {
    unsafe {
        let Ok(global) = GlobalAlloc(GMEM_MOVEABLE, bytes.len().max(1)) else {
            return false;
        };
        let ptr = GlobalLock(global);
        if ptr.is_null() {
            let _ = GlobalFree(Some(global));
            return false;
        }
        std::ptr::copy_nonoverlapping(bytes.as_ptr(), ptr as *mut u8, bytes.len());
        let _ = GlobalUnlock(global);
        // On success the clipboard owns the memory.
        if SetClipboardData(format, Some(HANDLE(global.0))).is_err() {
            let _ = GlobalFree(Some(global));
            return false;
        }
        true
    }
}

fn write_all(formats: &[(u32, Vec<u8>)]) {
    for (format, bytes) in formats {
        write_global(*format, bytes);
    }
}

/// The clipboard content from before the paste; put back with [`ClipboardSnapshot::restore`].
pub(crate) struct ClipboardSnapshot {
    owner: HWND,
    formats: Vec<(u32, Vec<u8>)>,
}

// HWND is only passed back to user32.
unsafe impl Send for ClipboardSnapshot {}

impl ClipboardSnapshot {
    /// Saves the clipboard and replaces it with `text`. `None` when the clipboard could not be
    /// opened or written; the previous content is then left (or put back) as it was.
    pub(crate) fn replace_with_text(owner: HWND, text: &str) -> Option<Self> {
        let _opened = Opened::open(owner)?;
        let mut formats = Vec::new();
        let mut format = 0;
        loop {
            format = unsafe { EnumClipboardFormats(format) };
            if format == 0 {
                break;
            }
            if !is_copyable(format) {
                continue;
            }
            if let Some(bytes) = unsafe { GetClipboardData(format) }.ok().and_then(read_global) {
                formats.push((format, bytes));
            }
        }
        unsafe { EmptyClipboard() }.ok()?;
        let units: Vec<u16> = text.encode_utf16().chain(std::iter::once(0)).collect();
        let text_bytes: Vec<u8> = units.iter().flat_map(|u| u.to_le_bytes()).collect();
        if !write_global(CF_UNICODETEXT, &text_bytes) {
            write_all(&formats);
            return None;
        }
        // Keep the pasted chat line out of clipboard history, cloud clipboard and managers.
        for name in [
            windows::core::w!("ExcludeClipboardContentFromMonitorProcessing"),
            windows::core::w!("CanIncludeInClipboardHistory"),
            windows::core::w!("CanUploadToCloudClipboard"),
        ] {
            let id = unsafe { RegisterClipboardFormatW(PCWSTR(name.as_ptr())) };
            if id != 0 {
                write_global(id, &0u32.to_le_bytes());
            }
        }
        Some(Self { owner, formats })
    }

    /// Puts the saved content back (an empty snapshot empties the clipboard again).
    pub(crate) fn restore(self) {
        let Some(_opened) = Opened::open(self.owner) else {
            return;
        };
        if unsafe { EmptyClipboard() }.is_ok() {
            write_all(&self.formats);
        }
    }
}
