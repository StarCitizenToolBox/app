//! Platform independent pieces of the input capture: HID usage mapping, value decoding,
//! axis / hat / button edge detection and XInput token mapping.

use crate::api::input_capture_api::InputDeviceKind;

pub const USAGE_PAGE_GENERIC_DESKTOP: u16 = 0x01;
pub const USAGE_PAGE_BUTTON: u16 = 0x09;

pub const USAGE_JOYSTICK: u16 = 0x04;
pub const USAGE_GAMEPAD: u16 = 0x05;
pub const USAGE_MULTI_AXIS: u16 = 0x08;

pub const USAGE_X: u16 = 0x30;
pub const USAGE_Y: u16 = 0x31;
pub const USAGE_Z: u16 = 0x32;
pub const USAGE_RX: u16 = 0x33;
pub const USAGE_RY: u16 = 0x34;
pub const USAGE_RZ: u16 = 0x35;
pub const USAGE_SLIDER: u16 = 0x36;
pub const USAGE_DIAL: u16 = 0x37;
pub const USAGE_WHEEL: u16 = 0x38;
pub const USAGE_HAT: u16 = 0x39;

/// Fraction of the available travel an axis has to move away from its rest value to fire.
pub const AXIS_TRIGGER_FRACTION: f64 = 0.5;
/// Fraction of the available travel within which an axis must return to re-arm.
pub const AXIS_REARM_FRACTION: f64 = 0.3;

/// Maps a HID top-level collection to a device kind, `None` for anything that is not a
/// joystick-like device (keyboards, mice, vendor collections, ...).
pub fn top_level_kind(usage_page: u16, usage: u16) -> Option<InputDeviceKind> {
    if usage_page != USAGE_PAGE_GENERIC_DESKTOP {
        return None;
    }
    match usage {
        USAGE_JOYSTICK | USAGE_MULTI_AXIS => Some(InputDeviceKind::Joystick),
        USAGE_GAMEPAD => Some(InputDeviceKind::Gamepad),
        _ => None,
    }
}

/// XInput compatible HID interfaces expose "IG_" in their interface path; they are read via
/// XInput instead (the HID view merges the triggers into a single axis).
pub fn is_xinput_hid_path(path: &str) -> bool {
    path.to_ascii_uppercase().contains("IG_")
}

/// Stable short id for a HID interface path (FNV-1a 64 over the lower-cased path).
pub fn stable_device_id(path: &str) -> String {
    let mut hash: u64 = 0xcbf2_9ce4_8422_2325;
    for byte in path.to_ascii_lowercase().bytes() {
        hash ^= byte as u64;
        hash = hash.wrapping_mul(0x0000_0100_0000_01b3);
    }
    format!("hid-{:012x}", hash & 0xffff_ffff_ffff)
}

/// Fixed SC axis name for the non-slider axes.
pub fn fixed_axis_name(usage: u16) -> Option<&'static str> {
    match usage {
        USAGE_X => Some("x"),
        USAGE_Y => Some("y"),
        USAGE_Z => Some("z"),
        USAGE_RX => Some("rotx"),
        USAGE_RY => Some("roty"),
        USAGE_RZ => Some("rotz"),
        _ => None,
    }
}

pub fn is_axis_usage(usage: u16) -> bool {
    (USAGE_X..=USAGE_WHEEL).contains(&usage)
}

/// Assigns SC axis names to a device's axis usages (in descriptor order).
///
/// Sliders take `slider1` then `slider2`; dials / wheels take `slider2` then `slider1`.
/// Sliders are assigned first so a dial never pushes a real slider out. Usages that
/// duplicate an already assigned name (or run out of slider slots) get `None`.
pub fn assign_axis_names(usages: &[u16]) -> Vec<Option<String>> {
    let mut names: Vec<Option<String>> = vec![None; usages.len()];
    let mut taken: Vec<&'static str> = Vec::new();
    fn take(candidates: &[&'static str], taken: &mut Vec<&'static str>) -> Option<String> {
        let free = candidates.iter().find(|c| !taken.contains(c))?;
        taken.push(free);
        Some(free.to_string())
    }
    for (i, &usage) in usages.iter().enumerate() {
        if let Some(name) = fixed_axis_name(usage) {
            names[i] = take(&[name], &mut taken);
        }
    }
    for (i, &usage) in usages.iter().enumerate() {
        if usage == USAGE_SLIDER {
            names[i] = take(&["slider1", "slider2"], &mut taken);
        }
    }
    for (i, &usage) in usages.iter().enumerate() {
        if usage == USAGE_DIAL || usage == USAGE_WHEEL {
            names[i] = take(&["slider2", "slider1"], &mut taken);
        }
    }
    names
}

fn bit_mask(bits: u16) -> u64 {
    if bits == 0 || bits >= 32 {
        u32::MAX as u64
    } else {
        (1u64 << bits) - 1
    }
}

/// Sign-extends a raw `bits`-wide two's complement HID value.
pub fn sign_extend(raw: u32, bits: u16) -> i32 {
    if bits == 0 || bits >= 32 {
        return raw as i32;
    }
    let shift = 32 - bits as u32;
    ((raw << shift) as i32) >> shift
}

/// Logical range of a HID value, with common descriptor mistakes corrected.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct ValueRange {
    pub min: i64,
    pub max: i64,
    pub bit_size: u16,
}

impl ValueRange {
    pub fn new(logical_min: i32, logical_max: i32, bit_size: u16) -> Self {
        let mut min = logical_min as i64;
        let mut max = logical_max as i64;
        // e.g. LogicalMax 0xFFFF encoded in two bytes is read back as -1.
        if min >= 0 && max < min {
            max = (logical_max as u32 as u64 & bit_mask(bit_size)) as i64;
        }
        // Descriptors that omit the range entirely: fall back to the full bit range.
        if min == max {
            min = 0;
            max = bit_mask(bit_size) as i64;
        }
        Self { min, max, bit_size }
    }

    pub fn is_signed(&self) -> bool {
        self.min < 0
    }

    /// Converts a raw report value into a logical value.
    pub fn decode(&self, raw: u32) -> i64 {
        if self.is_signed() {
            sign_extend(raw, self.bit_size) as i64
        } else {
            (raw as u64 & bit_mask(self.bit_size)) as i64
        }
    }

    pub fn contains(&self, v: i64) -> bool {
        v >= self.min && v <= self.max
    }

    /// Normalizes a logical value to -1..1.
    pub fn normalize(&self, v: i64) -> f64 {
        normalize(v as f64, self.min as f64, self.max as f64)
    }
}

pub fn normalize(v: f64, min: f64, max: f64) -> f64 {
    if max <= min {
        return 0.0;
    }
    ((v - min) / (max - min) * 2.0 - 1.0).clamp(-1.0, 1.0)
}

/// Edge detector for an analog axis.
///
/// The rest value is the reading seen before capture starts (or the first reading). The
/// axis fires once when it moves away from rest by [`AXIS_TRIGGER_FRACTION`] of the travel
/// available from rest (for a centred stick that is half deflection, for a throttle at an
/// end stop half of the full range), and re-arms after returning within
/// [`AXIS_REARM_FRACTION`] of that travel.
#[derive(Debug, Clone)]
pub struct AxisDetector {
    min: f64,
    max: f64,
    rest: Option<f64>,
    armed: bool,
}

impl AxisDetector {
    pub fn new(min: f64, max: f64) -> Self {
        Self {
            min,
            max,
            rest: None,
            armed: true,
        }
    }

    /// Records `v` as the rest value without firing (used during warm-up).
    pub fn set_rest(&mut self, v: f64) {
        self.rest = Some(v);
        self.armed = true;
    }

    /// Feeds a reading, returns `true` when the axis fires.
    pub fn feed(&mut self, v: f64) -> bool {
        if self.max <= self.min {
            return false;
        }
        let Some(rest) = self.rest else {
            self.set_rest(v);
            return false;
        };
        let travel = (rest - self.min).max(self.max - rest);
        if travel <= 0.0 {
            return false;
        }
        let deviation = (v - rest).abs();
        if self.armed {
            if deviation >= travel * AXIS_TRIGGER_FRACTION {
                self.armed = false;
                return true;
            }
        } else if deviation <= travel * AXIS_REARM_FRACTION {
            self.armed = true;
        }
        false
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HatDirection {
    Up,
    Right,
    Down,
    Left,
}

impl HatDirection {
    pub fn token(self) -> &'static str {
        match self {
            HatDirection::Up => "up",
            HatDirection::Right => "right",
            HatDirection::Down => "down",
            HatDirection::Left => "left",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HatPosition {
    Center,
    Cardinal(HatDirection),
    Diagonal,
}

/// Decodes a hat switch value. Values outside the logical range are the null (centred)
/// state. Positions are spread clockwise from "up" over the logical range, so both 4-way
/// (0..3), 8-way (0..7 / 1..8) and angular (0..359) hats work.
pub fn hat_position(value: i64, range: &ValueRange) -> HatPosition {
    if !range.contains(value) {
        return HatPosition::Center;
    }
    let positions = (range.max - range.min + 1) as f64;
    if positions < 4.0 {
        return HatPosition::Center;
    }
    let quarter = (value - range.min) as f64 * 4.0 / positions;
    let nearest = quarter.round();
    if (quarter - nearest).abs() >= 0.25 {
        return HatPosition::Diagonal;
    }
    match (nearest as i64).rem_euclid(4) {
        0 => HatPosition::Cardinal(HatDirection::Up),
        1 => HatPosition::Cardinal(HatDirection::Right),
        2 => HatPosition::Cardinal(HatDirection::Down),
        _ => HatPosition::Cardinal(HatDirection::Left),
    }
}

/// Edge detector for a hat switch: fires when a new cardinal direction is entered.
/// Diagonals keep the previous direction so sliding up -> up-right -> up fires once.
#[derive(Debug, Clone, Default)]
pub struct HatTracker {
    last: Option<HatDirection>,
}

impl HatTracker {
    pub fn feed(&mut self, pos: HatPosition, warm_up: bool) -> Option<HatDirection> {
        match pos {
            HatPosition::Center => {
                self.last = None;
                None
            }
            HatPosition::Diagonal => None,
            HatPosition::Cardinal(dir) => {
                if self.last == Some(dir) {
                    return None;
                }
                self.last = Some(dir);
                if warm_up {
                    None
                } else {
                    Some(dir)
                }
            }
        }
    }
}

pub fn hat_token(hat_index: u32, dir: HatDirection) -> String {
    format!("hat{}_{}", hat_index, dir.token())
}

pub fn button_token(usage: u16) -> String {
    format!("button{}", usage)
}

/// XInput `wButtons` bits and their SC gamepad tokens.
pub const XINPUT_BUTTON_TOKENS: [(u16, &str); 14] = [
    (0x1000, "a"),
    (0x2000, "b"),
    (0x4000, "x"),
    (0x8000, "y"),
    (0x0100, "shoulderl"),
    (0x0200, "shoulderr"),
    (0x0020, "back"),
    (0x0010, "start"),
    (0x0040, "thumbl"),
    (0x0080, "thumbr"),
    (0x0001, "dpad_up"),
    (0x0002, "dpad_down"),
    (0x0004, "dpad_left"),
    (0x0008, "dpad_right"),
];

pub const XINPUT_AXES: [&str; 4] = ["thumblx", "thumbly", "thumbrx", "thumbry"];

/// Trigger value (0..255) above which a trigger counts as pressed.
pub const XINPUT_TRIGGER_THRESHOLD: u8 = 127;

/// Tokens of the XInput buttons pressed in `now` but not in `prev`.
pub fn xinput_pressed_edges(prev: u16, now: u16) -> Vec<&'static str> {
    let edges = now & !prev;
    XINPUT_BUTTON_TOKENS
        .iter()
        .filter(|(bit, _)| edges & bit != 0)
        .map(|(_, token)| *token)
        .collect()
}

/// Tokens of the XInput buttons down in `prev` but up in `now`.
pub fn xinput_released_edges(prev: u16, now: u16) -> Vec<&'static str> {
    xinput_pressed_edges(now, prev)
}

pub fn xinput_trigger_pressed(value: u8) -> bool {
    value > XINPUT_TRIGGER_THRESHOLD
}

pub fn xinput_stick_normalize(v: i16) -> f64 {
    (v as f64 / 32767.0).clamp(-1.0, 1.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn input_capture_top_level_kind() {
        assert_eq!(top_level_kind(0x01, 0x04), Some(InputDeviceKind::Joystick));
        assert_eq!(top_level_kind(0x01, 0x05), Some(InputDeviceKind::Gamepad));
        assert_eq!(top_level_kind(0x01, 0x08), Some(InputDeviceKind::Joystick));
        assert_eq!(top_level_kind(0x01, 0x02), None); // mouse
        assert_eq!(top_level_kind(0x01, 0x06), None); // keyboard
        assert_eq!(top_level_kind(0xFF00, 0x04), None);
    }

    #[test]
    fn input_capture_xinput_path_filter() {
        assert!(is_xinput_hid_path(
            r"\\?\hid#vid_045e&pid_02ff&ig_00#7&1b4a2b6&0&0000#{4d1e55b2-f16f-11cf-88cb-001111000030}"
        ));
        assert!(!is_xinput_hid_path(
            r"\\?\hid#vid_231d&pid_0200#7&2a0f&0&0000#{4d1e55b2-f16f-11cf-88cb-001111000030}"
        ));
    }

    #[test]
    fn input_capture_stable_id() {
        let a = stable_device_id(r"\\?\HID#VID_231D&PID_0200#abc");
        let b = stable_device_id(r"\\?\hid#vid_231d&pid_0200#abc");
        assert_eq!(a, b);
        assert_eq!(a.len(), 4 + 12);
        assert_ne!(a, stable_device_id(r"\\?\hid#vid_231d&pid_0201#abc"));
    }

    #[test]
    fn input_capture_axis_names() {
        let names = assign_axis_names(&[
            USAGE_X,
            USAGE_Y,
            USAGE_Z,
            USAGE_RX,
            USAGE_RY,
            USAGE_RZ,
            USAGE_SLIDER,
        ]);
        let names: Vec<_> = names.into_iter().map(|n| n.unwrap()).collect();
        assert_eq!(
            names,
            vec!["x", "y", "z", "rotx", "roty", "rotz", "slider1"]
        );

        // two sliders
        assert_eq!(
            assign_axis_names(&[USAGE_SLIDER, USAGE_SLIDER]),
            vec![Some("slider1".into()), Some("slider2".into())]
        );
        // dial alone -> slider2, dial before slider still leaves slider1 to the slider
        assert_eq!(
            assign_axis_names(&[USAGE_DIAL]),
            vec![Some("slider2".into())]
        );
        assert_eq!(
            assign_axis_names(&[USAGE_DIAL, USAGE_SLIDER]),
            vec![Some("slider2".into()), Some("slider1".into())]
        );
        // two sliders + a wheel: no slot left for the wheel
        assert_eq!(
            assign_axis_names(&[USAGE_SLIDER, USAGE_WHEEL, USAGE_SLIDER]),
            vec![Some("slider1".into()), None, Some("slider2".into())]
        );
        // slider2 taken by a dial -> a wheel falls back to slider1
        assert_eq!(
            assign_axis_names(&[USAGE_DIAL, USAGE_WHEEL]),
            vec![Some("slider2".into()), Some("slider1".into())]
        );
        // duplicate x
        assert_eq!(
            assign_axis_names(&[USAGE_X, USAGE_X]),
            vec![Some("x".into()), None]
        );
    }

    #[test]
    fn input_capture_sign_extend_and_ranges() {
        assert_eq!(sign_extend(0xFF, 8), -1);
        assert_eq!(sign_extend(0x7F, 8), 127);
        assert_eq!(sign_extend(0x800, 12), -2048);
        assert_eq!(sign_extend(0xFFFF_FFFF, 32), -1);

        let signed = ValueRange::new(-32768, 32767, 16);
        assert!(signed.is_signed());
        assert_eq!(signed.decode(0x8000), -32768);
        assert_eq!(signed.decode(0x7FFF), 32767);
        assert!((signed.normalize(-32768) + 1.0).abs() < 1e-9);
        assert!((signed.normalize(32767) - 1.0).abs() < 1e-9);

        // LogicalMax 0xFFFF mis-read as -1
        let broken = ValueRange::new(0, -1, 16);
        assert_eq!(broken.max, 65535);
        assert_eq!(broken.decode(0xFFFF), 65535);

        let unsigned = ValueRange::new(0, 4095, 12);
        assert_eq!(unsigned.decode(0xFFF), 4095);
        assert!((unsigned.normalize(0) + 1.0).abs() < 1e-9);
    }

    #[test]
    fn input_capture_axis_detector_centered_stick() {
        let mut d = AxisDetector::new(0.0, 65535.0);
        d.set_rest(32768.0);
        // small jitter around rest never fires
        for v in [32760.0, 32790.0, 32000.0, 33500.0] {
            assert!(!d.feed(v));
        }
        // half deflection fires once
        assert!(d.feed(50000.0));
        assert!(!d.feed(65535.0));
        assert!(!d.feed(50000.0));
        // back near centre re-arms
        assert!(!d.feed(45000.0)); // still > 30% of travel away, not re-armed
        assert!(!d.feed(50000.0));
        assert!(!d.feed(33000.0));
        // fires again in the other direction
        assert!(d.feed(0.0));
    }

    #[test]
    fn input_capture_axis_detector_throttle_and_first_reading() {
        // throttle resting at the minimum: needs half the full range
        let mut d = AxisDetector::new(0.0, 1000.0);
        assert!(!d.feed(0.0)); // first reading is the rest value, never fires
        assert!(!d.feed(400.0));
        assert!(d.feed(600.0));
        assert!(!d.feed(1000.0));
        assert!(!d.feed(290.0)); // re-armed
        assert!(d.feed(700.0));

        // degenerate range never fires
        let mut z = AxisDetector::new(5.0, 5.0);
        assert!(!z.feed(5.0));
        assert!(!z.feed(100.0));
    }

    #[test]
    fn input_capture_hat_positions() {
        let eight = ValueRange::new(0, 7, 4);
        assert_eq!(
            hat_position(0, &eight),
            HatPosition::Cardinal(HatDirection::Up)
        );
        assert_eq!(hat_position(1, &eight), HatPosition::Diagonal);
        assert_eq!(
            hat_position(2, &eight),
            HatPosition::Cardinal(HatDirection::Right)
        );
        assert_eq!(
            hat_position(4, &eight),
            HatPosition::Cardinal(HatDirection::Down)
        );
        assert_eq!(
            hat_position(6, &eight),
            HatPosition::Cardinal(HatDirection::Left)
        );
        assert_eq!(hat_position(7, &eight), HatPosition::Diagonal);
        assert_eq!(hat_position(8, &eight), HatPosition::Center);
        assert_eq!(hat_position(15, &eight), HatPosition::Center);

        let one_based = ValueRange::new(1, 8, 4);
        assert_eq!(hat_position(0, &one_based), HatPosition::Center);
        assert_eq!(
            hat_position(1, &one_based),
            HatPosition::Cardinal(HatDirection::Up)
        );
        assert_eq!(
            hat_position(7, &one_based),
            HatPosition::Cardinal(HatDirection::Left)
        );

        let four = ValueRange::new(0, 3, 2);
        assert_eq!(
            hat_position(1, &four),
            HatPosition::Cardinal(HatDirection::Right)
        );

        let angular = ValueRange::new(0, 359, 16);
        assert_eq!(
            hat_position(270, &angular),
            HatPosition::Cardinal(HatDirection::Left)
        );
        assert_eq!(hat_position(45, &angular), HatPosition::Diagonal);
        assert_eq!(hat_position(0xFFFF, &angular), HatPosition::Center);
    }

    #[test]
    fn input_capture_hat_tracker_edges() {
        let up = HatPosition::Cardinal(HatDirection::Up);
        let right = HatPosition::Cardinal(HatDirection::Right);
        let mut t = HatTracker::default();
        assert_eq!(t.feed(up, false), Some(HatDirection::Up));
        assert_eq!(t.feed(up, false), None);
        assert_eq!(t.feed(HatPosition::Diagonal, false), None);
        assert_eq!(t.feed(up, false), None);
        assert_eq!(t.feed(HatPosition::Diagonal, false), None);
        assert_eq!(t.feed(right, false), Some(HatDirection::Right));
        assert_eq!(t.feed(HatPosition::Center, false), None);
        assert_eq!(t.feed(right, false), Some(HatDirection::Right));

        // held during warm-up: not emitted, and not emitted afterwards while still held
        let mut w = HatTracker::default();
        assert_eq!(w.feed(up, true), None);
        assert_eq!(w.feed(up, false), None);
        assert_eq!(w.feed(HatPosition::Center, false), None);
        assert_eq!(w.feed(up, false), Some(HatDirection::Up));
        assert_eq!(hat_token(2, HatDirection::Left), "hat2_left");
    }

    #[test]
    fn input_capture_xinput_tokens() {
        assert_eq!(xinput_pressed_edges(0, 0x1000), vec!["a"]);
        assert_eq!(xinput_pressed_edges(0x1000, 0x1000), Vec::<&str>::new());
        assert_eq!(xinput_pressed_edges(0x1000, 0x3000), vec!["b"]);
        assert_eq!(xinput_released_edges(0x3000, 0x1000), vec!["b"]);
        assert_eq!(xinput_released_edges(0x1000, 0x1000), Vec::<&str>::new());
        assert_eq!(
            xinput_pressed_edges(0, 0x000F),
            vec!["dpad_up", "dpad_down", "dpad_left", "dpad_right"]
        );
        assert_eq!(
            xinput_pressed_edges(0, 0x03F0),
            vec!["shoulderl", "shoulderr", "back", "start", "thumbl", "thumbr"]
        );
        assert!(xinput_trigger_pressed(200));
        assert!(!xinput_trigger_pressed(100));
        assert!((xinput_stick_normalize(i16::MIN) + 1.0).abs() < 1e-9);
        assert!((xinput_stick_normalize(i16::MAX) - 1.0).abs() < 1e-9);

        let mut stick = AxisDetector::new(-32768.0, 32767.0);
        stick.set_rest(0.0);
        assert!(!stick.feed(10000.0));
        assert!(stick.feed(20000.0));
        assert!(!stick.feed(32767.0));
        assert!(!stick.feed(5000.0));
        assert!(stick.feed(-20000.0));
    }

    #[test]
    fn input_capture_tokens() {
        assert_eq!(button_token(1), "button1");
        assert_eq!(button_token(128), "button128");
    }
}
