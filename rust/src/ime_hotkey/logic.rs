//! Platform independent pieces of the IME hotkey backend.

use crate::api::ime_hotkey_api::ImeHotkey;

pub(crate) const VK_SHIFT: u32 = 0x10;
pub(crate) const VK_CONTROL: u32 = 0x11;
pub(crate) const VK_MENU: u32 = 0x12;
pub(crate) const VK_ESCAPE: u32 = 0x1B;
pub(crate) const VK_LWIN: u32 = 0x5B;
pub(crate) const VK_RWIN: u32 = 0x5C;

pub(crate) const SC_LSHIFT: u16 = 0x2A;
pub(crate) const SC_RSHIFT: u16 = 0x36;
pub(crate) const SC_CTRL: u16 = 0x1D;
pub(crate) const SC_ALT: u16 = 0x38;
pub(crate) const SC_ENTER: u16 = 0x1C;
pub(crate) const SC_V: u16 = 0x2F;

/// Modifier keys (either side) cannot be the main key of a hotkey.
pub(crate) fn is_modifier_vk(vk: u32) -> bool {
    matches!(
        vk,
        0x10 | 0x11 | 0x12 // SHIFT CONTROL MENU
            | 0x5B | 0x5C // LWIN RWIN
            | 0xA0..=0xA5 // L/R SHIFT CONTROL MENU
    )
}

/// Packs a hotkey into one word so the hook can read it without locking.
pub(crate) fn pack_hotkey(h: &ImeHotkey) -> u64 {
    (h.vk as u64 & 0xFFFF)
        | (h.ctrl as u64) << 16
        | (h.alt as u64) << 17
        | (h.shift as u64) << 18
        | (h.win as u64) << 19
}

pub(crate) fn unpack_hotkey(v: u64) -> ImeHotkey {
    ImeHotkey {
        vk: (v & 0xFFFF) as u32,
        ctrl: v & (1 << 16) != 0,
        alt: v & (1 << 17) != 0,
        shift: v & (1 << 18) != 0,
        win: v & (1 << 19) != 0,
    }
}

/// One scancode key event.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) struct ScanKey {
    pub scan: u16,
    pub extended: bool,
    pub up: bool,
}

impl ScanKey {
    fn down(scan: u16, extended: bool) -> Self {
        Self { scan, extended, up: false }
    }
    fn up(scan: u16, extended: bool) -> Self {
        Self { scan, extended, up: true }
    }
}

/// Ctrl+V as scancodes. `v_scan_ex` is `MapVirtualKeyExW(VK_V, MAPVK_VK_TO_VSC_EX, ..)` for
/// the game's keyboard layout; falls back to the US position when the layout has no V.
pub(crate) fn ctrl_v_keys(v_scan_ex: u32) -> Vec<ScanKey> {
    let scan = match (v_scan_ex & 0xFF) as u16 {
        0 => SC_V,
        s => s,
    };
    vec![
        ScanKey::down(SC_CTRL, false),
        ScanKey::down(scan, false),
        ScanKey::up(scan, false),
        ScanKey::up(SC_CTRL, false),
    ]
}

/// Key-up events for every modifier, sent before typing so the game does not treat a
/// modifier it last saw pressed (the hotkey's) as still held.
pub(crate) fn release_modifier_keys() -> Vec<ScanKey> {
    vec![
        ScanKey::up(SC_LSHIFT, false),
        ScanKey::up(SC_RSHIFT, false),
        ScanKey::up(SC_CTRL, false),
        ScanKey::up(SC_CTRL, true),
        ScanKey::up(SC_ALT, false),
        ScanKey::up(SC_ALT, true),
    ]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn hotkey_roundtrip() {
        let h = ImeHotkey {
            vk: 0x20,
            ctrl: true,
            alt: true,
            shift: false,
            win: true,
        };
        assert_eq!(unpack_hotkey(pack_hotkey(&h)), h);
    }

    #[test]
    fn ctrl_v() {
        let expected = vec![
            ScanKey::down(SC_CTRL, false),
            ScanKey::down(0x2F, false),
            ScanKey::up(0x2F, false),
            ScanKey::up(SC_CTRL, false),
        ];
        assert_eq!(ctrl_v_keys(0x2F), expected);
        // No V on the layout: US position.
        assert_eq!(ctrl_v_keys(0), expected);
    }

    #[test]
    fn modifiers() {
        assert!(is_modifier_vk(0x10));
        assert!(is_modifier_vk(0xA3));
        assert!(!is_modifier_vk(0x20));
    }
}
