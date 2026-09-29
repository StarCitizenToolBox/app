//! Global-hotkey popup for the community input method (issue #322).
//!
//! While running, a low-level keyboard hook watches for the configured hotkey. When it fires
//! over the game window, a small native popup with a plain Win32 EDIT control takes focus so
//! the user can type with the system IME. Enter (outside of IME composition) emits
//! [`ImeHotkeyEvent::Submit`]; the Dart side encodes the text and answers with
//! [`ime_hotkey_send`], which switches back to the game and pastes the encoded text with Ctrl+V.
//!
//! Nothing is injected into the game process; the clipboard content is restored after pasting.
//! Only Windows is supported; on other platforms starting returns an error.

use crate::frb_generated::StreamSink;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ImeHotkey {
    /// Windows virtual-key code of the non-modifier key.
    pub vk: u32,
    pub ctrl: bool,
    pub alt: bool,
    pub shift: bool,
    pub win: bool,
}

#[derive(Debug, Clone)]
pub struct ImeHotkeyConfig {
    pub hotkey: ImeHotkey,
    /// Only react to the hotkey while `StarCitizen.exe` owns the foreground window.
    pub game_only: bool,
    /// Press Enter to open the chat box before pasting.
    pub open_chat_before_send: bool,
    /// Press Enter after pasting to send the message. When false the text is only pasted.
    pub auto_send: bool,
    /// Press Enter again after sending so the chat box stays open for the next message.
    /// Only used with `auto_send`.
    pub reopen_chat_after_send: bool,
    /// Last popup position in screen pixels; `None` places it near the bottom left of the
    /// game's monitor.
    pub window_x: Option<i32>,
    pub window_y: Option<i32>,
    /// Hint shown under the edit box while idle.
    pub hint_text: String,
    /// Status text shown while the text is being encoded / pasted.
    pub sending_text: String,
}

#[derive(Debug, Clone)]
pub enum ImeHotkeyEvent {
    /// The user pressed Enter in the popup. Answer with [`ime_hotkey_send`] (same `id`) or
    /// [`ime_hotkey_show_message`].
    Submit { id: u64, text: String },
    /// The encoded text was pasted into the game.
    Sent { id: u64 },
    /// Pasting was not started or was aborted; the popup is shown again with the text kept.
    /// A message for this `id` can follow with [`ime_hotkey_show_message`].
    SendFailed { id: u64, reason: ImeSendFailure },
    /// The user dragged the popup to a new place.
    WindowMoved { x: i32, y: i32 },
    /// Result of [`ime_hotkey_begin_capture`]; `None` when cancelled with Esc.
    HotkeyCaptured { hotkey: Option<ImeHotkey> },
    /// The pressed combination cannot be a hotkey (see [`ime_hotkey_is_valid`]); capturing
    /// continues.
    HotkeyCaptureRejected,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ImeSendFailure {
    /// The window that was in front when the hotkey was pressed is gone.
    TargetWindowGone,
    /// Windows refused to bring the game window back to the front.
    FocusFailed,
    /// Another window came to the front before the text was sent; sending stopped.
    FocusLost,
    /// The text could not be put on the clipboard.
    ClipboardFailed,
}

/// Starts the hook thread and popup. Calling it again restarts with the new config.
/// Startup failures arrive as an error on the returned stream.
pub fn ime_hotkey_start(config: ImeHotkeyConfig, sink: StreamSink<ImeHotkeyEvent>) {
    #[cfg(windows)]
    crate::ime_hotkey::win_impl::start(config, sink);
    #[cfg(not(windows))]
    {
        drop(config);
        let _ = sink.add_error(anyhow::anyhow!("ime hotkey is only supported on Windows"));
    }
}

/// Replaces the config of the running popup (hotkey, chat handling, position, texts).
pub fn ime_hotkey_update_config(config: ImeHotkeyConfig) {
    #[cfg(windows)]
    crate::ime_hotkey::win_impl::update_config(config);
    #[cfg(not(windows))]
    drop(config);
}

/// Stops the hook, destroys the popup and closes the event stream.
pub fn ime_hotkey_stop() {
    #[cfg(windows)]
    crate::ime_hotkey::win_impl::stop();
}

/// Pastes `encoded` into the window that was in front when the popup was opened, followed by
/// Enter when `auto_send` is set. `id` must match the [`ImeHotkeyEvent::Submit`] being answered.
pub fn ime_hotkey_send(id: u64, encoded: String) {
    #[cfg(windows)]
    crate::ime_hotkey::win_impl::send(id, encoded);
    #[cfg(not(windows))]
    drop((id, encoded));
}

/// Shows `message` under the edit box and keeps the popup open (e.g. unsupported characters).
/// `id` is the submit it belongs to; messages for an older or cancelled submit are ignored.
/// `busy` keeps the edit read-only while the submit is still being processed (translating);
/// otherwise the user can edit and submit again.
pub fn ime_hotkey_show_message(id: u64, message: String, is_error: bool, busy: bool) {
    #[cfg(windows)]
    crate::ime_hotkey::win_impl::show_message(id, message, is_error, busy);
    #[cfg(not(windows))]
    drop((id, message, is_error, busy));
}

/// The next key combination pressed anywhere is reported as
/// [`ImeHotkeyEvent::HotkeyCaptured`] and swallowed instead of triggering the popup.
/// Esc alone cancels. Requires a running popup.
pub fn ime_hotkey_begin_capture() -> anyhow::Result<()> {
    #[cfg(windows)]
    {
        crate::ime_hotkey::win_impl::begin_capture()
    }
    #[cfg(not(windows))]
    {
        Err(anyhow::anyhow!("ime hotkey is only supported on Windows"))
    }
}

pub fn ime_hotkey_cancel_capture() {
    #[cfg(windows)]
    crate::ime_hotkey::win_impl::cancel_capture();
}

/// A hotkey needs Ctrl, Alt or Win, or an F1-F24 key, so it never takes a key the popup or
/// plain typing needs (Enter, Esc, letters, ...).
#[flutter_rust_bridge::frb(sync)]
pub fn ime_hotkey_is_valid(hotkey: ImeHotkey) -> bool {
    crate::ime_hotkey::logic::is_valid_hotkey(&hotkey)
}

/// Human readable name such as `Ctrl + Alt + Space`, using the current keyboard layout.
#[flutter_rust_bridge::frb(sync)]
pub fn ime_hotkey_display_name(hotkey: ImeHotkey) -> String {
    let mut parts: Vec<String> = Vec::new();
    if hotkey.ctrl {
        parts.push("Ctrl".into());
    }
    if hotkey.alt {
        parts.push("Alt".into());
    }
    if hotkey.shift {
        parts.push("Shift".into());
    }
    if hotkey.win {
        parts.push("Win".into());
    }
    #[cfg(windows)]
    parts.push(crate::ime_hotkey::win_impl::key_name(hotkey.vk));
    #[cfg(not(windows))]
    parts.push(format!("0x{:02X}", hotkey.vk));
    parts.join(" + ")
}
