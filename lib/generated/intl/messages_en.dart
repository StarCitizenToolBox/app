// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(v0, v1) => "SCToolBox V ${v0} ${v1}";

  static String m1(v0) => "Initialization failure: ${v0}";

  static String m2(v0) => "Downloading: ${v0}%";

  static String m3(v0) => "Discover the new version-> ${v0}";

  static String m4(v0) => "Game abnormal exit: ${v0}";

  static String m5(v0) =>
      "Info: ${v0}, please click to add group feedback in the lower right corner.";

  static String m6(v0) => "After the analysis, I found that ${v0} questions";

  static String m7(v0, v1) =>
      "Create a folder failed, please try to create manually.\nDirectory: ${v0}\nError: ${v1}";

  static String m8(v0) => "Failure to repair, ${v0}";

  static String m9(v0) => "Operating system that does not support: ${v0}";

  static String m10(v0) =>
      "Add ForcedPhysicalsectorsizeinbytes value to the registry item to simulate old devices. Hard disk partition (${v0})";

  static String m11(V0) =>
      "No-English installation path! This may cause the game to start/install errors! (${V0}), please replace the installation path at the RSI starter.";

  static String m12(v0) =>
      "Click to fix the Live folder for you, and install it after completion. (${v0})";

  static String m13(v0) => "Repair suggestions: ${v0}";

  static String m14(v0) =>
      "You need at least 16GB of physical memory (Memory) to run this game. (Current size: ${v0})";

  static String m15(v0) => "Please upgrade your system (${v0})";

  static String m16(v0) => "One -click diagnosis-> ${v0}";

  static String m17(v0, v1) => "Download: ${v0}/s Upload: ${v1}/s";

  static String m18(v0) => "Downloaded: ${v0}";

  static String m19(v0) => "Download ... (${v0}%)";

  static String m20(v0) => "Status: ${v0}";

  static String m21(v1) => "Total size: ${v1}";

  static String m22(v0) => "Uploaded: ${v0}";

  static String m23(v2) => "In the verification ... (${v2})";

  static String m24(v0, v1, v2, v3, v4) =>
      "The game exits normally\nexitCode = ${v0}\nstdout = ${v1}\nstderr = ${v2}\n\nDiagnostic information: ${v3}\n${v4}";

  static String m25(v0) =>
      "Initialized webpage Localization resources failed! ${v0}";

  static String m26(v0) =>
      "After scanning, find ${v0} a valid installation directory";

  static String m27(v0) =>
      "You have a new version of the Localization you installed in ${v0}!";

  static String m28(v1, v2) =>
      "RSI server report version number: ${v1}\n\nLocal version number: ${v2}\n\nIt is recommended to use RSI Launcher to update the game!";

  static String m29(v0) => "Channel: ${v0}";

  static String m30(v0) => "Custom_ ${v0}";

  static String m31(v0) => "Enable (${v0}):";

  static String m32(v0) => "Install an error!\n\n ${v0}";

  static String m33(v0) => "The installed version: ${v0}";

  static String m34(v0) => "Update Time: ${v0}";

  static String m35(v0) => "Version number: ${v0}";

  static String m36(v0) => "Current status: ${v0}";

  static String m37(v0, v1, v2) =>
      "${v0} minimum value: ${v1} / maximum value: ${v2}";

  static String m38(v0) => "Performance Optimization -> ${v0}";

  static String m39(v0) =>
      "The cache size ${v0} MB, clean up the Localization -based file cache of the download of the box, will not affect the installed Localization";

  static String m40(v0, v1, v2, v3) =>
      "Enable: ${v0} Device Support: ${v1} Email: ${v2} Password: ${v3}";

  static String m41(v0) =>
      "Core quantity that has been set: ${v0} (This function is suitable for the box -click startup or RSI starter manager mode on the homepage, which is not enabled when it is 0)";

  static String m42(v0) =>
      "Failure to clean up, please remove manually, file location: ${v0}";

  static String m43(v0) => "Error: ${v0}";

  static String m44(v0) =>
      "Initialization failed, please take a screenshot report to the developer. ${v0}";

  static String m45(v0) =>
      "If you have a problem with the NVME patch, run this tool. (It may cause game installation/update to be unavailable.)\n\nCurrent patch status: ${v0}";

  static String m46(v0) =>
      "In some cases, the LOG file of the RSI promoter will be damaged, causing the problem to be scanned, and using this tool to clean up the damaged log file.\n\nCurrent log file size: ${v0} MB";

  static String m47(v0) =>
      "If the game screen appears abnormal or the version is updated, you can use the tool to clean the expired color (when it is greater than 500m, it is recommended to clean it)\n\nCache size: ${v0} MB";

  static String m48(v0, v1, v2, v3, v4) =>
      "System: ${v0}\n\nProcessor: ${v1}\n\nMemory size: ${v2} gb\n\nGraphics card information:\n${v3}\n\nHard disk information:\n${v4}";

  static String m49(V0) => "Failure to handle! : ${V0}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_action_email":
            MessageLookupByLibrary.simpleMessage("Email: scbox@xkeyc.com"),
        "about_action_open_source":
            MessageLookupByLibrary.simpleMessage("Open source"),
        "about_action_qq_group":
            MessageLookupByLibrary.simpleMessage("QQ group: 940696487"),
        "about_analytics_install_translation":
            MessageLookupByLibrary.simpleMessage("Localization installation"),
        "about_analytics_launch":
            MessageLookupByLibrary.simpleMessage("Start up"),
        "about_analytics_launch_game":
            MessageLookupByLibrary.simpleMessage("Start the game"),
        "about_analytics_p4k_redirection":
            MessageLookupByLibrary.simpleMessage("P4k diversion"),
        "about_analytics_performance_optimization":
            MessageLookupByLibrary.simpleMessage("Performance tuning"),
        "about_analytics_total_users":
            MessageLookupByLibrary.simpleMessage("Cumulative users"),
        "about_analytics_units_times":
            MessageLookupByLibrary.simpleMessage("Second-rate"),
        "about_analytics_units_user":
            MessageLookupByLibrary.simpleMessage("Bit"),
        "about_app_description": MessageLookupByLibrary.simpleMessage(
            "The SCToolBox is a good helper for your exploring the universe. We are committed to solving common problems in the game for citizens, and facilitate the operation of community localization, performance tuning, and commonly used website localization operations."),
        "about_check_update":
            MessageLookupByLibrary.simpleMessage("Check for updates"),
        "about_disclaimer": MessageLookupByLibrary.simpleMessage(
            "This is an unofficial interstellar citizen tool that is not affiliated to Cloud Imperium Group. In this software, all the contents of their own owners or users are their own property.\nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are the registered trademarks of Cloud Imperium Rights LLC."),
        "about_info_latest_version": MessageLookupByLibrary.simpleMessage(
            "It is already the latest version!"),
        "about_online_feedback":
            MessageLookupByLibrary.simpleMessage("Online feedback"),
        "action_close": MessageLookupByLibrary.simpleMessage("Closure"),
        "action_open_folder":
            MessageLookupByLibrary.simpleMessage("Open the folder"),
        "app_index_menu_about": MessageLookupByLibrary.simpleMessage("About"),
        "app_index_menu_home": MessageLookupByLibrary.simpleMessage("Index"),
        "app_index_menu_lobby": MessageLookupByLibrary.simpleMessage("Hall"),
        "app_index_menu_settings":
            MessageLookupByLibrary.simpleMessage("Settings"),
        "app_index_menu_tools": MessageLookupByLibrary.simpleMessage("Tool"),
        "app_index_version_info": m0,
        "app_init_failed_with_reason": m1,
        "app_language_code": MessageLookupByLibrary.simpleMessage("en"),
        "app_language_name": MessageLookupByLibrary.simpleMessage("English"),
        "app_shortcut_name":
            MessageLookupByLibrary.simpleMessage("SCToolBox.lnk"),
        "app_splash_almost_done":
            MessageLookupByLibrary.simpleMessage("Finish quickly…"),
        "app_splash_checking_availability": MessageLookupByLibrary.simpleMessage(
            "It is detection availability, which may take a little time ..."),
        "app_splash_checking_for_updates":
            MessageLookupByLibrary.simpleMessage("Inspection and update ..."),
        "app_upgrade_action_next_time":
            MessageLookupByLibrary.simpleMessage("Next time"),
        "app_upgrade_action_update_now":
            MessageLookupByLibrary.simpleMessage("Update immediately"),
        "app_upgrade_info_download_failed":
            MessageLookupByLibrary.simpleMessage(
                "Failure to download, please try to install manually!"),
        "app_upgrade_info_downloading": m2,
        "app_upgrade_info_getting_new_version_details":
            MessageLookupByLibrary.simpleMessage(
                "Get the new version details ..."),
        "app_upgrade_info_installing":
            MessageLookupByLibrary.simpleMessage("Installing:"),
        "app_upgrade_info_run_failed": MessageLookupByLibrary.simpleMessage(
            "Failure to run, try to install manually!"),
        "app_upgrade_info_update_server_tip": MessageLookupByLibrary.simpleMessage(
            "Tip: The current diversion server is updated, and the download speed may decline, but it will help us perform cost control. If you download the exception, please click here to jump and manually install it."),
        "app_upgrade_title_new_version_found": m3,
        "doctor_action_analyzing":
            MessageLookupByLibrary.simpleMessage("Analysing..."),
        "doctor_action_game_run_log":
            MessageLookupByLibrary.simpleMessage("Game running log"),
        "doctor_action_info_checking_eac":
            MessageLookupByLibrary.simpleMessage("Inspection: EAC"),
        "doctor_action_info_checking_install_info":
            MessageLookupByLibrary.simpleMessage(
                "Inspection: Installation information"),
        "doctor_action_info_checking_runtime":
            MessageLookupByLibrary.simpleMessage(
                "Inspection: operating environment"),
        "doctor_action_info_game_abnormal_exit": m4,
        "doctor_action_info_game_abnormal_exit_unknown":
            MessageLookupByLibrary.simpleMessage(
                "Game abnormal exit: unknown abnormalities"),
        "doctor_action_info_info_feedback": m5,
        "doctor_action_result_analysis_issues_found": m6,
        "doctor_action_result_analysis_no_issue":
            MessageLookupByLibrary.simpleMessage(
                "After the analysis, no problems are found"),
        "doctor_action_result_create_folder_fail": m7,
        "doctor_action_result_create_folder_success":
            MessageLookupByLibrary.simpleMessage(
                "Create a folder success, try to continue download the game!"),
        "doctor_action_result_fix_fail": m8,
        "doctor_action_result_fix_success": MessageLookupByLibrary.simpleMessage(
            "If the repair is successful, try to restart and continue to install the game! If the registry modification operation causes compatibility problems with other software, please use the NVMe registry in the tool to clean up."),
        "doctor_action_result_game_start_success":
            MessageLookupByLibrary.simpleMessage(
                "If the repair is successful, try to start the game. (If the problem cannot be solved, please use the toolbox\'s \"Reinstall EAC\")"),
        "doctor_action_result_info_unsupported_os": m9,
        "doctor_action_result_issue_not_supported":
            MessageLookupByLibrary.simpleMessage(
                "This problem does not support automatic processing for the time being, please provide screenshots for help"),
        "doctor_action_result_redirect_warning":
            MessageLookupByLibrary.simpleMessage(
                "The tutorial is about to jump, the tutorial comes from the Internet, please operate carefully ..."),
        "doctor_action_result_toast_scan_no_issue":
            MessageLookupByLibrary.simpleMessage(
                "After scanning, no problem is found. If you still fail, try to use the RSI starter administrator mode in the toolbox."),
        "doctor_action_result_try_latest_windows":
            MessageLookupByLibrary.simpleMessage(
                "If your hardware meets the standard, try to install the latest Windows system."),
        "doctor_action_rsi_launcher_log":
            MessageLookupByLibrary.simpleMessage("RSI starter log"),
        "doctor_action_tip_checking_game_log":
            MessageLookupByLibrary.simpleMessage("Inspection: Game.log"),
        "doctor_action_view_details":
            MessageLookupByLibrary.simpleMessage("Check the details"),
        "doctor_action_view_solution":
            MessageLookupByLibrary.simpleMessage("View solution"),
        "doctor_info_action_fix":
            MessageLookupByLibrary.simpleMessage("Repair"),
        "doctor_info_game_rescue_service_note":
            MessageLookupByLibrary.simpleMessage(
                "You are about to go to the game abnormal rescue services provided by the Deep Space Treatment Center (QQ group number: 536454632), which mainly solve the failure and frequent flashback of game installation. If you are a gameplay problem, please do not add groups."),
        "doctor_info_need_help": MessageLookupByLibrary.simpleMessage(
            "Need help? Click to seek free artificial support!"),
        "doctor_info_processing":
            MessageLookupByLibrary.simpleMessage("Treatment ..."),
        "doctor_info_result_add_registry_value": m10,
        "doctor_info_result_chinese_install_path":
            MessageLookupByLibrary.simpleMessage(
                "No-English installation path!"),
        "doctor_info_result_chinese_install_path_error": m11,
        "doctor_info_result_chinese_username":
            MessageLookupByLibrary.simpleMessage("No-English username!"),
        "doctor_info_result_chinese_username_error":
            MessageLookupByLibrary.simpleMessage(
                "The No-English username may cause the game to start/install errors! Click the repair button to view the modification tutorial!"),
        "doctor_info_result_create_live_folder": m12,
        "doctor_info_result_easyanticheat_not_installed":
            MessageLookupByLibrary.simpleMessage(
                "Easyanticheat is not installed or not withdrawn normally"),
        "doctor_info_result_fix_suggestion": m13,
        "doctor_info_result_incompatible_nvme_device":
            MessageLookupByLibrary.simpleMessage(
                "The new NVME device is not compatible with the RSI starter for the time being, which may cause the installation to fail"),
        "doctor_info_result_install_easyanticheat":
            MessageLookupByLibrary.simpleMessage(
                "Easyanticheat is not installed, please click to repair it for you one click. (Before the game starts normally and ends, the problem will always appear. If you retreat for other reasons, you can ignore this entry)"),
        "doctor_info_result_low_physical_memory":
            MessageLookupByLibrary.simpleMessage("Paralying memory is too low"),
        "doctor_info_result_memory_requirement": m14,
        "doctor_info_result_missing_easyanticheat_files":
            MessageLookupByLibrary.simpleMessage("Easyanticheat file loss"),
        "doctor_info_result_missing_live_folder":
            MessageLookupByLibrary.simpleMessage(
                "The installation directory lacks a Live folder, which may cause the installation to fail"),
        "doctor_info_result_no_solution": MessageLookupByLibrary.simpleMessage(
            "No solution, please take screenshots feedback"),
        "doctor_info_result_unsupported_os": MessageLookupByLibrary.simpleMessage(
            "The operating system that does not support, the game may not be able to run"),
        "doctor_info_result_upgrade_system": m15,
        "doctor_info_result_verify_files_with_rsi_launcher":
            MessageLookupByLibrary.simpleMessage(
                "Not found the EasyAnticheat file or file incomplete in the Live folder, please use the RSI starter to check the file"),
        "doctor_info_scan_complete_no_issues":
            MessageLookupByLibrary.simpleMessage(
                "After scanning, no problem was found!"),
        "doctor_info_tool_check_result_note": MessageLookupByLibrary.simpleMessage(
            "Note: The test results of this tool are for reference only. If you do not understand the following operations, please provide screenshots for experienced players!"),
        "doctor_tip_title_select_game_directory":
            MessageLookupByLibrary.simpleMessage(
                "Please select the game installation directory on the homepage."),
        "doctor_title_one_click_diagnosis": m16,
        "downloader_action_cancel_all":
            MessageLookupByLibrary.simpleMessage("Cancel all of them"),
        "downloader_action_cancel_download":
            MessageLookupByLibrary.simpleMessage("Cancel download"),
        "downloader_action_confirm_cancel_all_tasks":
            MessageLookupByLibrary.simpleMessage(
                "Confirm the cancellation of all tasks?"),
        "downloader_action_confirm_cancel_download":
            MessageLookupByLibrary.simpleMessage(
                "Confirm the cancellation download?"),
        "downloader_action_continue_download":
            MessageLookupByLibrary.simpleMessage("Continue download"),
        "downloader_action_options":
            MessageLookupByLibrary.simpleMessage("Option"),
        "downloader_action_pause_all":
            MessageLookupByLibrary.simpleMessage("All of the suspension"),
        "downloader_action_pause_download":
            MessageLookupByLibrary.simpleMessage("Paradse download"),
        "downloader_action_resume_all":
            MessageLookupByLibrary.simpleMessage("Restore all"),
        "downloader_info_deleted":
            MessageLookupByLibrary.simpleMessage("Deleted"),
        "downloader_info_download_completed":
            MessageLookupByLibrary.simpleMessage("Download completed"),
        "downloader_info_download_failed":
            MessageLookupByLibrary.simpleMessage("Download failed"),
        "downloader_info_download_unit_input_prompt":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the download unit."),
        "downloader_info_download_upload_speed": m17,
        "downloader_info_downloaded": m18,
        "downloader_info_downloading": m19,
        "downloader_info_downloading_status":
            MessageLookupByLibrary.simpleMessage("Downloading..."),
        "downloader_info_manual_file_deletion_note":
            MessageLookupByLibrary.simpleMessage(
                "If the file is no longer needed, you may need to delete the download file manually."),
        "downloader_info_no_download_tasks":
            MessageLookupByLibrary.simpleMessage("No download task"),
        "downloader_info_p2p_network_note": MessageLookupByLibrary.simpleMessage(
            "The SCToolBox uses the P2P network to accelerate file download. If you have limited traffic, you can set the upload bandwidth to 1 (byte) here."),
        "downloader_info_paused":
            MessageLookupByLibrary.simpleMessage("Paused"),
        "downloader_info_status": m20,
        "downloader_info_total_size": m21,
        "downloader_info_uploaded": m22,
        "downloader_info_verifying": m23,
        "downloader_info_waiting":
            MessageLookupByLibrary.simpleMessage("Waiting"),
        "downloader_input_download_speed_limit":
            MessageLookupByLibrary.simpleMessage("Download speed limit:"),
        "downloader_input_info_p2p_upload_note":
            MessageLookupByLibrary.simpleMessage(
                "* P2P upload is only performed when downloading files, and the P2P connection will be turned off after downloading. If you want to participate in planting, please contact us about the page."),
        "downloader_input_upload_speed_limit":
            MessageLookupByLibrary.simpleMessage("Upload speed limit:"),
        "downloader_speed_limit_settings":
            MessageLookupByLibrary.simpleMessage("Speed limit setting"),
        "downloader_title_downloading":
            MessageLookupByLibrary.simpleMessage("Downloading"),
        "downloader_title_ended": MessageLookupByLibrary.simpleMessage("Over"),
        "home_action_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "home_action_dps_calculator_localization":
            MessageLookupByLibrary.simpleMessage("DPS calculator Localization"),
        "home_action_external_browser_extension":
            MessageLookupByLibrary.simpleMessage("External browser expansion:"),
        "home_action_info_abnormal_game_exit": m24,
        "home_action_info_check_web_link": MessageLookupByLibrary.simpleMessage(
            "Please check the pop -up web link to get detailed information."),
        "home_action_info_engine_config_optimization":
            MessageLookupByLibrary.simpleMessage(
                "Adjust the engine configuration file to optimize the game performance"),
        "home_action_info_game_built_in":
            MessageLookupByLibrary.simpleMessage("Built -in game"),
        "home_action_info_initialization_failed": m25,
        "home_action_info_initializing_resources":
            MessageLookupByLibrary.simpleMessage(
                "It is initialized Localization resources ..."),
        "home_action_info_log_file_parse_fail":
            MessageLookupByLibrary.simpleMessage(
                "Analysis of LOG files failed!"),
        "home_action_info_mining_refining_trade_calculator":
            MessageLookupByLibrary.simpleMessage(
                "Mining, refining, trade calculator, price, ship information"),
        "home_action_info_one_click_diagnosis_star_citizen":
            MessageLookupByLibrary.simpleMessage(
                "Auto scan diagnosis of common problems in interstellar citizens"),
        "home_action_info_quick_install_localization_resources":
            MessageLookupByLibrary.simpleMessage(
                "Fast installation of localization resources"),
        "home_action_info_roberts_space_industries_origin":
            MessageLookupByLibrary.simpleMessage(
                "Roberts Aerospace Industry Corporation, the origin of all things"),
        "home_action_info_scan_complete_valid_directories_found": m26,
        "home_action_info_scanning":
            MessageLookupByLibrary.simpleMessage("Scanning ..."),
        "home_action_info_ship_upgrade_damage_value_query":
            MessageLookupByLibrary.simpleMessage(
                "Change the ship online, query the damage value and accessories location"),
        "home_action_info_unknown_error": MessageLookupByLibrary.simpleMessage(
            "Unknown errors, please use one -click diagnosis to add group feedback."),
        "home_action_info_valid_install_location_required":
            MessageLookupByLibrary.simpleMessage(
                "This function requires an effective installation location\n\nIf your game is not downloaded, wait for the download after downloading.\n\nIf your game has been downloaded but not recognized, please reopen the box after starting the game or manually set the installation position in the setting option."),
        "home_action_info_warning":
            MessageLookupByLibrary.simpleMessage("Warn"),
        "home_action_info_web_localization_plugin_disclaimer":
            MessageLookupByLibrary.simpleMessage(
                "This plug -in function is for general browsing, not responsible for any problems related to this function! Please pay attention to confirming the original content of the website before the account operation!\n\n\nWhen logging in to the account, please make sure your SCToolBox is downloaded from a trusted source."),
        "home_action_install_microsoft_store_version":
            MessageLookupByLibrary.simpleMessage(
                "Install Microsoft Store Version"),
        "home_action_localization_management":
            MessageLookupByLibrary.simpleMessage("Localization management"),
        "home_action_login_rsi_account":
            MessageLookupByLibrary.simpleMessage("Log in to RSI account"),
        "home_action_one_click_diagnosis":
            MessageLookupByLibrary.simpleMessage("Auto diagnosis"),
        "home_action_one_click_launch":
            MessageLookupByLibrary.simpleMessage("One-button start"),
        "home_action_performance_optimization":
            MessageLookupByLibrary.simpleMessage("Performance optimization"),
        "home_action_q_auto_password_fill_prompt":
            MessageLookupByLibrary.simpleMessage(
                "Do you turn on the automatic password filling?"),
        "home_action_rsi_status_arena_commander":
            MessageLookupByLibrary.simpleMessage("AC"),
        "home_action_rsi_status_electronic_access":
            MessageLookupByLibrary.simpleMessage("EV"),
        "home_action_rsi_status_persistent_universe":
            MessageLookupByLibrary.simpleMessage("PU"),
        "home_action_rsi_status_platform":
            MessageLookupByLibrary.simpleMessage("Platform"),
        "home_action_rsi_status_rsi_server_status":
            MessageLookupByLibrary.simpleMessage("RSI server status"),
        "home_action_rsi_status_status":
            MessageLookupByLibrary.simpleMessage("State:"),
        "home_action_star_citizen_website_localization":
            MessageLookupByLibrary.simpleMessage("SC Official Localization"),
        "home_action_title_star_citizen_website_localization":
            MessageLookupByLibrary.simpleMessage(
                "Star Citizen Website Sinicization"),
        "home_action_uex_localization":
            MessageLookupByLibrary.simpleMessage("UEX Localization"),
        "home_announcement_details":
            MessageLookupByLibrary.simpleMessage("Announcement details"),
        "home_holiday_countdown":
            MessageLookupByLibrary.simpleMessage("Countdown"),
        "home_holiday_countdown_disclaimer": MessageLookupByLibrary.simpleMessage(
            "* The above festival date is included in artificially and maintained. There may be errors. Welcome to feedback!"),
        "home_info_account_security_warning": MessageLookupByLibrary.simpleMessage(
            "In order to ensure the security of the account, the one -click startup function has been disabled in the development version, and we will provide this feature in the Microsoft store version.\n\nThe Microsoft Store Edition is provided with a reliable distribution download and digital signature by Microsoft, which can effectively prevent software from being maliciously tampered with.\n\nTip: You can use Localization without using a box to start the game."),
        "home_info_auto_fill_notice": MessageLookupByLibrary.simpleMessage(
            "* If the automatic filling is turned on, please pay attention to the pop -up Windows Hello window"),
        "home_info_one_click_launch_warning":
            MessageLookupByLibrary.simpleMessage(
                "One -click start -up function prompt"),
        "home_info_valid_installation_required":
            MessageLookupByLibrary.simpleMessage(
                "This function requires an effective installation location"),
        "home_install_location":
            MessageLookupByLibrary.simpleMessage("Installation location:"),
        "home_localization_new_version_available":
            MessageLookupByLibrary.simpleMessage(
                "Sinicization has a new version!"),
        "home_localization_new_version_installed": m27,
        "home_login_action_title_box_one_click_launch":
            MessageLookupByLibrary.simpleMessage("Box one -click start"),
        "home_login_action_title_need_webview2_runtime":
            MessageLookupByLibrary.simpleMessage(
                "Need to install WebView2 Runtime"),
        "home_login_info_action_ignore":
            MessageLookupByLibrary.simpleMessage("Neglect"),
        "home_login_info_enter_pin_to_encrypt":
            MessageLookupByLibrary.simpleMessage(
                "Enter PIN to enable encryption"),
        "home_login_info_game_version_outdated":
            MessageLookupByLibrary.simpleMessage("Game version expires"),
        "home_login_info_one_click_launch_description":
            MessageLookupByLibrary.simpleMessage(
                "This feature can help you start the game more conveniently.\n\nTo ensure the security of the account, this function uses the Localization browser to retain the login status and will not save your password information (unless you enable the automatic filling function).\n\nWhen logging in to the account, please make sure your SCToolBox is downloaded from a trusted source."),
        "home_login_info_password_encryption_notice":
            MessageLookupByLibrary.simpleMessage(
                "The box will use the PIN and Windows credentials to save your password encryption, and the password is only stored in your device.\n\nWhen you need to enter a password for the next login, you only need to authorize PIN to automatically fill in the login."),
        "home_login_info_rsi_server_report": m28,
        "home_login_title_launching_game": MessageLookupByLibrary.simpleMessage(
            "I\'m starting the game for you ..."),
        "home_login_title_welcome_back":
            MessageLookupByLibrary.simpleMessage("Welcome back!"),
        "home_not_installed_or_failed": MessageLookupByLibrary.simpleMessage(
            "Unpacking or installation failed"),
        "home_title_app_name":
            MessageLookupByLibrary.simpleMessage("SCToolBox"),
        "home_title_logging_in":
            MessageLookupByLibrary.simpleMessage("Logging in..."),
        "lobby_invitation_to_participate": MessageLookupByLibrary.simpleMessage(
            "Sincerely invite you to participate"),
        "lobby_online_lobby_coming_soon": MessageLookupByLibrary.simpleMessage(
            "The online lobby, so stay tuned!"),
        "lobby_survey": MessageLookupByLibrary.simpleMessage("Questionnaire."),
        "localization_action_advanced_features":
            MessageLookupByLibrary.simpleMessage("Advanced Features"),
        "localization_action_install":
            MessageLookupByLibrary.simpleMessage("Install"),
        "localization_action_translation_feedback":
            MessageLookupByLibrary.simpleMessage("Localization feedback"),
        "localization_action_uninstall_translation":
            MessageLookupByLibrary.simpleMessage(
                "Uninstallation of Localization"),
        "localization_info_channel": m29,
        "localization_info_community_translation":
            MessageLookupByLibrary.simpleMessage("Community Localization"),
        "localization_info_corrupted_file":
            MessageLookupByLibrary.simpleMessage(
                "The file is damaged, please download again"),
        "localization_info_custom_file": m30,
        "localization_info_custom_file_instructions":
            MessageLookupByLibrary.simpleMessage(
                "To open the localized folder, put the customized name .ini file in the Customize_ini folder.\n\nAfter adding a new file, you do not display the refresh button in the upper right corner.\n\nPlease make sure to choose the correct language during installation."),
        "localization_info_custom_files":
            MessageLookupByLibrary.simpleMessage("Custom file"),
        "localization_info_custom_text":
            MessageLookupByLibrary.simpleMessage("Custom text"),
        "localization_info_enabled": m31,
        "localization_info_incompatible_translation_params_warning":
            MessageLookupByLibrary.simpleMessage(
                "User.cfg contains incompatible Localization parameters, which may be the residual information of the previous Localization file.\n\nThis may lead to ineffective or garbled Localization, click to confirm that you are removed with one click (it will not affect other configuration)."),
        "localization_info_installation_error": m32,
        "localization_info_installed":
            MessageLookupByLibrary.simpleMessage("Installed"),
        "localization_info_installed_version": m33,
        "localization_info_language":
            MessageLookupByLibrary.simpleMessage("Language:"),
        "localization_info_machine_translation_warning":
            MessageLookupByLibrary.simpleMessage(
                "You are using the game built -in text. The official text is currently a machine translation (as of 3.21.0), and it is recommended that you install community Localization below."),
        "localization_info_no_custom_text":
            MessageLookupByLibrary.simpleMessage("No custom text"),
        "localization_info_no_translation_available":
            MessageLookupByLibrary.simpleMessage(
                "This language/version is not available for Localization, so stay tuned!"),
        "localization_info_note":
            MessageLookupByLibrary.simpleMessage("Remark:"),
        "localization_info_remove_incompatible_translation_params":
            MessageLookupByLibrary.simpleMessage(
                "Whether to remove incompatible Localization parameters"),
        "localization_info_translation_status":
            MessageLookupByLibrary.simpleMessage("State"),
        "localization_info_unavailable":
            MessageLookupByLibrary.simpleMessage("Unavailable"),
        "localization_info_update_time": m34,
        "localization_info_version_number": m35,
        "performance_action_apply":
            MessageLookupByLibrary.simpleMessage("Application"),
        "performance_action_apply_and_clear_shaders":
            MessageLookupByLibrary.simpleMessage(
                "Apply and clean up the color device (recommended)"),
        "performance_action_clear_shaders":
            MessageLookupByLibrary.simpleMessage("Clean the color device"),
        "performance_action_custom_parameters_input":
            MessageLookupByLibrary.simpleMessage(
                "You can enter the custom parameters that are not included in the box here. Configuration example:\n\nR_DISPLAYINFO = 0\nr_vsync = 0"),
        "performance_action_high": MessageLookupByLibrary.simpleMessage("High"),
        "performance_action_info_preset_only_changes_graphics":
            MessageLookupByLibrary.simpleMessage(
                "(Preset only the graphic settings)"),
        "performance_action_low": MessageLookupByLibrary.simpleMessage("Low"),
        "performance_action_medium":
            MessageLookupByLibrary.simpleMessage("Middle"),
        "performance_action_preset":
            MessageLookupByLibrary.simpleMessage("Preset:"),
        "performance_action_reset_to_default":
            MessageLookupByLibrary.simpleMessage("Reset"),
        "performance_action_super":
            MessageLookupByLibrary.simpleMessage("Super"),
        "performance_info_applied":
            MessageLookupByLibrary.simpleMessage("Applied"),
        "performance_info_current_status": m36,
        "performance_info_delete_config_file":
            MessageLookupByLibrary.simpleMessage(
                "Delete the configuration file ..."),
        "performance_info_done":
            MessageLookupByLibrary.simpleMessage("Finish..."),
        "performance_info_generate_config_file":
            MessageLookupByLibrary.simpleMessage("Generate configuration file"),
        "performance_info_graphic_optimization_hint":
            MessageLookupByLibrary.simpleMessage("Graph optimization tips"),
        "performance_info_graphic_optimization_warning":
            MessageLookupByLibrary.simpleMessage(
                "This function is very helpful for optimizing the bottleneck of the graphics card, but it may have a reverse effect on the CPU bottleneck. If your graphics card performance is strong, you can try to use better picture quality to obtain higher graphics card utilization."),
        "performance_info_graphics":
            MessageLookupByLibrary.simpleMessage("Graphic"),
        "performance_info_min_max_values": m37,
        "performance_info_not_applied":
            MessageLookupByLibrary.simpleMessage("Unused"),
        "performance_info_shader_clearing_warning":
            MessageLookupByLibrary.simpleMessage(
                "After cleaning up the color device, it may appear stutter when entering the game for the first time. Please wait patiently for the initialization of the game."),
        "performance_info_write_out_config_file":
            MessageLookupByLibrary.simpleMessage(
                "Write the configuration file"),
        "performance_title_performance_optimization": m38,
        "setting_action_clear_translation_file_cache":
            MessageLookupByLibrary.simpleMessage(
                "Clean up the Localization file cache"),
        "setting_action_create_desktop_shortcut":
            MessageLookupByLibrary.simpleMessage(
                "Create \"SC Sinicization Box\" shortcut on the desktop"),
        "setting_action_create_settings_shortcut":
            MessageLookupByLibrary.simpleMessage("Create Settings Settings"),
        "setting_action_ignore_efficiency_cores_on_launch":
            MessageLookupByLibrary.simpleMessage(
                "When starting the game, ignore the core of energy efficiency (suitable for Intel 12th+ processor)"),
        "setting_action_info_autofill_data_cleared":
            MessageLookupByLibrary.simpleMessage(
                "Automatic filling data has been cleaned up"),
        "setting_action_info_cache_clearing_info": m39,
        "setting_action_info_clear_cache_warning":
            MessageLookupByLibrary.simpleMessage(
                "This will not affect the installed Localization."),
        "setting_action_info_confirm_clear_cache":
            MessageLookupByLibrary.simpleMessage(
                "Confirmation of cleaning the Localization cache?"),
        "setting_action_info_confirm_reset_autofill":
            MessageLookupByLibrary.simpleMessage(
                "Confirm that resetting automatic filling?"),
        "setting_action_info_cpu_core_tip": MessageLookupByLibrary.simpleMessage(
            "Tip: Input a few of your equipment with a few energy efficiency cores, please keep 0 non -large and small nuclear equipment 0\n\nThis function is suitable for the box of one -click startup or the RSI starter mode in the box on the homepage. This function is not enabled when it is 0."),
        "setting_action_info_delete_local_account_warning":
            MessageLookupByLibrary.simpleMessage(
                "This will delete local account records, or it will automatically fill in the next time the game starts the game to disable automatic filling."),
        "setting_action_info_device_support_info": m40,
        "setting_action_info_disabled":
            MessageLookupByLibrary.simpleMessage("Disabled"),
        "setting_action_info_enabled":
            MessageLookupByLibrary.simpleMessage("Activated"),
        "setting_action_info_encrypted_saved":
            MessageLookupByLibrary.simpleMessage("Has been encrypted"),
        "setting_action_info_enter_cpu_core_to_ignore":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the core number of CPUs to be ignored"),
        "setting_action_info_file_error":
            MessageLookupByLibrary.simpleMessage("The file is wrong!"),
        "setting_action_info_manual_game_location_setting":
            MessageLookupByLibrary.simpleMessage(
                "Manually set the game installation location, it is recommended to use it only when the installation location cannot be automatically scanned"),
        "setting_action_info_manual_launcher_location_setting":
            MessageLookupByLibrary.simpleMessage(
                "Set the position of the starter manually, it is recommended to use it only when the installation position cannot be automatically scanned automatically"),
        "setting_action_info_microsoft_version_limitation":
            MessageLookupByLibrary.simpleMessage(
                "Due to Microsoft\'s version restrictions, manually drag the SCToolBox to the desktop in the next window to create a shortcut."),
        "setting_action_info_mirror_server_info":
            MessageLookupByLibrary.simpleMessage(
                "Use a mirror server to accelerate access to tool websites such as DPS UEX. If you access abnormal access, please turn off the function. To protect the security of the account, the RSI official website will not be accelerated in any case."),
        "setting_action_info_not_saved":
            MessageLookupByLibrary.simpleMessage("Not preserved"),
        "setting_action_info_not_support":
            MessageLookupByLibrary.simpleMessage("Not support"),
        "setting_action_info_select_game_install_location":
            MessageLookupByLibrary.simpleMessage(
                "Please select the game installation position (StarCitizen.exe)"),
        "setting_action_info_select_rsi_launcher_location":
            MessageLookupByLibrary.simpleMessage(
                "Please select the RSI starter position (RSI LAUNCHER.EXE)"),
        "setting_action_info_setting_success": MessageLookupByLibrary.simpleMessage(
            "Successfully set, click refresh on the corresponding page to scan the new path"),
        "setting_action_info_shortcut_created":
            MessageLookupByLibrary.simpleMessage(
                "After the creation, please return to the desktop to view"),
        "setting_action_info_support":
            MessageLookupByLibrary.simpleMessage("Support"),
        "setting_action_info_view_log_file": MessageLookupByLibrary.simpleMessage(
            "Check the log file of the SCToolBox to locate the bug of the box"),
        "setting_action_reset_auto_password_fill":
            MessageLookupByLibrary.simpleMessage(
                "Reset automatic password filling"),
        "setting_action_set_core_count": m41,
        "setting_action_set_game_file": MessageLookupByLibrary.simpleMessage(
            "Set the game file (StarCitizen.exe)"),
        "setting_action_set_launcher_file":
            MessageLookupByLibrary.simpleMessage(
                "Set the promoter file (RSI Launcher.exe)"),
        "setting_action_tool_site_access_acceleration":
            MessageLookupByLibrary.simpleMessage(
                "Tool station access acceleration"),
        "setting_action_view_log":
            MessageLookupByLibrary.simpleMessage("View log"),
        "tools_action_clear_shader_cache": MessageLookupByLibrary.simpleMessage(
            "Clean up the color device cache"),
        "tools_action_close_photography_mode":
            MessageLookupByLibrary.simpleMessage(
                "Turn off the photography mode"),
        "tools_action_hosts_acceleration_experimental":
            MessageLookupByLibrary.simpleMessage(
                "Hosts acceleration (experimental)"),
        "tools_action_info_cleanup_complete": MessageLookupByLibrary.simpleMessage(
            "After cleaning up, complete the installation / game startup operation once."),
        "tools_action_info_cleanup_failed": m42,
        "tools_action_info_config_file_not_exist":
            MessageLookupByLibrary.simpleMessage(
                "The configuration file does not exist, please try to run the game once"),
        "tools_action_info_eac_file_removed": MessageLookupByLibrary.simpleMessage(
            "Remove the EAC file for you, and then open the RSI startup for you. Please go to Settings-> Verify to reinstall EAC."),
        "tools_action_info_error_occurred": m43,
        "tools_action_info_fix_success_restart":
            MessageLookupByLibrary.simpleMessage(
                "If the repair is successful, please try to restart the computer and continue to install the game! If the registry modification operation causes compatibility problems with other software, please use the NVMe registry in the tool to clean up."),
        "tools_action_info_function_under_maintenance":
            MessageLookupByLibrary.simpleMessage(
                "During functional maintenance, please try it later!"),
        "tools_action_info_hosts_acceleration_experimental_tip":
            MessageLookupByLibrary.simpleMessage(
                "Write the IP information into the hosts file to solve problems such as DNS pollution in some regions that cannot log in to the official website.\nThis function is undergoing the first stage of testing. Please report it in time when you encounter problems."),
        "tools_action_info_init_failed": m44,
        "tools_action_info_log_file_not_exist":
            MessageLookupByLibrary.simpleMessage(
                "The log file does not exist, please try to start a game startup or game installation, and exit the starter. If the problem cannot be solved, try to update the launcher to the latest version!"),
        "tools_action_info_log_file_parse_failed":
            MessageLookupByLibrary.simpleMessage(
                "Analysis of LOG files failed!\nTry to use RSI Launcher Log repair tool!"),
        "tools_action_info_manual_nvme_patch": MessageLookupByLibrary.simpleMessage(
            "Manually write the NVM patch, this function is used only when you know what you do"),
        "tools_action_info_not_installed":
            MessageLookupByLibrary.simpleMessage("Not Installed"),
        "tools_action_info_nvme_patch_issue": m45,
        "tools_action_info_one_key_close_lens_shake":
            MessageLookupByLibrary.simpleMessage(
                "Close the game endoscope shaking to facilitate photography operations.\n\n @Lapernum offers parameter information."),
        "tools_action_info_p4k_download_in_progress":
            MessageLookupByLibrary.simpleMessage(
                "There is already a P4K download task in progress, please go to the download manager to view!"),
        "tools_action_info_p4k_download_repair_tip":
            MessageLookupByLibrary.simpleMessage(
                "The diversion download service provided by citizenwiki.cn can be used to download or fix P4K.\nLimited resources, please do not abuse."),
        "tools_action_info_p4k_file_description":
            MessageLookupByLibrary.simpleMessage(
                "P4K is the core game file of interstellar citizens, as high as 100GB+. The offline download provided by the box is to help some P4K files download super slow users or to repair the P4K file that the official launch cannot be repaired.\n\nNext, you will pop up the window and ask you to save the position (you can choose the Star Citizens Folder or you can choose elsewhere). After downloading, please make sure that the P4K folder is located in the LIVE folder, and then use the Star Citizen starter to check it."),
        "tools_action_info_reinstall_eac": MessageLookupByLibrary.simpleMessage(
            "If you encounter EAC errors and are invalid automatically, try using this feature to reinstall EAC."),
        "tools_action_info_removed_restart_effective":
            MessageLookupByLibrary.simpleMessage(
                "Remove the computer to take effect!"),
        "tools_action_info_restore_lens_shake":
            MessageLookupByLibrary.simpleMessage(
                "Restoring the lens shaking effect.\n\n@Lapernum offers parameter information."),
        "tools_action_info_rsi_launcher_directory_not_found":
            MessageLookupByLibrary.simpleMessage(
                "If the RSI starter directory is not found, please try manually."),
        "tools_action_info_rsi_launcher_log_issue": m46,
        "tools_action_info_rsi_launcher_not_found":
            MessageLookupByLibrary.simpleMessage(
                "If the RSI label is not found, try to reinstall it or add it manually in the settings."),
        "tools_action_info_rsi_launcher_running_warning":
            MessageLookupByLibrary.simpleMessage(
                "The RSI starter is running! Please turn off the label first and then use this feature!"),
        "tools_action_info_run_rsi_as_admin": MessageLookupByLibrary.simpleMessage(
            "Run RSI startups as an administrator may solve some problems.\n\nIf the energy efficiency core shielding parameters are set, it will also be applied here."),
        "tools_action_info_shader_cache_issue": m47,
        "tools_action_info_star_citizen_not_found":
            MessageLookupByLibrary.simpleMessage(
                "If the interstellar game installation location is not found, please complete the game startup operation at least once or add it manually in the settings."),
        "tools_action_info_system_info_content": m48,
        "tools_action_info_system_info_title":
            MessageLookupByLibrary.simpleMessage("System message"),
        "tools_action_info_valid_game_directory_needed":
            MessageLookupByLibrary.simpleMessage(
                "This function requires an effective game installation directory"),
        "tools_action_info_view_critical_system_info":
            MessageLookupByLibrary.simpleMessage(
                "Check the key information of the system for quick consultation\n\nTime -consuming operation, please wait patiently."),
        "tools_action_open_photography_mode":
            MessageLookupByLibrary.simpleMessage(
                "Turn on the photography mode"),
        "tools_action_p4k_download_repair":
            MessageLookupByLibrary.simpleMessage(
                "P4k diversion download / repair"),
        "tools_action_reinstall_easyanticheat":
            MessageLookupByLibrary.simpleMessage(
                "Reinstall EasyAnticheat\'s anti -cheating"),
        "tools_action_remove_nvme_registry_patch":
            MessageLookupByLibrary.simpleMessage(
                "Remove the NVMe registry patch"),
        "tools_action_rsi_launcher_admin_mode":
            MessageLookupByLibrary.simpleMessage(
                "RSI Launcher administrator mode"),
        "tools_action_rsi_launcher_log_fix":
            MessageLookupByLibrary.simpleMessage("RSI LAUNCHER LOG repair"),
        "tools_action_view_system_info":
            MessageLookupByLibrary.simpleMessage("View system information"),
        "tools_action_write_nvme_registry_patch":
            MessageLookupByLibrary.simpleMessage(
                "Write in the NVMe registry patch"),
        "tools_hosts_action_one_click_acceleration":
            MessageLookupByLibrary.simpleMessage("One -click acceleration"),
        "tools_hosts_info_dns_query_and_test": MessageLookupByLibrary.simpleMessage(
            "Inquiring about DNS and testing accessibility, please wait patiently ..."),
        "tools_hosts_info_enable":
            MessageLookupByLibrary.simpleMessage("Whether to enable"),
        "tools_hosts_info_hosts_acceleration":
            MessageLookupByLibrary.simpleMessage("Hosts accelerate"),
        "tools_hosts_info_open_hosts_file":
            MessageLookupByLibrary.simpleMessage("Open the hosts file"),
        "tools_hosts_info_reading_config":
            MessageLookupByLibrary.simpleMessage("Read the configuration ..."),
        "tools_hosts_info_rsi_customer_service":
            MessageLookupByLibrary.simpleMessage(
                "RSI customer service station"),
        "tools_hosts_info_rsi_official_website":
            MessageLookupByLibrary.simpleMessage("RSI official website"),
        "tools_hosts_info_rsi_zendesk": MessageLookupByLibrary.simpleMessage(
            "RSI ZENDESK Customer Service Station"),
        "tools_hosts_info_site": MessageLookupByLibrary.simpleMessage("Site"),
        "tools_hosts_info_status":
            MessageLookupByLibrary.simpleMessage("State"),
        "tools_hosts_info_writing_hosts":
            MessageLookupByLibrary.simpleMessage("I am writing Hosts ..."),
        "tools_info_game_install_location":
            MessageLookupByLibrary.simpleMessage("Game installation location:"),
        "tools_info_processing_failed": m49,
        "tools_info_rsi_launcher_location":
            MessageLookupByLibrary.simpleMessage("RSI starter position:"),
        "tools_info_scanning":
            MessageLookupByLibrary.simpleMessage("Scanning..."),
        "webview_localization_device_windows_hello_toast":
            MessageLookupByLibrary.simpleMessage(
                "Please complete the Windows Hello verification to fill in the password"),
        "webview_localization_enter_device_pin":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the device PIN to automatically log in to the RSI account"),
        "webview_localization_finished_invitations":
            MessageLookupByLibrary.simpleMessage("Completed invitations"),
        "webview_localization_name_member":
            MessageLookupByLibrary.simpleMessage("Member"),
        "webview_localization_total_invitations":
            MessageLookupByLibrary.simpleMessage("Total invitation:"),
        "webview_localization_unfinished_invitations":
            MessageLookupByLibrary.simpleMessage("Undead invitation")
      };
}
