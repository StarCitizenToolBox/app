// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get app_language_name {
    return Intl.message(
      'English',
      name: 'app_language_name',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get app_language_code {
    return Intl.message('en', name: 'app_language_code', desc: '', args: []);
  }

  /// `SCToolbox V{v0} {v1}`
  String app_index_version_info(Object v0, Object v1) {
    return Intl.message(
      'SCToolbox V$v0 $v1',
      name: 'app_index_version_info',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `SCToolboxDEV.lnk`
  String get app_shortcut_name {
    return Intl.message(
      'SCToolboxDEV.lnk',
      name: 'app_shortcut_name',
      desc: '',
      args: [],
    );
  }

  /// `Check for Updates`
  String get about_check_update {
    return Intl.message(
      'Check for Updates',
      name: 'about_check_update',
      desc: '',
      args: [],
    );
  }

  /// `Not just Localization!\n\nSCToolbox is your excellent companion for exploring the universe. We are dedicated to solving common in-game issues for citizens and facilitating community Localization, performance optimization, and Localization for popular websites.`
  String get about_app_description {
    return Intl.message(
      'Not just Localization!\n\nSCToolbox is your excellent companion for exploring the universe. We are dedicated to solving common in-game issues for citizens and facilitating community Localization, performance optimization, and Localization for popular websites.',
      name: 'about_app_description',
      desc: '',
      args: [],
    );
  }

  /// `Online Feedback`
  String get about_online_feedback {
    return Intl.message(
      'Online Feedback',
      name: 'about_online_feedback',
      desc: '',
      args: [],
    );
  }

  /// `QQ Group: 940696487`
  String get about_action_qq_group {
    return Intl.message(
      'QQ Group: 940696487',
      name: 'about_action_qq_group',
      desc: '',
      args: [],
    );
  }

  /// `Email: xkeyc@qq.com`
  String get about_action_email {
    return Intl.message(
      'Email: xkeyc@qq.com',
      name: 'about_action_email',
      desc: '',
      args: [],
    );
  }

  /// `Open Source`
  String get about_action_open_source {
    return Intl.message(
      'Open Source',
      name: 'about_action_open_source',
      desc: '',
      args: [],
    );
  }

  /// `This is an unofficial Star Citizen tool and is not affiliated with the Cloud Imperium Group. All content not created by its hosts or users remains the property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.`
  String get about_disclaimer {
    return Intl.message(
      'This is an unofficial Star Citizen tool and is not affiliated with the Cloud Imperium Group. All content not created by its hosts or users remains the property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.',
      name: 'about_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Launch`
  String get about_analytics_launch {
    return Intl.message(
      'Launch',
      name: 'about_analytics_launch',
      desc: '',
      args: [],
    );
  }

  /// `Launch Game`
  String get about_analytics_launch_game {
    return Intl.message(
      'Launch Game',
      name: 'about_analytics_launch_game',
      desc: '',
      args: [],
    );
  }

  /// `Total Users`
  String get about_analytics_total_users {
    return Intl.message(
      'Total Users',
      name: 'about_analytics_total_users',
      desc: '',
      args: [],
    );
  }

  /// `Localization Installation`
  String get about_analytics_install_translation {
    return Intl.message(
      'Localization Installation',
      name: 'about_analytics_install_translation',
      desc: '',
      args: [],
    );
  }

  /// `Performance Optimization`
  String get about_analytics_performance_optimization {
    return Intl.message(
      'Performance Optimization',
      name: 'about_analytics_performance_optimization',
      desc: '',
      args: [],
    );
  }

  /// `P4K Redirection`
  String get about_analytics_p4k_redirection {
    return Intl.message(
      'P4K Redirection',
      name: 'about_analytics_p4k_redirection',
      desc: '',
      args: [],
    );
  }

  /// `users`
  String get about_analytics_units_user {
    return Intl.message(
      'users',
      name: 'about_analytics_units_user',
      desc: '',
      args: [],
    );
  }

  /// `times`
  String get about_analytics_units_times {
    return Intl.message(
      'times',
      name: 'about_analytics_units_times',
      desc: '',
      args: [],
    );
  }

  /// `Already the latest version!`
  String get about_info_latest_version {
    return Intl.message(
      'Already the latest version!',
      name: 'about_info_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `Holiday Countdown`
  String get home_holiday_countdown {
    return Intl.message(
      'Holiday Countdown',
      name: 'home_holiday_countdown',
      desc: '',
      args: [],
    );
  }

  /// `* The holiday dates above are manually collected and maintained, and may contain errors. Feedback is welcome!`
  String get home_holiday_countdown_disclaimer {
    return Intl.message(
      '* The holiday dates above are manually collected and maintained, and may contain errors. Feedback is welcome!',
      name: 'home_holiday_countdown_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `One-Click Launch`
  String get home_action_one_click_launch {
    return Intl.message(
      'One-Click Launch',
      name: 'home_action_one_click_launch',
      desc: '',
      args: [],
    );
  }

  /// `Logging in...`
  String get home_title_logging_in {
    return Intl.message(
      'Logging in...',
      name: 'home_title_logging_in',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get home_login_title_welcome_back {
    return Intl.message(
      'Welcome Back!',
      name: 'home_login_title_welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Launching the game for you...`
  String get home_login_title_launching_game {
    return Intl.message(
      'Launching the game for you...',
      name: 'home_login_title_launching_game',
      desc: '',
      args: [],
    );
  }

  /// `Login to RSI Account`
  String get home_action_login_rsi_account {
    return Intl.message(
      'Login to RSI Account',
      name: 'home_action_login_rsi_account',
      desc: '',
      args: [],
    );
  }

  /// `Game version outdated`
  String get home_login_info_game_version_outdated {
    return Intl.message(
      'Game version outdated',
      name: 'home_login_info_game_version_outdated',
      desc: '',
      args: [],
    );
  }

  /// `RSI Server reports version: {v1} \n\nLocal version: {v2} \n\nIt is recommended to use RSI Launcher to update the game!`
  String home_login_info_rsi_server_report(Object v1, Object v2) {
    return Intl.message(
      'RSI Server reports version: $v1 \n\nLocal version: $v2 \n\nIt is recommended to use RSI Launcher to update the game!',
      name: 'home_login_info_rsi_server_report',
      desc: '',
      args: [v1, v2],
    );
  }

  /// `Ignore`
  String get home_login_info_action_ignore {
    return Intl.message(
      'Ignore',
      name: 'home_login_info_action_ignore',
      desc: '',
      args: [],
    );
  }

  /// `Toolbox One-Click Launch`
  String get home_login_action_title_box_one_click_launch {
    return Intl.message(
      'Toolbox One-Click Launch',
      name: 'home_login_action_title_box_one_click_launch',
      desc: '',
      args: [],
    );
  }

  /// `This feature helps you launch the game more conveniently.\n\nTo ensure account safety, this feature uses a localized browser to maintain login status and will not save your password information (unless you enable the auto-fill feature).\n\nWhen using this feature to login, please ensure that your SCToolbox is downloaded from a trusted source.`
  String get home_login_info_one_click_launch_description {
    return Intl.message(
      'This feature helps you launch the game more conveniently.\n\nTo ensure account safety, this feature uses a localized browser to maintain login status and will not save your password information (unless you enable the auto-fill feature).\n\nWhen using this feature to login, please ensure that your SCToolbox is downloaded from a trusted source.',
      name: 'home_login_info_one_click_launch_description',
      desc: '',
      args: [],
    );
  }

  /// `WebView2 Runtime Required`
  String get home_login_action_title_need_webview2_runtime {
    return Intl.message(
      'WebView2 Runtime Required',
      name: 'home_login_action_title_need_webview2_runtime',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get action_close {
    return Intl.message('Close', name: 'action_close', desc: '', args: []);
  }

  /// `Speed Limit Settings`
  String get downloader_speed_limit_settings {
    return Intl.message(
      'Speed Limit Settings',
      name: 'downloader_speed_limit_settings',
      desc: '',
      args: [],
    );
  }

  /// `Pause All`
  String get downloader_action_pause_all {
    return Intl.message(
      'Pause All',
      name: 'downloader_action_pause_all',
      desc: '',
      args: [],
    );
  }

  /// `Resume All`
  String get downloader_action_resume_all {
    return Intl.message(
      'Resume All',
      name: 'downloader_action_resume_all',
      desc: '',
      args: [],
    );
  }

  /// `Cancel All`
  String get downloader_action_cancel_all {
    return Intl.message(
      'Cancel All',
      name: 'downloader_action_cancel_all',
      desc: '',
      args: [],
    );
  }

  /// `Clear Completed`
  String get downloader_action_clear_completed {
    return Intl.message(
      'Clear Completed',
      name: 'downloader_action_clear_completed',
      desc: '',
      args: [],
    );
  }

  /// `Remove Record`
  String get downloader_action_remove_record {
    return Intl.message(
      'Remove Record',
      name: 'downloader_action_remove_record',
      desc: '',
      args: [],
    );
  }

  /// `No download tasks`
  String get downloader_info_no_download_tasks {
    return Intl.message(
      'No download tasks',
      name: 'downloader_info_no_download_tasks',
      desc: '',
      args: [],
    );
  }

  /// `Total Size: {v1}`
  String downloader_info_total_size(Object v1) {
    return Intl.message(
      'Total Size: $v1',
      name: 'downloader_info_total_size',
      desc: '',
      args: [v1],
    );
  }

  /// `Downloading... ({v0}%)`
  String downloader_info_downloading(Object v0) {
    return Intl.message(
      'Downloading... ($v0%)',
      name: 'downloader_info_downloading',
      desc: '',
      args: [v0],
    );
  }

  /// `Status: {v0}`
  String downloader_info_status(Object v0) {
    return Intl.message(
      'Status: $v0',
      name: 'downloader_info_status',
      desc: '',
      args: [v0],
    );
  }

  /// `Uploaded: {v0}`
  String downloader_info_uploaded(Object v0) {
    return Intl.message(
      'Uploaded: $v0',
      name: 'downloader_info_uploaded',
      desc: '',
      args: [v0],
    );
  }

  /// `Downloaded: {v0}`
  String downloader_info_downloaded(Object v0) {
    return Intl.message(
      'Downloaded: $v0',
      name: 'downloader_info_downloaded',
      desc: '',
      args: [v0],
    );
  }

  /// `Checked: {v0}`
  String downloader_info_checked(Object v0) {
    return Intl.message(
      'Checked: $v0',
      name: 'downloader_info_checked',
      desc: '',
      args: [v0],
    );
  }

  /// `Options`
  String get downloader_action_options {
    return Intl.message(
      'Options',
      name: 'downloader_action_options',
      desc: '',
      args: [],
    );
  }

  /// `Continue Download`
  String get downloader_action_continue_download {
    return Intl.message(
      'Continue Download',
      name: 'downloader_action_continue_download',
      desc: '',
      args: [],
    );
  }

  /// `Pause Download`
  String get downloader_action_pause_download {
    return Intl.message(
      'Pause Download',
      name: 'downloader_action_pause_download',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Download`
  String get downloader_action_cancel_download {
    return Intl.message(
      'Cancel Download',
      name: 'downloader_action_cancel_download',
      desc: '',
      args: [],
    );
  }

  /// `Open Folder`
  String get action_open_folder {
    return Intl.message(
      'Open Folder',
      name: 'action_open_folder',
      desc: '',
      args: [],
    );
  }

  /// `Download: {v0}/s    Upload: {v1}/s`
  String downloader_info_download_upload_speed(Object v0, Object v1) {
    return Intl.message(
      'Download: $v0/s    Upload: $v1/s',
      name: 'downloader_info_download_upload_speed',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Downloading...`
  String get downloader_info_downloading_status {
    return Intl.message(
      'Downloading...',
      name: 'downloader_info_downloading_status',
      desc: '',
      args: [],
    );
  }

  /// `Checking`
  String get downloader_info_checking {
    return Intl.message(
      'Checking',
      name: 'downloader_info_checking',
      desc: '',
      args: [],
    );
  }

  /// `Checking... ({v0}%)`
  String downloader_info_checking_progress(Object v0) {
    return Intl.message(
      'Checking... ($v0%)',
      name: 'downloader_info_checking_progress',
      desc: '',
      args: [v0],
    );
  }

  /// `Waiting`
  String get downloader_info_waiting {
    return Intl.message(
      'Waiting',
      name: 'downloader_info_waiting',
      desc: '',
      args: [],
    );
  }

  /// `Paused`
  String get downloader_info_paused {
    return Intl.message(
      'Paused',
      name: 'downloader_info_paused',
      desc: '',
      args: [],
    );
  }

  /// `Download Failed`
  String get downloader_info_download_failed {
    return Intl.message(
      'Download Failed',
      name: 'downloader_info_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `Download Completed`
  String get downloader_info_download_completed {
    return Intl.message(
      'Download Completed',
      name: 'downloader_info_download_completed',
      desc: '',
      args: [],
    );
  }

  /// `Deleted`
  String get downloader_info_deleted {
    return Intl.message(
      'Deleted',
      name: 'downloader_info_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Downloading`
  String get downloader_title_downloading {
    return Intl.message(
      'Downloading',
      name: 'downloader_title_downloading',
      desc: '',
      args: [],
    );
  }

  /// `Ended`
  String get downloader_title_ended {
    return Intl.message(
      'Ended',
      name: 'downloader_title_ended',
      desc: '',
      args: [],
    );
  }

  /// `Confirm cancellation of all tasks?`
  String get downloader_action_confirm_cancel_all_tasks {
    return Intl.message(
      'Confirm cancellation of all tasks?',
      name: 'downloader_action_confirm_cancel_all_tasks',
      desc: '',
      args: [],
    );
  }

  /// `If the file is no longer needed, you may need to manually delete the downloaded files.`
  String get downloader_info_manual_file_deletion_note {
    return Intl.message(
      'If the file is no longer needed, you may need to manually delete the downloaded files.',
      name: 'downloader_info_manual_file_deletion_note',
      desc: '',
      args: [],
    );
  }

  /// `Confirm cancellation of download?`
  String get downloader_action_confirm_cancel_download {
    return Intl.message(
      'Confirm cancellation of download?',
      name: 'downloader_action_confirm_cancel_download',
      desc: '',
      args: [],
    );
  }

  /// `SCToolbox uses p2p network to accelerate file downloads. If you have limited bandwidth, you can set the upload bandwidth to 1(byte) here.`
  String get downloader_info_p2p_network_note {
    return Intl.message(
      'SCToolbox uses p2p network to accelerate file downloads. If you have limited bandwidth, you can set the upload bandwidth to 1(byte) here.',
      name: 'downloader_info_p2p_network_note',
      desc: '',
      args: [],
    );
  }

  /// `Please enter download units, e.g.: 1, 100k, 10m. Enter 0 or leave blank for unlimited speed.`
  String get downloader_info_download_unit_input_prompt {
    return Intl.message(
      'Please enter download units, e.g.: 1, 100k, 10m. Enter 0 or leave blank for unlimited speed.',
      name: 'downloader_info_download_unit_input_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Upload Speed Limit:`
  String get downloader_input_upload_speed_limit {
    return Intl.message(
      'Upload Speed Limit:',
      name: 'downloader_input_upload_speed_limit',
      desc: '',
      args: [],
    );
  }

  /// `Download Speed Limit:`
  String get downloader_input_download_speed_limit {
    return Intl.message(
      'Download Speed Limit:',
      name: 'downloader_input_download_speed_limit',
      desc: '',
      args: [],
    );
  }

  /// `* P2P upload only occurs when downloading files and will close p2p connections after download completion. If you want to participate in seeding, please contact us through the About page.`
  String get downloader_input_info_p2p_upload_note {
    return Intl.message(
      '* P2P upload only occurs when downloading files and will close p2p connections after download completion. If you want to participate in seeding, please contact us through the About page.',
      name: 'downloader_input_info_p2p_upload_note',
      desc: '',
      args: [],
    );
  }

  /// `Speed limit settings saved. Will apply on next downloader start.`
  String get downloader_info_speed_limit_saved_restart_required {
    return Intl.message(
      'Speed limit settings saved. Will apply on next downloader start.',
      name: 'downloader_info_speed_limit_saved_restart_required',
      desc: '',
      args: [],
    );
  }

  /// `Restart Now`
  String get downloader_action_restart_now {
    return Intl.message(
      'Restart Now',
      name: 'downloader_action_restart_now',
      desc: '',
      args: [],
    );
  }

  /// `Apply Later`
  String get downloader_action_restart_later {
    return Intl.message(
      'Apply Later',
      name: 'downloader_action_restart_later',
      desc: '',
      args: [],
    );
  }

  /// `Speed limit settings saved. Restart the download manager now to apply new settings?`
  String get downloader_info_restart_manager_to_apply {
    return Intl.message(
      'Speed limit settings saved. Restart the download manager now to apply new settings?',
      name: 'downloader_info_restart_manager_to_apply',
      desc: '',
      args: [],
    );
  }

  /// `One-Click Diagnosis -> {v0}`
  String doctor_title_one_click_diagnosis(Object v0) {
    return Intl.message(
      'One-Click Diagnosis -> $v0',
      name: 'doctor_title_one_click_diagnosis',
      desc: '',
      args: [v0],
    );
  }

  /// `RSI Launcher log`
  String get doctor_action_rsi_launcher_log {
    return Intl.message(
      'RSI Launcher log',
      name: 'doctor_action_rsi_launcher_log',
      desc: '',
      args: [],
    );
  }

  /// `Game run log`
  String get doctor_action_game_run_log {
    return Intl.message(
      'Game run log',
      name: 'doctor_action_game_run_log',
      desc: '',
      args: [],
    );
  }

  /// `Scan complete, no issues found!`
  String get doctor_info_scan_complete_no_issues {
    return Intl.message(
      'Scan complete, no issues found!',
      name: 'doctor_info_scan_complete_no_issues',
      desc: '',
      args: [],
    );
  }

  /// `Processing...`
  String get doctor_info_processing {
    return Intl.message(
      'Processing...',
      name: 'doctor_info_processing',
      desc: '',
      args: [],
    );
  }

  /// `You are about to access the game anomaly rescue service provided by Deep Space Treatment Center (QQ Group: 536454632), which mainly solves game installation failures and frequent crashes. Please do not join the group for gameplay issues.`
  String get doctor_info_game_rescue_service_note {
    return Intl.message(
      'You are about to access the game anomaly rescue service provided by Deep Space Treatment Center (QQ Group: 536454632), which mainly solves game installation failures and frequent crashes. Please do not join the group for gameplay issues.',
      name: 'doctor_info_game_rescue_service_note',
      desc: '',
      args: [],
    );
  }

  /// `Need help? Click to join the group for free human support!`
  String get doctor_info_need_help {
    return Intl.message(
      'Need help? Click to join the group for free human support!',
      name: 'doctor_info_need_help',
      desc: '',
      args: [],
    );
  }

  /// `Note: The detection results of this tool are for reference only. If you do not understand the following operations, please provide screenshots to experienced players!`
  String get doctor_info_tool_check_result_note {
    return Intl.message(
      'Note: The detection results of this tool are for reference only. If you do not understand the following operations, please provide screenshots to experienced players!',
      name: 'doctor_info_tool_check_result_note',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported operating system, the game may not run`
  String get doctor_info_result_unsupported_os {
    return Intl.message(
      'Unsupported operating system, the game may not run',
      name: 'doctor_info_result_unsupported_os',
      desc: '',
      args: [],
    );
  }

  /// `Please upgrade your system ({v0})`
  String doctor_info_result_upgrade_system(Object v0) {
    return Intl.message(
      'Please upgrade your system ($v0)',
      name: 'doctor_info_result_upgrade_system',
      desc: '',
      args: [v0],
    );
  }

  /// `Installation directory is missing LIVE folder, may cause installation failure`
  String get doctor_info_result_missing_live_folder {
    return Intl.message(
      'Installation directory is missing LIVE folder, may cause installation failure',
      name: 'doctor_info_result_missing_live_folder',
      desc: '',
      args: [],
    );
  }

  /// `Click to fix and create LIVE folder for you, then retry installation. ({v0})`
  String doctor_info_result_create_live_folder(Object v0) {
    return Intl.message(
      'Click to fix and create LIVE folder for you, then retry installation. ($v0)',
      name: 'doctor_info_result_create_live_folder',
      desc: '',
      args: [v0],
    );
  }

  /// `New type NVME device, not compatible with RSI Launcher, may cause installation failure`
  String get doctor_info_result_incompatible_nvme_device {
    return Intl.message(
      'New type NVME device, not compatible with RSI Launcher, may cause installation failure',
      name: 'doctor_info_result_incompatible_nvme_device',
      desc: '',
      args: [],
    );
  }

  /// `Add ForcedPhysicalSectorSizeInBytes value to registry to simulate old devices. Hard disk partition ({v0})`
  String doctor_info_result_add_registry_value(Object v0) {
    return Intl.message(
      'Add ForcedPhysicalSectorSizeInBytes value to registry to simulate old devices. Hard disk partition ($v0)',
      name: 'doctor_info_result_add_registry_value',
      desc: '',
      args: [v0],
    );
  }

  /// `EasyAntiCheat files missing`
  String get doctor_info_result_missing_easyanticheat_files {
    return Intl.message(
      'EasyAntiCheat files missing',
      name: 'doctor_info_result_missing_easyanticheat_files',
      desc: '',
      args: [],
    );
  }

  /// `EasyAntiCheat files not found in LIVE folder or files are incomplete, please use RSI Launcher to verify files`
  String get doctor_info_result_verify_files_with_rsi_launcher {
    return Intl.message(
      'EasyAntiCheat files not found in LIVE folder or files are incomplete, please use RSI Launcher to verify files',
      name: 'doctor_info_result_verify_files_with_rsi_launcher',
      desc: '',
      args: [],
    );
  }

  /// `EasyAntiCheat not installed or abnormal exit`
  String get doctor_info_result_easyanticheat_not_installed {
    return Intl.message(
      'EasyAntiCheat not installed or abnormal exit',
      name: 'doctor_info_result_easyanticheat_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `EasyAntiCheat is not installed, please click fix to install it with one click. (This issue will persist until the game starts and exits normally. If your game crashes for other reasons, you can ignore this entry)`
  String get doctor_info_result_install_easyanticheat {
    return Intl.message(
      'EasyAntiCheat is not installed, please click fix to install it with one click. (This issue will persist until the game starts and exits normally. If your game crashes for other reasons, you can ignore this entry)',
      name: 'doctor_info_result_install_easyanticheat',
      desc: '',
      args: [],
    );
  }

  /// `Chinese username!`
  String get doctor_info_result_chinese_username {
    return Intl.message(
      'Chinese username!',
      name: 'doctor_info_result_chinese_username',
      desc: '',
      args: [],
    );
  }

  /// `Chinese username may cause game startup/installation errors! Click the fix button to view the modification tutorial!`
  String get doctor_info_result_chinese_username_error {
    return Intl.message(
      'Chinese username may cause game startup/installation errors! Click the fix button to view the modification tutorial!',
      name: 'doctor_info_result_chinese_username_error',
      desc: '',
      args: [],
    );
  }

  /// `Chinese installation path!`
  String get doctor_info_result_chinese_install_path {
    return Intl.message(
      'Chinese installation path!',
      name: 'doctor_info_result_chinese_install_path',
      desc: '',
      args: [],
    );
  }

  /// `Chinese installation path! This may cause game startup/installation errors! ({v0}), please change the installation path in the RSI Launcher.`
  String doctor_info_result_chinese_install_path_error(Object v0) {
    return Intl.message(
      'Chinese installation path! This may cause game startup/installation errors! ($v0), please change the installation path in the RSI Launcher.',
      name: 'doctor_info_result_chinese_install_path_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Low physical memory`
  String get doctor_info_result_low_physical_memory {
    return Intl.message(
      'Low physical memory',
      name: 'doctor_info_result_low_physical_memory',
      desc: '',
      args: [],
    );
  }

  /// `You need at least 16GB of physical memory (RAM) to run this game. (Current size: {v0})`
  String doctor_info_result_memory_requirement(Object v0) {
    return Intl.message(
      'You need at least 16GB of physical memory (RAM) to run this game. (Current size: $v0)',
      name: 'doctor_info_result_memory_requirement',
      desc: '',
      args: [v0],
    );
  }

  /// `Fix suggestion: {v0}`
  String doctor_info_result_fix_suggestion(Object v0) {
    return Intl.message(
      'Fix suggestion: $v0',
      name: 'doctor_info_result_fix_suggestion',
      desc: '',
      args: [v0],
    );
  }

  /// `No solution available yet, please take a screenshot and report feedback`
  String get doctor_info_result_no_solution {
    return Intl.message(
      'No solution available yet, please take a screenshot and report feedback',
      name: 'doctor_info_result_no_solution',
      desc: '',
      args: [],
    );
  }

  /// `Fix`
  String get doctor_info_action_fix {
    return Intl.message(
      'Fix',
      name: 'doctor_info_action_fix',
      desc: '',
      args: [],
    );
  }

  /// `View Solution`
  String get doctor_action_view_solution {
    return Intl.message(
      'View Solution',
      name: 'doctor_action_view_solution',
      desc: '',
      args: [],
    );
  }

  /// `Please select the game installation directory on the home page.`
  String get doctor_tip_title_select_game_directory {
    return Intl.message(
      'Please select the game installation directory on the home page.',
      name: 'doctor_tip_title_select_game_directory',
      desc: '',
      args: [],
    );
  }

  /// `If your hardware meets the requirements, please try installing the latest Windows system.`
  String get doctor_action_result_try_latest_windows {
    return Intl.message(
      'If your hardware meets the requirements, please try installing the latest Windows system.',
      name: 'doctor_action_result_try_latest_windows',
      desc: '',
      args: [],
    );
  }

  /// `Folder creation successful, please try to continue downloading the game!`
  String get doctor_action_result_create_folder_success {
    return Intl.message(
      'Folder creation successful, please try to continue downloading the game!',
      name: 'doctor_action_result_create_folder_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create folder, please try to create it manually.\nDirectory: {v0} \nError: {v1}`
  String doctor_action_result_create_folder_fail(Object v0, Object v1) {
    return Intl.message(
      'Failed to create folder, please try to create it manually.\nDirectory: $v0 \nError: $v1',
      name: 'doctor_action_result_create_folder_fail',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Fix successful, please try restarting and continue installing the game! If the registry modification causes compatibility issues with other software, please use the NVME registry cleaner in the Tools section.`
  String get doctor_action_result_fix_success {
    return Intl.message(
      'Fix successful, please try restarting and continue installing the game! If the registry modification causes compatibility issues with other software, please use the NVME registry cleaner in the Tools section.',
      name: 'doctor_action_result_fix_success',
      desc: '',
      args: [],
    );
  }

  /// `Fix failed, {v0}`
  String doctor_action_result_fix_fail(Object v0) {
    return Intl.message(
      'Fix failed, $v0',
      name: 'doctor_action_result_fix_fail',
      desc: '',
      args: [v0],
    );
  }

  /// `Fix successful, please try to start the game. (If the problem persists, please use the 'Reinstall EAC' tool in the toolbox)`
  String get doctor_action_result_game_start_success {
    return Intl.message(
      'Fix successful, please try to start the game. (If the problem persists, please use the \'Reinstall EAC\' tool in the toolbox)',
      name: 'doctor_action_result_game_start_success',
      desc: '',
      args: [],
    );
  }

  /// `About to redirect, the tutorial is from the internet, please proceed with caution...`
  String get doctor_action_result_redirect_warning {
    return Intl.message(
      'About to redirect, the tutorial is from the internet, please proceed with caution...',
      name: 'doctor_action_result_redirect_warning',
      desc: '',
      args: [],
    );
  }

  /// `This issue is not currently supported for automatic handling, please provide screenshots to seek help`
  String get doctor_action_result_issue_not_supported {
    return Intl.message(
      'This issue is not currently supported for automatic handling, please provide screenshots to seek help',
      name: 'doctor_action_result_issue_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing...`
  String get doctor_action_analyzing {
    return Intl.message(
      'Analyzing...',
      name: 'doctor_action_analyzing',
      desc: '',
      args: [],
    );
  }

  /// `Analysis complete, no issues found`
  String get doctor_action_result_analysis_no_issue {
    return Intl.message(
      'Analysis complete, no issues found',
      name: 'doctor_action_result_analysis_no_issue',
      desc: '',
      args: [],
    );
  }

  /// `Analysis complete, found {v0} issues`
  String doctor_action_result_analysis_issues_found(Object v0) {
    return Intl.message(
      'Analysis complete, found $v0 issues',
      name: 'doctor_action_result_analysis_issues_found',
      desc: '',
      args: [v0],
    );
  }

  /// `Scan complete, no issues found. If installation still fails, please try using the RSI Launcher in administrator mode from the toolbox.`
  String get doctor_action_result_toast_scan_no_issue {
    return Intl.message(
      'Scan complete, no issues found. If installation still fails, please try using the RSI Launcher in administrator mode from the toolbox.',
      name: 'doctor_action_result_toast_scan_no_issue',
      desc: '',
      args: [],
    );
  }

  /// `Checking: Game.log`
  String get doctor_action_tip_checking_game_log {
    return Intl.message(
      'Checking: Game.log',
      name: 'doctor_action_tip_checking_game_log',
      desc: '',
      args: [],
    );
  }

  /// `Game abnormal exit: {v0}`
  String doctor_action_info_game_abnormal_exit(Object v0) {
    return Intl.message(
      'Game abnormal exit: $v0',
      name: 'doctor_action_info_game_abnormal_exit',
      desc: '',
      args: [v0],
    );
  }

  /// `Game abnormal exit: Unknown exception`
  String get doctor_action_info_game_abnormal_exit_unknown {
    return Intl.message(
      'Game abnormal exit: Unknown exception',
      name: 'doctor_action_info_game_abnormal_exit_unknown',
      desc: '',
      args: [],
    );
  }

  /// `info:{v0}, please click the bottom right corner to join the group for feedback.`
  String doctor_action_info_info_feedback(Object v0) {
    return Intl.message(
      'info:$v0, please click the bottom right corner to join the group for feedback.',
      name: 'doctor_action_info_info_feedback',
      desc: '',
      args: [v0],
    );
  }

  /// `Checking: EAC`
  String get doctor_action_info_checking_eac {
    return Intl.message(
      'Checking: EAC',
      name: 'doctor_action_info_checking_eac',
      desc: '',
      args: [],
    );
  }

  /// `Checking: Runtime environment`
  String get doctor_action_info_checking_runtime {
    return Intl.message(
      'Checking: Runtime environment',
      name: 'doctor_action_info_checking_runtime',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported operating system: {v0}`
  String doctor_action_result_info_unsupported_os(Object v0) {
    return Intl.message(
      'Unsupported operating system: $v0',
      name: 'doctor_action_result_info_unsupported_os',
      desc: '',
      args: [v0],
    );
  }

  /// `Checking: Installation information`
  String get doctor_action_info_checking_install_info {
    return Intl.message(
      'Checking: Installation information',
      name: 'doctor_action_info_checking_install_info',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get doctor_action_view_details {
    return Intl.message(
      'View Details',
      name: 'doctor_action_view_details',
      desc: '',
      args: [],
    );
  }

  /// `Installation Location:`
  String get home_install_location {
    return Intl.message(
      'Installation Location:',
      name: 'home_install_location',
      desc: '',
      args: [],
    );
  }

  /// `Not Installed or Installation Failed`
  String get home_not_installed_or_failed {
    return Intl.message(
      'Not Installed or Installation Failed',
      name: 'home_not_installed_or_failed',
      desc: '',
      args: [],
    );
  }

  /// `SC Website Localization`
  String get home_action_star_citizen_website_localization {
    return Intl.message(
      'SC Website Localization',
      name: 'home_action_star_citizen_website_localization',
      desc: '',
      args: [],
    );
  }

  /// `Roberts Space Industries, the origin of everything`
  String get home_action_info_roberts_space_industries_origin {
    return Intl.message(
      'Roberts Space Industries, the origin of everything',
      name: 'home_action_info_roberts_space_industries_origin',
      desc: '',
      args: [],
    );
  }

  /// `UEX Localization`
  String get home_action_uex_localization {
    return Intl.message(
      'UEX Localization',
      name: 'home_action_uex_localization',
      desc: '',
      args: [],
    );
  }

  /// `Mining, refining, trade calculator, prices, ship information`
  String get home_action_info_mining_refining_trade_calculator {
    return Intl.message(
      'Mining, refining, trade calculator, prices, ship information',
      name: 'home_action_info_mining_refining_trade_calculator',
      desc: '',
      args: [],
    );
  }

  /// `DPS Calculator Localization`
  String get home_action_dps_calculator_localization {
    return Intl.message(
      'DPS Calculator Localization',
      name: 'home_action_dps_calculator_localization',
      desc: '',
      args: [],
    );
  }

  /// `Online ship modification, damage value query and equipment purchase location`
  String get home_action_info_ship_upgrade_damage_value_query {
    return Intl.message(
      'Online ship modification, damage value query and equipment purchase location',
      name: 'home_action_info_ship_upgrade_damage_value_query',
      desc: '',
      args: [],
    );
  }

  /// `External Browser Extension:`
  String get home_action_external_browser_extension {
    return Intl.message(
      'External Browser Extension:',
      name: 'home_action_external_browser_extension',
      desc: '',
      args: [],
    );
  }

  /// `One-Click Diagnosis`
  String get home_action_one_click_diagnosis {
    return Intl.message(
      'One-Click Diagnosis',
      name: 'home_action_one_click_diagnosis',
      desc: '',
      args: [],
    );
  }

  /// `One-click diagnosis of common Star Citizen issues`
  String get home_action_info_one_click_diagnosis_star_citizen {
    return Intl.message(
      'One-click diagnosis of common Star Citizen issues',
      name: 'home_action_info_one_click_diagnosis_star_citizen',
      desc: '',
      args: [],
    );
  }

  /// `Localization Management`
  String get home_action_localization_management {
    return Intl.message(
      'Localization Management',
      name: 'home_action_localization_management',
      desc: '',
      args: [],
    );
  }

  /// `Quick installation of Localization resources`
  String get home_action_info_quick_install_localization_resources {
    return Intl.message(
      'Quick installation of Localization resources',
      name: 'home_action_info_quick_install_localization_resources',
      desc: '',
      args: [],
    );
  }

  /// `Performance Optimization`
  String get home_action_performance_optimization {
    return Intl.message(
      'Performance Optimization',
      name: 'home_action_performance_optimization',
      desc: '',
      args: [],
    );
  }

  /// `Adjust engine configuration files to optimize game performance`
  String get home_action_info_engine_config_optimization {
    return Intl.message(
      'Adjust engine configuration files to optimize game performance',
      name: 'home_action_info_engine_config_optimization',
      desc: '',
      args: [],
    );
  }

  /// `Platform`
  String get home_action_rsi_status_platform {
    return Intl.message(
      'Platform',
      name: 'home_action_rsi_status_platform',
      desc: '',
      args: [],
    );
  }

  /// `PU`
  String get home_action_rsi_status_persistent_universe {
    return Intl.message(
      'PU',
      name: 'home_action_rsi_status_persistent_universe',
      desc: '',
      args: [],
    );
  }

  /// `EA`
  String get home_action_rsi_status_electronic_access {
    return Intl.message(
      'EA',
      name: 'home_action_rsi_status_electronic_access',
      desc: '',
      args: [],
    );
  }

  /// `AC`
  String get home_action_rsi_status_arena_commander {
    return Intl.message(
      'AC',
      name: 'home_action_rsi_status_arena_commander',
      desc: '',
      args: [],
    );
  }

  /// `Server Status`
  String get home_action_rsi_status_rsi_server_status {
    return Intl.message(
      'Server Status',
      name: 'home_action_rsi_status_rsi_server_status',
      desc: '',
      args: [],
    );
  }

  /// `Status:`
  String get home_action_rsi_status_status {
    return Intl.message(
      'Status:',
      name: 'home_action_rsi_status_status',
      desc: '',
      args: [],
    );
  }

  /// `Announcement Details`
  String get home_announcement_details {
    return Intl.message(
      'Announcement Details',
      name: 'home_announcement_details',
      desc: '',
      args: [],
    );
  }

  /// `This feature requires a valid installation location\n\nIf your game is not fully downloaded, please wait for the download to complete before using this feature.\n\nIf your game has been completely downloaded but isn't recognized, please launch the game once and then reopen SCToolbox or manually set the installation location in settings.`
  String get home_action_info_valid_install_location_required {
    return Intl.message(
      'This feature requires a valid installation location\n\nIf your game is not fully downloaded, please wait for the download to complete before using this feature.\n\nIf your game has been completely downloaded but isn\'t recognized, please launch the game once and then reopen SCToolbox or manually set the installation location in settings.',
      name: 'home_action_info_valid_install_location_required',
      desc: '',
      args: [],
    );
  }

  /// `Scanning ...`
  String get home_action_info_scanning {
    return Intl.message(
      'Scanning ...',
      name: 'home_action_info_scanning',
      desc: '',
      args: [],
    );
  }

  /// `Scan complete, found {v0} valid installation directories`
  String home_action_info_scan_complete_valid_directories_found(Object v0) {
    return Intl.message(
      'Scan complete, found $v0 valid installation directories',
      name: 'home_action_info_scan_complete_valid_directories_found',
      desc: '',
      args: [v0],
    );
  }

  /// `Failed to parse log file!`
  String get home_action_info_log_file_parse_fail {
    return Intl.message(
      'Failed to parse log file!',
      name: 'home_action_info_log_file_parse_fail',
      desc: '',
      args: [],
    );
  }

  /// `SC Site Localization`
  String get home_action_title_star_citizen_website_localization {
    return Intl.message(
      'SC Site Localization',
      name: 'home_action_title_star_citizen_website_localization',
      desc: '',
      args: [],
    );
  }

  /// `This plugin is for general browsing purposes only and is not responsible for any issues that may arise from its use! Please verify the original content of the website before performing any account operations!\n\n\nWhen logging into your account with this feature, please ensure your SCToolbox is downloaded from a trusted source.`
  String get home_action_info_web_localization_plugin_disclaimer {
    return Intl.message(
      'This plugin is for general browsing purposes only and is not responsible for any issues that may arise from its use! Please verify the original content of the website before performing any account operations!\n\n\nWhen logging into your account with this feature, please ensure your SCToolbox is downloaded from a trusted source.',
      name: 'home_action_info_web_localization_plugin_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Initializing localization resources...`
  String get home_action_info_initializing_resources {
    return Intl.message(
      'Initializing localization resources...',
      name: 'home_action_info_initializing_resources',
      desc: '',
      args: [],
    );
  }

  /// `Failed to initialize web localization resources! {v0}`
  String home_action_info_initialization_failed(Object v0) {
    return Intl.message(
      'Failed to initialize web localization resources! $v0',
      name: 'home_action_info_initialization_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `SCToolbox`
  String get home_title_app_name {
    return Intl.message(
      'SCToolbox',
      name: 'home_title_app_name',
      desc: '',
      args: [],
    );
  }

  /// `New localization version available!`
  String get home_localization_new_version_available {
    return Intl.message(
      'New localization version available!',
      name: 'home_localization_new_version_available',
      desc: '',
      args: [],
    );
  }

  /// `There's a new version of the localization you installed on {v0}!`
  String home_localization_new_version_installed(Object v0) {
    return Intl.message(
      'There\'s a new version of the localization you installed on $v0!',
      name: 'home_localization_new_version_installed',
      desc: '',
      args: [v0],
    );
  }

  /// `This feature requires a valid installation location`
  String get home_info_valid_installation_required {
    return Intl.message(
      'This feature requires a valid installation location',
      name: 'home_info_valid_installation_required',
      desc: '',
      args: [],
    );
  }

  /// `One-click launch feature notice`
  String get home_info_one_click_launch_warning {
    return Intl.message(
      'One-click launch feature notice',
      name: 'home_info_one_click_launch_warning',
      desc: '',
      args: [],
    );
  }

  /// `To ensure account security, the one-click launch feature has been disabled in the development version. We will provide this feature in the Microsoft Store version.\n\nThe Microsoft Store version provides reliable distribution downloads and digital signatures from Microsoft, which can effectively prevent malicious tampering of the software.\n\nNote: You don't need to use SCToolbox to launch the game to use localization.`
  String get home_info_account_security_warning {
    return Intl.message(
      'To ensure account security, the one-click launch feature has been disabled in the development version. We will provide this feature in the Microsoft Store version.\n\nThe Microsoft Store version provides reliable distribution downloads and digital signatures from Microsoft, which can effectively prevent malicious tampering of the software.\n\nNote: You don\'t need to use SCToolbox to launch the game to use localization.',
      name: 'home_info_account_security_warning',
      desc: '',
      args: [],
    );
  }

  /// `Install Microsoft Store Version`
  String get home_action_install_microsoft_store_version {
    return Intl.message(
      'Install Microsoft Store Version',
      name: 'home_action_install_microsoft_store_version',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get home_action_cancel {
    return Intl.message(
      'Cancel',
      name: 'home_action_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Game exited abnormally\nexitCode={v0}\nstdout={v1}\nstderr={v2}\n\nDiagnostic information: {v3} \n{v4}`
  String home_action_info_abnormal_game_exit(
    Object v0,
    Object v1,
    Object v2,
    Object v3,
    Object v4,
  ) {
    return Intl.message(
      'Game exited abnormally\nexitCode=$v0\nstdout=$v1\nstderr=$v2\n\nDiagnostic information: $v3 \n$v4',
      name: 'home_action_info_abnormal_game_exit',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `Unknown error, please use the one-click diagnosis to join the group for feedback.`
  String get home_action_info_unknown_error {
    return Intl.message(
      'Unknown error, please use the one-click diagnosis to join the group for feedback.',
      name: 'home_action_info_unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Please check the popup web link for detailed information.`
  String get home_action_info_check_web_link {
    return Intl.message(
      'Please check the popup web link for detailed information.',
      name: 'home_action_info_check_web_link',
      desc: '',
      args: [],
    );
  }

  /// `Game built-in`
  String get home_action_info_game_built_in {
    return Intl.message(
      'Game built-in',
      name: 'home_action_info_game_built_in',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get home_action_info_warning {
    return Intl.message(
      'Warning',
      name: 'home_action_info_warning',
      desc: '',
      args: [],
    );
  }

  /// `You are using the game's built-in text. The official text is currently machine-translated (as of 3.21.0). We recommend you install the community localization below.`
  String get localization_info_machine_translation_warning {
    return Intl.message(
      'You are using the game\'s built-in text. The official text is currently machine-translated (as of 3.21.0). We recommend you install the community localization below.',
      name: 'localization_info_machine_translation_warning',
      desc: '',
      args: [],
    );
  }

  /// `Game Localization`
  String get localization_info_translation {
    return Intl.message(
      'Game Localization',
      name: 'localization_info_translation',
      desc: '',
      args: [],
    );
  }

  /// `Enabled ({v0}):`
  String localization_info_enabled(Object v0) {
    return Intl.message(
      'Enabled ($v0):',
      name: 'localization_info_enabled',
      desc: '',
      args: [v0],
    );
  }

  /// `Installed version: {v0}`
  String localization_info_installed_version(Object v0) {
    return Intl.message(
      'Installed version: $v0',
      name: 'localization_info_installed_version',
      desc: '',
      args: [v0],
    );
  }

  /// `Localization Feedback`
  String get localization_action_translation_feedback {
    return Intl.message(
      'Localization Feedback',
      name: 'localization_action_translation_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Uninstall Localization`
  String get localization_action_uninstall_translation {
    return Intl.message(
      'Uninstall Localization',
      name: 'localization_action_uninstall_translation',
      desc: '',
      args: [],
    );
  }

  /// `Note:`
  String get localization_info_note {
    return Intl.message(
      'Note:',
      name: 'localization_info_note',
      desc: '',
      args: [],
    );
  }

  /// `Community Localization`
  String get localization_info_community_translation {
    return Intl.message(
      'Community Localization',
      name: 'localization_info_community_translation',
      desc: '',
      args: [],
    );
  }

  /// `No localization available for this language/version, please stay tuned!`
  String get localization_info_no_translation_available {
    return Intl.message(
      'No localization available for this language/version, please stay tuned!',
      name: 'localization_info_no_translation_available',
      desc: '',
      args: [],
    );
  }

  /// `Install`
  String get localization_action_install {
    return Intl.message(
      'Install',
      name: 'localization_action_install',
      desc: '',
      args: [],
    );
  }

  /// `Version number: {v0}`
  String localization_info_version_number(Object v0) {
    return Intl.message(
      'Version number: $v0',
      name: 'localization_info_version_number',
      desc: '',
      args: [v0],
    );
  }

  /// `Channel: {v0}`
  String localization_info_channel(Object v0) {
    return Intl.message(
      'Channel: $v0',
      name: 'localization_info_channel',
      desc: '',
      args: [v0],
    );
  }

  /// `Update time: {v0}`
  String localization_info_update_time(Object v0) {
    return Intl.message(
      'Update time: $v0',
      name: 'localization_info_update_time',
      desc: '',
      args: [v0],
    );
  }

  /// `Installed`
  String get localization_info_installed {
    return Intl.message(
      'Installed',
      name: 'localization_info_installed',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get localization_info_unavailable {
    return Intl.message(
      'Unavailable',
      name: 'localization_info_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Language: `
  String get localization_info_language {
    return Intl.message(
      'Language: ',
      name: 'localization_info_language',
      desc: '',
      args: [],
    );
  }

  /// `Remove incompatible localization parameters`
  String get localization_info_remove_incompatible_translation_params {
    return Intl.message(
      'Remove incompatible localization parameters',
      name: 'localization_info_remove_incompatible_translation_params',
      desc: '',
      args: [],
    );
  }

  /// `USER.cfg contains incompatible localization parameters, which may be residual information from previous localization files.\n\nThis may cause the localization to be invalid or display garbled characters. Click confirm to remove these with one click (will not affect other configurations).`
  String get localization_info_incompatible_translation_params_warning {
    return Intl.message(
      'USER.cfg contains incompatible localization parameters, which may be residual information from previous localization files.\n\nThis may cause the localization to be invalid or display garbled characters. Click confirm to remove these with one click (will not affect other configurations).',
      name: 'localization_info_incompatible_translation_params_warning',
      desc: '',
      args: [],
    );
  }

  /// `File corrupted, please download again`
  String get localization_info_corrupted_file {
    return Intl.message(
      'File corrupted, please download again',
      name: 'localization_info_corrupted_file',
      desc: '',
      args: [],
    );
  }

  /// `Installation error!\n\n {v0}`
  String localization_info_installation_error(Object v0) {
    return Intl.message(
      'Installation error!\n\n $v0',
      name: 'localization_info_installation_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Custom Files`
  String get localization_info_custom_files {
    return Intl.message(
      'Custom Files',
      name: 'localization_info_custom_files',
      desc: '',
      args: [],
    );
  }

  /// `Graphics Optimization Tips`
  String get performance_info_graphic_optimization_hint {
    return Intl.message(
      'Graphics Optimization Tips',
      name: 'performance_info_graphic_optimization_hint',
      desc: '',
      args: [],
    );
  }

  /// `This feature helps significantly with GPU bottlenecks but may have the opposite effect for CPU bottlenecks. If you have a powerful GPU, you can try using better quality settings to achieve higher GPU utilization.`
  String get performance_info_graphic_optimization_warning {
    return Intl.message(
      'This feature helps significantly with GPU bottlenecks but may have the opposite effect for CPU bottlenecks. If you have a powerful GPU, you can try using better quality settings to achieve higher GPU utilization.',
      name: 'performance_info_graphic_optimization_warning',
      desc: '',
      args: [],
    );
  }

  /// `Current status: {v0}`
  String performance_info_current_status(Object v0) {
    return Intl.message(
      'Current status: $v0',
      name: 'performance_info_current_status',
      desc: '',
      args: [v0],
    );
  }

  /// `Applied`
  String get performance_info_applied {
    return Intl.message(
      'Applied',
      name: 'performance_info_applied',
      desc: '',
      args: [],
    );
  }

  /// `Not applied`
  String get performance_info_not_applied {
    return Intl.message(
      'Not applied',
      name: 'performance_info_not_applied',
      desc: '',
      args: [],
    );
  }

  /// `Preset:`
  String get performance_action_preset {
    return Intl.message(
      'Preset:',
      name: 'performance_action_preset',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get performance_action_low {
    return Intl.message(
      'Low',
      name: 'performance_action_low',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get performance_action_medium {
    return Intl.message(
      'Medium',
      name: 'performance_action_medium',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get performance_action_high {
    return Intl.message(
      'High',
      name: 'performance_action_high',
      desc: '',
      args: [],
    );
  }

  /// `Super`
  String get performance_action_super {
    return Intl.message(
      'Super',
      name: 'performance_action_super',
      desc: '',
      args: [],
    );
  }

  /// `(Preset only changes graphics settings)`
  String get performance_action_info_preset_only_changes_graphics {
    return Intl.message(
      '(Preset only changes graphics settings)',
      name: 'performance_action_info_preset_only_changes_graphics',
      desc: '',
      args: [],
    );
  }

  /// ` Reset to Default `
  String get performance_action_reset_to_default {
    return Intl.message(
      ' Reset to Default ',
      name: 'performance_action_reset_to_default',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get performance_action_apply {
    return Intl.message(
      'Apply',
      name: 'performance_action_apply',
      desc: '',
      args: [],
    );
  }

  /// `Apply and Clear Shaders (Recommended)`
  String get performance_action_apply_and_clear_shaders {
    return Intl.message(
      'Apply and Clear Shaders (Recommended)',
      name: 'performance_action_apply_and_clear_shaders',
      desc: '',
      args: [],
    );
  }

  /// `Performance Optimization -> {v0}`
  String performance_title_performance_optimization(Object v0) {
    return Intl.message(
      'Performance Optimization -> $v0',
      name: 'performance_title_performance_optimization',
      desc: '',
      args: [v0],
    );
  }

  /// `You can enter custom parameters not included in SCToolbox here. Configuration example:\n\nr_displayinfo=0\nr_VSync=0`
  String get performance_action_custom_parameters_input {
    return Intl.message(
      'You can enter custom parameters not included in SCToolbox here. Configuration example:\n\nr_displayinfo=0\nr_VSync=0',
      name: 'performance_action_custom_parameters_input',
      desc: '',
      args: [],
    );
  }

  /// `{v0}    Min value: {v1} / Max value: {v2}`
  String performance_info_min_max_values(Object v0, Object v1, Object v2) {
    return Intl.message(
      '$v0    Min value: $v1 / Max value: $v2',
      name: 'performance_info_min_max_values',
      desc: '',
      args: [v0, v1, v2],
    );
  }

  /// `Graphics`
  String get performance_info_graphics {
    return Intl.message(
      'Graphics',
      name: 'performance_info_graphics',
      desc: '',
      args: [],
    );
  }

  /// `Deleting config file...`
  String get performance_info_delete_config_file {
    return Intl.message(
      'Deleting config file...',
      name: 'performance_info_delete_config_file',
      desc: '',
      args: [],
    );
  }

  /// `Clear Shaders`
  String get performance_action_clear_shaders {
    return Intl.message(
      'Clear Shaders',
      name: 'performance_action_clear_shaders',
      desc: '',
      args: [],
    );
  }

  /// `Done...`
  String get performance_info_done {
    return Intl.message(
      'Done...',
      name: 'performance_info_done',
      desc: '',
      args: [],
    );
  }

  /// `After clearing shaders, the game may stutter when you first enter it. Please wait patiently for the game to complete initialization.`
  String get performance_info_shader_clearing_warning {
    return Intl.message(
      'After clearing shaders, the game may stutter when you first enter it. Please wait patiently for the game to complete initialization.',
      name: 'performance_info_shader_clearing_warning',
      desc: '',
      args: [],
    );
  }

  /// `Generate Config File`
  String get performance_info_generate_config_file {
    return Intl.message(
      'Generate Config File',
      name: 'performance_info_generate_config_file',
      desc: '',
      args: [],
    );
  }

  /// `Write Out Config File`
  String get performance_info_write_out_config_file {
    return Intl.message(
      'Write Out Config File',
      name: 'performance_info_write_out_config_file',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get app_index_menu_home {
    return Intl.message(
      'Home',
      name: 'app_index_menu_home',
      desc: '',
      args: [],
    );
  }

  /// `Lobby`
  String get app_index_menu_lobby {
    return Intl.message(
      'Lobby',
      name: 'app_index_menu_lobby',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get app_index_menu_tools {
    return Intl.message(
      'Tools',
      name: 'app_index_menu_tools',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get app_index_menu_settings {
    return Intl.message(
      'Settings',
      name: 'app_index_menu_settings',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get app_index_menu_about {
    return Intl.message(
      'About',
      name: 'app_index_menu_about',
      desc: '',
      args: [],
    );
  }

  /// `Online lobby, coming soon!`
  String get lobby_online_lobby_coming_soon {
    return Intl.message(
      'Online lobby, coming soon!',
      name: 'lobby_online_lobby_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `You are invited to participate in `
  String get lobby_invitation_to_participate {
    return Intl.message(
      'You are invited to participate in ',
      name: 'lobby_invitation_to_participate',
      desc: '',
      args: [],
    );
  }

  /// `a survey.`
  String get lobby_survey {
    return Intl.message('a survey.', name: 'lobby_survey', desc: '', args: []);
  }

  /// `Create Settings Shortcut`
  String get setting_action_create_settings_shortcut {
    return Intl.message(
      'Create Settings Shortcut',
      name: 'setting_action_create_settings_shortcut',
      desc: '',
      args: [],
    );
  }

  /// `Create SCToolbox shortcut on desktop`
  String get setting_action_create_desktop_shortcut {
    return Intl.message(
      'Create SCToolbox shortcut on desktop',
      name: 'setting_action_create_desktop_shortcut',
      desc: '',
      args: [],
    );
  }

  /// `Reset Auto Password Fill`
  String get setting_action_reset_auto_password_fill {
    return Intl.message(
      'Reset Auto Password Fill',
      name: 'setting_action_reset_auto_password_fill',
      desc: '',
      args: [],
    );
  }

  /// `Ignore efficiency cores when launching game (For Intel 12th+ processors)`
  String get setting_action_ignore_efficiency_cores_on_launch {
    return Intl.message(
      'Ignore efficiency cores when launching game (For Intel 12th+ processors)',
      name: 'setting_action_ignore_efficiency_cores_on_launch',
      desc: '',
      args: [],
    );
  }

  /// `Number of cores set: {v0} (This feature applies to SCToolbox one-click launch on the homepage or RSI Launcher admin mode in tools. When set to 0, this feature is not enabled)`
  String setting_action_set_core_count(Object v0) {
    return Intl.message(
      'Number of cores set: $v0 (This feature applies to SCToolbox one-click launch on the homepage or RSI Launcher admin mode in tools. When set to 0, this feature is not enabled)',
      name: 'setting_action_set_core_count',
      desc: '',
      args: [v0],
    );
  }

  /// `Set Launcher File (RSI Launcher.exe)`
  String get setting_action_set_launcher_file {
    return Intl.message(
      'Set Launcher File (RSI Launcher.exe)',
      name: 'setting_action_set_launcher_file',
      desc: '',
      args: [],
    );
  }

  /// `Manually set launcher location, recommended only when automatic installation location scanning is not available`
  String get setting_action_info_manual_launcher_location_setting {
    return Intl.message(
      'Manually set launcher location, recommended only when automatic installation location scanning is not available',
      name: 'setting_action_info_manual_launcher_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `Set Game File (StarCitizen.exe)`
  String get setting_action_set_game_file {
    return Intl.message(
      'Set Game File (StarCitizen.exe)',
      name: 'setting_action_set_game_file',
      desc: '',
      args: [],
    );
  }

  /// `Manually set game installation location, recommended only when automatic installation location scanning is not available`
  String get setting_action_info_manual_game_location_setting {
    return Intl.message(
      'Manually set game installation location, recommended only when automatic installation location scanning is not available',
      name: 'setting_action_info_manual_game_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `Clear Localization File Cache`
  String get setting_action_clear_translation_file_cache {
    return Intl.message(
      'Clear Localization File Cache',
      name: 'setting_action_clear_translation_file_cache',
      desc: '',
      args: [],
    );
  }

  /// `Cache size {v0}MB, clears the localization file cache downloaded by SCToolbox, does not affect installed localizations`
  String setting_action_info_cache_clearing_info(Object v0) {
    return Intl.message(
      'Cache size ${v0}MB, clears the localization file cache downloaded by SCToolbox, does not affect installed localizations',
      name: 'setting_action_info_cache_clearing_info',
      desc: '',
      args: [v0],
    );
  }

  /// `Tool Site Access Acceleration`
  String get setting_action_tool_site_access_acceleration {
    return Intl.message(
      'Tool Site Access Acceleration',
      name: 'setting_action_tool_site_access_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `Use mirror server to accelerate access to tool websites such as Dps, Uex, etc. If access is abnormal, please turn off this feature. To protect account security, the RSI official website will never be accelerated under any circumstances.`
  String get setting_action_info_mirror_server_info {
    return Intl.message(
      'Use mirror server to accelerate access to tool websites such as Dps, Uex, etc. If access is abnormal, please turn off this feature. To protect account security, the RSI official website will never be accelerated under any circumstances.',
      name: 'setting_action_info_mirror_server_info',
      desc: '',
      args: [],
    );
  }

  /// `View log`
  String get setting_action_view_log {
    return Intl.message(
      'View log',
      name: 'setting_action_view_log',
      desc: '',
      args: [],
    );
  }

  /// `View the log file of SCToolbox to locate bugs in the box`
  String get setting_action_info_view_log_file {
    return Intl.message(
      'View the log file of SCToolbox to locate bugs in the box',
      name: 'setting_action_info_view_log_file',
      desc: '',
      args: [],
    );
  }

  /// `Confirm reset auto-fill?`
  String get setting_action_info_confirm_reset_autofill {
    return Intl.message(
      'Confirm reset auto-fill?',
      name: 'setting_action_info_confirm_reset_autofill',
      desc: '',
      args: [],
    );
  }

  /// `This will delete the local account record, or select 'no' for auto-fill the next time you launch the game to disable auto-fill.`
  String get setting_action_info_delete_local_account_warning {
    return Intl.message(
      'This will delete the local account record, or select \'no\' for auto-fill the next time you launch the game to disable auto-fill.',
      name: 'setting_action_info_delete_local_account_warning',
      desc: '',
      args: [],
    );
  }

  /// `Auto-fill data cleared`
  String get setting_action_info_autofill_data_cleared {
    return Intl.message(
      'Auto-fill data cleared',
      name: 'setting_action_info_autofill_data_cleared',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of CPU cores to ignore`
  String get setting_action_info_enter_cpu_core_to_ignore {
    return Intl.message(
      'Please enter the number of CPU cores to ignore',
      name: 'setting_action_info_enter_cpu_core_to_ignore',
      desc: '',
      args: [],
    );
  }

  /// `Tip: Enter how many efficiency cores your device has, keep 0 for non-big.LITTLE devices\n\nThis feature applies to SCToolbox one-click launch on the home page or RSI Launcher admin mode in tools. When set to 0, this feature is not enabled.`
  String get setting_action_info_cpu_core_tip {
    return Intl.message(
      'Tip: Enter how many efficiency cores your device has, keep 0 for non-big.LITTLE devices\n\nThis feature applies to SCToolbox one-click launch on the home page or RSI Launcher admin mode in tools. When set to 0, this feature is not enabled.',
      name: 'setting_action_info_cpu_core_tip',
      desc: '',
      args: [],
    );
  }

  /// `Please select RSI launcher location (RSI Launcher.exe)`
  String get setting_action_info_select_rsi_launcher_location {
    return Intl.message(
      'Please select RSI launcher location (RSI Launcher.exe)',
      name: 'setting_action_info_select_rsi_launcher_location',
      desc: '',
      args: [],
    );
  }

  /// `Setting successful, click refresh on the corresponding page to scan for the new path`
  String get setting_action_info_setting_success {
    return Intl.message(
      'Setting successful, click refresh on the corresponding page to scan for the new path',
      name: 'setting_action_info_setting_success',
      desc: '',
      args: [],
    );
  }

  /// `File error!`
  String get setting_action_info_file_error {
    return Intl.message(
      'File error!',
      name: 'setting_action_info_file_error',
      desc: '',
      args: [],
    );
  }

  /// `Please select game installation location (StarCitizen.exe)`
  String get setting_action_info_select_game_install_location {
    return Intl.message(
      'Please select game installation location (StarCitizen.exe)',
      name: 'setting_action_info_select_game_install_location',
      desc: '',
      args: [],
    );
  }

  /// `Confirm clearing localization cache?`
  String get setting_action_info_confirm_clear_cache {
    return Intl.message(
      'Confirm clearing localization cache?',
      name: 'setting_action_info_confirm_clear_cache',
      desc: '',
      args: [],
    );
  }

  /// `This will not affect installed localizations.`
  String get setting_action_info_clear_cache_warning {
    return Intl.message(
      'This will not affect installed localizations.',
      name: 'setting_action_info_clear_cache_warning',
      desc: '',
      args: [],
    );
  }

  /// `Due to Microsoft version feature limitations, please manually drag SCToolbox to the desktop in the window that opens next to create a shortcut.`
  String get setting_action_info_microsoft_version_limitation {
    return Intl.message(
      'Due to Microsoft version feature limitations, please manually drag SCToolbox to the desktop in the window that opens next to create a shortcut.',
      name: 'setting_action_info_microsoft_version_limitation',
      desc: '',
      args: [],
    );
  }

  /// `Creation complete, please check your desktop`
  String get setting_action_info_shortcut_created {
    return Intl.message(
      'Creation complete, please check your desktop',
      name: 'setting_action_info_shortcut_created',
      desc: '',
      args: [],
    );
  }

  /// `New version found -> {v0}`
  String app_upgrade_title_new_version_found(Object v0) {
    return Intl.message(
      'New version found -> $v0',
      name: 'app_upgrade_title_new_version_found',
      desc: '',
      args: [v0],
    );
  }

  /// `Getting new version details...`
  String get app_upgrade_info_getting_new_version_details {
    return Intl.message(
      'Getting new version details...',
      name: 'app_upgrade_info_getting_new_version_details',
      desc: '',
      args: [],
    );
  }

  /// `Note: Currently using diversion server for updates, which may result in decreased download speed but helps us with cost control. If the download is abnormal, please click here to switch to manual installation.`
  String get app_upgrade_info_update_server_tip {
    return Intl.message(
      'Note: Currently using diversion server for updates, which may result in decreased download speed but helps us with cost control. If the download is abnormal, please click here to switch to manual installation.',
      name: 'app_upgrade_info_update_server_tip',
      desc: '',
      args: [],
    );
  }

  /// `Installing: `
  String get app_upgrade_info_installing {
    return Intl.message(
      'Installing: ',
      name: 'app_upgrade_info_installing',
      desc: '',
      args: [],
    );
  }

  /// `Downloading: {v0}% `
  String app_upgrade_info_downloading(Object v0) {
    return Intl.message(
      'Downloading: $v0% ',
      name: 'app_upgrade_info_downloading',
      desc: '',
      args: [v0],
    );
  }

  /// `Update Now`
  String get app_upgrade_action_update_now {
    return Intl.message(
      'Update Now',
      name: 'app_upgrade_action_update_now',
      desc: '',
      args: [],
    );
  }

  /// `Next Time`
  String get app_upgrade_action_next_time {
    return Intl.message(
      'Next Time',
      name: 'app_upgrade_action_next_time',
      desc: '',
      args: [],
    );
  }

  /// `Download failed, please try manual installation!`
  String get app_upgrade_info_download_failed {
    return Intl.message(
      'Download failed, please try manual installation!',
      name: 'app_upgrade_info_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `Run failed, please try manual installation!`
  String get app_upgrade_info_run_failed {
    return Intl.message(
      'Run failed, please try manual installation!',
      name: 'app_upgrade_info_run_failed',
      desc: '',
      args: [],
    );
  }

  /// `Checking availability, this may take a moment...`
  String get app_splash_checking_availability {
    return Intl.message(
      'Checking availability, this may take a moment...',
      name: 'app_splash_checking_availability',
      desc: '',
      args: [],
    );
  }

  /// `Checking for updates...`
  String get app_splash_checking_for_updates {
    return Intl.message(
      'Checking for updates...',
      name: 'app_splash_checking_for_updates',
      desc: '',
      args: [],
    );
  }

  /// `Almost done...`
  String get app_splash_almost_done {
    return Intl.message(
      'Almost done...',
      name: 'app_splash_almost_done',
      desc: '',
      args: [],
    );
  }

  /// `RSI Official Website`
  String get tools_hosts_info_rsi_official_website {
    return Intl.message(
      'RSI Official Website',
      name: 'tools_hosts_info_rsi_official_website',
      desc: '',
      args: [],
    );
  }

  /// `RSI Customer Service`
  String get tools_hosts_info_rsi_customer_service {
    return Intl.message(
      'RSI Customer Service',
      name: 'tools_hosts_info_rsi_customer_service',
      desc: '',
      args: [],
    );
  }

  /// `Querying DNS and testing accessibility, please wait patiently...`
  String get tools_hosts_info_dns_query_and_test {
    return Intl.message(
      'Querying DNS and testing accessibility, please wait patiently...',
      name: 'tools_hosts_info_dns_query_and_test',
      desc: '',
      args: [],
    );
  }

  /// `Writing to Hosts...`
  String get tools_hosts_info_writing_hosts {
    return Intl.message(
      'Writing to Hosts...',
      name: 'tools_hosts_info_writing_hosts',
      desc: '',
      args: [],
    );
  }

  /// `Reading configuration...`
  String get tools_hosts_info_reading_config {
    return Intl.message(
      'Reading configuration...',
      name: 'tools_hosts_info_reading_config',
      desc: '',
      args: [],
    );
  }

  /// `Hosts Acceleration`
  String get tools_hosts_info_hosts_acceleration {
    return Intl.message(
      'Hosts Acceleration',
      name: 'tools_hosts_info_hosts_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `Open Hosts File`
  String get tools_hosts_info_open_hosts_file {
    return Intl.message(
      'Open Hosts File',
      name: 'tools_hosts_info_open_hosts_file',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get tools_hosts_info_status {
    return Intl.message(
      'Status',
      name: 'tools_hosts_info_status',
      desc: '',
      args: [],
    );
  }

  /// `Site`
  String get tools_hosts_info_site {
    return Intl.message(
      'Site',
      name: 'tools_hosts_info_site',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get tools_hosts_info_enable {
    return Intl.message(
      'Enable',
      name: 'tools_hosts_info_enable',
      desc: '',
      args: [],
    );
  }

  /// `One-Click Acceleration`
  String get tools_hosts_action_one_click_acceleration {
    return Intl.message(
      'One-Click Acceleration',
      name: 'tools_hosts_action_one_click_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `Scanning...`
  String get tools_info_scanning {
    return Intl.message(
      'Scanning...',
      name: 'tools_info_scanning',
      desc: '',
      args: [],
    );
  }

  /// `Processing failed!: {v0}`
  String tools_info_processing_failed(Object v0) {
    return Intl.message(
      'Processing failed!: $v0',
      name: 'tools_info_processing_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Game installation location: `
  String get tools_info_game_install_location {
    return Intl.message(
      'Game installation location: ',
      name: 'tools_info_game_install_location',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher location:`
  String get tools_info_rsi_launcher_location {
    return Intl.message(
      'RSI Launcher location:',
      name: 'tools_info_rsi_launcher_location',
      desc: '',
      args: [],
    );
  }

  /// `View System Info`
  String get tools_action_view_system_info {
    return Intl.message(
      'View System Info',
      name: 'tools_action_view_system_info',
      desc: '',
      args: [],
    );
  }

  /// `View critical system information for quick diagnosis\n\nThis operation takes time, please wait patiently.`
  String get tools_action_info_view_critical_system_info {
    return Intl.message(
      'View critical system information for quick diagnosis\n\nThis operation takes time, please wait patiently.',
      name: 'tools_action_info_view_critical_system_info',
      desc: '',
      args: [],
    );
  }

  /// `P4K Diversion Download / Repair`
  String get tools_action_p4k_download_repair {
    return Intl.message(
      'P4K Diversion Download / Repair',
      name: 'tools_action_p4k_download_repair',
      desc: '',
      args: [],
    );
  }

  /// `Use the diversion download service provided by Star Citizen Chinese Wiki for downloading or repairing p4k.\nVersion info: {v0}`
  String tools_action_info_p4k_download_repair_tip(Object v0) {
    return Intl.message(
      'Use the diversion download service provided by Star Citizen Chinese Wiki for downloading or repairing p4k.\nVersion info: $v0',
      name: 'tools_action_info_p4k_download_repair_tip',
      desc: '',
      args: [v0],
    );
  }

  /// `Hosts Acceleration (Experimental)`
  String get tools_action_hosts_acceleration_experimental {
    return Intl.message(
      'Hosts Acceleration (Experimental)',
      name: 'tools_action_hosts_acceleration_experimental',
      desc: '',
      args: [],
    );
  }

  /// `Write IP information to the Hosts file to solve issues such as DNS pollution in some regions that prevent logging in to the official website.\nThis feature is in its first testing phase, please provide feedback if you encounter any issues.`
  String get tools_action_info_hosts_acceleration_experimental_tip {
    return Intl.message(
      'Write IP information to the Hosts file to solve issues such as DNS pollution in some regions that prevent logging in to the official website.\nThis feature is in its first testing phase, please provide feedback if you encounter any issues.',
      name: 'tools_action_info_hosts_acceleration_experimental_tip',
      desc: '',
      args: [],
    );
  }

  /// `Reinstall EasyAntiCheat`
  String get tools_action_reinstall_easyanticheat {
    return Intl.message(
      'Reinstall EasyAntiCheat',
      name: 'tools_action_reinstall_easyanticheat',
      desc: '',
      args: [],
    );
  }

  /// `If you encounter EAC errors and automatic repair is ineffective, please try using this feature to reinstall EAC.`
  String get tools_action_info_reinstall_eac {
    return Intl.message(
      'If you encounter EAC errors and automatic repair is ineffective, please try using this feature to reinstall EAC.',
      name: 'tools_action_info_reinstall_eac',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Admin Mode`
  String get tools_action_rsi_launcher_admin_mode {
    return Intl.message(
      'RSI Launcher Admin Mode',
      name: 'tools_action_rsi_launcher_admin_mode',
      desc: '',
      args: [],
    );
  }

  /// `Run the RSI launcher as administrator, which may solve some issues.\n\nIf efficiency core blocking parameters are set, they will also be applied here.`
  String get tools_action_info_run_rsi_as_admin {
    return Intl.message(
      'Run the RSI launcher as administrator, which may solve some issues.\n\nIf efficiency core blocking parameters are set, they will also be applied here.',
      name: 'tools_action_info_run_rsi_as_admin',
      desc: '',
      args: [],
    );
  }

  /// `Initialization failed, please take a screenshot to report to the developer. {v0}`
  String tools_action_info_init_failed(Object v0) {
    return Intl.message(
      'Initialization failed, please take a screenshot to report to the developer. $v0',
      name: 'tools_action_info_init_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `RSI Launcher Log Fix`
  String get tools_action_rsi_launcher_log_fix {
    return Intl.message(
      'RSI Launcher Log Fix',
      name: 'tools_action_rsi_launcher_log_fix',
      desc: '',
      args: [],
    );
  }

  /// `In some cases, the log file of the RSI Launcher may be corrupted, preventing problem scanning from completing. Use this tool to clean up corrupted log files.\n\nCurrent log file size: {v0} MB`
  String tools_action_info_rsi_launcher_log_issue(Object v0) {
    return Intl.message(
      'In some cases, the log file of the RSI Launcher may be corrupted, preventing problem scanning from completing. Use this tool to clean up corrupted log files.\n\nCurrent log file size: $v0 MB',
      name: 'tools_action_info_rsi_launcher_log_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `Remove NVME Registry Patch`
  String get tools_action_remove_nvme_registry_patch {
    return Intl.message(
      'Remove NVME Registry Patch',
      name: 'tools_action_remove_nvme_registry_patch',
      desc: '',
      args: [],
    );
  }

  /// `If you have issues with the nvme patch, please run this tool. (May cause game installation/updates to be unavailable.)\n\nCurrent patch status: {v0}`
  String tools_action_info_nvme_patch_issue(Object v0) {
    return Intl.message(
      'If you have issues with the nvme patch, please run this tool. (May cause game installation/updates to be unavailable.)\n\nCurrent patch status: $v0',
      name: 'tools_action_info_nvme_patch_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `Not installed`
  String get tools_action_info_not_installed {
    return Intl.message(
      'Not installed',
      name: 'tools_action_info_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `Removed, restart computer for changes to take effect!`
  String get tools_action_info_removed_restart_effective {
    return Intl.message(
      'Removed, restart computer for changes to take effect!',
      name: 'tools_action_info_removed_restart_effective',
      desc: '',
      args: [],
    );
  }

  /// `Write NVME Registry Patch`
  String get tools_action_write_nvme_registry_patch {
    return Intl.message(
      'Write NVME Registry Patch',
      name: 'tools_action_write_nvme_registry_patch',
      desc: '',
      args: [],
    );
  }

  /// `Manually write NVM patch, only use this feature if you know what you're doing`
  String get tools_action_info_manual_nvme_patch {
    return Intl.message(
      'Manually write NVM patch, only use this feature if you know what you\'re doing',
      name: 'tools_action_info_manual_nvme_patch',
      desc: '',
      args: [],
    );
  }

  /// `Fixed successfully, please try restarting your computer and then continue installing the game! If the registry modification causes compatibility issues with other software, please use the NVME Registry Cleanup in Tools.`
  String get tools_action_info_fix_success_restart {
    return Intl.message(
      'Fixed successfully, please try restarting your computer and then continue installing the game! If the registry modification causes compatibility issues with other software, please use the NVME Registry Cleanup in Tools.',
      name: 'tools_action_info_fix_success_restart',
      desc: '',
      args: [],
    );
  }

  /// `Clear Shader Cache`
  String get tools_action_clear_shader_cache {
    return Intl.message(
      'Clear Shader Cache',
      name: 'tools_action_clear_shader_cache',
      desc: '',
      args: [],
    );
  }

  /// `If game graphics appear abnormal or after version updates, you can use this tool to clear expired shaders \n\nCache size: {v0} MB`
  String tools_action_info_shader_cache_issue(Object v0) {
    return Intl.message(
      'If game graphics appear abnormal or after version updates, you can use this tool to clear expired shaders \n\nCache size: $v0 MB',
      name: 'tools_action_info_shader_cache_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `Close Photography Mode`
  String get tools_action_close_photography_mode {
    return Intl.message(
      'Close Photography Mode',
      name: 'tools_action_close_photography_mode',
      desc: '',
      args: [],
    );
  }

  /// `Open Photography Mode`
  String get tools_action_open_photography_mode {
    return Intl.message(
      'Open Photography Mode',
      name: 'tools_action_open_photography_mode',
      desc: '',
      args: [],
    );
  }

  /// `Restore lens shake effect.\n\n@Lapernum provides parameter information.`
  String get tools_action_info_restore_lens_shake {
    return Intl.message(
      'Restore lens shake effect.\n\n@Lapernum provides parameter information.',
      name: 'tools_action_info_restore_lens_shake',
      desc: '',
      args: [],
    );
  }

  /// `One-click disable in-game lens shake for better photography operations.\n\n@Lapernum provides parameter information.`
  String get tools_action_info_one_key_close_lens_shake {
    return Intl.message(
      'One-click disable in-game lens shake for better photography operations.\n\n@Lapernum provides parameter information.',
      name: 'tools_action_info_one_key_close_lens_shake',
      desc: '',
      args: [],
    );
  }

  /// `Failed to parse log file!\nPlease try using the RSI Launcher Log Fix tool!`
  String get tools_action_info_log_file_parse_failed {
    return Intl.message(
      'Failed to parse log file!\nPlease try using the RSI Launcher Log Fix tool!',
      name: 'tools_action_info_log_file_parse_failed',
      desc: '',
      args: [],
    );
  }

  /// `RSI launcher not found, please try reinstalling or manually adding it in settings.`
  String get tools_action_info_rsi_launcher_not_found {
    return Intl.message(
      'RSI launcher not found, please try reinstalling or manually adding it in settings.',
      name: 'tools_action_info_rsi_launcher_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Star Citizen game installation location not found, please complete at least one game launch operation or manually add it in settings.`
  String get tools_action_info_star_citizen_not_found {
    return Intl.message(
      'Star Citizen game installation location not found, please complete at least one game launch operation or manually add it in settings.',
      name: 'tools_action_info_star_citizen_not_found',
      desc: '',
      args: [],
    );
  }

  /// `This feature requires a valid game installation directory`
  String get tools_action_info_valid_game_directory_needed {
    return Intl.message(
      'This feature requires a valid game installation directory',
      name: 'tools_action_info_valid_game_directory_needed',
      desc: '',
      args: [],
    );
  }

  /// `EAC files have been removed for you. Next, we'll open the RSI launcher for you. Please go to SETTINGS -> VERIFY to reinstall EAC.`
  String get tools_action_info_eac_file_removed {
    return Intl.message(
      'EAC files have been removed for you. Next, we\'ll open the RSI launcher for you. Please go to SETTINGS -> VERIFY to reinstall EAC.',
      name: 'tools_action_info_eac_file_removed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: {v0}`
  String tools_action_info_error_occurred(Object v0) {
    return Intl.message(
      'An error occurred: $v0',
      name: 'tools_action_info_error_occurred',
      desc: '',
      args: [v0],
    );
  }

  /// `System: {v0}\n\nProcessor: {v1}\n\nMemory size: {v2}GB\n\nGPU information:\n{v3}\n\nStorage information:\n{v4}\n\n`
  String tools_action_info_system_info_content(
    Object v0,
    Object v1,
    Object v2,
    Object v3,
    Object v4,
  ) {
    return Intl.message(
      'System: $v0\n\nProcessor: $v1\n\nMemory size: ${v2}GB\n\nGPU information:\n$v3\n\nStorage information:\n$v4\n\n',
      name: 'tools_action_info_system_info_content',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `RSI launcher directory not found, please try manual operation.`
  String get tools_action_info_rsi_launcher_directory_not_found {
    return Intl.message(
      'RSI launcher directory not found, please try manual operation.',
      name: 'tools_action_info_rsi_launcher_directory_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Log file does not exist. Please try launching the game or installing the game once and then exit the launcher. If the problem persists, please try updating the launcher to the latest version!`
  String get tools_action_info_log_file_not_exist {
    return Intl.message(
      'Log file does not exist. Please try launching the game or installing the game once and then exit the launcher. If the problem persists, please try updating the launcher to the latest version!',
      name: 'tools_action_info_log_file_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Cleanup complete, please complete one installation / game launch operation.`
  String get tools_action_info_cleanup_complete {
    return Intl.message(
      'Cleanup complete, please complete one installation / game launch operation.',
      name: 'tools_action_info_cleanup_complete',
      desc: '',
      args: [],
    );
  }

  /// `Cleanup failed, please remove manually, file location: {v0}`
  String tools_action_info_cleanup_failed(Object v0) {
    return Intl.message(
      'Cleanup failed, please remove manually, file location: $v0',
      name: 'tools_action_info_cleanup_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `System Information`
  String get tools_action_info_system_info_title {
    return Intl.message(
      'System Information',
      name: 'tools_action_info_system_info_title',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher is running! Please close the launcher before using this feature!`
  String get tools_action_info_rsi_launcher_running_warning {
    return Intl.message(
      'RSI Launcher is running! Please close the launcher before using this feature!',
      name: 'tools_action_info_rsi_launcher_running_warning',
      desc: '',
      args: [],
    );
  }

  /// `P4k is Star Citizen's core game file, over 100GB+. The offline download provided by SCToolbox is to help users who have extremely slow p4k file downloads or to repair p4k files that the official launcher cannot fix.\n\nNext, a dialog will ask for your save location (you can choose the Star Citizen folder or elsewhere). After downloading, please make sure the P4K file is placed in the LIVE folder, then verify and update using the Star Citizen launcher.`
  String get tools_action_info_p4k_file_description {
    return Intl.message(
      'P4k is Star Citizen\'s core game file, over 100GB+. The offline download provided by SCToolbox is to help users who have extremely slow p4k file downloads or to repair p4k files that the official launcher cannot fix.\n\nNext, a dialog will ask for your save location (you can choose the Star Citizen folder or elsewhere). After downloading, please make sure the P4K file is placed in the LIVE folder, then verify and update using the Star Citizen launcher.',
      name: 'tools_action_info_p4k_file_description',
      desc: '',
      args: [],
    );
  }

  /// `A p4k download task is already in progress, please check the download manager!`
  String get tools_action_info_p4k_download_in_progress {
    return Intl.message(
      'A p4k download task is already in progress, please check the download manager!',
      name: 'tools_action_info_p4k_download_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Function under maintenance, please try again later!`
  String get tools_action_info_function_under_maintenance {
    return Intl.message(
      'Function under maintenance, please try again later!',
      name: 'tools_action_info_function_under_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Configuration file does not exist, please try running the game once`
  String get tools_action_info_config_file_not_exist {
    return Intl.message(
      'Configuration file does not exist, please try running the game once',
      name: 'tools_action_info_config_file_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Member`
  String get webview_localization_name_member {
    return Intl.message(
      'Member',
      name: 'webview_localization_name_member',
      desc: '',
      args: [],
    );
  }

  /// `Total invitations:`
  String get webview_localization_total_invitations {
    return Intl.message(
      'Total invitations:',
      name: 'webview_localization_total_invitations',
      desc: '',
      args: [],
    );
  }

  /// `Unfinished invitations`
  String get webview_localization_unfinished_invitations {
    return Intl.message(
      'Unfinished invitations',
      name: 'webview_localization_unfinished_invitations',
      desc: '',
      args: [],
    );
  }

  /// `Finished invitations`
  String get webview_localization_finished_invitations {
    return Intl.message(
      'Finished invitations',
      name: 'webview_localization_finished_invitations',
      desc: '',
      args: [],
    );
  }

  /// `Initialization failed: {v0}`
  String app_init_failed_with_reason(Object v0) {
    return Intl.message(
      'Initialization failed: $v0',
      name: 'app_init_failed_with_reason',
      desc: '',
      args: [v0],
    );
  }

  /// `Language`
  String get settings_app_language {
    return Intl.message(
      'Language',
      name: 'settings_app_language',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get settings_app_language_auto {
    return Intl.message(
      'Auto',
      name: 'settings_app_language_auto',
      desc: '',
      args: [],
    );
  }

  /// `Network connection failed!\nEntering offline mode...\n\nPlease check your network connection or get the latest information on social forums. You can try enabling built-in DNS mode in the app settings\nCurrent version build date: {v0}\nQQ group: 940696487\nError message: {v1}`
  String app_common_network_error(Object v0, Object v1) {
    return Intl.message(
      'Network connection failed!\nEntering offline mode...\n\nPlease check your network connection or get the latest information on social forums. You can try enabling built-in DNS mode in the app settings\nCurrent version build date: $v0\nQQ group: 940696487\nError message: $v1',
      name: 'app_common_network_error',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Failed to get update information, please try again later.`
  String get app_common_upgrade_info_error {
    return Intl.message(
      'Failed to get update information, please try again later.',
      name: 'app_common_upgrade_info_error',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient available memory`
  String get doctor_game_error_low_memory {
    return Intl.message(
      'Insufficient available memory',
      name: 'doctor_game_error_low_memory',
      desc: '',
      args: [],
    );
  }

  /// `Please try increasing virtual memory (at 1080p, physical available + virtual memory should be > 64GB)`
  String get doctor_game_error_low_memory_info {
    return Intl.message(
      'Please try increasing virtual memory (at 1080p, physical available + virtual memory should be > 64GB)',
      name: 'doctor_game_error_low_memory_info',
      desc: '',
      args: [],
    );
  }

  /// `The game triggered the most common crash issue, please check the troubleshooting guide`
  String get doctor_game_error_generic_info {
    return Intl.message(
      'The game triggered the most common crash issue, please check the troubleshooting guide',
      name: 'doctor_game_error_generic_info',
      desc: '',
      args: [],
    );
  }

  /// `Your GPU has crashed! Please check the troubleshooting guide`
  String get doctor_game_error_gpu_crash {
    return Intl.message(
      'Your GPU has crashed! Please check the troubleshooting guide',
      name: 'doctor_game_error_gpu_crash',
      desc: '',
      args: [],
    );
  }

  /// `Socket error detected`
  String get doctor_game_error_socket_error {
    return Intl.message(
      'Socket error detected',
      name: 'doctor_game_error_socket_error',
      desc: '',
      args: [],
    );
  }

  /// `If using X-Black Box accelerator, please try changing the acceleration mode`
  String get doctor_game_error_socket_error_info {
    return Intl.message(
      'If using X-Black Box accelerator, please try changing the acceleration mode',
      name: 'doctor_game_error_socket_error_info',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient permissions`
  String get doctor_game_error_permissions_error {
    return Intl.message(
      'Insufficient permissions',
      name: 'doctor_game_error_permissions_error',
      desc: '',
      args: [],
    );
  }

  /// `Please try running the launcher with administrator privileges or use SCToolbox (Microsoft Store version) to launch.`
  String get doctor_game_error_permissions_error_info {
    return Intl.message(
      'Please try running the launcher with administrator privileges or use SCToolbox (Microsoft Store version) to launch.',
      name: 'doctor_game_error_permissions_error_info',
      desc: '',
      args: [],
    );
  }

  /// `Game process is in use`
  String get doctor_game_error_game_process_error {
    return Intl.message(
      'Game process is in use',
      name: 'doctor_game_error_game_process_error',
      desc: '',
      args: [],
    );
  }

  /// `Please try restarting the launcher or restarting your computer directly`
  String get doctor_game_error_game_process_error_info {
    return Intl.message(
      'Please try restarting the launcher or restarting your computer directly',
      name: 'doctor_game_error_game_process_error_info',
      desc: '',
      args: [],
    );
  }

  /// `Game program files corrupted`
  String get doctor_game_error_game_damaged_file {
    return Intl.message(
      'Game program files corrupted',
      name: 'doctor_game_error_game_damaged_file',
      desc: '',
      args: [],
    );
  }

  /// `Please try deleting the Bin64 folder and verify in the launcher.`
  String get doctor_game_error_game_damaged_file_info {
    return Intl.message(
      'Please try deleting the Bin64 folder and verify in the launcher.',
      name: 'doctor_game_error_game_damaged_file_info',
      desc: '',
      args: [],
    );
  }

  /// `P4K file corrupted`
  String get doctor_game_error_game_damaged_p4k_file {
    return Intl.message(
      'P4K file corrupted',
      name: 'doctor_game_error_game_damaged_p4k_file',
      desc: '',
      args: [],
    );
  }

  /// `Please try deleting the Data.p4k file and verify in the launcher or use the diversion in SCToolbox.`
  String get doctor_game_error_game_damaged_p4k_file_info {
    return Intl.message(
      'Please try deleting the Data.p4k file and verify in the launcher or use the diversion in SCToolbox.',
      name: 'doctor_game_error_game_damaged_p4k_file_info',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient GPU memory`
  String get doctor_game_error_low_gpu_memory {
    return Intl.message(
      'Insufficient GPU memory',
      name: 'doctor_game_error_low_gpu_memory',
      desc: '',
      args: [],
    );
  }

  /// `Please don't run other games/applications with high GPU usage in the background, or upgrade your GPU.`
  String get doctor_game_error_low_gpu_memory_info {
    return Intl.message(
      'Please don\'t run other games/applications with high GPU usage in the background, or upgrade your GPU.',
      name: 'doctor_game_error_low_gpu_memory_info',
      desc: '',
      args: [],
    );
  }

  /// `GPU Vulkan crash`
  String get doctor_game_error_gpu_vulkan_crash {
    return Intl.message(
      'GPU Vulkan crash',
      name: 'doctor_game_error_gpu_vulkan_crash',
      desc: '',
      args: [],
    );
  }

  /// `Vulkan crash! This may be a driver version or game engine issue. Please try updating GPU drivers or use the clear shader feature to fall back to DX11`
  String get doctor_game_error_gpu_vulkan_crash_info {
    return Intl.message(
      'Vulkan crash! This may be a driver version or game engine issue. Please try updating GPU drivers or use the clear shader feature to fall back to DX11',
      name: 'doctor_game_error_gpu_vulkan_crash_info',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred: {v0}`
  String app_common_error_info(Object v0) {
    return Intl.message(
      'An error occurred: $v0',
      name: 'app_common_error_info',
      desc: '',
      args: [v0],
    );
  }

  /// `Tip`
  String get app_common_tip {
    return Intl.message('Tip', name: 'app_common_tip', desc: '', args: []);
  }

  /// `I know`
  String get app_common_tip_i_know {
    return Intl.message(
      'I know',
      name: 'app_common_tip_i_know',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get app_common_tip_confirm {
    return Intl.message(
      'Confirm',
      name: 'app_common_tip_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get app_common_tip_cancel {
    return Intl.message(
      'Cancel',
      name: 'app_common_tip_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Switch application display language`
  String get settings_app_language_switch_info {
    return Intl.message(
      'Switch application display language',
      name: 'settings_app_language_switch_info',
      desc: '',
      args: [],
    );
  }

  /// `{v0} days `
  String home_holiday_countdown_days(Object v0) {
    return Intl.message(
      '$v0 days ',
      name: 'home_holiday_countdown_days',
      desc: '',
      args: [v0],
    );
  }

  /// `In progress`
  String get home_holiday_countdown_in_progress {
    return Intl.message(
      'In progress',
      name: 'home_holiday_countdown_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Loading images...`
  String get app_common_loading_images {
    return Intl.message(
      'Loading images...',
      name: 'app_common_loading_images',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement and Privacy Policy`
  String get app_splash_dialog_u_a_p_p {
    return Intl.message(
      'User Agreement and Privacy Policy',
      name: 'app_splash_dialog_u_a_p_p',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for choosing SCToolbox. We are committed to providing you with a safe, convenient, and reliable user experience. Before you start using the application, please read and agree to the following content:\n\n1. This application is open source software under the GNU General Public License v3.0, which you can freely use, modify, and distribute in compliance with the license. Our source code is located at: [Github.com/StarCitizenToolBox/app](https://github.com/StarCitizenToolBox/app).\n2. Internet content in this application (including but not limited to localization files, tool websites, news, videos, etc.) is copyrighted by its authors and is not part of the GPL. Please use it in compliance with the corresponding authorization agreements.\n3. The official free distribution channels for this application are: [Microsoft App Store](https://apps.microsoft.com/detail/9NF3SWFWNKL1) and [Star Citizen Chinese Localization Team Website](https://www.starcitizenzw.com/). If you obtained it from third parties, please carefully verify to avoid financial loss.\n4. This application sends anonymous statistical data to our servers during use to improve software quality. We do not collect any of your personal privacy information.\n5. This application is community-supported and has no direct affiliation with Cloud Imperium Games or other third-party commercial companies.\n6. We provide limited community support. If needed, please visit the About page to learn how to contact us.`
  String get app_splash_dialog_u_a_p_p_content {
    return Intl.message(
      'Thank you for choosing SCToolbox. We are committed to providing you with a safe, convenient, and reliable user experience. Before you start using the application, please read and agree to the following content:\n\n1. This application is open source software under the GNU General Public License v3.0, which you can freely use, modify, and distribute in compliance with the license. Our source code is located at: [Github.com/StarCitizenToolBox/app](https://github.com/StarCitizenToolBox/app).\n2. Internet content in this application (including but not limited to localization files, tool websites, news, videos, etc.) is copyrighted by its authors and is not part of the GPL. Please use it in compliance with the corresponding authorization agreements.\n3. The official free distribution channels for this application are: [Microsoft App Store](https://apps.microsoft.com/detail/9NF3SWFWNKL1) and [Star Citizen Chinese Localization Team Website](https://www.starcitizenzw.com/). If you obtained it from third parties, please carefully verify to avoid financial loss.\n4. This application sends anonymous statistical data to our servers during use to improve software quality. We do not collect any of your personal privacy information.\n5. This application is community-supported and has no direct affiliation with Cloud Imperium Games or other third-party commercial companies.\n6. We provide limited community support. If needed, please visit the About page to learn how to contact us.',
      name: 'app_splash_dialog_u_a_p_p_content',
      desc: '',
      args: [],
    );
  }

  /// `Initializing...`
  String get tools_unp4k_msg_init {
    return Intl.message(
      'Initializing...',
      name: 'tools_unp4k_msg_init',
      desc: '',
      args: [],
    );
  }

  /// `Reading P4K file...`
  String get tools_unp4k_msg_reading {
    return Intl.message(
      'Reading P4K file...',
      name: 'tools_unp4k_msg_reading',
      desc: '',
      args: [],
    );
  }

  /// `Processing files...`
  String get tools_unp4k_msg_reading2 {
    return Intl.message(
      'Processing files...',
      name: 'tools_unp4k_msg_reading2',
      desc: '',
      args: [],
    );
  }

  /// `Processing files ({v0}/{v1})...`
  String tools_unp4k_msg_reading3(Object v0, Object v1) {
    return Intl.message(
      'Processing files ($v0/$v1)...',
      name: 'tools_unp4k_msg_reading3',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Loading complete: {v0} files, time taken: {v1} ms`
  String tools_unp4k_msg_read_completed(Object v0, Object v1) {
    return Intl.message(
      'Loading complete: $v0 files, time taken: $v1 ms',
      name: 'tools_unp4k_msg_read_completed',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Opening file: {v0}`
  String tools_unp4k_msg_open_file(Object v0) {
    return Intl.message(
      'Opening file: $v0',
      name: 'tools_unp4k_msg_open_file',
      desc: '',
      args: [v0],
    );
  }

  /// `Reading file: {v0}...`
  String tools_unp4k_msg_read_file(Object v0) {
    return Intl.message(
      'Reading file: $v0...',
      name: 'tools_unp4k_msg_read_file',
      desc: '',
      args: [v0],
    );
  }

  /// `Advanced Localization -> {v0}`
  String home_localization_advanced_title(Object v0) {
    return Intl.message(
      'Advanced Localization -> $v0',
      name: 'home_localization_advanced_title',
      desc: '',
      args: [v0],
    );
  }

  /// `Loaded localization version: {v0}`
  String home_localization_advanced_msg_version(Object v0) {
    return Intl.message(
      'Loaded localization version: $v0',
      name: 'home_localization_advanced_msg_version',
      desc: '',
      args: [v0],
    );
  }

  /// `Localization text lines: {v0}  P4K text lines: {v1}`
  String home_localization_advanced_title_msg(Object v0, Object v1) {
    return Intl.message(
      'Localization text lines: $v0  P4K text lines: $v1',
      name: 'home_localization_advanced_title_msg',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Install Localization`
  String get home_localization_advanced_action_install {
    return Intl.message(
      'Install Localization',
      name: 'home_localization_advanced_action_install',
      desc: '',
      args: [],
    );
  }

  /// `Regenerating text...`
  String get home_localization_advanced_action_mod_change {
    return Intl.message(
      'Regenerating text...',
      name: 'home_localization_advanced_action_mod_change',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get home_localization_advanced_action_mode {
    return Intl.message(
      'Mode',
      name: 'home_localization_advanced_action_mode',
      desc: '',
      args: [],
    );
  }

  /// `Preview: {v0}`
  String home_localization_advanced_title_preview(Object v0) {
    return Intl.message(
      'Preview: $v0',
      name: 'home_localization_advanced_title_preview',
      desc: '',
      args: [v0],
    );
  }

  /// `Locations-Other`
  String get home_localization_advanced_json_text_location_other {
    return Intl.message(
      'Locations-Other',
      name: 'home_localization_advanced_json_text_location_other',
      desc: '',
      args: [],
    );
  }

  /// `Locations-Common`
  String get home_localization_advanced_json_text_location_used {
    return Intl.message(
      'Locations-Common',
      name: 'home_localization_advanced_json_text_location_used',
      desc: '',
      args: [],
    );
  }

  /// `Items-Other`
  String get home_localization_advanced_json_text_things_other {
    return Intl.message(
      'Items-Other',
      name: 'home_localization_advanced_json_text_things_other',
      desc: '',
      args: [],
    );
  }

  /// `Items-Common`
  String get home_localization_advanced_json_text_things_used {
    return Intl.message(
      'Items-Common',
      name: 'home_localization_advanced_json_text_things_used',
      desc: '',
      args: [],
    );
  }

  /// `Vehicles-Other`
  String get home_localization_advanced_json_text_vehicle_other {
    return Intl.message(
      'Vehicles-Other',
      name: 'home_localization_advanced_json_text_vehicle_other',
      desc: '',
      args: [],
    );
  }

  /// `Vehicles-Common`
  String get home_localization_advanced_json_text_vehicle_used {
    return Intl.message(
      'Vehicles-Common',
      name: 'home_localization_advanced_json_text_vehicle_used',
      desc: '',
      args: [],
    );
  }

  /// `Missions/Logs`
  String get home_localization_advanced_json_text_mission_or_logs {
    return Intl.message(
      'Missions/Logs',
      name: 'home_localization_advanced_json_text_mission_or_logs',
      desc: '',
      args: [],
    );
  }

  /// `Subtitles`
  String get home_localization_advanced_json_text_subtitle {
    return Intl.message(
      'Subtitles',
      name: 'home_localization_advanced_json_text_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `UI/HUD/Menu`
  String get home_localization_advanced_json_text_ui_or_hud_or_menu {
    return Intl.message(
      'UI/HUD/Menu',
      name: 'home_localization_advanced_json_text_ui_or_hud_or_menu',
      desc: '',
      args: [],
    );
  }

  /// `Not Localized`
  String get home_localization_advanced_json_text_un_localization {
    return Intl.message(
      'Not Localized',
      name: 'home_localization_advanced_json_text_un_localization',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get home_localization_advanced_json_text_others {
    return Intl.message(
      'Others',
      name: 'home_localization_advanced_json_text_others',
      desc: '',
      args: [],
    );
  }

  /// `Localized`
  String get home_localization_advanced_action_mod_change_localization {
    return Intl.message(
      'Localized',
      name: 'home_localization_advanced_action_mod_change_localization',
      desc: '',
      args: [],
    );
  }

  /// `Original English`
  String get home_localization_advanced_action_mod_change_un_localization {
    return Intl.message(
      'Original English',
      name: 'home_localization_advanced_action_mod_change_un_localization',
      desc: '',
      args: [],
    );
  }

  /// `Bilingual`
  String get home_localization_advanced_action_mod_change_mixed {
    return Intl.message(
      'Bilingual',
      name: 'home_localization_advanced_action_mod_change_mixed',
      desc: '',
      args: [],
    );
  }

  /// `Bilingual (New Line)`
  String get home_localization_advanced_action_mod_change_mixed_newline {
    return Intl.message(
      'Bilingual (New Line)',
      name: 'home_localization_advanced_action_mod_change_mixed_newline',
      desc: '',
      args: [],
    );
  }

  /// `Classifying...`
  String get home_localization_advanced_msg_classifying {
    return Intl.message(
      'Classifying...',
      name: 'home_localization_advanced_msg_classifying',
      desc: '',
      args: [],
    );
  }

  /// `Reading p4k file...`
  String get home_localization_advanced_msg_reading_p4k {
    return Intl.message(
      'Reading p4k file...',
      name: 'home_localization_advanced_msg_reading_p4k',
      desc: '',
      args: [],
    );
  }

  /// `Getting localization text...`
  String get home_localization_advanced_msg_reading_server_localization_text {
    return Intl.message(
      'Getting localization text...',
      name: 'home_localization_advanced_msg_reading_server_localization_text',
      desc: '',
      args: [],
    );
  }

  /// `Generating localization file...`
  String get home_localization_advanced_msg_gen_localization_text {
    return Intl.message(
      'Generating localization file...',
      name: 'home_localization_advanced_msg_gen_localization_text',
      desc: '',
      args: [],
    );
  }

  /// `Installing localization file...`
  String get home_localization_advanced_msg_gen_localization_install {
    return Intl.message(
      'Installing localization file...',
      name: 'home_localization_advanced_msg_gen_localization_install',
      desc: '',
      args: [],
    );
  }

  /// ` (Advanced Localization)`
  String get home_localization_msg_version_advanced {
    return Intl.message(
      ' (Advanced Localization)',
      name: 'home_localization_msg_version_advanced',
      desc: '',
      args: [],
    );
  }

  /// `This version does not provide a description`
  String get home_localization_msg_no_note {
    return Intl.message(
      'This version does not provide a description',
      name: 'home_localization_msg_no_note',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Localization`
  String get home_localization_action_rsi_launcher_localization {
    return Intl.message(
      'RSI Launcher Localization',
      name: 'home_localization_action_rsi_launcher_localization',
      desc: '',
      args: [],
    );
  }

  /// `You currently don't have the game installed or haven't selected a game installation directory. You can only use the launcher localization feature. Please make sure the game is installed or add the game installation directory in the SCToolbox settings and try again.`
  String get home_localization_action_rsi_launcher_no_game_path_msg {
    return Intl.message(
      'You currently don\'t have the game installed or haven\'t selected a game installation directory. You can only use the launcher localization feature. Please make sure the game is installed or add the game installation directory in the SCToolbox settings and try again.',
      name: 'home_localization_action_rsi_launcher_no_game_path_msg',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Localization`
  String get home_localization_action_advanced {
    return Intl.message(
      'Advanced Localization',
      name: 'home_localization_action_advanced',
      desc: '',
      args: [],
    );
  }

  /// `Install Custom Files`
  String get home_localization_action_install_customize {
    return Intl.message(
      'Install Custom Files',
      name: 'home_localization_action_install_customize',
      desc: '',
      args: [],
    );
  }

  /// `Localization Tools`
  String get home_localization_title_localization_tools {
    return Intl.message(
      'Localization Tools',
      name: 'home_localization_title_localization_tools',
      desc: '',
      args: [],
    );
  }

  /// `Depth of Field Effect`
  String get performance_json_text_dof {
    return Intl.message(
      'Depth of Field Effect',
      name: 'performance_json_text_dof',
      desc: '',
      args: [],
    );
  }

  /// `Controls depth of field effect for mobiglas pages, etc.`
  String get performance_json_text_dof_info {
    return Intl.message(
      'Controls depth of field effect for mobiglas pages, etc.',
      name: 'performance_json_text_dof_info',
      desc: '',
      args: [],
    );
  }

  /// `Screen Light Post-processing`
  String get performance_json_text_ssdo {
    return Intl.message(
      'Screen Light Post-processing',
      name: 'performance_json_text_ssdo',
      desc: '',
      args: [],
    );
  }

  /// `Adjusts light post-processing level`
  String get performance_json_text_ssdo_info {
    return Intl.message(
      'Adjusts light post-processing level',
      name: 'performance_json_text_ssdo_info',
      desc: '',
      args: [],
    );
  }

  /// `Graphics (Shader cleaning recommended after modifications)`
  String get performance_json_text_title_graphics {
    return Intl.message(
      'Graphics (Shader cleaning recommended after modifications)',
      name: 'performance_json_text_title_graphics',
      desc: '',
      args: [],
    );
  }

  /// `Anti-aliasing`
  String get performance_json_text_antialiasing {
    return Intl.message(
      'Anti-aliasing',
      name: 'performance_json_text_antialiasing',
      desc: '',
      args: [],
    );
  }

  /// `0 off, 1 SMAA, 2 temporal filter + SMAA, 3 SMAA with temporal filtering and projection matrix jitter`
  String get performance_json_text_antialiasing_info {
    return Intl.message(
      '0 off, 1 SMAA, 2 temporal filter + SMAA, 3 SMAA with temporal filtering and projection matrix jitter',
      name: 'performance_json_text_antialiasing_info',
      desc: '',
      args: [],
    );
  }

  /// `Effects Level`
  String get performance_json_text_game_effects {
    return Intl.message(
      'Effects Level',
      name: 'performance_json_text_game_effects',
      desc: '',
      args: [],
    );
  }

  /// `Game effects level`
  String get performance_json_text_game_effects_info {
    return Intl.message(
      'Game effects level',
      name: 'performance_json_text_game_effects_info',
      desc: '',
      args: [],
    );
  }

  /// `Texture Level`
  String get performance_json_text_texture {
    return Intl.message(
      'Texture Level',
      name: 'performance_json_text_texture',
      desc: '',
      args: [],
    );
  }

  /// `Model texture detail`
  String get performance_json_text_texture_info {
    return Intl.message(
      'Model texture detail',
      name: 'performance_json_text_texture_info',
      desc: '',
      args: [],
    );
  }

  /// `Volumetric Effects`
  String get performance_json_text_volumetric_effects {
    return Intl.message(
      'Volumetric Effects',
      name: 'performance_json_text_volumetric_effects',
      desc: '',
      args: [],
    );
  }

  /// `Volumetric clouds, volumetric lighting, etc.`
  String get performance_json_text_volumetric_effects_info {
    return Intl.message(
      'Volumetric clouds, volumetric lighting, etc.',
      name: 'performance_json_text_volumetric_effects_info',
      desc: '',
      args: [],
    );
  }

  /// `Water Effects`
  String get performance_json_text_water {
    return Intl.message(
      'Water Effects',
      name: 'performance_json_text_water',
      desc: '',
      args: [],
    );
  }

  /// `Various water level effects`
  String get performance_json_text_water_info {
    return Intl.message(
      'Various water level effects',
      name: 'performance_json_text_water_info',
      desc: '',
      args: [],
    );
  }

  /// `Object Detail`
  String get performance_json_text_object_detail {
    return Intl.message(
      'Object Detail',
      name: 'performance_json_text_object_detail',
      desc: '',
      args: [],
    );
  }

  /// `Model object detail, affects LOD, etc.`
  String get performance_json_text_object_detail_info {
    return Intl.message(
      'Model object detail, affects LOD, etc.',
      name: 'performance_json_text_object_detail_info',
      desc: '',
      args: [],
    );
  }

  /// `Particle Detail`
  String get performance_json_text_particles {
    return Intl.message(
      'Particle Detail',
      name: 'performance_json_text_particles',
      desc: '',
      args: [],
    );
  }

  /// `Physics Detail`
  String get performance_json_text_physics {
    return Intl.message(
      'Physics Detail',
      name: 'performance_json_text_physics',
      desc: '',
      args: [],
    );
  }

  /// `Physics effect range`
  String get performance_json_text_physics_info {
    return Intl.message(
      'Physics effect range',
      name: 'performance_json_text_physics_info',
      desc: '',
      args: [],
    );
  }

  /// `Shader Detail`
  String get performance_json_text_shading {
    return Intl.message(
      'Shader Detail',
      name: 'performance_json_text_shading',
      desc: '',
      args: [],
    );
  }

  /// `Shader related`
  String get performance_json_text_shading_info {
    return Intl.message(
      'Shader related',
      name: 'performance_json_text_shading_info',
      desc: '',
      args: [],
    );
  }

  /// `Shadow Detail`
  String get performance_json_text_shadows {
    return Intl.message(
      'Shadow Detail',
      name: 'performance_json_text_shadows',
      desc: '',
      args: [],
    );
  }

  /// `Shadow effects`
  String get performance_json_text_shadows_info {
    return Intl.message(
      'Shadow effects',
      name: 'performance_json_text_shadows_info',
      desc: '',
      args: [],
    );
  }

  /// `Post-processing Detail`
  String get performance_json_text_postprocessing {
    return Intl.message(
      'Post-processing Detail',
      name: 'performance_json_text_postprocessing',
      desc: '',
      args: [],
    );
  }

  /// `Post-processing shaders, motion blur effects, etc.`
  String get performance_json_text_postprocessing_info {
    return Intl.message(
      'Post-processing shaders, motion blur effects, etc.',
      name: 'performance_json_text_postprocessing_info',
      desc: '',
      args: [],
    );
  }

  /// `Renderer Quality`
  String get performance_json_text_renderer {
    return Intl.message(
      'Renderer Quality',
      name: 'performance_json_text_renderer',
      desc: '',
      args: [],
    );
  }

  /// `CryEngine renderer quality`
  String get performance_json_text_renderer_info {
    return Intl.message(
      'CryEngine renderer quality',
      name: 'performance_json_text_renderer_info',
      desc: '',
      args: [],
    );
  }

  /// `Decal Quality`
  String get performance_json_text_shader_decal {
    return Intl.message(
      'Decal Quality',
      name: 'performance_json_text_shader_decal',
      desc: '',
      args: [],
    );
  }

  /// `(Logos, symbols, etc.)`
  String get performance_json_text_shader_decal_info {
    return Intl.message(
      '(Logos, symbols, etc.)',
      name: 'performance_json_text_shader_decal_info',
      desc: '',
      args: [],
    );
  }

  /// `Shader Quality`
  String get performance_json_text_shader_post_process {
    return Intl.message(
      'Shader Quality',
      name: 'performance_json_text_shader_post_process',
      desc: '',
      args: [],
    );
  }

  /// `FX Quality`
  String get performance_json_text_shader_fx {
    return Intl.message(
      'FX Quality',
      name: 'performance_json_text_shader_fx',
      desc: '',
      args: [],
    );
  }

  /// `General Quality`
  String get performance_json_text_shader_general {
    return Intl.message(
      'General Quality',
      name: 'performance_json_text_shader_general',
      desc: '',
      args: [],
    );
  }

  /// `Overall model quality`
  String get performance_json_text_shader_general_info {
    return Intl.message(
      'Overall model quality',
      name: 'performance_json_text_shader_general_info',
      desc: '',
      args: [],
    );
  }

  /// `Glass Quality`
  String get performance_json_text_shader_glass {
    return Intl.message(
      'Glass Quality',
      name: 'performance_json_text_shader_glass',
      desc: '',
      args: [],
    );
  }

  /// `Windows, mirrors, etc.`
  String get performance_json_text_shader_glass_info {
    return Intl.message(
      'Windows, mirrors, etc.',
      name: 'performance_json_text_shader_glass_info',
      desc: '',
      args: [],
    );
  }

  /// `HDR Quality`
  String get performance_json_text_shader_hdr {
    return Intl.message(
      'HDR Quality',
      name: 'performance_json_text_shader_hdr',
      desc: '',
      args: [],
    );
  }

  /// `HDR color difference, brightness level processing, etc.`
  String get performance_json_text_shader_hdr_info {
    return Intl.message(
      'HDR color difference, brightness level processing, etc.',
      name: 'performance_json_text_shader_hdr_info',
      desc: '',
      args: [],
    );
  }

  /// `Particle Quality`
  String get performance_json_text_shader_particle {
    return Intl.message(
      'Particle Quality',
      name: 'performance_json_text_shader_particle',
      desc: '',
      args: [],
    );
  }

  /// `Particle effect quality`
  String get performance_json_text_shader_particle_info {
    return Intl.message(
      'Particle effect quality',
      name: 'performance_json_text_shader_particle_info',
      desc: '',
      args: [],
    );
  }

  /// `Terrain Quality`
  String get performance_json_text_shader_terrain {
    return Intl.message(
      'Terrain Quality',
      name: 'performance_json_text_shader_terrain',
      desc: '',
      args: [],
    );
  }

  /// `Shadow Quality`
  String get performance_json_text_shader_shadow {
    return Intl.message(
      'Shadow Quality',
      name: 'performance_json_text_shader_shadow',
      desc: '',
      args: [],
    );
  }

  /// `Sky Quality`
  String get performance_json_text_shader_sky {
    return Intl.message(
      'Sky Quality',
      name: 'performance_json_text_shader_sky',
      desc: '',
      args: [],
    );
  }

  /// `Particle Collisions`
  String get performance_json_text_particles_object_collisions {
    return Intl.message(
      'Particle Collisions',
      name: 'performance_json_text_particles_object_collisions',
      desc: '',
      args: [],
    );
  }

  /// `1 static particles only, 2 includes dynamic particles`
  String get performance_json_text_particles_object_collisions_info {
    return Intl.message(
      '1 static particles only, 2 includes dynamic particles',
      name: 'performance_json_text_particles_object_collisions_info',
      desc: '',
      args: [],
    );
  }

  /// `Screen Info (Show FPS)`
  String get performance_json_text_displayinfo {
    return Intl.message(
      'Screen Info (Show FPS)',
      name: 'performance_json_text_displayinfo',
      desc: '',
      args: [],
    );
  }

  /// `Display FPS, server information, etc. in the upper right corner of the screen`
  String get performance_json_text_displayinfo_info {
    return Intl.message(
      'Display FPS, server information, etc. in the upper right corner of the screen',
      name: 'performance_json_text_displayinfo_info',
      desc: '',
      args: [],
    );
  }

  /// `Maximum FPS`
  String get performance_json_text_max_fps {
    return Intl.message(
      'Maximum FPS',
      name: 'performance_json_text_max_fps',
      desc: '',
      args: [],
    );
  }

  /// `Adjust the game's maximum frame rate, 0 for unlimited`
  String get performance_json_text_max_fps_info {
    return Intl.message(
      'Adjust the game\'s maximum frame rate, 0 for unlimited',
      name: 'performance_json_text_max_fps_info',
      desc: '',
      args: [],
    );
  }

  /// `Display Session Info`
  String get performance_json_text_display_session {
    return Intl.message(
      'Display Session Info',
      name: 'performance_json_text_display_session',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, displays a QR code on screen for quickly locating relevant information when providing feedback to CIG`
  String get performance_json_text_display_session_info {
    return Intl.message(
      'When enabled, displays a QR code on screen for quickly locating relevant information when providing feedback to CIG',
      name: 'performance_json_text_display_session_info',
      desc: '',
      args: [],
    );
  }

  /// `V-Sync`
  String get performance_json_text_vsync {
    return Intl.message(
      'V-Sync',
      name: 'performance_json_text_vsync',
      desc: '',
      args: [],
    );
  }

  /// `Enable to prevent tearing, disable to increase frame rate`
  String get performance_json_text_vsync_info {
    return Intl.message(
      'Enable to prevent tearing, disable to increase frame rate',
      name: 'performance_json_text_vsync_info',
      desc: '',
      args: [],
    );
  }

  /// `Motion Blur`
  String get performance_json_text_motion_blur {
    return Intl.message(
      'Motion Blur',
      name: 'performance_json_text_motion_blur',
      desc: '',
      args: [],
    );
  }

  /// `Enable for enhanced motion feel, disable for improved visuals`
  String get performance_json_text_motion_blur_info {
    return Intl.message(
      'Enable for enhanced motion feel, disable for improved visuals',
      name: 'performance_json_text_motion_blur_info',
      desc: '',
      args: [],
    );
  }

  /// `Enable OpenXR`
  String get performance_json_text_openxr {
    return Intl.message(
      'Enable OpenXR',
      name: 'performance_json_text_openxr',
      desc: '',
      args: [],
    );
  }

  /// `Connect OpenXR-compatible headsets, use Numpad / to switch between VR and widescreen theater mode after game launch`
  String get performance_json_text_openxr_info {
    return Intl.message(
      'Connect OpenXR-compatible headsets, use Numpad / to switch between VR and widescreen theater mode after game launch',
      name: 'performance_json_text_openxr_info',
      desc: '',
      args: [],
    );
  }

  /// `Set FOV`
  String get performance_json_text_fov {
    return Intl.message(
      'Set FOV',
      name: 'performance_json_text_fov',
      desc: '',
      args: [],
    );
  }

  /// `UI Fade Animation`
  String get performance_json_text_ui_animation {
    return Intl.message(
      'UI Fade Animation',
      name: 'performance_json_text_ui_animation',
      desc: '',
      args: [],
    );
  }

  /// `Custom Parameters`
  String get performance_json_text_custom_parameters {
    return Intl.message(
      'Custom Parameters',
      name: 'performance_json_text_custom_parameters',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get performance_json_text_title_custom {
    return Intl.message(
      'Custom',
      name: 'performance_json_text_title_custom',
      desc: '',
      args: [],
    );
  }

  /// `Reading launcher information...`
  String get tools_rsi_launcher_enhance_init_msg1 {
    return Intl.message(
      'Reading launcher information...',
      name: 'tools_rsi_launcher_enhance_init_msg1',
      desc: '',
      args: [],
    );
  }

  /// `Getting enhancement data from network...`
  String get tools_rsi_launcher_enhance_init_msg2 {
    return Intl.message(
      'Getting enhancement data from network...',
      name: 'tools_rsi_launcher_enhance_init_msg2',
      desc: '',
      args: [],
    );
  }

  /// `Generating patch...`
  String get tools_rsi_launcher_enhance_working_msg1 {
    return Intl.message(
      'Generating patch...',
      name: 'tools_rsi_launcher_enhance_working_msg1',
      desc: '',
      args: [],
    );
  }

  /// `Installing patch, this will take some time depending on your computer's performance...`
  String get tools_rsi_launcher_enhance_working_msg2 {
    return Intl.message(
      'Installing patch, this will take some time depending on your computer\'s performance...',
      name: 'tools_rsi_launcher_enhance_working_msg2',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Enhancement`
  String get tools_rsi_launcher_enhance_title {
    return Intl.message(
      'RSI Launcher Enhancement',
      name: 'tools_rsi_launcher_enhance_title',
      desc: '',
      args: [],
    );
  }

  /// `Launcher internal version information: {v0}`
  String tools_rsi_launcher_enhance_msg_version(Object v0) {
    return Intl.message(
      'Launcher internal version information: $v0',
      name: 'tools_rsi_launcher_enhance_msg_version',
      desc: '',
      args: [v0],
    );
  }

  /// `Patch status: {v0}`
  String tools_rsi_launcher_enhance_msg_patch_status(Object v0) {
    return Intl.message(
      'Patch status: $v0',
      name: 'tools_rsi_launcher_enhance_msg_patch_status',
      desc: '',
      args: [v0],
    );
  }

  /// `Failed to get enhancement data, possibly due to network issues or the current version is not supported`
  String get tools_rsi_launcher_enhance_msg_error {
    return Intl.message(
      'Failed to get enhancement data, possibly due to network issues or the current version is not supported',
      name: 'tools_rsi_launcher_enhance_msg_error',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Localization`
  String get tools_rsi_launcher_enhance_title_localization {
    return Intl.message(
      'RSI Launcher Localization',
      name: 'tools_rsi_launcher_enhance_title_localization',
      desc: '',
      args: [],
    );
  }

  /// `Add multi-language support to RSI Launcher.`
  String get tools_rsi_launcher_enhance_subtitle_localization {
    return Intl.message(
      'Add multi-language support to RSI Launcher.',
      name: 'tools_rsi_launcher_enhance_subtitle_localization',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Download Enhancement`
  String get tools_rsi_launcher_enhance_title_download_booster {
    return Intl.message(
      'RSI Launcher Download Enhancement',
      name: 'tools_rsi_launcher_enhance_title_download_booster',
      desc: '',
      args: [],
    );
  }

  /// `Use more threads to improve download speed when downloading the game. After enabling, please modify the number of threads in the launcher settings.`
  String get tools_rsi_launcher_enhance_subtitle_download_booster {
    return Intl.message(
      'Use more threads to improve download speed when downloading the game. After enabling, please modify the number of threads in the launcher settings.',
      name: 'tools_rsi_launcher_enhance_subtitle_download_booster',
      desc: '',
      args: [],
    );
  }

  /// `Install Enhancement Patch`
  String get tools_rsi_launcher_enhance_action_install {
    return Intl.message(
      'Install Enhancement Patch',
      name: 'tools_rsi_launcher_enhance_action_install',
      desc: '',
      args: [],
    );
  }

  /// `* To uninstall the enhancement patch, please reinstall the RSI launcher.`
  String get tools_rsi_launcher_enhance_msg_uninstall {
    return Intl.message(
      '* To uninstall the enhancement patch, please reinstall the RSI launcher.',
      name: 'tools_rsi_launcher_enhance_msg_uninstall',
      desc: '',
      args: [],
    );
  }

  /// `RSI launcher not found`
  String get tools_rsi_launcher_enhance_msg_error_launcher_notfound {
    return Intl.message(
      'RSI launcher not found',
      name: 'tools_rsi_launcher_enhance_msg_error_launcher_notfound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to read launcher information!`
  String get tools_rsi_launcher_enhance_msg_error_get_launcher_info_error {
    return Intl.message(
      'Failed to read launcher information!',
      name: 'tools_rsi_launcher_enhance_msg_error_get_launcher_info_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to read launcher information: {v0}`
  String tools_rsi_launcher_enhance_msg_error_get_launcher_info_error_with_args(
    Object v0,
  ) {
    return Intl.message(
      'Failed to read launcher information: $v0',
      name:
          'tools_rsi_launcher_enhance_msg_error_get_launcher_info_error_with_args',
      desc: '',
      args: [v0],
    );
  }

  /// `Launcher localization, download thread enhancement`
  String get tools_action_rsi_launcher_enhance_info {
    return Intl.message(
      'Launcher localization, download thread enhancement',
      name: 'tools_action_rsi_launcher_enhance_info',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Enhancement Usage Notice`
  String get tools_rsi_launcher_enhance_note_title {
    return Intl.message(
      'RSI Launcher Enhancement Usage Notice',
      name: 'tools_rsi_launcher_enhance_note_title',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher Enhancement is a community feature that unpacks the "RSI Launcher" on your computer and adds additional enhancement features. Which features to use is up to you.\n\nCurrently, only multi-language operations are officially permitted by CIG. Launcher download enhancement is an extra feature we consider useful, but violating the CIG user agreement (https://robertsspaceindustries.com/eula) may result in serious consequences such as account banning. Whether to enable it is your decision, and we are not responsible for any consequences (game damage, account banning, etc.) that may arise.\n\nThe modifications to the launcher are open-sourced at: https://github.com/StarCitizenToolBox/RSILauncherEnhance, which you can check if needed.\n\nIf for any reason you need to cancel this enhancement patch, please directly reinstall the official launcher.`
  String get tools_rsi_launcher_enhance_note_msg {
    return Intl.message(
      'RSI Launcher Enhancement is a community feature that unpacks the "RSI Launcher" on your computer and adds additional enhancement features. Which features to use is up to you.\n\nCurrently, only multi-language operations are officially permitted by CIG. Launcher download enhancement is an extra feature we consider useful, but violating the CIG user agreement (https://robertsspaceindustries.com/eula) may result in serious consequences such as account banning. Whether to enable it is your decision, and we are not responsible for any consequences (game damage, account banning, etc.) that may arise.\n\nThe modifications to the launcher are open-sourced at: https://github.com/StarCitizenToolBox/RSILauncherEnhance, which you can check if needed.\n\nIf for any reason you need to cancel this enhancement patch, please directly reinstall the official launcher.',
      name: 'tools_rsi_launcher_enhance_note_msg',
      desc: '',
      args: [],
    );
  }

  /// `P4K Viewer`
  String get tools_action_unp4k {
    return Intl.message(
      'P4K Viewer',
      name: 'tools_action_unp4k',
      desc: '',
      args: [],
    );
  }

  /// `Unpack Star Citizen p4k files`
  String get tools_action_unp4k_info {
    return Intl.message(
      'Unpack Star Citizen p4k files',
      name: 'tools_action_unp4k_info',
      desc: '',
      args: [],
    );
  }

  /// `P4K Viewer -> {v0}`
  String tools_unp4k_title(Object v0) {
    return Intl.message(
      'P4K Viewer -> $v0',
      name: 'tools_unp4k_title',
      desc: '',
      args: [v0],
    );
  }

  /// `Click file to preview`
  String get tools_unp4k_view_file {
    return Intl.message(
      'Click file to preview',
      name: 'tools_unp4k_view_file',
      desc: '',
      args: [],
    );
  }

  /// `Unknown file type\n{v0}`
  String tools_unp4k_msg_unknown_file_type(Object v0) {
    return Intl.message(
      'Unknown file type\n$v0',
      name: 'tools_unp4k_msg_unknown_file_type',
      desc: '',
      args: [v0],
    );
  }

  /// `Please select ini file`
  String get home_localization_select_customize_file_ini {
    return Intl.message(
      'Please select ini file',
      name: 'home_localization_select_customize_file_ini',
      desc: '',
      args: [],
    );
  }

  /// `Please select custom localization file`
  String get home_localization_select_customize_file {
    return Intl.message(
      'Please select custom localization file',
      name: 'home_localization_select_customize_file',
      desc: '',
      args: [],
    );
  }

  /// `Click to select ini file`
  String get home_localization_action_select_customize_file {
    return Intl.message(
      'Click to select ini file',
      name: 'home_localization_action_select_customize_file',
      desc: '',
      args: [],
    );
  }

  /// `Collapse Additional Features`
  String get tools_rsi_launcher_enhance_action_fold {
    return Intl.message(
      'Collapse Additional Features',
      name: 'tools_rsi_launcher_enhance_action_fold',
      desc: '',
      args: [],
    );
  }

  /// `Expand Additional Features`
  String get tools_rsi_launcher_enhance_action_expand {
    return Intl.message(
      'Expand Additional Features',
      name: 'tools_rsi_launcher_enhance_action_expand',
      desc: '',
      args: [],
    );
  }

  /// `Missing Runtime`
  String get tools_unp4k_missing_runtime {
    return Intl.message(
      'Missing Runtime',
      name: 'tools_unp4k_missing_runtime',
      desc: '',
      args: [],
    );
  }

  /// `Using this feature requires .NET8 runtime. Please click the button below to download and install it. After successful installation, reopen this page to continue using.`
  String get tools_unp4k_missing_runtime_info {
    return Intl.message(
      'Using this feature requires .NET8 runtime. Please click the button below to download and install it. After successful installation, reopen this page to continue using.',
      name: 'tools_unp4k_missing_runtime_info',
      desc: '',
      args: [],
    );
  }

  /// `Install Runtime`
  String get tools_unp4k_missing_runtime_action_install {
    return Intl.message(
      'Install Runtime',
      name: 'tools_unp4k_missing_runtime_action_install',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get settings_title_general {
    return Intl.message(
      'General',
      name: 'settings_title_general',
      desc: '',
      args: [],
    );
  }

  /// `Use Built-in DNS`
  String get settings_item_dns {
    return Intl.message(
      'Use Built-in DNS',
      name: 'settings_item_dns',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, may solve DNS pollution issues in some regions`
  String get settings_item_dns_info {
    return Intl.message(
      'When enabled, may solve DNS pollution issues in some regions',
      name: 'settings_item_dns_info',
      desc: '',
      args: [],
    );
  }

  /// `Game`
  String get settings_title_game {
    return Intl.message(
      'Game',
      name: 'settings_title_game',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get about_action_btn_faq {
    return Intl.message(
      'FAQ',
      name: 'about_action_btn_faq',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get guide_title_welcome {
    return Intl.message(
      'Welcome',
      name: 'guide_title_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Please check if the following settings are correct. If there are errors, click the icon on the right to correct them before continuing`
  String get guide_info_check_settings {
    return Intl.message(
      'Please check if the following settings are correct. If there are errors, click the icon on the right to correct them before continuing',
      name: 'guide_info_check_settings',
      desc: '',
      args: [],
    );
  }

  /// `* If your game is currently downloading, please launch the game once after the download is complete and click the refresh button. If you only want to use launcher enhancement localization, make sure the launcher path is correct and click Complete Setup`
  String get guide_info_game_download_note {
    return Intl.message(
      '* If your game is currently downloading, please launch the game once after the download is complete and click the refresh button. If you only want to use launcher enhancement localization, make sure the launcher path is correct and click Complete Setup',
      name: 'guide_info_game_download_note',
      desc: '',
      args: [],
    );
  }

  /// `Get Help`
  String get guide_action_get_help {
    return Intl.message(
      'Get Help',
      name: 'guide_action_get_help',
      desc: '',
      args: [],
    );
  }

  /// `Complete Setup`
  String get guide_action_complete_setup {
    return Intl.message(
      'Complete Setup',
      name: 'guide_action_complete_setup',
      desc: '',
      args: [],
    );
  }

  /// `Confirm complete setup?`
  String get guide_dialog_confirm_complete_setup {
    return Intl.message(
      'Confirm complete setup?',
      name: 'guide_dialog_confirm_complete_setup',
      desc: '',
      args: [],
    );
  }

  /// `You have not selected a launcher installation path. Are you sure you want to complete the setup?\n\nAfter the guide page closes, you will need to manually go to the settings page to operate.`
  String get guide_action_info_no_launcher_path_warning {
    return Intl.message(
      'You have not selected a launcher installation path. Are you sure you want to complete the setup?\n\nAfter the guide page closes, you will need to manually go to the settings page to operate.',
      name: 'guide_action_info_no_launcher_path_warning',
      desc: '',
      args: [],
    );
  }

  /// `You have not selected a game installation path. Are you sure you want to complete the setup?\n\nAfter the guide page closes, you will need to manually go to the settings page to operate.`
  String get guide_action_info_no_game_path_warning {
    return Intl.message(
      'You have not selected a game installation path. Are you sure you want to complete the setup?\n\nAfter the guide page closes, you will need to manually go to the settings page to operate.',
      name: 'guide_action_info_no_game_path_warning',
      desc: '',
      args: [],
    );
  }

  /// `Select launcher exe file: "RSI Launcher.exe"`
  String get setting_toast_select_launcher_exe {
    return Intl.message(
      'Select launcher exe file: "RSI Launcher.exe"',
      name: 'setting_toast_select_launcher_exe',
      desc: '',
      args: [],
    );
  }

  /// `Select the corresponding game file to: Bin64/StarCitizen.exe`
  String get setting_toast_select_game_file {
    return Intl.message(
      'Select the corresponding game file to: Bin64/StarCitizen.exe',
      name: 'setting_toast_select_game_file',
      desc: '',
      args: [],
    );
  }

  /// `Feature under maintenance, please try again later`
  String get input_method_feature_maintenance {
    return Intl.message(
      'Feature under maintenance, please try again later',
      name: 'input_method_feature_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Community input method support not installed`
  String get input_method_community_input_method_not_installed {
    return Intl.message(
      'Community input method support not installed',
      name: 'input_method_community_input_method_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to go to Localization Management to install?\n\nIf you have already installed localization, please uninstall it and enable the community input method support switch when reinstalling.`
  String get input_method_install_community_input_method_prompt {
    return Intl.message(
      'Do you want to go to Localization Management to install?\n\nIf you have already installed localization, please uninstall it and enable the community input method support switch when reinstalling.',
      name: 'input_method_install_community_input_method_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Instructions`
  String get input_method_usage_instructions {
    return Intl.message(
      'Instructions',
      name: 'input_method_usage_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Enter text in the text box above, and paste (Ctrl+V) the encoded text below into the game's text box to send characters that the game doesn't support input for in chat channels.`
  String get input_method_input_text_instructions {
    return Intl.message(
      'Enter text in the text box above, and paste (Ctrl+V) the encoded text below into the game\'s text box to send characters that the game doesn\'t support input for in chat channels.',
      name: 'input_method_input_text_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Please enter text...`
  String get input_method_input_placeholder {
    return Intl.message(
      'Please enter text...',
      name: 'input_method_input_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Encoded text will appear here...`
  String get input_method_encoded_text_placeholder {
    return Intl.message(
      'Encoded text will appear here...',
      name: 'input_method_encoded_text_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Remote Input Service:`
  String get input_method_remote_input_service {
    return Intl.message(
      'Remote Input Service:',
      name: 'input_method_remote_input_service',
      desc: '',
      args: [],
    );
  }

  /// `*This feature is recommended for use only in non-public channels. If users choose to use this feature in public channels, any consequences (including but not limited to being reported by other players for spam, etc.) are the user's sole responsibility.\n*If this feature is abused, we will disable it.`
  String get input_method_disclaimer {
    return Intl.message(
      '*This feature is recommended for use only in non-public channels. If users choose to use this feature in public channels, any consequences (including but not limited to being reported by other players for spam, etc.) are the user\'s sole responsibility.\n*If this feature is abused, we will disable it.',
      name: 'input_method_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Community Input Method (Experimental)`
  String get input_method_experimental_input_method {
    return Intl.message(
      'Community Input Method (Experimental)',
      name: 'input_method_experimental_input_method',
      desc: '',
      args: [],
    );
  }

  /// `Auto Copy`
  String get input_method_auto_copy {
    return Intl.message(
      'Auto Copy',
      name: 'input_method_auto_copy',
      desc: '',
      args: [],
    );
  }

  /// `Confirm enable remote input?`
  String get input_method_confirm_enable_remote_input {
    return Intl.message(
      'Confirm enable remote input?',
      name: 'input_method_confirm_enable_remote_input',
      desc: '',
      args: [],
    );
  }

  /// `After enabling this feature, you can access the remote service address via mobile phone for quick text input, saving the hassle of switching windows and not interrupting game flow.\n\nIf a firewall prompt appears, please expand the dialog, manually check all network types and allow, otherwise you may not be able to access this feature normally.`
  String get input_method_enable_remote_input_instructions {
    return Intl.message(
      'After enabling this feature, you can access the remote service address via mobile phone for quick text input, saving the hassle of switching windows and not interrupting game flow.\n\nIf a firewall prompt appears, please expand the dialog, manually check all network types and allow, otherwise you may not be able to access this feature normally.',
      name: 'input_method_enable_remote_input_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch address, please check computer IP manually`
  String get input_method_address_fetch_failed {
    return Intl.message(
      'Failed to fetch address, please check computer IP manually',
      name: 'input_method_address_fetch_failed',
      desc: '',
      args: [],
    );
  }

  /// `Text cannot be empty!`
  String get input_method_text_cannot_be_empty {
    return Intl.message(
      'Text cannot be empty!',
      name: 'input_method_text_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Sent successfully!`
  String get input_method_send_success {
    return Intl.message(
      'Sent successfully!',
      name: 'input_method_send_success',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find an appropriate IP address to access the service. Please try the following addresses (swipe left/right)`
  String get input_method_ip_address_not_found {
    return Intl.message(
      'We couldn\'t find an appropriate IP address to access the service. Please try the following addresses (swipe left/right)',
      name: 'input_method_ip_address_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Please scan the QR code below with your mobile device, or manually visit the link`
  String get input_method_scan_qr_code {
    return Intl.message(
      'Please scan the QR code below with your mobile device, or manually visit the link',
      name: 'input_method_scan_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Service QR Code`
  String get input_method_service_qr_code {
    return Intl.message(
      'Service QR Code',
      name: 'input_method_service_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Confirm install advanced localization?`
  String get input_method_confirm_install_advanced_localization {
    return Intl.message(
      'Confirm install advanced localization?',
      name: 'input_method_confirm_install_advanced_localization',
      desc: '',
      args: [],
    );
  }

  /// `Install Community Input Method Support`
  String get input_method_install_community_input_method_support {
    return Intl.message(
      'Install Community Input Method Support',
      name: 'input_method_install_community_input_method_support',
      desc: '',
      args: [],
    );
  }

  /// `Community Input Method Support: {v0}`
  String input_method_community_input_method_support_version(Object v0) {
    return Intl.message(
      'Community Input Method Support: $v0',
      name: 'input_method_community_input_method_support_version',
      desc: '',
      args: [v0],
    );
  }

  /// `An online standalone version of this feature is also available. Click to visit >`
  String get input_method_online_version_prompt {
    return Intl.message(
      'An online standalone version of this feature is also available. Click to visit >',
      name: 'input_method_online_version_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Community input method support updated`
  String get input_method_support_updated {
    return Intl.message(
      'Community input method support updated',
      name: 'input_method_support_updated',
      desc: '',
      args: [],
    );
  }

  /// `Community input method support updated to: {v0}`
  String input_method_support_updated_to_version(Object v0) {
    return Intl.message(
      'Community input method support updated to: $v0',
      name: 'input_method_support_updated_to_version',
      desc: '',
      args: [v0],
    );
  }

  /// `Bilingual Translation:`
  String get input_method_auto_translate {
    return Intl.message(
      'Bilingual Translation:',
      name: 'input_method_auto_translate',
      desc: '',
      args: [],
    );
  }

  /// `Download AI model to use translation function?`
  String get input_method_auto_translate_dialog_title {
    return Intl.message(
      'Download AI model to use translation function?',
      name: 'input_method_auto_translate_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Approximately 200MB of local space is required.\n\nWe use a local model for translation; your translation data will not be sent to any third party.\n\nOpus-MT-StarCitizen is a model fine-tuned by the Chinese localization team based on the Opus-MT model, optimized for game terminology.`
  String get input_method_auto_translate_dialog_title_content {
    return Intl.message(
      'Approximately 200MB of local space is required.\n\nWe use a local model for translation; your translation data will not be sent to any third party.\n\nOpus-MT-StarCitizen is a model fine-tuned by the Chinese localization team based on the Opus-MT model, optimized for game terminology.',
      name: 'input_method_auto_translate_dialog_title_content',
      desc: '',
      args: [],
    );
  }

  /// `Download has started. Please re-enable the translation function after the model download is complete.`
  String get input_method_auto_translate_model_download_start {
    return Intl.message(
      'Download has started. Please re-enable the translation function after the model download is complete.',
      name: 'input_method_auto_translate_model_download_start',
      desc: '',
      args: [],
    );
  }

  /// `{v0}\n\nThe local translation model has poor handling of mixed Chinese and English; if needed, it is recommended to send them separately.`
  String input_method_auto_translate_model_tips(Object v0) {
    return Intl.message(
      '$v0\n\nThe local translation model has poor handling of mixed Chinese and English; if needed, it is recommended to send them separately.',
      name: 'input_method_auto_translate_model_tips',
      desc: '',
      args: [v0],
    );
  }

  /// `Model is downloading, please wait...`
  String get input_method_auto_translate_model_tips_downloading_tips {
    return Intl.message(
      'Model is downloading, please wait...',
      name: 'input_method_auto_translate_model_tips_downloading_tips',
      desc: '',
      args: [],
    );
  }

  /// `Translation model loading failed`
  String get input_method_auto_translate_model_load_failed_title {
    return Intl.message(
      'Translation model loading failed',
      name: 'input_method_auto_translate_model_load_failed_title',
      desc: '',
      args: [],
    );
  }

  /// `Delete the local file? You can try downloading it again later. Error message:\n{v0}`
  String input_method_auto_translate_model_load_failed_content(Object v0) {
    return Intl.message(
      'Delete the local file? You can try downloading it again later. Error message:\n$v0',
      name: 'input_method_auto_translate_model_load_failed_content',
      desc: '',
      args: [v0],
    );
  }

  /// `Thank you for using SCToolbox, I'm its developer xkeyC\nSCToolbox is committed to open source and providing free services to players. Free service is a challenging job, and if you consider buying me a drink, I would be very grateful.\nDonated funds will be used for server expenses, new feature development, and increasing motivation for software maintenance.`
  String get support_dev_thanks_message {
    return Intl.message(
      'Thank you for using SCToolbox, I\'m its developer xkeyC\nSCToolbox is committed to open source and providing free services to players. Free service is a challenging job, and if you consider buying me a drink, I would be very grateful.\nDonated funds will be used for server expenses, new feature development, and increasing motivation for software maintenance.',
      name: 'support_dev_thanks_message',
      desc: '',
      args: [],
    );
  }

  /// `If you haven't registered for the game or entered a referral code yet, you can consider mine: STAR-3YXS-SWTC. Thanks for reading this far`
  String get support_dev_referral_code_message {
    return Intl.message(
      'If you haven\'t registered for the game or entered a referral code yet, you can consider mine: STAR-3YXS-SWTC. Thanks for reading this far',
      name: 'support_dev_referral_code_message',
      desc: '',
      args: [],
    );
  }

  /// `Support Developer`
  String get support_dev_title {
    return Intl.message(
      'Support Developer',
      name: 'support_dev_title',
      desc: '',
      args: [],
    );
  }

  /// `You can also give my project a Star on GitHub`
  String get support_dev_github_star_message {
    return Intl.message(
      'You can also give my project a Star on GitHub',
      name: 'support_dev_github_star_message',
      desc: '',
      args: [],
    );
  }

  /// `Star Project`
  String get support_dev_github_star_button {
    return Intl.message(
      'Star Project',
      name: 'support_dev_github_star_button',
      desc: '',
      args: [],
    );
  }

  /// `In-game Currency`
  String get support_dev_in_game_currency_title {
    return Intl.message(
      'In-game Currency',
      name: 'support_dev_in_game_currency_title',
      desc: '',
      args: [],
    );
  }

  /// `Game ID: xkeyC`
  String get support_dev_in_game_id {
    return Intl.message(
      'Game ID: xkeyC',
      name: 'support_dev_in_game_id',
      desc: '',
      args: [],
    );
  }

  /// `Game ID copied`
  String get support_dev_in_game_id_copied {
    return Intl.message(
      'Game ID copied',
      name: 'support_dev_in_game_id_copied',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get support_dev_copy_button {
    return Intl.message(
      'Copy',
      name: 'support_dev_copy_button',
      desc: '',
      args: [],
    );
  }

  /// `You can send aUEC to me in the game as support, which will help me get a better gaming experience in limited time`
  String get support_dev_in_game_currency_message {
    return Intl.message(
      'You can send aUEC to me in the game as support, which will help me get a better gaming experience in limited time',
      name: 'support_dev_in_game_currency_message',
      desc: '',
      args: [],
    );
  }

  /// `Hong Kong FPS`
  String get support_dev_hk_fps_transfer_title {
    return Intl.message(
      'Hong Kong FPS',
      name: 'support_dev_hk_fps_transfer_title',
      desc: '',
      args: [],
    );
  }

  /// `FPS ID copied`
  String get support_dev_hk_fps_transfer_id_copied {
    return Intl.message(
      'FPS ID copied',
      name: 'support_dev_hk_fps_transfer_id_copied',
      desc: '',
      args: [],
    );
  }

  /// `If you are located in Hong Kong - China, or have a bank account in Hong Kong, this will be the easiest way to transfer money`
  String get support_dev_hk_fps_transfer_info {
    return Intl.message(
      'If you are located in Hong Kong - China, or have a bank account in Hong Kong, this will be the easiest way to transfer money',
      name: 'support_dev_hk_fps_transfer_info',
      desc: '',
      args: [],
    );
  }

  /// `Alipay`
  String get support_dev_alipay {
    return Intl.message(
      'Alipay',
      name: 'support_dev_alipay',
      desc: '',
      args: [],
    );
  }

  /// `WeChat`
  String get support_dev_wechat {
    return Intl.message(
      'WeChat',
      name: 'support_dev_wechat',
      desc: '',
      args: [],
    );
  }

  /// `* Please note: Donation is a gratuitous gift, you will not receive additional benefits in software experience.`
  String get support_dev_donation_disclaimer {
    return Intl.message(
      '* Please note: Donation is a gratuitous gift, you will not receive additional benefits in software experience.',
      name: 'support_dev_donation_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get support_dev_back_button {
    return Intl.message(
      'Back',
      name: 'support_dev_back_button',
      desc: '',
      args: [],
    );
  }

  /// `Scroll down for more`
  String get support_dev_scroll_hint {
    return Intl.message(
      'Scroll down for more',
      name: 'support_dev_scroll_hint',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get log_analyzer_filter_all {
    return Intl.message(
      'All',
      name: 'log_analyzer_filter_all',
      desc: '',
      args: [],
    );
  }

  /// `Basic Info`
  String get log_analyzer_filter_basic_info {
    return Intl.message(
      'Basic Info',
      name: 'log_analyzer_filter_basic_info',
      desc: '',
      args: [],
    );
  }

  /// `Account Related`
  String get log_analyzer_filter_account_related {
    return Intl.message(
      'Account Related',
      name: 'log_analyzer_filter_account_related',
      desc: '',
      args: [],
    );
  }

  /// `Fatal Collision`
  String get log_analyzer_filter_fatal_collision {
    return Intl.message(
      'Fatal Collision',
      name: 'log_analyzer_filter_fatal_collision',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Damaged`
  String get log_analyzer_filter_vehicle_damaged {
    return Intl.message(
      'Vehicle Damaged',
      name: 'log_analyzer_filter_vehicle_damaged',
      desc: '',
      args: [],
    );
  }

  /// `Character Death`
  String get log_analyzer_filter_character_death {
    return Intl.message(
      'Character Death',
      name: 'log_analyzer_filter_character_death',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get log_analyzer_filter_statistics {
    return Intl.message(
      'Statistics',
      name: 'log_analyzer_filter_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Game Crash`
  String get log_analyzer_filter_game_crash {
    return Intl.message(
      'Game Crash',
      name: 'log_analyzer_filter_game_crash',
      desc: '',
      args: [],
    );
  }

  /// `Local Inventory`
  String get log_analyzer_filter_local_inventory {
    return Intl.message(
      'Local Inventory',
      name: 'log_analyzer_filter_local_inventory',
      desc: '',
      args: [],
    );
  }

  /// `Log file not found`
  String get log_analyzer_no_log_file {
    return Intl.message(
      'Log file not found',
      name: 'log_analyzer_no_log_file',
      desc: '',
      args: [],
    );
  }

  /// `----- SCToolbox One-Click Diagnosis -----`
  String get log_analyzer_one_click_diagnosis_header {
    return Intl.message(
      '----- SCToolbox One-Click Diagnosis -----',
      name: 'log_analyzer_one_click_diagnosis_header',
      desc: '',
      args: [],
    );
  }

  /// `Detailed information: {v0}`
  String log_analyzer_details_info(Object v0) {
    return Intl.message(
      'Detailed information: $v0',
      name: 'log_analyzer_details_info',
      desc: '',
      args: [v0],
    );
  }

  /// `No game crash information detected`
  String get log_analyzer_no_crash_detected {
    return Intl.message(
      'No game crash information detected',
      name: 'log_analyzer_no_crash_detected',
      desc: '',
      args: [],
    );
  }

  /// `Game Crash `
  String get log_analyzer_game_crash {
    return Intl.message(
      'Game Crash ',
      name: 'log_analyzer_game_crash',
      desc: '',
      args: [],
    );
  }

  /// `Kill Summary`
  String get log_analyzer_kill_summary {
    return Intl.message(
      'Kill Summary',
      name: 'log_analyzer_kill_summary',
      desc: '',
      args: [],
    );
  }

  /// `Kills: {v0}   Deaths: {v1}   Suicides: {v2}  \nVehicle Destruction (Soft Death): {v3}   Vehicle Destruction (Disintegration): {v4}`
  String log_analyzer_kill_death_suicide_count(
    Object v0,
    Object v1,
    Object v2,
    Object v3,
    Object v4,
  ) {
    return Intl.message(
      'Kills: $v0   Deaths: $v1   Suicides: $v2  \nVehicle Destruction (Soft Death): $v3   Vehicle Destruction (Disintegration): $v4',
      name: 'log_analyzer_kill_death_suicide_count',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `Play Time`
  String get log_analyzer_play_time {
    return Intl.message(
      'Play Time',
      name: 'log_analyzer_play_time',
      desc: '',
      args: [],
    );
  }

  /// `{v0} hours {v1} minutes {v2} seconds`
  String log_analyzer_play_time_format(Object v0, Object v1, Object v2) {
    return Intl.message(
      '$v0 hours $v1 minutes $v2 seconds',
      name: 'log_analyzer_play_time_format',
      desc: '',
      args: [v0, v1, v2],
    );
  }

  /// `Game Start`
  String get log_analyzer_game_start {
    return Intl.message(
      'Game Start',
      name: 'log_analyzer_game_start',
      desc: '',
      args: [],
    );
  }

  /// `Game Loading`
  String get log_analyzer_game_loading {
    return Intl.message(
      'Game Loading',
      name: 'log_analyzer_game_loading',
      desc: '',
      args: [],
    );
  }

  /// `Mode: {v0}   Time taken: {v1} seconds`
  String log_analyzer_mode_loading_time(Object v0, Object v1) {
    return Intl.message(
      'Mode: $v0   Time taken: $v1 seconds',
      name: 'log_analyzer_mode_loading_time',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Game Close`
  String get log_analyzer_game_close {
    return Intl.message(
      'Game Close',
      name: 'log_analyzer_game_close',
      desc: '',
      args: [],
    );
  }

  /// `Area: {v0}   Player driving: {v1}   Collision entity: {v2} \nCollision vehicle: {v3}   Collision distance: {v4} `
  String log_analyzer_collision_details(
    Object v0,
    Object v1,
    Object v2,
    Object v3,
    Object v4,
  ) {
    return Intl.message(
      'Area: $v0   Player driving: $v1   Collision entity: $v2 \nCollision vehicle: $v3   Collision distance: $v4 ',
      name: 'log_analyzer_collision_details',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `Soft Death`
  String get log_analyzer_soft_death {
    return Intl.message(
      'Soft Death',
      name: 'log_analyzer_soft_death',
      desc: '',
      args: [],
    );
  }

  /// `Disintegration`
  String get log_analyzer_disintegration {
    return Intl.message(
      'Disintegration',
      name: 'log_analyzer_disintegration',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle model: {v0}   \nArea: {v1} \nDamage level: {v2} ({v3})   Responsible party: {v4}`
  String log_analyzer_vehicle_damage_details(
    Object v0,
    Object v1,
    Object v2,
    Object v3,
    Object v4,
  ) {
    return Intl.message(
      'Vehicle model: $v0   \nArea: $v1 \nDamage level: $v2 ($v3)   Responsible party: $v4',
      name: 'log_analyzer_vehicle_damage_details',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `Victim ID: {v0}   \nLocation: {v2}  \nArea: {v3}`
  String log_analyzer_death_details(Object v0, Object v2, Object v3) {
    return Intl.message(
      'Victim ID: $v0   \nLocation: $v2  \nArea: $v3',
      name: 'log_analyzer_death_details',
      desc: '',
      args: [v0, v2, v3],
    );
  }

  /// `Player {v0} logged in...`
  String log_analyzer_player_login(Object v0) {
    return Intl.message(
      'Player $v0 logged in...',
      name: 'log_analyzer_player_login',
      desc: '',
      args: [v0],
    );
  }

  /// `View Local Inventory`
  String get log_analyzer_view_local_inventory {
    return Intl.message(
      'View Local Inventory',
      name: 'log_analyzer_view_local_inventory',
      desc: '',
      args: [],
    );
  }

  /// `Player ID: {v0}   Location: {v1}`
  String log_analyzer_player_location(Object v0, Object v1) {
    return Intl.message(
      'Player ID: $v0   Location: $v1',
      name: 'log_analyzer_player_location',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Game Installation Path`
  String get log_analyzer_game_installation_path {
    return Intl.message(
      'Game Installation Path',
      name: 'log_analyzer_game_installation_path',
      desc: '',
      args: [],
    );
  }

  /// `Please select game installation path`
  String get log_analyzer_select_game_path {
    return Intl.message(
      'Please select game installation path',
      name: 'log_analyzer_select_game_path',
      desc: '',
      args: [],
    );
  }

  /// `Enter keywords to search content`
  String get log_analyzer_search_placeholder {
    return Intl.message(
      'Enter keywords to search content',
      name: 'log_analyzer_search_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Log Analyzer`
  String get log_analyzer_title {
    return Intl.message(
      'Log Analyzer',
      name: 'log_analyzer_title',
      desc: '',
      args: [],
    );
  }

  /// `Analyze your gameplay records (login, death, kills, and other information)`
  String get log_analyzer_description {
    return Intl.message(
      'Analyze your gameplay records (login, death, kills, and other information)',
      name: 'log_analyzer_description',
      desc: '',
      args: [],
    );
  }

  /// `SCToolbox: Log Analyzer`
  String get log_analyzer_window_title {
    return Intl.message(
      'SCToolbox: Log Analyzer',
      name: 'log_analyzer_window_title',
      desc: '',
      args: [],
    );
  }

  /// `Navigation`
  String get nav_title {
    return Intl.message('Navigation', name: 'nav_title', desc: '', args: []);
  }

  /// `*The services linked correspond to third-party providers. We do not make any guarantees and users should assess the risks of using them.    |   `
  String get nav_third_party_service_disclaimer {
    return Intl.message(
      '*The services linked correspond to third-party providers. We do not make any guarantees and users should assess the risks of using them.    |   ',
      name: 'nav_third_party_service_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Website navigation data provided by`
  String get nav_website_navigation_data_provided_by {
    return Intl.message(
      'Website navigation data provided by',
      name: 'nav_website_navigation_data_provided_by',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get nav_provided_by {
    return Intl.message('', name: 'nav_provided_by', desc: '', args: []);
  }

  /// `Fetching data...`
  String get nav_fetching_data {
    return Intl.message(
      'Fetching data...',
      name: 'nav_fetching_data',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Sorting`
  String get tools_vehicle_sorting_title {
    return Intl.message(
      'Vehicle Sorting',
      name: 'tools_vehicle_sorting_title',
      desc: '',
      args: [],
    );
  }

  /// `Drag vehicles from the left to the right list. This will add prefixes like 001, 002... to vehicle names, making it easier to locate them in the game UI. Drag vehicles up and down in the right list to adjust their order.`
  String get tools_vehicle_sorting_info {
    return Intl.message(
      'Drag vehicles from the left to the right list. This will add prefixes like 001, 002... to vehicle names, making it easier to locate them in the game UI. Drag vehicles up and down in the right list to adjust their order.',
      name: 'tools_vehicle_sorting_info',
      desc: '',
      args: [],
    );
  }

  /// `Vehicles`
  String get tools_vehicle_sorting_vehicle {
    return Intl.message(
      'Vehicles',
      name: 'tools_vehicle_sorting_vehicle',
      desc: '',
      args: [],
    );
  }

  /// `Search Vehicles`
  String get tools_vehicle_sorting_search {
    return Intl.message(
      'Search Vehicles',
      name: 'tools_vehicle_sorting_search',
      desc: '',
      args: [],
    );
  }

  /// `Sorted Vehicles`
  String get tools_vehicle_sorting_sorted {
    return Intl.message(
      'Sorted Vehicles',
      name: 'tools_vehicle_sorting_sorted',
      desc: '',
      args: [],
    );
  }

  /// `Not Logged In`
  String get user_not_logged_in {
    return Intl.message(
      'Not Logged In',
      name: 'user_not_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Unregister Account`
  String get user_action_unregister {
    return Intl.message(
      'Unregister Account',
      name: 'user_action_unregister',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Unregister`
  String get user_confirm_unregister_title {
    return Intl.message(
      'Confirm Unregister',
      name: 'user_confirm_unregister_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to unregister your account? If you need to log in again, you will need to link your account again.`
  String get user_confirm_unregister_message {
    return Intl.message(
      'Are you sure you want to unregister your account? If you need to log in again, you will need to link your account again.',
      name: 'user_confirm_unregister_message',
      desc: '',
      args: [],
    );
  }

  /// `Account unregistered successfully`
  String get user_unregister_success {
    return Intl.message(
      'Account unregistered successfully',
      name: 'user_unregister_success',
      desc: '',
      args: [],
    );
  }

  /// `Account unregistration failed`
  String get user_unregister_failed {
    return Intl.message(
      'Account unregistration failed',
      name: 'user_unregister_failed',
      desc: '',
      args: [],
    );
  }

  /// `Use XNN to accelerate ONNX inference`
  String get settings_item_onnx_xnn_pack {
    return Intl.message(
      'Use XNN to accelerate ONNX inference',
      name: 'settings_item_onnx_xnn_pack',
      desc: '',
      args: [],
    );
  }

  /// `Disabling this option may solve some compatibility issues`
  String get settings_item_onnx_xnn_pack_info {
    return Intl.message(
      'Disabling this option may solve some compatibility issues',
      name: 'settings_item_onnx_xnn_pack_info',
      desc: '',
      args: [],
    );
  }

  /// `Party Room`
  String get party_room_title {
    return Intl.message(
      'Party Room',
      name: 'party_room_title',
      desc: '',
      args: [],
    );
  }

  /// `Connecting to server...`
  String get party_room_connecting {
    return Intl.message(
      'Connecting to server...',
      name: 'party_room_connecting',
      desc: '',
      args: [],
    );
  }

  /// `Connection failed`
  String get party_room_connect_failed {
    return Intl.message(
      'Connection failed',
      name: 'party_room_connect_failed',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get party_room_retry {
    return Intl.message('Retry', name: 'party_room_retry', desc: '', args: []);
  }

  /// `Connection lost`
  String get party_room_disconnected {
    return Intl.message(
      'Connection lost',
      name: 'party_room_disconnected',
      desc: '',
      args: [],
    );
  }

  /// `The connection to the room server has been lost. Do you want to reconnect?`
  String get party_room_reconnect_prompt {
    return Intl.message(
      'The connection to the room server has been lost. Do you want to reconnect?',
      name: 'party_room_reconnect_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Exit Room`
  String get party_room_exit_room {
    return Intl.message(
      'Exit Room',
      name: 'party_room_exit_room',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect`
  String get party_room_reconnect {
    return Intl.message(
      'Reconnect',
      name: 'party_room_reconnect',
      desc: '',
      args: [],
    );
  }

  /// `Failed to exit room: {v0}`
  String party_room_exit_room_failed(Object v0) {
    return Intl.message(
      'Failed to exit room: $v0',
      name: 'party_room_exit_room_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `No members`
  String get party_room_no_members {
    return Intl.message(
      'No members',
      name: 'party_room_no_members',
      desc: '',
      args: [],
    );
  }

  /// `Copy Game ID`
  String get party_room_copy_game_id {
    return Intl.message(
      'Copy Game ID',
      name: 'party_room_copy_game_id',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Ownership`
  String get party_room_transfer_owner {
    return Intl.message(
      'Transfer Ownership',
      name: 'party_room_transfer_owner',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to transfer ownership to {v0}?`
  String party_room_transfer_owner_confirm(Object v0) {
    return Intl.message(
      'Are you sure you want to transfer ownership to $v0?',
      name: 'party_room_transfer_owner_confirm',
      desc: '',
      args: [v0],
    );
  }

  /// `Transfer`
  String get party_room_transfer {
    return Intl.message(
      'Transfer',
      name: 'party_room_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Operation failed`
  String get party_room_operation_failed {
    return Intl.message(
      'Operation failed',
      name: 'party_room_operation_failed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to transfer ownership: {v0}`
  String party_room_transfer_owner_failed(Object v0) {
    return Intl.message(
      'Failed to transfer ownership: $v0',
      name: 'party_room_transfer_owner_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Kick Member`
  String get party_room_kick_member {
    return Intl.message(
      'Kick Member',
      name: 'party_room_kick_member',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to kick {v0}?`
  String party_room_kick_member_confirm(Object v0) {
    return Intl.message(
      'Are you sure you want to kick $v0?',
      name: 'party_room_kick_member_confirm',
      desc: '',
      args: [v0],
    );
  }

  /// `Kick`
  String get party_room_kick {
    return Intl.message('Kick', name: 'party_room_kick', desc: '', args: []);
  }

  /// `Failed to kick member: {v0}`
  String party_room_kick_member_failed(Object v0) {
    return Intl.message(
      'Failed to kick member: $v0',
      name: 'party_room_kick_member_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Loading...`
  String get party_room_loading {
    return Intl.message(
      'Loading...',
      name: 'party_room_loading',
      desc: '',
      args: [],
    );
  }

  /// `Send Signal`
  String get party_room_send_signal {
    return Intl.message(
      'Send Signal',
      name: 'party_room_send_signal',
      desc: '',
      args: [],
    );
  }

  /// `Send failed`
  String get party_room_send_failed {
    return Intl.message(
      'Send failed',
      name: 'party_room_send_failed',
      desc: '',
      args: [],
    );
  }

  /// `No messages`
  String get party_room_no_messages {
    return Intl.message(
      'No messages',
      name: 'party_room_no_messages',
      desc: '',
      args: [],
    );
  }

  /// `This room contains third-party social links. Click to join and chat freely~`
  String get party_room_social_links_hint {
    return Intl.message(
      'This room contains third-party social links. Click to join and chat freely~',
      name: 'party_room_social_links_hint',
      desc: '',
      args: [],
    );
  }

  /// `Copy the room owner's game ID to add friends and quickly team up on the game homepage`
  String get party_room_copy_owner_id_hint {
    return Intl.message(
      'Copy the room owner\'s game ID to add friends and quickly team up on the game homepage',
      name: 'party_room_copy_owner_id_hint',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get party_room_copy {
    return Intl.message('Copy', name: 'party_room_copy', desc: '', args: []);
  }

  /// `Link`
  String get party_room_link {
    return Intl.message('Link', name: 'party_room_link', desc: '', args: []);
  }

  /// `Unknown Location`
  String get party_room_unknown_location {
    return Intl.message(
      'Unknown Location',
      name: 'party_room_unknown_location',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Area`
  String get party_room_unknown_area {
    return Intl.message(
      'Unknown Area',
      name: 'party_room_unknown_area',
      desc: '',
      args: [],
    );
  }

  /// `Player Death`
  String get party_room_player_death {
    return Intl.message(
      'Player Death',
      name: 'party_room_player_death',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get party_room_location {
    return Intl.message(
      'Location',
      name: 'party_room_location',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get party_room_area {
    return Intl.message('Area', name: 'party_room_area', desc: '', args: []);
  }

  /// `Unknown User`
  String get party_room_unknown_user {
    return Intl.message(
      'Unknown User',
      name: 'party_room_unknown_user',
      desc: '',
      args: [],
    );
  }

  /// `New Owner`
  String get party_room_new_owner {
    return Intl.message(
      'New Owner',
      name: 'party_room_new_owner',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get party_room_system {
    return Intl.message(
      'System',
      name: 'party_room_system',
      desc: '',
      args: [],
    );
  }

  /// `joined the room`
  String get party_room_joined_room {
    return Intl.message(
      'joined the room',
      name: 'party_room_joined_room',
      desc: '',
      args: [],
    );
  }

  /// `left the room`
  String get party_room_left_room {
    return Intl.message(
      'left the room',
      name: 'party_room_left_room',
      desc: '',
      args: [],
    );
  }

  /// `became the new room owner`
  String get party_room_became_owner {
    return Intl.message(
      'became the new room owner',
      name: 'party_room_became_owner',
      desc: '',
      args: [],
    );
  }

  /// `Room information updated`
  String get party_room_info_updated {
    return Intl.message(
      'Room information updated',
      name: 'party_room_info_updated',
      desc: '',
      args: [],
    );
  }

  /// `Room has been dismissed`
  String get party_room_dismissed {
    return Intl.message(
      'Room has been dismissed',
      name: 'party_room_dismissed',
      desc: '',
      args: [],
    );
  }

  /// `was kicked from the room`
  String get party_room_kicked {
    return Intl.message(
      'was kicked from the room',
      name: 'party_room_kicked',
      desc: '',
      args: [],
    );
  }

  /// `Just now`
  String get party_room_just_now {
    return Intl.message(
      'Just now',
      name: 'party_room_just_now',
      desc: '',
      args: [],
    );
  }

  /// `{v0} minutes ago`
  String party_room_minutes_ago(Object v0) {
    return Intl.message(
      '$v0 minutes ago',
      name: 'party_room_minutes_ago',
      desc: '',
      args: [v0],
    );
  }

  /// `{v0} hours ago`
  String party_room_hours_ago(Object v0) {
    return Intl.message(
      '$v0 hours ago',
      name: 'party_room_hours_ago',
      desc: '',
      args: [v0],
    );
  }

  /// `{v0} days ago`
  String party_room_days_ago(Object v0) {
    return Intl.message(
      '$v0 days ago',
      name: 'party_room_days_ago',
      desc: '',
      args: [v0],
    );
  }

  /// `Room`
  String get party_room_room {
    return Intl.message('Room', name: 'party_room_room', desc: '', args: []);
  }

  /// `{v0}/{v1} members`
  String party_room_members_count(Object v0, Object v1) {
    return Intl.message(
      '$v0/$v1 members',
      name: 'party_room_members_count',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Edit Room`
  String get party_room_edit_room {
    return Intl.message(
      'Edit Room',
      name: 'party_room_edit_room',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Dismiss`
  String get party_room_confirm_dismiss {
    return Intl.message(
      'Confirm Dismiss',
      name: 'party_room_confirm_dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to dismiss this room? All members will be removed.`
  String get party_room_dismiss_confirm_msg {
    return Intl.message(
      'Are you sure you want to dismiss this room? All members will be removed.',
      name: 'party_room_dismiss_confirm_msg',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get party_room_dismiss {
    return Intl.message(
      'Dismiss',
      name: 'party_room_dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss Room`
  String get party_room_dismiss_room {
    return Intl.message(
      'Dismiss Room',
      name: 'party_room_dismiss_room',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to leave the room?`
  String get party_room_leave_confirm {
    return Intl.message(
      'Are you sure you want to leave the room?',
      name: 'party_room_leave_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Leave Room`
  String get party_room_leave_room {
    return Intl.message(
      'Leave Room',
      name: 'party_room_leave_room',
      desc: '',
      args: [],
    );
  }

  /// `Create Room`
  String get party_room_create_room {
    return Intl.message(
      'Create Room',
      name: 'party_room_create_room',
      desc: '',
      args: [],
    );
  }

  /// `Room Type`
  String get party_room_room_type {
    return Intl.message(
      'Room Type',
      name: 'party_room_room_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Main Tag`
  String get party_room_select_main_tag {
    return Intl.message(
      'Select Main Tag',
      name: 'party_room_select_main_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sub Tag (Optional)`
  String get party_room_sub_tag_optional {
    return Intl.message(
      'Sub Tag (Optional)',
      name: 'party_room_sub_tag_optional',
      desc: '',
      args: [],
    );
  }

  /// `Select Sub Tag`
  String get party_room_select_sub_tag {
    return Intl.message(
      'Select Sub Tag',
      name: 'party_room_select_sub_tag',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get party_room_none {
    return Intl.message('None', name: 'party_room_none', desc: '', args: []);
  }

  /// `Target Members (2-100)`
  String get party_room_target_members {
    return Intl.message(
      'Target Members (2-100)',
      name: 'party_room_target_members',
      desc: '',
      args: [],
    );
  }

  /// `Enter target members`
  String get party_room_enter_target_members {
    return Intl.message(
      'Enter target members',
      name: 'party_room_enter_target_members',
      desc: '',
      args: [],
    );
  }

  /// `Set Password`
  String get party_room_set_password {
    return Intl.message(
      'Set Password',
      name: 'party_room_set_password',
      desc: '',
      args: [],
    );
  }

  /// `Room Password`
  String get party_room_room_password {
    return Intl.message(
      'Room Password',
      name: 'party_room_room_password',
      desc: '',
      args: [],
    );
  }

  /// `Leave empty to keep password unchanged, uncheck to remove password`
  String get party_room_password_empty_hint {
    return Intl.message(
      'Leave empty to keep password unchanged, uncheck to remove password',
      name: 'party_room_password_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get party_room_enter_password {
    return Intl.message(
      'Enter password',
      name: 'party_room_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Password not enabled`
  String get party_room_password_disabled {
    return Intl.message(
      'Password not enabled',
      name: 'party_room_password_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Social Links (Optional)`
  String get party_room_social_links_optional {
    return Intl.message(
      'Social Links (Optional)',
      name: 'party_room_social_links_optional',
      desc: '',
      args: [],
    );
  }

  /// `Start with https://, currently only supports qq, discord, kook, oopz links`
  String get party_room_social_links_placeholder {
    return Intl.message(
      'Start with https://, currently only supports qq, discord, kook, oopz links',
      name: 'party_room_social_links_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please select room type`
  String get party_room_select_room_type {
    return Intl.message(
      'Please select room type',
      name: 'party_room_select_room_type',
      desc: '',
      args: [],
    );
  }

  /// `Target members must be between 2-100`
  String get party_room_target_members_range {
    return Intl.message(
      'Target members must be between 2-100',
      name: 'party_room_target_members_range',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get party_room_enter_password_required {
    return Intl.message(
      'Please enter password',
      name: 'party_room_enter_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Link format error!`
  String get party_room_link_format_error {
    return Intl.message(
      'Link format error!',
      name: 'party_room_link_format_error',
      desc: '',
      args: [],
    );
  }

  /// `Update failed`
  String get party_room_update_failed {
    return Intl.message(
      'Update failed',
      name: 'party_room_update_failed',
      desc: '',
      args: [],
    );
  }

  /// `Create failed`
  String get party_room_create_failed {
    return Intl.message(
      'Create failed',
      name: 'party_room_create_failed',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get party_room_save {
    return Intl.message('Save', name: 'party_room_save', desc: '', args: []);
  }

  /// `Create`
  String get party_room_create {
    return Intl.message(
      'Create',
      name: 'party_room_create',
      desc: '',
      args: [],
    );
  }

  /// `Register Account`
  String get party_room_register_title {
    return Intl.message(
      'Register Account',
      name: 'party_room_register_title',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get party_room_error {
    return Intl.message('Error', name: 'party_room_error', desc: '', args: []);
  }

  /// `Enter Game ID`
  String get party_room_step_enter_game_id {
    return Intl.message(
      'Enter Game ID',
      name: 'party_room_step_enter_game_id',
      desc: '',
      args: [],
    );
  }

  /// `Verify RSI Account`
  String get party_room_step_verify_rsi {
    return Intl.message(
      'Verify RSI Account',
      name: 'party_room_step_verify_rsi',
      desc: '',
      args: [],
    );
  }

  /// `Complete Registration`
  String get party_room_step_complete {
    return Intl.message(
      'Complete Registration',
      name: 'party_room_step_complete',
      desc: '',
      args: [],
    );
  }

  /// `About Account Verification`
  String get party_room_about_verification {
    return Intl.message(
      'About Account Verification',
      name: 'party_room_about_verification',
      desc: '',
      args: [],
    );
  }

  /// `Next, you need to add a verification code to your RSI account bio to prove account ownership. After verification, you can remove the code.`
  String get party_room_verification_hint {
    return Intl.message(
      'Next, you need to add a verification code to your RSI account bio to prove account ownership. After verification, you can remove the code.',
      name: 'party_room_verification_hint',
      desc: '',
      args: [],
    );
  }

  /// `Step 1: Enter Your Game ID`
  String get party_room_step1_title {
    return Intl.message(
      'Step 1: Enter Your Game ID',
      name: 'party_room_step1_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Star Citizen game ID (Handle), which is your unique identifier in the game.`
  String get party_room_step1_desc {
    return Intl.message(
      'Please enter your Star Citizen game ID (Handle), which is your unique identifier in the game.',
      name: 'party_room_step1_desc',
      desc: '',
      args: [],
    );
  }

  /// `Example: Citizen123`
  String get party_room_game_id_example {
    return Intl.message(
      'Example: Citizen123',
      name: 'party_room_game_id_example',
      desc: '',
      args: [],
    );
  }

  /// `View My Game ID`
  String get party_room_view_game_id {
    return Intl.message(
      'View My Game ID',
      name: 'party_room_view_game_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter game ID`
  String get party_room_enter_game_id {
    return Intl.message(
      'Please enter game ID',
      name: 'party_room_enter_game_id',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get party_room_next_step {
    return Intl.message(
      'Next',
      name: 'party_room_next_step',
      desc: '',
      args: [],
    );
  }

  /// `Step 2: Verify RSI Account`
  String get party_room_step2_title {
    return Intl.message(
      'Step 2: Verify RSI Account',
      name: 'party_room_step2_title',
      desc: '',
      args: [],
    );
  }

  /// `Please follow these steps to complete account verification:`
  String get party_room_step2_desc {
    return Intl.message(
      'Please follow these steps to complete account verification:',
      name: 'party_room_step2_desc',
      desc: '',
      args: [],
    );
  }

  /// `1. Copy the following verification code:`
  String get party_room_copy_code {
    return Intl.message(
      '1. Copy the following verification code:',
      name: 'party_room_copy_code',
      desc: '',
      args: [],
    );
  }

  /// `2. Visit your RSI account settings page`
  String get party_room_visit_rsi {
    return Intl.message(
      '2. Visit your RSI account settings page',
      name: 'party_room_visit_rsi',
      desc: '',
      args: [],
    );
  }

  /// `Open Profile Page`
  String get party_room_open_profile {
    return Intl.message(
      'Open Profile Page',
      name: 'party_room_open_profile',
      desc: '',
      args: [],
    );
  }

  /// `3. Edit your bio and add the verification code`
  String get party_room_edit_bio {
    return Intl.message(
      '3. Edit your bio and add the verification code',
      name: 'party_room_edit_bio',
      desc: '',
      args: [],
    );
  }

  /// `Add the code anywhere in your bio. The code is valid for 30 minutes`
  String get party_room_code_validity {
    return Intl.message(
      'Add the code anywhere in your bio. The code is valid for 30 minutes',
      name: 'party_room_code_validity',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get party_room_prev_step {
    return Intl.message(
      'Previous',
      name: 'party_room_prev_step',
      desc: '',
      args: [],
    );
  }

  /// `I've added it, verify and register`
  String get party_room_verify_register {
    return Intl.message(
      'I\'ve added it, verify and register',
      name: 'party_room_verify_register',
      desc: '',
      args: [],
    );
  }

  /// `Registration Successful!`
  String get party_room_register_success {
    return Intl.message(
      'Registration Successful!',
      name: 'party_room_register_success',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully registered for the party room. You can now start using it`
  String get party_room_register_success_msg {
    return Intl.message(
      'You have successfully registered for the party room. You can now start using it',
      name: 'party_room_register_success_msg',
      desc: '',
      args: [],
    );
  }

  /// `You are browsing as a guest. Log in to create or join rooms.`
  String get party_room_guest_mode_hint {
    return Intl.message(
      'You are browsing as a guest. Log in to create or join rooms.',
      name: 'party_room_guest_mode_hint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get party_room_login {
    return Intl.message('Login', name: 'party_room_login', desc: '', args: []);
  }

  /// `Search room owner...`
  String get party_room_search_owner {
    return Intl.message(
      'Search room owner...',
      name: 'party_room_search_owner',
      desc: '',
      args: [],
    );
  }

  /// `Return to current room`
  String get party_room_return_to_room {
    return Intl.message(
      'Return to current room',
      name: 'party_room_return_to_room',
      desc: '',
      args: [],
    );
  }

  /// `Select Tag`
  String get party_room_select_tag {
    return Intl.message(
      'Select Tag',
      name: 'party_room_select_tag',
      desc: '',
      args: [],
    );
  }

  /// `All Tags`
  String get party_room_all_tags {
    return Intl.message(
      'All Tags',
      name: 'party_room_all_tags',
      desc: '',
      args: [],
    );
  }

  /// `No rooms matching criteria found`
  String get party_room_no_matching_room {
    return Intl.message(
      'No rooms matching criteria found',
      name: 'party_room_no_matching_room',
      desc: '',
      args: [],
    );
  }

  /// `No rooms in this category`
  String get party_room_no_room_in_category {
    return Intl.message(
      'No rooms in this category',
      name: 'party_room_no_room_in_category',
      desc: '',
      args: [],
    );
  }

  /// `No rooms available`
  String get party_room_no_available_room {
    return Intl.message(
      'No rooms available',
      name: 'party_room_no_available_room',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to create a room!`
  String get party_room_be_first_create {
    return Intl.message(
      'Be the first to create a room!',
      name: 'party_room_be_first_create',
      desc: '',
      args: [],
    );
  }

  /// `All rooms loaded`
  String get party_room_all_loaded {
    return Intl.message(
      'All rooms loaded',
      name: 'party_room_all_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Login Required`
  String get party_room_need_login {
    return Intl.message(
      'Login Required',
      name: 'party_room_need_login',
      desc: '',
      args: [],
    );
  }

  /// `You need to login to create a room. Would you like to login now?`
  String get party_room_create_need_login {
    return Intl.message(
      'You need to login to create a room. Would you like to login now?',
      name: 'party_room_create_need_login',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get party_room_go_login {
    return Intl.message(
      'Login',
      name: 'party_room_go_login',
      desc: '',
      args: [],
    );
  }

  /// `Create New Room`
  String get party_room_create_new_room {
    return Intl.message(
      'Create New Room',
      name: 'party_room_create_new_room',
      desc: '',
      args: [],
    );
  }

  /// `You are already in another room. Creating a new room will automatically exit the current room. Continue?`
  String get party_room_already_in_room_create {
    return Intl.message(
      'You are already in another room. Creating a new room will automatically exit the current room. Continue?',
      name: 'party_room_already_in_room_create',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get party_room_continue {
    return Intl.message(
      'Continue',
      name: 'party_room_continue',
      desc: '',
      args: [],
    );
  }

  /// `You need to login to join a room. Would you like to login now?`
  String get party_room_join_need_login {
    return Intl.message(
      'You need to login to join a room. Would you like to login now?',
      name: 'party_room_join_need_login',
      desc: '',
      args: [],
    );
  }

  /// `Switch Room`
  String get party_room_switch_room {
    return Intl.message(
      'Switch Room',
      name: 'party_room_switch_room',
      desc: '',
      args: [],
    );
  }

  /// `You are already in another room. Joining a new room will automatically exit the current room. Continue?`
  String get party_room_already_in_room_join {
    return Intl.message(
      'You are already in another room. Joining a new room will automatically exit the current room. Continue?',
      name: 'party_room_already_in_room_join',
      desc: '',
      args: [],
    );
  }

  /// `Enter Room Password`
  String get party_room_enter_room_password {
    return Intl.message(
      'Enter Room Password',
      name: 'party_room_enter_room_password',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get party_room_join {
    return Intl.message('Join', name: 'party_room_join', desc: '', args: []);
  }

  /// `Join failed`
  String get party_room_join_failed {
    return Intl.message(
      'Join failed',
      name: 'party_room_join_failed',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect failed: {v0}`
  String party_room_reconnect_failed(Object v0) {
    return Intl.message(
      'Reconnect failed: $v0',
      name: 'party_room_reconnect_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Reconnect failed, attempted {v0} times`
  String party_room_reconnect_retry(Object v0) {
    return Intl.message(
      'Reconnect failed, attempted $v0 times',
      name: 'party_room_reconnect_retry',
      desc: '',
      args: [v0],
    );
  }

  /// `Connection failed: {v0}`
  String party_room_connect_error(Object v0) {
    return Intl.message(
      'Connection failed: $v0',
      name: 'party_room_connect_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Failed to get verification code: {v0}`
  String party_room_get_code_failed(Object v0) {
    return Intl.message(
      'Failed to get verification code: $v0',
      name: 'party_room_get_code_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Game ID cannot be empty`
  String get party_room_game_id_empty {
    return Intl.message(
      'Game ID cannot be empty',
      name: 'party_room_game_id_empty',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed: {v0}`
  String party_room_register_failed(Object v0) {
    return Intl.message(
      'Registration failed: $v0',
      name: 'party_room_register_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Failed to load room list: {v0}`
  String party_room_load_list_failed(Object v0) {
    return Intl.message(
      'Failed to load room list: $v0',
      name: 'party_room_load_list_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `<Game Not Started>`
  String get party_room_game_not_started {
    return Intl.message(
      '<Game Not Started>',
      name: 'party_room_game_not_started',
      desc: '',
      args: [],
    );
  }

  /// `<Main Menu>`
  String get party_room_main_menu {
    return Intl.message(
      '<Main Menu>',
      name: 'party_room_main_menu',
      desc: '',
      args: [],
    );
  }

  /// `Diagnostic Mode - Step {v0}`
  String splash_diagnostic_mode(Object v0) {
    return Intl.message(
      'Diagnostic Mode - Step $v0',
      name: 'splash_diagnostic_mode',
      desc: '',
      args: [v0],
    );
  }

  /// `Read Full Log`
  String get splash_read_full_log {
    return Intl.message(
      'Read Full Log',
      name: 'splash_read_full_log',
      desc: '',
      args: [],
    );
  }

  /// `Reset Database`
  String get splash_reset_database {
    return Intl.message(
      'Reset Database',
      name: 'splash_reset_database',
      desc: '',
      args: [],
    );
  }

  /// `Initialization Task Status:`
  String get splash_init_task_status {
    return Intl.message(
      'Initialization Task Status:',
      name: 'splash_init_task_status',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for log...`
  String get splash_waiting_log {
    return Intl.message(
      'Waiting for log...',
      name: 'splash_waiting_log',
      desc: '',
      args: [],
    );
  }

  /// `Timeout`
  String get splash_timeout {
    return Intl.message('Timeout', name: 'splash_timeout', desc: '', args: []);
  }

  /// `Error`
  String get splash_error {
    return Intl.message('Error', name: 'splash_error', desc: '', args: []);
  }

  /// `[Diagnostic] {v0}`
  String splash_diagnostic_log(Object v0) {
    return Intl.message(
      '[Diagnostic] $v0',
      name: 'splash_diagnostic_log',
      desc: '',
      args: [v0],
    );
  }

  /// `[{v0}] Starting initialization...`
  String splash_start_init(Object v0) {
    return Intl.message(
      '[$v0] Starting initialization...',
      name: 'splash_start_init',
      desc: '',
      args: [v0],
    );
  }

  /// `Executing appModel.initApp()...`
  String get splash_exec_app_init {
    return Intl.message(
      'Executing appModel.initApp()...',
      name: 'splash_exec_app_init',
      desc: '',
      args: [],
    );
  }

  /// `✗ appModel.initApp() timeout (10s)`
  String get splash_app_init_timeout {
    return Intl.message(
      '✗ appModel.initApp() timeout (10s)',
      name: 'splash_app_init_timeout',
      desc: '',
      args: [],
    );
  }

  /// `✓ appModel.initApp() completed`
  String get splash_app_init_done {
    return Intl.message(
      '✓ appModel.initApp() completed',
      name: 'splash_app_init_done',
      desc: '',
      args: [],
    );
  }

  /// `✗ appModel.initApp() error: {v0}`
  String splash_app_init_error(Object v0) {
    return Intl.message(
      '✗ appModel.initApp() error: $v0',
      name: 'splash_app_init_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Opening Hive app_conf box...`
  String get splash_open_hive_box {
    return Intl.message(
      'Opening Hive app_conf box...',
      name: 'splash_open_hive_box',
      desc: '',
      args: [],
    );
  }

  /// `✗ Hive.openBox("app_conf") timeout (10s)`
  String get splash_hive_timeout {
    return Intl.message(
      '✗ Hive.openBox("app_conf") timeout (10s)',
      name: 'splash_hive_timeout',
      desc: '',
      args: [],
    );
  }

  /// `✓ Hive.openBox("app_conf") completed`
  String get splash_hive_done {
    return Intl.message(
      '✓ Hive.openBox("app_conf") completed',
      name: 'splash_hive_done',
      desc: '',
      args: [],
    );
  }

  /// `✗ Hive.openBox("app_conf") error: {v0}`
  String splash_hive_error(Object v0) {
    return Intl.message(
      '✗ Hive.openBox("app_conf") error: $v0',
      name: 'splash_hive_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Checking splash_alert_info_version...`
  String get splash_check_version {
    return Intl.message(
      'Checking splash_alert_info_version...',
      name: 'splash_check_version',
      desc: '',
      args: [],
    );
  }

  /// `Executing AnalyticsApi.touch("launch")...`
  String get splash_exec_analytics {
    return Intl.message(
      'Executing AnalyticsApi.touch("launch")...',
      name: 'splash_exec_analytics',
      desc: '',
      args: [],
    );
  }

  /// `⚠ AnalyticsApi.touch() timeout (10s) - continuing`
  String get splash_analytics_timeout {
    return Intl.message(
      '⚠ AnalyticsApi.touch() timeout (10s) - continuing',
      name: 'splash_analytics_timeout',
      desc: '',
      args: [],
    );
  }

  /// `✓ AnalyticsApi.touch("launch") completed`
  String get splash_analytics_done {
    return Intl.message(
      '✓ AnalyticsApi.touch("launch") completed',
      name: 'splash_analytics_done',
      desc: '',
      args: [],
    );
  }

  /// `⚠ AnalyticsApi.touch("launch") error: {v0} - continuing`
  String splash_analytics_error(Object v0) {
    return Intl.message(
      '⚠ AnalyticsApi.touch("launch") error: $v0 - continuing',
      name: 'splash_analytics_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Need to show user agreement dialog...`
  String get splash_show_agreement {
    return Intl.message(
      'Need to show user agreement dialog...',
      name: 'splash_show_agreement',
      desc: '',
      args: [],
    );
  }

  /// `✗ Context unmounted, cannot show dialog`
  String get splash_context_unmounted_dialog {
    return Intl.message(
      '✗ Context unmounted, cannot show dialog',
      name: 'splash_context_unmounted_dialog',
      desc: '',
      args: [],
    );
  }

  /// `✓ User agreement dialog handled`
  String get splash_agreement_handled {
    return Intl.message(
      '✓ User agreement dialog handled',
      name: 'splash_agreement_handled',
      desc: '',
      args: [],
    );
  }

  /// `Executing URLConf.checkHost()...`
  String get splash_exec_check_host {
    return Intl.message(
      'Executing URLConf.checkHost()...',
      name: 'splash_exec_check_host',
      desc: '',
      args: [],
    );
  }

  /// `⚠ URLConf.checkHost() timeout (10s) - continuing`
  String get splash_check_host_timeout {
    return Intl.message(
      '⚠ URLConf.checkHost() timeout (10s) - continuing',
      name: 'splash_check_host_timeout',
      desc: '',
      args: [],
    );
  }

  /// `✓ URLConf.checkHost() completed`
  String get splash_check_host_done {
    return Intl.message(
      '✓ URLConf.checkHost() completed',
      name: 'splash_check_host_done',
      desc: '',
      args: [],
    );
  }

  /// `⚠ URLConf.checkHost() error: {v0} - continuing`
  String splash_check_host_error(Object v0) {
    return Intl.message(
      '⚠ URLConf.checkHost() error: $v0 - continuing',
      name: 'splash_check_host_error',
      desc: '',
      args: [v0],
    );
  }

  /// `--- Step 0 complete, entering Step 1 ---`
  String get splash_step0_done {
    return Intl.message(
      '--- Step 0 complete, entering Step 1 ---',
      name: 'splash_step0_done',
      desc: '',
      args: [],
    );
  }

  /// `✗ Context unmounted`
  String get splash_context_unmounted {
    return Intl.message(
      '✗ Context unmounted',
      name: 'splash_context_unmounted',
      desc: '',
      args: [],
    );
  }

  /// `Executing appModel.checkUpdate()...`
  String get splash_exec_check_update {
    return Intl.message(
      'Executing appModel.checkUpdate()...',
      name: 'splash_exec_check_update',
      desc: '',
      args: [],
    );
  }

  /// `⚠ appModel.checkUpdate() timeout (10s) - continuing`
  String get splash_check_update_timeout {
    return Intl.message(
      '⚠ appModel.checkUpdate() timeout (10s) - continuing',
      name: 'splash_check_update_timeout',
      desc: '',
      args: [],
    );
  }

  /// `✓ appModel.checkUpdate() completed`
  String get splash_check_update_done {
    return Intl.message(
      '✓ appModel.checkUpdate() completed',
      name: 'splash_check_update_done',
      desc: '',
      args: [],
    );
  }

  /// `⚠ appModel.checkUpdate() error: {v0} - continuing`
  String splash_check_update_error(Object v0) {
    return Intl.message(
      '⚠ appModel.checkUpdate() error: $v0 - continuing',
      name: 'splash_check_update_error',
      desc: '',
      args: [v0],
    );
  }

  /// `--- Step 1 complete, entering Step 2 ---`
  String get splash_step1_done {
    return Intl.message(
      '--- Step 1 complete, entering Step 2 ---',
      name: 'splash_step1_done',
      desc: '',
      args: [],
    );
  }

  /// `Initializing aria2cModelProvider...`
  String get splash_init_aria2c {
    return Intl.message(
      'Initializing aria2cModelProvider...',
      name: 'splash_init_aria2c',
      desc: '',
      args: [],
    );
  }

  /// `✓ aria2cModelProvider initialization complete`
  String get splash_aria2c_done {
    return Intl.message(
      '✓ aria2cModelProvider initialization complete',
      name: 'splash_aria2c_done',
      desc: '',
      args: [],
    );
  }

  /// `⚠ aria2cModelProvider initialization error: {v0}`
  String splash_aria2c_error(Object v0) {
    return Intl.message(
      '⚠ aria2cModelProvider initialization error: $v0',
      name: 'splash_aria2c_error',
      desc: '',
      args: [v0],
    );
  }

  /// `✗ Context unmounted, cannot navigate`
  String get splash_context_unmounted_nav {
    return Intl.message(
      '✗ Context unmounted, cannot navigate',
      name: 'splash_context_unmounted_nav',
      desc: '',
      args: [],
    );
  }

  /// `✓ All initialization complete, ready to navigate to main interface`
  String get splash_all_done {
    return Intl.message(
      '✓ All initialization complete, ready to navigate to main interface',
      name: 'splash_all_done',
      desc: '',
      args: [],
    );
  }

  /// `✗ Context unmounted, cannot jump`
  String get splash_context_unmounted_jump {
    return Intl.message(
      '✗ Context unmounted, cannot jump',
      name: 'splash_context_unmounted_jump',
      desc: '',
      args: [],
    );
  }

  /// `[{v0}] ⚠ Log file does not exist`
  String splash_log_not_exist(Object v0) {
    return Intl.message(
      '[$v0] ⚠ Log file does not exist',
      name: 'splash_log_not_exist',
      desc: '',
      args: [v0],
    );
  }

  /// `[{v0}] --- Starting to read full log file ---`
  String splash_start_read_log(Object v0) {
    return Intl.message(
      '[$v0] --- Starting to read full log file ---',
      name: 'splash_start_read_log',
      desc: '',
      args: [v0],
    );
  }

  /// `[{v0}] --- Log reading complete (showing last 1000 lines) ---`
  String splash_log_read_done(Object v0) {
    return Intl.message(
      '[$v0] --- Log reading complete (showing last 1000 lines) ---',
      name: 'splash_log_read_done',
      desc: '',
      args: [v0],
    );
  }

  /// `[{v0}] ✗ Failed to read log: {v1}`
  String splash_read_log_failed(Object v0, Object v1) {
    return Intl.message(
      '[$v0] ✗ Failed to read log: $v1',
      name: 'splash_read_log_failed',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `[Diagnostic] User requested database reset`
  String get splash_user_reset_db {
    return Intl.message(
      '[Diagnostic] User requested database reset',
      name: 'splash_user_reset_db',
      desc: '',
      args: [],
    );
  }

  /// `[Diagnostic] Hive boxes closed`
  String get splash_hive_boxes_closed {
    return Intl.message(
      '[Diagnostic] Hive boxes closed',
      name: 'splash_hive_boxes_closed',
      desc: '',
      args: [],
    );
  }

  /// `[Diagnostic] Failed to close Hive boxes: {v0}`
  String splash_close_hive_failed(Object v0) {
    return Intl.message(
      '[Diagnostic] Failed to close Hive boxes: $v0',
      name: 'splash_close_hive_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `[Diagnostic] Deleting database directory: {v0}`
  String splash_deleting_db(Object v0) {
    return Intl.message(
      '[Diagnostic] Deleting database directory: $v0',
      name: 'splash_deleting_db',
      desc: '',
      args: [v0],
    );
  }

  /// `[Diagnostic] Database directory deleted`
  String get splash_db_deleted {
    return Intl.message(
      '[Diagnostic] Database directory deleted',
      name: 'splash_db_deleted',
      desc: '',
      args: [],
    );
  }

  /// `[Diagnostic] Database directory does not exist: {v0}`
  String splash_db_not_exist(Object v0) {
    return Intl.message(
      '[Diagnostic] Database directory does not exist: $v0',
      name: 'splash_db_not_exist',
      desc: '',
      args: [v0],
    );
  }

  /// `[Diagnostic] Database reset complete, preparing to exit application`
  String get splash_db_reset_done {
    return Intl.message(
      '[Diagnostic] Database reset complete, preparing to exit application',
      name: 'splash_db_reset_done',
      desc: '',
      args: [],
    );
  }

  /// `Database has been reset, application will exit. Please restart the application.`
  String get splash_db_reset_msg {
    return Intl.message(
      'Database has been reset, application will exit. Please restart the application.',
      name: 'splash_db_reset_msg',
      desc: '',
      args: [],
    );
  }

  /// `[Diagnostic] Failed to reset database: {v0}`
  String splash_reset_db_failed(Object v0) {
    return Intl.message(
      '[Diagnostic] Failed to reset database: $v0',
      name: 'splash_reset_db_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Search files (supports regex)...`
  String get tools_unp4k_search_placeholder {
    return Intl.message(
      'Search files (supports regex)...',
      name: 'tools_unp4k_search_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Default Sort`
  String get tools_unp4k_sort_default {
    return Intl.message(
      'Default Sort',
      name: 'tools_unp4k_sort_default',
      desc: '',
      args: [],
    );
  }

  /// `Smaller First`
  String get tools_unp4k_sort_size_asc {
    return Intl.message(
      'Smaller First',
      name: 'tools_unp4k_sort_size_asc',
      desc: '',
      args: [],
    );
  }

  /// `Larger First`
  String get tools_unp4k_sort_size_desc {
    return Intl.message(
      'Larger First',
      name: 'tools_unp4k_sort_size_desc',
      desc: '',
      args: [],
    );
  }

  /// `Older First`
  String get tools_unp4k_sort_date_asc {
    return Intl.message(
      'Older First',
      name: 'tools_unp4k_sort_date_asc',
      desc: '',
      args: [],
    );
  }

  /// `Newer First`
  String get tools_unp4k_sort_date_desc {
    return Intl.message(
      'Newer First',
      name: 'tools_unp4k_sort_date_desc',
      desc: '',
      args: [],
    );
  }

  /// `Save As...`
  String get tools_unp4k_action_save_as {
    return Intl.message(
      'Save As...',
      name: 'tools_unp4k_action_save_as',
      desc: '',
      args: [],
    );
  }

  /// `Extracting: {v0}`
  String tools_unp4k_action_extracting(Object v0) {
    return Intl.message(
      'Extracting: $v0',
      name: 'tools_unp4k_action_extracting',
      desc: '',
      args: [v0],
    );
  }

  /// `Extraction complete: {v0}`
  String tools_unp4k_action_extract_success(Object v0) {
    return Intl.message(
      'Extraction complete: $v0',
      name: 'tools_unp4k_action_extract_success',
      desc: '',
      args: [v0],
    );
  }

  /// `Extraction failed: {v0}`
  String tools_unp4k_action_extract_failed(Object v0) {
    return Intl.message(
      'Extraction failed: $v0',
      name: 'tools_unp4k_action_extract_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `No matching files found`
  String get tools_unp4k_search_no_result {
    return Intl.message(
      'No matching files found',
      name: 'tools_unp4k_search_no_result',
      desc: '',
      args: [],
    );
  }

  /// `Searching...`
  String get tools_unp4k_searching {
    return Intl.message(
      'Searching...',
      name: 'tools_unp4k_searching',
      desc: '',
      args: [],
    );
  }

  /// `Extract Files`
  String get tools_unp4k_extract_dialog_title {
    return Intl.message(
      'Extract Files',
      name: 'tools_unp4k_extract_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Extracting ({v0}/{v1})`
  String tools_unp4k_extract_progress(Object v0, Object v1) {
    return Intl.message(
      'Extracting ($v0/$v1)',
      name: 'tools_unp4k_extract_progress',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Current file: {v0}`
  String tools_unp4k_extract_current_file(Object v0) {
    return Intl.message(
      'Current file: $v0',
      name: 'tools_unp4k_extract_current_file',
      desc: '',
      args: [v0],
    );
  }

  /// `Extraction cancelled`
  String get tools_unp4k_extract_cancelled {
    return Intl.message(
      'Extraction cancelled',
      name: 'tools_unp4k_extract_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Extraction completed, {v0} files total`
  String tools_unp4k_extract_completed(Object v0) {
    return Intl.message(
      'Extraction completed, $v0 files total',
      name: 'tools_unp4k_extract_completed',
      desc: '',
      args: [v0],
    );
  }

  /// `Multi-Select`
  String get tools_unp4k_action_multi_select {
    return Intl.message(
      'Multi-Select',
      name: 'tools_unp4k_action_multi_select',
      desc: '',
      args: [],
    );
  }

  /// `Export Selected ({v0})`
  String tools_unp4k_action_export_selected(Object v0) {
    return Intl.message(
      'Export Selected ($v0)',
      name: 'tools_unp4k_action_export_selected',
      desc: '',
      args: [v0],
    );
  }

  /// `Cancel Multi-Select`
  String get tools_unp4k_action_cancel_multi_select {
    return Intl.message(
      'Cancel Multi-Select',
      name: 'tools_unp4k_action_cancel_multi_select',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get tools_unp4k_action_select_all {
    return Intl.message(
      'Select All',
      name: 'tools_unp4k_action_select_all',
      desc: '',
      args: [],
    );
  }

  /// `Deselect All`
  String get tools_unp4k_action_deselect_all {
    return Intl.message(
      'Deselect All',
      name: 'tools_unp4k_action_deselect_all',
      desc: '',
      args: [],
    );
  }

  /// `DataForge Viewer -> {v0}`
  String dcb_viewer_title(Object v0) {
    return Intl.message(
      'DataForge Viewer -> $v0',
      name: 'dcb_viewer_title',
      desc: '',
      args: [v0],
    );
  }

  /// `Loading DCB file...`
  String get dcb_viewer_loading {
    return Intl.message(
      'Loading DCB file...',
      name: 'dcb_viewer_loading',
      desc: '',
      args: [],
    );
  }

  /// `Parsing DataForge data...`
  String get dcb_viewer_parsing {
    return Intl.message(
      'Parsing DataForge data...',
      name: 'dcb_viewer_parsing',
      desc: '',
      args: [],
    );
  }

  /// `Loading record list...`
  String get dcb_viewer_loading_records {
    return Intl.message(
      'Loading record list...',
      name: 'dcb_viewer_loading_records',
      desc: '',
      args: [],
    );
  }

  /// `{v0} records loaded`
  String dcb_viewer_loaded_records(Object v0) {
    return Intl.message(
      '$v0 records loaded',
      name: 'dcb_viewer_loaded_records',
      desc: '',
      args: [v0],
    );
  }

  /// `Invalid DCB file format`
  String get dcb_viewer_error_not_dcb {
    return Intl.message(
      'Invalid DCB file format',
      name: 'dcb_viewer_error_not_dcb',
      desc: '',
      args: [],
    );
  }

  /// `Search Mode`
  String get dcb_viewer_search_mode {
    return Intl.message(
      'Search Mode',
      name: 'dcb_viewer_search_mode',
      desc: '',
      args: [],
    );
  }

  /// `Searching...`
  String get dcb_viewer_searching {
    return Intl.message(
      'Searching...',
      name: 'dcb_viewer_searching',
      desc: '',
      args: [],
    );
  }

  /// `{v0} results found`
  String dcb_viewer_search_results(Object v0) {
    return Intl.message(
      '$v0 results found',
      name: 'dcb_viewer_search_results',
      desc: '',
      args: [v0],
    );
  }

  /// `Full text search (press Enter)...`
  String get dcb_viewer_search_fulltext_placeholder {
    return Intl.message(
      'Full text search (press Enter)...',
      name: 'dcb_viewer_search_fulltext_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Filter record paths...`
  String get dcb_viewer_search_list_placeholder {
    return Intl.message(
      'Filter record paths...',
      name: 'dcb_viewer_search_list_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Search in current file...`
  String get dcb_viewer_search_in_file {
    return Intl.message(
      'Search in current file...',
      name: 'dcb_viewer_search_in_file',
      desc: '',
      args: [],
    );
  }

  /// `No results`
  String get dcb_viewer_search_no_results {
    return Intl.message(
      'No results',
      name: 'dcb_viewer_search_no_results',
      desc: '',
      args: [],
    );
  }

  /// `Match Case`
  String get dcb_viewer_search_case_sensitive {
    return Intl.message(
      'Match Case',
      name: 'dcb_viewer_search_case_sensitive',
      desc: '',
      args: [],
    );
  }

  /// `Use Regular Expression`
  String get dcb_viewer_search_regex {
    return Intl.message(
      'Use Regular Expression',
      name: 'dcb_viewer_search_regex',
      desc: '',
      args: [],
    );
  }

  /// `Fold/Unfold Code Blocks`
  String get dcb_viewer_fold_all {
    return Intl.message(
      'Fold/Unfold Code Blocks',
      name: 'dcb_viewer_fold_all',
      desc: '',
      args: [],
    );
  }

  /// `No records`
  String get dcb_viewer_no_records {
    return Intl.message(
      'No records',
      name: 'dcb_viewer_no_records',
      desc: '',
      args: [],
    );
  }

  /// `No search results`
  String get dcb_viewer_no_search_results {
    return Intl.message(
      'No search results',
      name: 'dcb_viewer_no_search_results',
      desc: '',
      args: [],
    );
  }

  /// `Select a record to view XML content`
  String get dcb_viewer_select_record {
    return Intl.message(
      'Select a record to view XML content',
      name: 'dcb_viewer_select_record',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get dcb_viewer_export {
    return Intl.message(
      'Export',
      name: 'dcb_viewer_export',
      desc: '',
      args: [],
    );
  }

  /// `Export as single XML`
  String get dcb_viewer_export_single_xml {
    return Intl.message(
      'Export as single XML',
      name: 'dcb_viewer_export_single_xml',
      desc: '',
      args: [],
    );
  }

  /// `Export as multiple XML files`
  String get dcb_viewer_export_multiple_xml {
    return Intl.message(
      'Export as multiple XML files',
      name: 'dcb_viewer_export_multiple_xml',
      desc: '',
      args: [],
    );
  }

  /// `Export successful`
  String get dcb_viewer_export_success {
    return Intl.message(
      'Export successful',
      name: 'dcb_viewer_export_success',
      desc: '',
      args: [],
    );
  }

  /// `Export failed`
  String get dcb_viewer_export_failed {
    return Intl.message(
      'Export failed',
      name: 'dcb_viewer_export_failed',
      desc: '',
      args: [],
    );
  }

  /// `DataForge Viewer`
  String get dcb_viewer_title_standalone {
    return Intl.message(
      'DataForge Viewer',
      name: 'dcb_viewer_title_standalone',
      desc: '',
      args: [],
    );
  }

  /// `Select DCB File`
  String get dcb_viewer_select_file_title {
    return Intl.message(
      'Select DCB File',
      name: 'dcb_viewer_select_file_title',
      desc: '',
      args: [],
    );
  }

  /// `Please select a .dcb file or DCB file extracted from P4K`
  String get dcb_viewer_select_file_description {
    return Intl.message(
      'Please select a .dcb file or DCB file extracted from P4K',
      name: 'dcb_viewer_select_file_description',
      desc: '',
      args: [],
    );
  }

  /// `Select DCB File`
  String get dcb_viewer_select_dcb_file {
    return Intl.message(
      'Select DCB File',
      name: 'dcb_viewer_select_dcb_file',
      desc: '',
      args: [],
    );
  }

  /// `Select P4K File`
  String get dcb_viewer_select_p4k_file {
    return Intl.message(
      'Select P4K File',
      name: 'dcb_viewer_select_p4k_file',
      desc: '',
      args: [],
    );
  }

  /// `Select Another File`
  String get dcb_viewer_select_another_file {
    return Intl.message(
      'Select Another File',
      name: 'dcb_viewer_select_another_file',
      desc: '',
      args: [],
    );
  }

  /// `DCB/DataForge Viewer`
  String get tools_action_dcb_viewer {
    return Intl.message(
      'DCB/DataForge Viewer',
      name: 'tools_action_dcb_viewer',
      desc: '',
      args: [],
    );
  }

  /// `View and export DataForge game database (.dcb) file content`
  String get tools_action_dcb_viewer_info {
    return Intl.message(
      'View and export DataForge game database (.dcb) file content',
      name: 'tools_action_dcb_viewer_info',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get action_back {
    return Intl.message('Back', name: 'action_back', desc: '', args: []);
  }

  /// `Switch DirectX/Vulkan Renderer`
  String get tools_action_switch_graphics_renderer {
    return Intl.message(
      'Switch DirectX/Vulkan Renderer',
      name: 'tools_action_switch_graphics_renderer',
      desc: '',
      args: [],
    );
  }

  /// `Current Renderer: {v0}`
  String tools_action_switch_graphics_renderer_info(Object v0) {
    return Intl.message(
      'Current Renderer: $v0',
      name: 'tools_action_switch_graphics_renderer_info',
      desc: '',
      args: [v0],
    );
  }

  /// `DirectX 11`
  String get tools_graphics_renderer_dx11 {
    return Intl.message(
      'DirectX 11',
      name: 'tools_graphics_renderer_dx11',
      desc: '',
      args: [],
    );
  }

  /// `Vulkan`
  String get tools_graphics_renderer_vulkan {
    return Intl.message(
      'Vulkan',
      name: 'tools_graphics_renderer_vulkan',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get tools_graphics_renderer_unknown {
    return Intl.message(
      'Unknown',
      name: 'tools_graphics_renderer_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Switch Graphics Renderer`
  String get tools_graphics_renderer_dialog_title {
    return Intl.message(
      'Switch Graphics Renderer',
      name: 'tools_graphics_renderer_dialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Version Code`
  String get tools_graphics_renderer_dialog_version {
    return Intl.message(
      'Version Code',
      name: 'tools_graphics_renderer_dialog_version',
      desc: '',
      args: [],
    );
  }

  /// `Select or enter version code`
  String get tools_graphics_renderer_dialog_version_hint {
    return Intl.message(
      'Select or enter version code',
      name: 'tools_graphics_renderer_dialog_version_hint',
      desc: '',
      args: [],
    );
  }

  /// `Renderer`
  String get tools_graphics_renderer_dialog_renderer {
    return Intl.message(
      'Renderer',
      name: 'tools_graphics_renderer_dialog_renderer',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get tools_graphics_renderer_dialog_save {
    return Intl.message(
      'Save',
      name: 'tools_graphics_renderer_dialog_save',
      desc: '',
      args: [],
    );
  }

  /// `Renderer settings saved`
  String get tools_graphics_renderer_dialog_save_success {
    return Intl.message(
      'Renderer settings saved',
      name: 'tools_graphics_renderer_dialog_save_success',
      desc: '',
      args: [],
    );
  }

  /// `Save failed: {v0}`
  String tools_graphics_renderer_dialog_save_failed(Object v0) {
    return Intl.message(
      'Save failed: $v0',
      name: 'tools_graphics_renderer_dialog_save_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Version code not found. Please enter it manually. (If you are unfamiliar with this, please ask other players for help.)`
  String get tools_graphics_renderer_dialog_no_version {
    return Intl.message(
      'Version code not found. Please enter it manually. (If you are unfamiliar with this, please ask other players for help.)',
      name: 'tools_graphics_renderer_dialog_no_version',
      desc: '',
      args: [],
    );
  }

  /// `Star Citizen {year} Yearly Report`
  String yearly_report_title(Object year) {
    return Intl.message(
      'Star Citizen $year Yearly Report',
      name: 'yearly_report_title',
      desc: '',
      args: [year],
    );
  }

  /// `Generating your yearly report...`
  String get yearly_report_generating {
    return Intl.message(
      'Generating your yearly report...',
      name: 'yearly_report_generating',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing game log data`
  String get yearly_report_analyzing_logs {
    return Intl.message(
      'Analyzing game log data',
      name: 'yearly_report_analyzing_logs',
      desc: '',
      args: [],
    );
  }

  /// `Unable to generate yearly report`
  String get yearly_report_error_title {
    return Intl.message(
      'Unable to generate yearly report',
      name: 'yearly_report_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure the game directory is correct and log files exist`
  String get yearly_report_error_description {
    return Intl.message(
      'Please ensure the game directory is correct and log files exist',
      name: 'yearly_report_error_description',
      desc: '',
      args: [],
    );
  }

  /// `Previous Page`
  String get yearly_report_nav_prev {
    return Intl.message(
      'Previous Page',
      name: 'yearly_report_nav_prev',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get yearly_report_nav_next {
    return Intl.message(
      'Continue',
      name: 'yearly_report_nav_next',
      desc: '',
      args: [],
    );
  }

  /// `{year} Yearly Report`
  String yearly_report_welcome_title(Object year) {
    return Intl.message(
      '$year Yearly Report',
      name: 'yearly_report_welcome_title',
      desc: '',
      args: [year],
    );
  }

  /// `Relive your memorable moments in Star Citizen`
  String get yearly_report_welcome_subtitle {
    return Intl.message(
      'Relive your memorable moments in Star Citizen',
      name: 'yearly_report_welcome_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Scroll down or click the button below to start`
  String get yearly_report_welcome_hint {
    return Intl.message(
      'Scroll down or click the button below to start',
      name: 'yearly_report_welcome_hint',
      desc: '',
      args: [],
    );
  }

  /// `Game Launch Count`
  String get yearly_report_launch_count_title {
    return Intl.message(
      'Game Launch Count',
      name: 'yearly_report_launch_count_title',
      desc: '',
      args: [],
    );
  }

  /// `This year you launched the game`
  String get yearly_report_launch_count_desc {
    return Intl.message(
      'This year you launched the game',
      name: 'yearly_report_launch_count_desc',
      desc: '',
      args: [],
    );
  }

  /// `Total Launches`
  String get yearly_report_launch_count_label {
    return Intl.message(
      'Total Launches',
      name: 'yearly_report_launch_count_label',
      desc: '',
      args: [],
    );
  }

  /// `{v0} times`
  String yearly_report_launch_count_value(Object v0) {
    return Intl.message(
      '$v0 times',
      name: 'yearly_report_launch_count_value',
      desc: '',
      args: [v0],
    );
  }

  /// `Play Time`
  String get yearly_report_play_time_title {
    return Intl.message(
      'Play Time',
      name: 'yearly_report_play_time_title',
      desc: '',
      args: [],
    );
  }

  /// `This year you explored the universe for`
  String get yearly_report_play_time_desc {
    return Intl.message(
      'This year you explored the universe for',
      name: 'yearly_report_play_time_desc',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get yearly_report_play_time_unit {
    return Intl.message(
      'hours',
      name: 'yearly_report_play_time_unit',
      desc: '',
      args: [],
    );
  }

  /// `Total Playtime`
  String get yearly_report_play_time_label {
    return Intl.message(
      'Total Playtime',
      name: 'yearly_report_play_time_label',
      desc: '',
      args: [],
    );
  }

  /// `{v0} hours`
  String yearly_report_play_time_value(Object v0) {
    return Intl.message(
      '$v0 hours',
      name: 'yearly_report_play_time_value',
      desc: '',
      args: [v0],
    );
  }

  /// `Game Crash Count`
  String get yearly_report_crash_title {
    return Intl.message(
      'Game Crash Count',
      name: 'yearly_report_crash_title',
      desc: '',
      args: [],
    );
  }

  /// `Unstable moments this year`
  String get yearly_report_crash_desc {
    return Intl.message(
      'Unstable moments this year',
      name: 'yearly_report_crash_desc',
      desc: '',
      args: [],
    );
  }

  /// `Total Crashes`
  String get yearly_report_crash_label {
    return Intl.message(
      'Total Crashes',
      name: 'yearly_report_crash_label',
      desc: '',
      args: [],
    );
  }

  /// `Hope it's more stable next year!`
  String get yearly_report_crash_note_high {
    return Intl.message(
      'Hope it\'s more stable next year!',
      name: 'yearly_report_crash_note_high',
      desc: '',
      args: [],
    );
  }

  /// `Lucky you!`
  String get yearly_report_crash_note_low {
    return Intl.message(
      'Lucky you!',
      name: 'yearly_report_crash_note_low',
      desc: '',
      args: [],
    );
  }

  /// `Kill Statistics`
  String get yearly_report_kd_title {
    return Intl.message(
      'Kill Statistics',
      name: 'yearly_report_kd_title',
      desc: '',
      args: [],
    );
  }

  /// `Kills`
  String get yearly_report_kd_kill {
    return Intl.message(
      'Kills',
      name: 'yearly_report_kd_kill',
      desc: '',
      args: [],
    );
  }

  /// `Deaths`
  String get yearly_report_kd_death {
    return Intl.message(
      'Deaths',
      name: 'yearly_report_kd_death',
      desc: '',
      args: [],
    );
  }

  /// `Suicides`
  String get yearly_report_kd_suicide {
    return Intl.message(
      'Suicides',
      name: 'yearly_report_kd_suicide',
      desc: '',
      args: [],
    );
  }

  /// `No kill/death records detected this year`
  String get yearly_report_kd_no_record {
    return Intl.message(
      'No kill/death records detected this year',
      name: 'yearly_report_kd_no_record',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get yearly_report_no_data {
    return Intl.message(
      'No data available',
      name: 'yearly_report_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Earliest Play Session`
  String get yearly_report_earliest_play_title {
    return Intl.message(
      'Earliest Play Session',
      name: 'yearly_report_earliest_play_title',
      desc: '',
      args: [],
    );
  }

  /// `You started your space journey at dawn on {v0}/{v1}`
  String yearly_report_earliest_play_desc(Object v0, Object v1) {
    return Intl.message(
      'You started your space journey at dawn on $v0/$v1',
      name: 'yearly_report_earliest_play_desc',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Latest Play Session`
  String get yearly_report_latest_play_title {
    return Intl.message(
      'Latest Play Session',
      name: 'yearly_report_latest_play_title',
      desc: '',
      args: [],
    );
  }

  /// `Late night on {v0}/{v1}, you were still exploring the universe`
  String yearly_report_latest_play_desc(Object v0, Object v1) {
    return Intl.message(
      'Late night on $v0/$v1, you were still exploring the universe',
      name: 'yearly_report_latest_play_desc',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Vehicle Destruction Statistics`
  String get yearly_report_vehicle_destruction_title {
    return Intl.message(
      'Vehicle Destruction Statistics',
      name: 'yearly_report_vehicle_destruction_title',
      desc: '',
      args: [],
    );
  }

  /// `This year you destroyed`
  String get yearly_report_vehicle_destruction_desc {
    return Intl.message(
      'This year you destroyed',
      name: 'yearly_report_vehicle_destruction_desc',
      desc: '',
      args: [],
    );
  }

  /// `ships`
  String get yearly_report_vehicle_destruction_unit {
    return Intl.message(
      'ships',
      name: 'yearly_report_vehicle_destruction_unit',
      desc: '',
      args: [],
    );
  }

  /// `Most destroyed ship`
  String get yearly_report_vehicle_destruction_most {
    return Intl.message(
      'Most destroyed ship',
      name: 'yearly_report_vehicle_destruction_most',
      desc: '',
      args: [],
    );
  }

  /// `Destroyed {v0} times`
  String yearly_report_vehicle_destruction_count(Object v0) {
    return Intl.message(
      'Destroyed $v0 times',
      name: 'yearly_report_vehicle_destruction_count',
      desc: '',
      args: [v0],
    );
  }

  /// `Vehicle Piloting Statistics`
  String get yearly_report_vehicle_pilot_title {
    return Intl.message(
      'Vehicle Piloting Statistics',
      name: 'yearly_report_vehicle_pilot_title',
      desc: '',
      args: [],
    );
  }

  /// `Most piloted vehicle`
  String get yearly_report_vehicle_pilot_most {
    return Intl.message(
      'Most piloted vehicle',
      name: 'yearly_report_vehicle_pilot_most',
      desc: '',
      args: [],
    );
  }

  /// `Piloted {v0} times`
  String yearly_report_vehicle_pilot_count(Object v0) {
    return Intl.message(
      'Piloted $v0 times',
      name: 'yearly_report_vehicle_pilot_count',
      desc: '',
      args: [v0],
    );
  }

  /// `Collapse details`
  String get yearly_report_vehicle_pilot_collapse {
    return Intl.message(
      'Collapse details',
      name: 'yearly_report_vehicle_pilot_collapse',
      desc: '',
      args: [],
    );
  }

  /// `View all {v0} vehicles`
  String yearly_report_vehicle_pilot_expand(Object v0) {
    return Intl.message(
      'View all $v0 vehicles',
      name: 'yearly_report_vehicle_pilot_expand',
      desc: '',
      args: [v0],
    );
  }

  /// `Account Statistics`
  String get yearly_report_account_title {
    return Intl.message(
      'Account Statistics',
      name: 'yearly_report_account_title',
      desc: '',
      args: [],
    );
  }

  /// `Most used account`
  String get yearly_report_account_most {
    return Intl.message(
      'Most used account',
      name: 'yearly_report_account_most',
      desc: '',
      args: [],
    );
  }

  /// `Logged in {v0} times`
  String yearly_report_account_count(Object v0) {
    return Intl.message(
      'Logged in $v0 times',
      name: 'yearly_report_account_count',
      desc: '',
      args: [v0],
    );
  }

  /// `Detected {v0} accounts in total`
  String yearly_report_account_total(Object v0) {
    return Intl.message(
      'Detected $v0 accounts in total',
      name: 'yearly_report_account_total',
      desc: '',
      args: [v0],
    );
  }

  /// `View all accounts`
  String get yearly_report_account_expand {
    return Intl.message(
      'View all accounts',
      name: 'yearly_report_account_expand',
      desc: '',
      args: [],
    );
  }

  /// `{v0} hours {v1} minutes`
  String yearly_report_duration_hours_minutes(Object v0, Object v1) {
    return Intl.message(
      '$v0 hours $v1 minutes',
      name: 'yearly_report_duration_hours_minutes',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `{v0} minutes`
  String yearly_report_duration_minutes(Object v0) {
    return Intl.message(
      '$v0 minutes',
      name: 'yearly_report_duration_minutes',
      desc: '',
      args: [v0],
    );
  }

  /// `Session Time Details`
  String get yearly_report_session_title {
    return Intl.message(
      'Session Time Details',
      name: 'yearly_report_session_title',
      desc: '',
      args: [],
    );
  }

  /// `Average`
  String get yearly_report_session_average {
    return Intl.message(
      'Average',
      name: 'yearly_report_session_average',
      desc: '',
      args: [],
    );
  }

  /// `Longest`
  String get yearly_report_session_longest {
    return Intl.message(
      'Longest',
      name: 'yearly_report_session_longest',
      desc: '',
      args: [],
    );
  }

  /// `{v0}/{v1}`
  String yearly_report_session_date(Object v0, Object v1) {
    return Intl.message(
      '$v0/$v1',
      name: 'yearly_report_session_date',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Shortest`
  String get yearly_report_session_shortest {
    return Intl.message(
      'Shortest',
      name: 'yearly_report_session_shortest',
      desc: '',
      args: [],
    );
  }

  /// `(Shortest only counts sessions over 5 minutes)`
  String get yearly_report_session_note {
    return Intl.message(
      '(Shortest only counts sessions over 5 minutes)',
      name: 'yearly_report_session_note',
      desc: '',
      args: [],
    );
  }

  /// `Month {v0}`
  String yearly_report_month_format(Object v0) {
    return Intl.message(
      'Month $v0',
      name: 'yearly_report_month_format',
      desc: '',
      args: [v0],
    );
  }

  /// `Monthly Statistics`
  String get yearly_report_monthly_title {
    return Intl.message(
      'Monthly Statistics',
      name: 'yearly_report_monthly_title',
      desc: '',
      args: [],
    );
  }

  /// `Most played`
  String get yearly_report_monthly_most {
    return Intl.message(
      'Most played',
      name: 'yearly_report_monthly_most',
      desc: '',
      args: [],
    );
  }

  /// `Launched {v0} times`
  String yearly_report_monthly_most_count(Object v0) {
    return Intl.message(
      'Launched $v0 times',
      name: 'yearly_report_monthly_most_count',
      desc: '',
      args: [v0],
    );
  }

  /// `Least played`
  String get yearly_report_monthly_least {
    return Intl.message(
      'Least played',
      name: 'yearly_report_monthly_least',
      desc: '',
      args: [],
    );
  }

  /// `Only launched {v0} times`
  String yearly_report_monthly_least_count(Object v0) {
    return Intl.message(
      'Only launched $v0 times',
      name: 'yearly_report_monthly_least_count',
      desc: '',
      args: [v0],
    );
  }

  /// `{v0}/{v1} - {v2}/{v3}`
  String yearly_report_date_range(Object v0, Object v1, Object v2, Object v3) {
    return Intl.message(
      '$v0/$v1 - $v2/$v3',
      name: 'yearly_report_date_range',
      desc: '',
      args: [v0, v1, v2, v3],
    );
  }

  /// `Streak Records`
  String get yearly_report_streak_title {
    return Intl.message(
      'Streak Records',
      name: 'yearly_report_streak_title',
      desc: '',
      args: [],
    );
  }

  /// `Consecutive Play`
  String get yearly_report_streak_play {
    return Intl.message(
      'Consecutive Play',
      name: 'yearly_report_streak_play',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get yearly_report_streak_day_unit {
    return Intl.message(
      'days',
      name: 'yearly_report_streak_day_unit',
      desc: '',
      args: [],
    );
  }

  /// `Consecutive Offline`
  String get yearly_report_streak_offline {
    return Intl.message(
      'Consecutive Offline',
      name: 'yearly_report_streak_offline',
      desc: '',
      args: [],
    );
  }

  /// `Location Statistics`
  String get yearly_report_location_title {
    return Intl.message(
      'Location Statistics',
      name: 'yearly_report_location_title',
      desc: '',
      args: [],
    );
  }

  /// `No location visit records`
  String get yearly_report_location_no_record {
    return Intl.message(
      'No location visit records',
      name: 'yearly_report_location_no_record',
      desc: '',
      args: [],
    );
  }

  /// `Frequent Locations`
  String get yearly_report_location_frequent {
    return Intl.message(
      'Frequent Locations',
      name: 'yearly_report_location_frequent',
      desc: '',
      args: [],
    );
  }

  /// `Based on inventory viewing records`
  String get yearly_report_location_note {
    return Intl.message(
      'Based on inventory viewing records',
      name: 'yearly_report_location_note',
      desc: '',
      args: [],
    );
  }

  /// `Thank You for Being With Us`
  String get yearly_report_thanks_title {
    return Intl.message(
      'Thank You for Being With Us',
      name: 'yearly_report_thanks_title',
      desc: '',
      args: [],
    );
  }

  /// `In {year}, together we created\ncountless wonderful memories in Star Citizen`
  String yearly_report_thanks_message(Object year) {
    return Intl.message(
      'In $year, together we created\\ncountless wonderful memories in Star Citizen',
      name: 'yearly_report_thanks_message',
      desc: '',
      args: [year],
    );
  }

  /// `Looking forward to {nextYear} with you!`
  String yearly_report_thanks_next(Object nextYear) {
    return Intl.message(
      'Looking forward to $nextYear with you!',
      name: 'yearly_report_thanks_next',
      desc: '',
      args: [nextYear],
    );
  }

  /// `Launch Game`
  String get yearly_report_summary_launch_game {
    return Intl.message(
      'Launch Game',
      name: 'yearly_report_summary_launch_game',
      desc: '',
      args: [],
    );
  }

  /// `Longest Online`
  String get yearly_report_summary_longest_online {
    return Intl.message(
      'Longest Online',
      name: 'yearly_report_summary_longest_online',
      desc: '',
      args: [],
    );
  }

  /// `Earliest Time`
  String get yearly_report_summary_earliest_time {
    return Intl.message(
      'Earliest Time',
      name: 'yearly_report_summary_earliest_time',
      desc: '',
      args: [],
    );
  }

  /// `Latest Time`
  String get yearly_report_summary_latest_time {
    return Intl.message(
      'Latest Time',
      name: 'yearly_report_summary_latest_time',
      desc: '',
      args: [],
    );
  }

  /// `Respawn Count`
  String get yearly_report_summary_respawn_count {
    return Intl.message(
      'Respawn Count',
      name: 'yearly_report_summary_respawn_count',
      desc: '',
      args: [],
    );
  }

  /// `Hottest Month`
  String get yearly_report_summary_hottest_month {
    return Intl.message(
      'Hottest Month',
      name: 'yearly_report_summary_hottest_month',
      desc: '',
      args: [],
    );
  }

  /// `Frequent Location`
  String get yearly_report_summary_frequent_location {
    return Intl.message(
      'Frequent Location',
      name: 'yearly_report_summary_frequent_location',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Vehicle`
  String get yearly_report_summary_favorite_vehicle {
    return Intl.message(
      'Favorite Vehicle',
      name: 'yearly_report_summary_favorite_vehicle',
      desc: '',
      args: [],
    );
  }

  /// `Presented by SCToolbox`
  String get yearly_report_powered_by {
    return Intl.message(
      'Presented by SCToolbox',
      name: 'yearly_report_powered_by',
      desc: '',
      args: [],
    );
  }

  /// `Data is generated from your local logs and will not be sent to any third party. Due to significant log changes across versions, data may be incomplete. For entertainment purposes only.`
  String get yearly_report_disclaimer {
    return Intl.message(
      'Data is generated from your local logs and will not be sent to any third party. Due to significant log changes across versions, data may be incomplete. For entertainment purposes only.',
      name: 'yearly_report_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `{year} Yearly Report (Limited Time)`
  String yearly_report_card_title(Object year) {
    return Intl.message(
      '$year Yearly Report (Limited Time)',
      name: 'yearly_report_card_title',
      desc: '',
      args: [year],
    );
  }

  /// `View your Star Citizen gameplay statistics for {year}. Data is from local logs, please check on your main computer.`
  String yearly_report_card_desc(Object year) {
    return Intl.message(
      'View your Star Citizen gameplay statistics for $year. Data is from local logs, please check on your main computer.',
      name: 'yearly_report_card_desc',
      desc: '',
      args: [year],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
