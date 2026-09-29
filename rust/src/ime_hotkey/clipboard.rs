//! Clipboard handling for the paste.
//!
//! The previous content is saved and restored inside single OpenClipboard sessions
//! (clipboard-rs reopens the clipboard per image and silently drops the other formats).
//!
//! The chat text is offered with delayed rendering: the popup window renders it on
//! `WM_RENDERFORMAT`, which tells the sender that the game has actually read it. The previous
//! content is only restored after that (or a timeout), so a stalled game cannot paste the
//! user's old clipboard into the chat.

use std::sync::atomic::{AtomicU32, AtomicU64, AtomicU8, Ordering};
use std::sync::Mutex;
use std::time::{Duration, Instant};

use windows::core::{w, PCWSTR};
use windows::Win32::Foundation::{GlobalFree, HANDLE, HGLOBAL, HWND};
use windows::Win32::Graphics::Gdi::{CopyEnhMetaFileW, DeleteEnhMetaFile, HENHMETAFILE};
use windows::Win32::System::DataExchange::{
    CloseClipboard, EmptyClipboard, EnumClipboardFormats, GetClipboardData, GetClipboardOwner,
    GetClipboardSequenceNumber, GetOpenClipboardWindow, IsClipboardFormatAvailable, OpenClipboard, RegisterClipboardFormatW,
    SetClipboardData,
};
use windows::Win32::System::Memory::{GlobalAlloc, GlobalLock, GlobalSize, GlobalUnlock, GMEM_MOVEABLE};
use windows::Win32::UI::WindowsAndMessaging::{
    CreateWindowExW, DestroyWindow, GetWindowThreadProcessId, IsWindow, HWND_MESSAGE,
    WINDOW_EX_STYLE, WINDOW_STYLE,
};

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

/// Invisible message-only window owned by the calling thread, used as clipboard owner for the
/// restore (the popup may be gone by then). Plain memory formats survive its destruction.
struct MessageWindow(HWND);

impl MessageWindow {
    fn new() -> Option<Self> {
        let hwnd = unsafe {
            CreateWindowExW(
                WINDOW_EX_STYLE(0),
                w!("STATIC"),
                w!(""),
                WINDOW_STYLE(0),
                0,
                0,
                0,
                0,
                Some(HWND_MESSAGE),
                None,
                None,
                None,
            )
        }
        .ok()?;
        Some(Self(hwnd))
    }
}

impl Drop for MessageWindow {
    fn drop(&mut self) {
        unsafe {
            let _ = DestroyWindow(self.0);
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
    /// Which paste this text belongs to; a later restore of another paste leaves it alone.
    token: u64,
    bytes: Vec<u8>,
    /// Process that has to read the text for it to count as pasted.
    target_pid: u32,
}

static PENDING_RENDER: Mutex<Option<PendingRender>> = Mutex::new(None);
static NEXT_TOKEN: AtomicU64 = AtomicU64::new(1);

// Values of `READ_BY`.
const NOT_READ: u8 = 0;
const READ_BY_OTHER: u8 = 1;
const READ_BY_GAME: u8 = 2;
/// Who rendered the pending text. Delayed data is only rendered once, so when something else
/// reads it first the game's read cannot be observed any more.
static READ_BY: AtomicU8 = AtomicU8::new(NOT_READ);
/// Clipboard sequence number right after our last write, to tell our (now ownerless) content
/// apart from something copied later by an app that opened the clipboard without a window.
static OWN_SEQUENCE: AtomicU32 = AtomicU32::new(0);

fn remember_own_sequence() {
    OWN_SEQUENCE.store(unsafe { GetClipboardSequenceNumber() }, Ordering::SeqCst);
}

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
    remember_own_sequence();
    let reader = unsafe { GetOpenClipboardWindow() }.unwrap_or_default();
    let mut reader_pid = 0u32;
    if !reader.is_invalid() {
        unsafe { GetWindowThreadProcessId(reader, Some(&mut reader_pid)) };
    }
    // A reader without a window cannot be told apart; count it as the game.
    let by = if reader_pid == 0 || reader_pid == render.target_pid {
        READ_BY_GAME
    } else {
        READ_BY_OTHER
    };
    READ_BY.store(by, Ordering::SeqCst);
}

/// `WM_RENDERALLFORMATS`: the owner window is being destroyed while still owning the text.
pub(crate) fn on_render_all_formats(owner: HWND) {
    let Some(_opened) = Opened::open(owner, 10) else {
        return;
    };
    if unsafe { GetClipboardOwner() }.ok() == Some(owner) {
        if let Some(render) = lock_render().as_ref() {
            write_global(CF_UNICODETEXT, &render.bytes);
            remember_own_sequence();
        }
    }
}

/// The clipboard content from before the paste; put back with [`ClipboardSnapshot::restore`].
pub(crate) struct ClipboardSnapshot {
    owner: HWND,
    token: u64,
    saved: Vec<Saved>,
}

// HWND / HENHMETAFILE are only passed back to user32 / gdi32.
unsafe impl Send for ClipboardSnapshot {}

/// Result of [`ClipboardSnapshot::wait_read`].
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) enum ReadResult {
    Game,
    /// Something else rendered the text first; the game's own read cannot be seen.
    Other,
    TimedOut,
}

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

        let token = NEXT_TOKEN.fetch_add(1, Ordering::SeqCst);
        let units: Vec<u16> = text.encode_utf16().chain(std::iter::once(0)).collect();
        *lock_render() = Some(PendingRender {
            token,
            bytes: units.iter().flat_map(|u| u.to_le_bytes()).collect(),
            target_pid,
        });
        READ_BY.store(NOT_READ, Ordering::SeqCst);
        // No data: rendered by `owner` on WM_RENDERFORMAT. A successful delayed registration
        // returns NULL, which the windows crate reports as an error, so check the result on the
        // (just emptied) clipboard instead.
        let _ = unsafe { SetClipboardData(CF_UNICODETEXT, None) };
        if unsafe { IsClipboardFormatAvailable(CF_UNICODETEXT) }.is_err() {
            *lock_render() = None;
            write_saved(&mut saved);
            return None;
        }
        // Keep the pasted chat line out of clipboard history, cloud clipboard and managers.
        for name in [
            w!("ExcludeClipboardContentFromMonitorProcessing"),
            w!("CanIncludeInClipboardHistory"),
            w!("CanUploadToCloudClipboard"),
        ] {
            let id = unsafe { RegisterClipboardFormatW(PCWSTR(name.as_ptr())) };
            if id != 0 {
                write_global(id, &0u32.to_le_bytes());
            }
        }
        remember_own_sequence();
        Some(Self {
            owner,
            token,
            saved,
        })
    }

    /// Waits until the text has been read, up to `timeout`.
    pub(crate) fn wait_read(&self, timeout: Duration) -> ReadResult {
        let started = Instant::now();
        loop {
            match READ_BY.load(Ordering::SeqCst) {
                READ_BY_GAME => return ReadResult::Game,
                READ_BY_OTHER => return ReadResult::Other,
                _ => {}
            }
            if started.elapsed() >= timeout {
                return ReadResult::TimedOut;
            }
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    /// Puts the saved content back, unless the clipboard changed since the paste (the user
    /// copied something else, or another paste owns it now). An empty snapshot empties the
    /// clipboard again.
    pub(crate) fn restore(mut self) {
        let Some(window) = MessageWindow::new() else {
            println!("[ime_hotkey] could not restore the clipboard: no window");
            return;
        };
        // The sender is a background thread: wait up to ~2 s for another app to let go.
        let Some(_opened) = Opened::open(window.0, 200) else {
            println!("[ime_hotkey] could not restore the clipboard: busy");
            return;
        };
        let owner = unsafe { GetClipboardOwner() }.unwrap_or_default();
        // Still ours: owned by the popup, or ownerless because the popup was destroyed with the
        // text rendered (quick input stopped meanwhile) and nothing was written since.
        let ours = owner == self.owner
            || (owner.is_invalid()
                && !unsafe { IsWindow(Some(self.owner)) }.as_bool()
                && unsafe { GetClipboardSequenceNumber() } == OWN_SEQUENCE.load(Ordering::SeqCst));
        if !ours {
            println!("[ime_hotkey] clipboard changed after the paste; not restoring");
            return;
        }
        {
            let mut pending = lock_render();
            if pending.as_ref().is_some_and(|p| p.token == self.token) {
                *pending = None;
            }
        }
        if unsafe { EmptyClipboard() }.is_ok() {
            write_saved(&mut self.saved);
        }
    }
}

#[cfg(test)]
mod tests {
    //! Runs against the real Win32 clipboard inside a private window station, so the user's
    //! clipboard is not touched. Ignored by default (needs an interactive Windows session):
    //! `cargo test --lib ime_hotkey::clipboard -- --ignored`.

    use super::*;
    use windows::Win32::Foundation::{GENERIC_ALL, LPARAM, LRESULT, WPARAM};
    use windows::Win32::System::StationsAndDesktops::{
        CreateDesktopW, CreateWindowStationW, SetProcessWindowStation, SetThreadDesktop,
        DESKTOP_CONTROL_FLAGS, HDESK,
    };
    use windows::Win32::System::Threading::GetCurrentThreadId;
    use windows::Win32::UI::WindowsAndMessaging::{
        DefWindowProcW, DispatchMessageW, GetMessageW, PostThreadMessageW, RegisterClassW, MSG,
        WM_QUIT, WM_RENDERALLFORMATS, WM_RENDERFORMAT, WNDCLASSW,
    };

    unsafe extern "system" fn owner_proc(hwnd: HWND, msg: u32, wparam: WPARAM, lparam: LPARAM) -> LRESULT {
        match msg {
            WM_RENDERFORMAT => {
                on_render_format(wparam.0 as u32);
                LRESULT(0)
            }
            WM_RENDERALLFORMATS => {
                on_render_all_formats(hwnd);
                LRESULT(0)
            }
            _ => unsafe { DefWindowProcW(hwnd, msg, wparam, lparam) },
        }
    }

    /// Stand-in for the popup: a window on its own thread pumping messages.
    fn spawn_owner(desktop: isize) -> (HWND, u32, std::thread::JoinHandle<()>) {
        let (tx, rx) = std::sync::mpsc::channel();
        let handle = std::thread::spawn(move || unsafe {
            SetThreadDesktop(HDESK(desktop as _)).unwrap();
            let class = WNDCLASSW {
                lpfnWndProc: Some(owner_proc),
                lpszClassName: w!("SCToolBoxClipboardTestOwner"),
                ..Default::default()
            };
            RegisterClassW(&class);
            let hwnd = CreateWindowExW(
                WINDOW_EX_STYLE(0),
                w!("SCToolBoxClipboardTestOwner"),
                w!(""),
                WINDOW_STYLE(0),
                0,
                0,
                0,
                0,
                Some(HWND_MESSAGE),
                None,
                None,
                None,
            )
            .unwrap();
            tx.send((hwnd.0 as isize, GetCurrentThreadId())).unwrap();
            let mut msg = MSG::default();
            while GetMessageW(&mut msg, None, 0, 0).as_bool() {
                DispatchMessageW(&msg);
            }
            let _ = DestroyWindow(hwnd);
        });
        let (hwnd, tid) = rx.recv().unwrap();
        (HWND(hwnd as _), tid, handle)
    }

    fn set_text(text: &str, extra: Option<(u32, &[u8])>) {
        let window = MessageWindow::new().unwrap();
        let _opened = Opened::open(window.0, 10).unwrap();
        unsafe { EmptyClipboard() }.unwrap();
        let units: Vec<u16> = text.encode_utf16().chain(std::iter::once(0)).collect();
        let bytes: Vec<u8> = units.iter().flat_map(|u| u.to_le_bytes()).collect();
        assert!(write_global(CF_UNICODETEXT, &bytes));
        if let Some((format, data)) = extra {
            assert!(write_global(format, data));
        }
    }

    fn read_format(format: u32) -> Option<Vec<u8>> {
        let _opened = Opened::open(HWND::default(), 10).unwrap();
        unsafe { GetClipboardData(format) }.ok().and_then(read_global)
    }

    fn get_text() -> String {
        let bytes = read_format(CF_UNICODETEXT).unwrap_or_default();
        let units: Vec<u16> = bytes
            .chunks_exact(2)
            .map(|c| u16::from_le_bytes([c[0], c[1]]))
            .take_while(|&u| u != 0)
            .collect();
        String::from_utf16_lossy(&units)
    }

    #[test]
    #[ignore = "uses the Win32 clipboard of a private window station"]
    fn paste_snapshot_roundtrip() {
        unsafe {
            let station = CreateWindowStationW(PCWSTR::null(), 0, GENERIC_ALL.0, None).unwrap();
            SetProcessWindowStation(station).unwrap();
            let desktop = CreateDesktopW(
                w!("ime_hotkey_clipboard_test"),
                PCWSTR::null(),
                None,
                DESKTOP_CONTROL_FLAGS(0),
                GENERIC_ALL.0,
                None,
            )
            .unwrap();
            SetThreadDesktop(desktop).unwrap();
            let (owner, owner_tid, owner_thread) = spawn_owner(desktop.0 as isize);
            let custom = RegisterClipboardFormatW(w!("SCToolBoxImeHotkeyTest"));

            // The game reads the text, then the previous content (incl. a custom format) is back.
            set_text("old", Some((custom, &[1, 2, 3])));
            let snapshot =
                ClipboardSnapshot::replace_with_text(owner, std::process::id(), "[zh] @IH").expect("replace");
            assert_eq!(snapshot.wait_read(Duration::from_millis(50)), ReadResult::TimedOut);
            assert_eq!(get_text(), "[zh] @IH");
            assert_eq!(snapshot.wait_read(Duration::from_secs(1)), ReadResult::Game);
            snapshot.restore();
            assert_eq!(get_text(), "old");
            assert_eq!(&read_format(custom).unwrap()[..3], &[1, 2, 3]);

            // Something copied after the paste is not overwritten by the restore.
            let snapshot = ClipboardSnapshot::replace_with_text(owner, std::process::id(), "[zh] @E8").expect("replace");
            set_text("copied later", None);
            snapshot.restore();
            assert_eq!(get_text(), "copied later");

            // An empty clipboard is empty again after the paste.
            {
                let window = MessageWindow::new().unwrap();
                let _opened = Opened::open(window.0, 10).unwrap();
                EmptyClipboard().unwrap();
            }
            let snapshot = ClipboardSnapshot::replace_with_text(owner, std::process::id(), "x").expect("replace");
            snapshot.restore();
            assert!(IsClipboardFormatAvailable(CF_UNICODETEXT).is_err());

            let _ = PostThreadMessageW(owner_tid, WM_QUIT, WPARAM(0), LPARAM(0));
            owner_thread.join().unwrap();
        }
    }
}
