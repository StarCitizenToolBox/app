use std::env;

/// Applinks URL scheme registration result
#[derive(Debug, Clone)]
pub struct ApplinksRegistrationResult {
    /// Whether registration was successful
    pub success: bool,
    /// Detailed message about the operation
    pub message: String,
    /// Whether the registry was modified (false if already configured correctly)
    pub was_modified: bool,
}

/// Check if the URL scheme is already registered with the correct executable path
#[cfg(target_os = "windows")]
pub fn check_applinks_registration(scheme: String) -> anyhow::Result<ApplinksRegistrationResult> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{
        RegCloseKey, RegOpenKeyExW, RegQueryValueExW, HKEY_CURRENT_USER, KEY_READ,
        REG_VALUE_TYPE,
    };

    let app_path = env::current_exe()
        .map_err(|e| anyhow::anyhow!("Failed to get current executable path: {}", e))?
        .to_string_lossy()
        .to_string();

    let expected_command = format!("\"{}\" \"%1\"", app_path);
    let protocol_key_path = format!("Software\\Classes\\{}", scheme);
    let command_key_path = format!("{}\\shell\\open\\command", protocol_key_path);

    unsafe {
        // Check if URL Protocol value exists
        let mut protocol_key = std::mem::zeroed();
        let protocol_key_hstring = HSTRING::from(&protocol_key_path);

        if RegOpenKeyExW(
            HKEY_CURRENT_USER,
            PCWSTR(protocol_key_hstring.as_ptr()),
            Some(0),
            KEY_READ,
            &mut protocol_key,
        )
        .is_err()
        {
            return Ok(ApplinksRegistrationResult {
                success: false,
                message: format!("URL scheme '{}' is not registered", scheme),
                was_modified: false,
            });
        }

        // Check URL Protocol value
        let url_protocol_name = HSTRING::from("URL Protocol");
        let mut data_type: REG_VALUE_TYPE = REG_VALUE_TYPE::default();
        let mut data_size: u32 = 0;

        if RegQueryValueExW(
            protocol_key,
            PCWSTR(url_protocol_name.as_ptr()),
            None,
            Some(&mut data_type),
            None,
            Some(&mut data_size),
        )
        .is_err()
        {
            let _ = RegCloseKey(protocol_key);
            return Ok(ApplinksRegistrationResult {
                success: false,
                message: format!("URL Protocol value not found for scheme '{}'", scheme),
                was_modified: false,
            });
        }

        let _ = RegCloseKey(protocol_key);

        // Check command key
        let mut command_key = std::mem::zeroed();
        let command_key_hstring = HSTRING::from(&command_key_path);

        if RegOpenKeyExW(
            HKEY_CURRENT_USER,
            PCWSTR(command_key_hstring.as_ptr()),
            Some(0),
            KEY_READ,
            &mut command_key,
        )
        .is_err()
        {
            return Ok(ApplinksRegistrationResult {
                success: false,
                message: format!("Command key not found for scheme '{}'", scheme),
                was_modified: false,
            });
        }

        // Read command value (default value with empty name)
        let empty_name = HSTRING::from("");
        let mut data_size: u32 = 0;

        if RegQueryValueExW(
            command_key,
            PCWSTR(empty_name.as_ptr()),
            None,
            Some(&mut data_type),
            None,
            Some(&mut data_size),
        )
        .is_err()
            || data_size == 0
        {
            let _ = RegCloseKey(command_key);
            return Ok(ApplinksRegistrationResult {
                success: false,
                message: format!("Command value not found for scheme '{}'", scheme),
                was_modified: false,
            });
        }

        // Read the actual command value
        let mut buffer: Vec<u8> = vec![0; data_size as usize];
        if RegQueryValueExW(
            command_key,
            PCWSTR(empty_name.as_ptr()),
            None,
            Some(&mut data_type),
            Some(buffer.as_mut_ptr()),
            Some(&mut data_size),
        )
        .is_err()
        {
            let _ = RegCloseKey(command_key);
            return Ok(ApplinksRegistrationResult {
                success: false,
                message: format!("Failed to read command value for scheme '{}'", scheme),
                was_modified: false,
            });
        }

        let _ = RegCloseKey(command_key);

        // Convert buffer to string (UTF-16 to UTF-8)
        let command_value = String::from_utf16_lossy(
            &buffer
                .chunks_exact(2)
                .map(|chunk| u16::from_le_bytes([chunk[0], chunk[1]]))
                .take_while(|&c| c != 0)
                .collect::<Vec<u16>>(),
        );

        // Compare with expected command (case-insensitive for path)
        if command_value.to_lowercase() == expected_command.to_lowercase() {
            Ok(ApplinksRegistrationResult {
                success: true,
                message: format!("URL scheme '{}' is already registered correctly", scheme),
                was_modified: false,
            })
        } else {
            Ok(ApplinksRegistrationResult {
                success: false,
                message: format!(
                    "URL scheme '{}' is registered but with different path. Current: '{}', Expected: '{}'",
                    scheme, command_value, expected_command
                ),
                was_modified: false,
            })
        }
    }
}

#[cfg(not(target_os = "windows"))]
pub fn check_applinks_registration(scheme: String) -> anyhow::Result<ApplinksRegistrationResult> {
    Ok(ApplinksRegistrationResult {
        success: false,
        message: format!(
            "URL scheme registration check is not supported on this platform for scheme '{}'",
            scheme
        ),
        was_modified: false,
    })
}

/// Register URL scheme in Windows registry
/// This will create or update the registry keys for the custom URL scheme
/// 
/// # Arguments
/// * `scheme` - The URL scheme to register (e.g., "sctoolbox")
/// * `app_name` - Optional application display name (e.g., "SCToolBox"). If provided, 
///                the registry will show "URL:{app_name} Protocol" as the scheme description.
#[cfg(target_os = "windows")]
pub fn register_applinks(scheme: String, app_name: Option<String>) -> anyhow::Result<ApplinksRegistrationResult> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{
        RegCloseKey, RegCreateKeyExW, RegSetValueExW, HKEY_CURRENT_USER, KEY_WRITE,
        REG_CREATE_KEY_DISPOSITION, REG_OPTION_NON_VOLATILE, REG_SZ,
    };

    // First check if already registered correctly
    let check_result = check_applinks_registration(scheme.clone())?;
    if check_result.success {
        return Ok(check_result);
    }

    let app_path = env::current_exe()
        .map_err(|e| anyhow::anyhow!("Failed to get current executable path: {}", e))?
        .to_string_lossy()
        .to_string();

    let command_value = format!("\"{}\" \"%1\"", app_path);
    let protocol_key_path = format!("Software\\Classes\\{}", scheme);
    let command_key_path = format!("{}\\shell\\open\\command", protocol_key_path);

    unsafe {
        // Create protocol key
        let mut protocol_key = std::mem::zeroed();
        let protocol_key_hstring = HSTRING::from(&protocol_key_path);
        let mut disposition: REG_CREATE_KEY_DISPOSITION = REG_CREATE_KEY_DISPOSITION::default();

        if RegCreateKeyExW(
            HKEY_CURRENT_USER,
            PCWSTR(protocol_key_hstring.as_ptr()),
            Some(0),
            PCWSTR::null(),
            REG_OPTION_NON_VOLATILE,
            KEY_WRITE,
            None,
            &mut protocol_key,
            Some(&mut disposition),
        )
        .is_err()
        {
            return Err(anyhow::anyhow!(
                "Failed to create registry key '{}'",
                protocol_key_path
            ));
        }

        // Set default value (display name) if app_name is provided
        if let Some(ref name) = app_name {
            let display_name = format!("URL:{} Protocol", name);
            let empty_name = HSTRING::from("");
            let display_name_bytes: Vec<u8> = display_name
                .encode_utf16()
                .chain(std::iter::once(0))
                .flat_map(|c| c.to_le_bytes())
                .collect();

            if RegSetValueExW(
                protocol_key,
                PCWSTR(empty_name.as_ptr()),
                Some(0),
                REG_SZ,
                Some(&display_name_bytes),
            )
            .is_err()
            {
                let _ = RegCloseKey(protocol_key);
                return Err(anyhow::anyhow!("Failed to set display name value"));
            }
        }

        // Set URL Protocol value (empty string)
        let url_protocol_name = HSTRING::from("URL Protocol");
        let empty_value: [u8; 2] = [0, 0]; // Empty UTF-16 string

        if RegSetValueExW(
            protocol_key,
            PCWSTR(url_protocol_name.as_ptr()),
            Some(0),
            REG_SZ,
            Some(&empty_value),
        )
        .is_err()
        {
            let _ = RegCloseKey(protocol_key);
            return Err(anyhow::anyhow!("Failed to set URL Protocol value"));
        }

        let _ = RegCloseKey(protocol_key);

        // Create command key
        let mut command_key = std::mem::zeroed();
        let command_key_hstring = HSTRING::from(&command_key_path);

        if RegCreateKeyExW(
            HKEY_CURRENT_USER,
            PCWSTR(command_key_hstring.as_ptr()),
            Some(0),
            PCWSTR::null(),
            REG_OPTION_NON_VOLATILE,
            KEY_WRITE,
            None,
            &mut command_key,
            Some(&mut disposition),
        )
        .is_err()
        {
            return Err(anyhow::anyhow!(
                "Failed to create command key '{}'",
                command_key_path
            ));
        }

        // Set command value
        let empty_name = HSTRING::from("");
        let command_bytes: Vec<u8> = command_value
            .encode_utf16()
            .chain(std::iter::once(0))
            .flat_map(|c| c.to_le_bytes())
            .collect();

        if RegSetValueExW(
            command_key,
            PCWSTR(empty_name.as_ptr()),
            Some(0),
            REG_SZ,
            Some(&command_bytes),
        )
        .is_err()
        {
            let _ = RegCloseKey(command_key);
            return Err(anyhow::anyhow!("Failed to set command value"));
        }

        let _ = RegCloseKey(command_key);

        Ok(ApplinksRegistrationResult {
            success: true,
            message: format!(
                "Successfully registered URL scheme '{}' with command '{}'",
                scheme, command_value
            ),
            was_modified: true,
        })
    }
}

#[cfg(not(target_os = "windows"))]
pub fn register_applinks(scheme: String, _app_name: Option<String>) -> anyhow::Result<ApplinksRegistrationResult> {
    Ok(ApplinksRegistrationResult {
        success: false,
        message: format!(
            "URL scheme registration is not supported on this platform for scheme '{}'",
            scheme
        ),
        was_modified: false,
    })
}

/// Unregister URL scheme from Windows registry
#[cfg(target_os = "windows")]
pub fn unregister_applinks(scheme: String) -> anyhow::Result<ApplinksRegistrationResult> {
    use windows::core::{HSTRING, PCWSTR};
    use windows::Win32::System::Registry::{RegDeleteTreeW, HKEY_CURRENT_USER};

    let protocol_key_path = format!("Software\\Classes\\{}", scheme);

    unsafe {
        let protocol_key_hstring = HSTRING::from(&protocol_key_path);

        let result = RegDeleteTreeW(HKEY_CURRENT_USER, PCWSTR(protocol_key_hstring.as_ptr()));

        if result.is_err() {
            // Check if the key doesn't exist (not an error in this case)
            let error_code = result.0 as u32;
            if error_code == 2 {
                // ERROR_FILE_NOT_FOUND
                return Ok(ApplinksRegistrationResult {
                    success: true,
                    message: format!("URL scheme '{}' was not registered", scheme),
                    was_modified: false,
                });
            }
            return Err(anyhow::anyhow!(
                "Failed to delete registry key '{}': error code {}",
                protocol_key_path,
                error_code
            ));
        }

        Ok(ApplinksRegistrationResult {
            success: true,
            message: format!("Successfully unregistered URL scheme '{}'", scheme),
            was_modified: true,
        })
    }
}

#[cfg(not(target_os = "windows"))]
pub fn unregister_applinks(scheme: String) -> anyhow::Result<ApplinksRegistrationResult> {
    Ok(ApplinksRegistrationResult {
        success: false,
        message: format!(
            "URL scheme unregistration is not supported on this platform for scheme '{}'",
            scheme
        ),
        was_modified: false,
    })
}
