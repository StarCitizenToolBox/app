//! Joystick / HOTAS / gamepad input detection for the Star Citizen keybinding tool.
//!
//! The Dart side lists devices with [`input_list_devices`] and listens to
//! [`input_capture_start`] while waiting for the user to "press a button to bind".
//! Emitted `input` values are Star Citizen input tokens without the instance prefix
//! (`button3`, `x`, `slider1`, `hat1_up`, `dpad_left`, `thumblx`, ...); the Dart side
//! prepends `jsN_` / `gpN_`.
//!
//! Only Windows is supported (raw HID + XInput). On other platforms listing returns an
//! empty list and starting a capture returns an error.

use crate::frb_generated::StreamSink;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum InputDeviceKind {
    /// HID joystick / throttle / pedals (generic desktop usage 0x04).
    Joystick,
    /// Non-XInput HID gamepad (generic desktop usage 0x05).
    Gamepad,
    /// Xbox-compatible controller read through XInput.
    XInput,
}

#[derive(Debug, Clone)]
pub struct InputDeviceInfo {
    /// Stable id per physical device interface (hash of the HID interface path, or `xinput{slot}`).
    pub id: String,
    pub name: String,
    pub vendor_id: u16,
    pub product_id: u16,
    pub kind: InputDeviceKind,
    pub button_count: u32,
    /// Star Citizen axis names this device exposes (`x`, `y`, `z`, `rotx`, `slider1`, ...).
    pub axes: Vec<String>,
    pub hat_count: u32,
}

#[derive(Debug, Clone)]
pub struct InputCaptureEvent {
    pub device_id: String,
    pub device_name: String,
    pub vendor_id: u16,
    pub product_id: u16,
    pub kind: InputDeviceKind,
    /// Star Citizen input token without the `jsN_` / `gpN_` prefix.
    pub input: String,
    /// 1.0 for buttons / hats; normalized -1..1 position for axes.
    /// Button / trigger events: 1.0 on press, 0.0 on release. Axes: normalized position.
    pub value: f64,
}

/// Lists the currently connected joysticks, HID gamepads and XInput controllers.
pub fn input_list_devices() -> anyhow::Result<Vec<InputDeviceInfo>> {
    #[cfg(windows)]
    {
        crate::input_capture::win_impl::list_devices()
    }
    #[cfg(not(windows))]
    {
        Ok(Vec::new())
    }
}

/// Starts background polling of all joystick-like devices and pushes detected inputs to `sink`.
/// Returns immediately. Calling it again stops the previous capture first.
pub fn input_capture_start(sink: StreamSink<InputCaptureEvent>) -> anyhow::Result<()> {
    #[cfg(windows)]
    {
        crate::input_capture::win_impl::start_capture(sink)
    }
    #[cfg(not(windows))]
    {
        drop(sink);
        Err(anyhow::anyhow!(
            "joystick input capture is only supported on Windows"
        ))
    }
}

/// Stops the capture started by [`input_capture_start`] and closes its stream.
pub fn input_capture_stop() {
    #[cfg(windows)]
    crate::input_capture::win_impl::stop_capture();
}
