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

/// Turns a `VkKeyScanExW` result plus the `MapVirtualKeyExW(.., MAPVK_VK_TO_VSC_EX, ..)`
/// scancode of its virtual key into the press sequence for one character.
/// Returns `None` when the layout cannot produce the character.
pub(crate) fn plan_char_keys(vk_scan: i16, scan_ex: u32) -> Option<Vec<ScanKey>> {
    if vk_scan == -1 || scan_ex & 0xFF == 0 {
        return None;
    }
    let shift_state = (vk_scan as u16 >> 8) & 0xFF;
    // Bits above shift/ctrl/alt mean layout specific (Hankaku, ...) states we cannot reproduce.
    if shift_state & !0x07 != 0 {
        return None;
    }
    let scan = (scan_ex & 0xFF) as u16;
    let extended = scan_ex & 0xFF00 == 0xE000 || scan_ex & 0xFF00 == 0xE100;

    let mut mods: Vec<(u16, bool)> = Vec::new();
    if shift_state & 0x02 != 0 && shift_state & 0x04 != 0 {
        // Ctrl+Alt is AltGr: left Ctrl + right Alt.
        mods.push((SC_CTRL, false));
        mods.push((SC_ALT, true));
    } else if shift_state & 0x02 != 0 {
        mods.push((SC_CTRL, false));
    } else if shift_state & 0x04 != 0 {
        mods.push((SC_ALT, false));
    }
    if shift_state & 0x01 != 0 {
        mods.push((SC_LSHIFT, false));
    }

    let mut keys = Vec::with_capacity(mods.len() * 2 + 2);
    keys.extend(mods.iter().map(|&(s, e)| ScanKey::down(s, e)));
    keys.push(ScanKey::down(scan, extended));
    keys.push(ScanKey::up(scan, extended));
    keys.extend(mods.iter().rev().map(|&(s, e)| ScanKey::up(s, e)));
    Some(keys)
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
    fn plain_char() {
        // 'a' on US: vk 0x41, no shift, scancode 0x1E
        let keys = plan_char_keys(0x41, 0x1E).unwrap();
        assert_eq!(keys, vec![ScanKey::down(0x1E, false), ScanKey::up(0x1E, false)]);
    }

    #[test]
    fn shifted_char() {
        // '@' on US: Shift + '2' (vk 0x32, scancode 0x03)
        let keys = plan_char_keys(0x0132, 0x03).unwrap();
        assert_eq!(
            keys,
            vec![
                ScanKey::down(SC_LSHIFT, false),
                ScanKey::down(0x03, false),
                ScanKey::up(0x03, false),
                ScanKey::up(SC_LSHIFT, false),
            ]
        );
    }

    #[test]
    fn altgr_char() {
        // '@' on German: AltGr + 'Q'
        let keys = plan_char_keys(0x0651, 0x10).unwrap();
        assert_eq!(
            keys,
            vec![
                ScanKey::down(SC_CTRL, false),
                ScanKey::down(SC_ALT, true),
                ScanKey::down(0x10, false),
                ScanKey::up(0x10, false),
                ScanKey::up(SC_ALT, true),
                ScanKey::up(SC_CTRL, false),
            ]
        );
    }

    #[test]
    fn unmappable() {
        assert!(plan_char_keys(-1, 0).is_none());
        assert!(plan_char_keys(0x41, 0).is_none());
        assert!(plan_char_keys(0x0841, 0x1E).is_none());
    }

    #[test]
    fn modifiers() {
        assert!(is_modifier_vk(0x10));
        assert!(is_modifier_vk(0xA3));
        assert!(!is_modifier_vk(0x20));
    }
}
