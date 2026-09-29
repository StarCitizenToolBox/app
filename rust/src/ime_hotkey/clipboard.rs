//! Clipboard handling for the paste.
//!
//! The previous content is saved and restored inside single OpenClipboard sessions
//! (clipboard-rs reopens the clipboard per image and silently drops the other formats).
//!
//! The chat text is offered with delayed rendering: the popup window renders it on
//! `WM_RENDERFORMAT`, which tells the sender that the game has actually read it. The previous
//! content is only restored after that (or a timeout), so a stalled game cannot paste the
//! user's old clipboard into the chat.

use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Mutex;
use std::time::{Duration, Instant};

use windows::core::PCWSTR;
use windows::Win32::Foundation::{GlobalFree, HANDLE, HGLOBAL, HWND};
use windows::Win32::Graphics::Gdi::{CopyEnhMetaFileW, DeleteEnhMetaFile, HENHMETAFILE};
use windows::Win32::System::DataExchange::{
    CloseClipboard, EmptyClipboard, EnumClipboardFormats, GetClipboardData, GetClipboardOwner,
    GetOpenClipboardWindow, OpenClipboard, RegisterClipboardFormatW, SetClipboardData,
};
use windows::Win32::System::Memory::{GlobalAlloc, GlobalLock, GlobalSize, GlobalUnlock, GMEM_MOVEABLE};
use windows::Win32::UI::WindowsAndMessaging::{GetWindowThreadProcessId, IsWindow};

const CF_UNICODETEXT: u32 = 13;
const CF_ENHMETAFILE: u32 = 14;

/// Formats whose data is not an HGLOBAL (GDI / metafile handles, owner display, private
/// handles) or that Windows synthesizes from another saved format (CF_TEXT and CF_OEMTEXT from
/// CF_UNICODETEXT, CF_BITMAP / CF_PALETTE from CF_DIB, CF_METAFILEPICT from CF_ENHMETAFILE).
/// CF_ENHMETAFILE itself is copied separately.
fn is_memory_format(format: u32) -> bool {
    !matches!(
        format,
        1 // CF_TEXT
            | 2 // CF_BITMAP
            | 3 // CF_METAFILEPICT
            | 7 // CF_OEMTEXT
            | 9 // CF_PALETTE
            | CF_ENHMETAFILE
            | 0x80 // CF_OWNERDISPLAY
            | 0x82 // CF_DSPBITMAP
            | 0x83 // CF_DSPMETAFILEPICT
            | 0x8E // CF_DSPENHMETAFILE
    ) && !(0x200..=0x3FF).contains(&format) // CF_PRIVATEFIRST..CF_GDIOBJLAST
}

struct Opened;

impl Opened {
    /// The owner must be a window: with no owner EmptyClipboard makes SetClipboardData fail.
    fn open(owner: HWND, attempts: u32) -> Option<Self> {
        for _ in 0..attempts {
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

/// Requires the clipboard to be open (or a `WM_RENDERFORMAT` in progress).
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

enum Saved {
    Memory(u32, Vec<u8>),
    /// Our own copy; handed to the clipboard on restore, deleted if never restored.
    EnhMetaFile(HENHMETAFILE),
}

impl Drop for Saved {
    fn drop(&mut self) {
        if let Saved::EnhMetaFile(emf) = self {
            if !emf.is_invalid() {
                unsafe {
                    let _ = DeleteEnhMetaFile(Some(*emf));
                }
            }
        }
    }
}

fn write_saved(saved: &mut [Saved]) {
    for item in saved.iter_mut() {
        match item {
            Saved::Memory(format, bytes) => {
                write_global(*format, bytes);
            }
            Saved::EnhMetaFile(emf) => {
                if unsafe { SetClipboardData(CF_ENHMETAFILE, Some(HANDLE(emf.0))) }.is_ok() {
                    // Owned by the clipboard now.
                    *emf = HENHMETAFILE::default();
                }
            }
        }
    }
}

/// The chat text waiting for `WM_RENDERFORMAT` (UTF-16 with terminator, as bytes).
struct PendingRender {
    bytes: Vec<u8>,
    /// Process that has to read the text for it to count as pasted.
    target_pid: u32,
}

static PENDING_RENDER: Mutex<Option<PendingRender>> = Mutex::new(None);
static RENDERED: AtomicBool = AtomicBool::new(false);

fn lock_render() -> std::sync::MutexGuard<'static, Option<PendingRender>> {
    PENDING_RENDER.lock().unwrap_or_else(|e| e.into_inner())
}

/// `WM_RENDERFORMAT` on the owner window (the clipboard is already open by the reader).
pub(crate) fn on_render_format(format: u32) {
    if format != CF_UNICODETEXT {
        return;
    }
    let pending = lock_render();
    let Some(render) = pending.as_ref() else {
        return;
    };
    if !write_global(CF_UNICODETEXT, &render.bytes) {
        return;
    }
    // Only the game reading it means the paste went through; anything else (a clipboard
    // viewer ignoring the exclusion flags) just gets the text.
    let reader = unsafe { GetOpenClipboardWindow() }.unwrap_or_default();
    let mut reader_pid = 0u32;
    if !reader.is_invalid() {
        unsafe { GetWindowThreadProcessId(reader, Some(&mut reader_pid)) };
    }
    if reader_pid == 0 || reader_pid == render.target_pid {
        RENDERED.store(true, Ordering::SeqCst);
    }
}

/// `WM_RENDERALLFORMATS`: the owner window is being destroyed while still owning the text.
pub(crate) fn on_render_all_formats(owner: HWND) {
    let Some(_opened) = Opened::open(owner, 10) else {
        return;
    };
    if unsafe { GetClipboardOwner() }.ok() == Some(owner) {
        if let Some(render) = lock_render().as_ref() {
            write_global(CF_UNICODETEXT, &render.bytes);
        }
    }
}

/// The clipboard content from before the paste; put back with [`ClipboardSnapshot::restore`].
pub(crate) struct ClipboardSnapshot {
    owner: HWND,
    saved: Vec<Saved>,
}

// HWND / HENHMETAFILE are only passed back to user32 / gdi32.
unsafe impl Send for ClipboardSnapshot {}

impl ClipboardSnapshot {
    /// Saves the clipboard and offers `text` in its place (delay rendered by `owner`). `None`
    /// when the clipboard could not be opened or written; the previous content is then left (or
    /// put back) as it was.
    pub(crate) fn replace_with_text(owner: HWND, target_pid: u32, text: &str) -> Option<Self> {
        let _opened = Opened::open(owner, 10)?;
        let mut saved = Vec::new();
        let mut format = 0;
        loop {
            format = unsafe { EnumClipboardFormats(format) };
            if format == 0 {
                break;
            }
            if format == CF_ENHMETAFILE {
                if let Ok(handle) = unsafe { GetClipboardData(format) } {
                    let copy = unsafe { CopyEnhMetaFileW(HENHMETAFILE(handle.0), PCWSTR::null()) };
                    if !copy.is_invalid() {
                        saved.push(Saved::EnhMetaFile(copy));
                    }
                }
            } else if is_memory_format(format) {
                if let Some(bytes) = unsafe { GetClipboardData(format) }.ok().and_then(read_global) {
                    saved.push(Saved::Memory(format, bytes));
                }
            }
        }
        unsafe { EmptyClipboard() }.ok()?;

        let units: Vec<u16> = text.encode_utf16().chain(std::iter::once(0)).collect();
        *lock_render() = Some(PendingRender {
            bytes: units.iter().flat_map(|u| u.to_le_bytes()).collect(),
            target_pid,
        });
        RENDERED.store(false, Ordering::SeqCst);
        // No data: rendered by `owner` on WM_RENDERFORMAT.
        if unsafe { SetClipboardData(CF_UNICODETEXT, None) }.is_err() {
            *lock_render() = None;
            write_saved(&mut saved);
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
        Some(Self { owner, saved })
    }

    /// Waits until the game has read the text, up to `timeout`. Returns whether it did.
    pub(crate) fn wait_read(&self, timeout: Duration) -> bool {
        let started = Instant::now();
        while !RENDERED.load(Ordering::SeqCst) {
            if started.elapsed() >= timeout {
                return false;
            }
            std::thread::sleep(Duration::from_millis(10));
        }
        true
    }

    /// Puts the saved content back (an empty snapshot empties the clipboard again). `fallback`
    /// is used as owner when the original window is gone (quick input restarted meanwhile).
    pub(crate) fn restore(mut self, fallback: HWND) {
        let owner = if unsafe { IsWindow(Some(self.owner)) }.as_bool() {
            self.owner
        } else {
            fallback
        };
        // The sender is a background thread: wait up to ~2 s for another app to let go.
        let opened = if owner.is_invalid() { None } else { Opened::open(owner, 200) };
        if opened.is_some() && unsafe { EmptyClipboard() }.is_ok() {
            write_saved(&mut self.saved);
            *lock_render() = None;
        } else {
            // Keep the text renderable: the clipboard still offers it.
            println!("[ime_hotkey] could not restore the clipboard");
        }
    }
}
