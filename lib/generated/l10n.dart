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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
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
    return Intl.message(
      'en',
      name: 'app_language_code',
      desc: '',
      args: [],
    );
  }

  /// `SCToolBox V {v0} {v1}`
  String app_index_version_info(Object v0, Object v1) {
    return Intl.message(
      'SCToolBox V $v0 $v1',
      name: 'app_index_version_info',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `SCToolBox.lnk`
  String get app_shortcut_name {
    return Intl.message(
      'SCToolBox.lnk',
      name: 'app_shortcut_name',
      desc: '',
      args: [],
    );
  }

  /// `Check for updates`
  String get about_check_update {
    return Intl.message(
      'Check for updates',
      name: 'about_check_update',
      desc: '',
      args: [],
    );
  }

  /// `Not just about localization!\n\nThe SCToolBox is your helper to explore the verse. We are committed to solving common in-game problems for citizens, in addition to facilitating localization from the community, game performance tuning, and localization of some commonly used website.`
  String get about_app_description {
    return Intl.message(
      'Not just about localization!\n\nThe SCToolBox is your helper to explore the verse. We are committed to solving common in-game problems for citizens, in addition to facilitating localization from the community, game performance tuning, and localization of some commonly used website.',
      name: 'about_app_description',
      desc: '',
      args: [],
    );
  }

  /// `Online feedback`
  String get about_online_feedback {
    return Intl.message(
      'Online feedback',
      name: 'about_online_feedback',
      desc: '',
      args: [],
    );
  }

  /// `QQ group: 940696487`
  String get about_action_qq_group {
    return Intl.message(
      'QQ group: 940696487',
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

  /// `Open source`
  String get about_action_open_source {
    return Intl.message(
      'Open source',
      name: 'about_action_open_source',
      desc: '',
      args: [],
    );
  }

  /// `This is an unofficial Star Citizen fan-made tools, not affiliated with the Cloud Imperium group of companies. All content on this Software not authored by its host or users are property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.`
  String get about_disclaimer {
    return Intl.message(
      'This is an unofficial Star Citizen fan-made tools, not affiliated with the Cloud Imperium group of companies. All content on this Software not authored by its host or users are property of their respective owners. \nStar Citizen®, Roberts Space Industries® and Cloud Imperium® are registered trademarks of Cloud Imperium Rights LLC.',
      name: 'about_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Start up`
  String get about_analytics_launch {
    return Intl.message(
      'Start up',
      name: 'about_analytics_launch',
      desc: '',
      args: [],
    );
  }

  /// `Game launches`
  String get about_analytics_launch_game {
    return Intl.message(
      'Game launches',
      name: 'about_analytics_launch_game',
      desc: '',
      args: [],
    );
  }

  /// `Cumulative users`
  String get about_analytics_total_users {
    return Intl.message(
      'Cumulative users',
      name: 'about_analytics_total_users',
      desc: '',
      args: [],
    );
  }

  /// `Localization installs`
  String get about_analytics_install_translation {
    return Intl.message(
      'Localization installs',
      name: 'about_analytics_install_translation',
      desc: '',
      args: [],
    );
  }

  /// `Performance tuning`
  String get about_analytics_performance_optimization {
    return Intl.message(
      'Performance tuning',
      name: 'about_analytics_performance_optimization',
      desc: '',
      args: [],
    );
  }

  /// `P4k diversion`
  String get about_analytics_p4k_redirection {
    return Intl.message(
      'P4k diversion',
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

  /// `Times`
  String get about_analytics_units_times {
    return Intl.message(
      'Times',
      name: 'about_analytics_units_times',
      desc: '',
      args: [],
    );
  }

  /// `It is already the latest version!`
  String get about_info_latest_version {
    return Intl.message(
      'It is already the latest version!',
      name: 'about_info_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `Countdown`
  String get home_holiday_countdown {
    return Intl.message(
      'Countdown',
      name: 'home_holiday_countdown',
      desc: '',
      args: [],
    );
  }

  /// `* The above festival dates are added and maintained manually. There may be errors and we welcome any feedback!`
  String get home_holiday_countdown_disclaimer {
    return Intl.message(
      '* The above festival dates are added and maintained manually. There may be errors and we welcome any feedback!',
      name: 'home_holiday_countdown_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `One-click launch`
  String get home_action_one_click_launch {
    return Intl.message(
      'One-click launch',
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

  /// `Welcome back!`
  String get home_login_title_welcome_back {
    return Intl.message(
      'Welcome back!',
      name: 'home_login_title_welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Launching game for you ...`
  String get home_login_title_launching_game {
    return Intl.message(
      'Launching game for you ...',
      name: 'home_login_title_launching_game',
      desc: '',
      args: [],
    );
  }

  /// `Log in to RSI account`
  String get home_action_login_rsi_account {
    return Intl.message(
      'Log in to RSI account',
      name: 'home_action_login_rsi_account',
      desc: '',
      args: [],
    );
  }

  /// `Outdated game version`
  String get home_login_info_game_version_outdated {
    return Intl.message(
      'Outdated game version',
      name: 'home_login_info_game_version_outdated',
      desc: '',
      args: [],
    );
  }

  /// `RSI server report version number: {v1}\n\nLocal version number: {v2}\n\nIt is recommended to use RSI Launcher to update the game!`
  String home_login_info_rsi_server_report(Object v1, Object v2) {
    return Intl.message(
      'RSI server report version number: $v1\n\nLocal version number: $v2\n\nIt is recommended to use RSI Launcher to update the game!',
      name: 'home_login_info_rsi_server_report',
      desc: '',
      args: [v1, v2],
    );
  }

  /// `Neglect`
  String get home_login_info_action_ignore {
    return Intl.message(
      'Neglect',
      name: 'home_login_info_action_ignore',
      desc: '',
      args: [],
    );
  }

  /// `Box one -click start`
  String get home_login_action_title_box_one_click_launch {
    return Intl.message(
      'Box one -click start',
      name: 'home_login_action_title_box_one_click_launch',
      desc: '',
      args: [],
    );
  }

  /// `This feature can help you start the game more conveniently.\n\nTo ensure the security of the account, this function uses the Localization browser to retain the login status and will not save your password information (unless you enable the automatic filling function).\n\nWhen logging in to the account, please make sure your SCToolBox is downloaded from a trusted source.`
  String get home_login_info_one_click_launch_description {
    return Intl.message(
      'This feature can help you start the game more conveniently.\n\nTo ensure the security of the account, this function uses the Localization browser to retain the login status and will not save your password information (unless you enable the automatic filling function).\n\nWhen logging in to the account, please make sure your SCToolBox is downloaded from a trusted source.',
      name: 'home_login_info_one_click_launch_description',
      desc: '',
      args: [],
    );
  }

  /// `Need to install WebView2 Runtime`
  String get home_login_action_title_need_webview2_runtime {
    return Intl.message(
      'Need to install WebView2 Runtime',
      name: 'home_login_action_title_need_webview2_runtime',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get action_close {
    return Intl.message(
      'Close',
      name: 'action_close',
      desc: '',
      args: [],
    );
  }

  /// `Speed limit setting`
  String get downloader_speed_limit_settings {
    return Intl.message(
      'Speed limit setting',
      name: 'downloader_speed_limit_settings',
      desc: '',
      args: [],
    );
  }

  /// `All of the suspension`
  String get downloader_action_pause_all {
    return Intl.message(
      'All of the suspension',
      name: 'downloader_action_pause_all',
      desc: '',
      args: [],
    );
  }

  /// `Restore all`
  String get downloader_action_resume_all {
    return Intl.message(
      'Restore all',
      name: 'downloader_action_resume_all',
      desc: '',
      args: [],
    );
  }

  /// `Cancel all of them`
  String get downloader_action_cancel_all {
    return Intl.message(
      'Cancel all of them',
      name: 'downloader_action_cancel_all',
      desc: '',
      args: [],
    );
  }

  /// `No download task`
  String get downloader_info_no_download_tasks {
    return Intl.message(
      'No download task',
      name: 'downloader_info_no_download_tasks',
      desc: '',
      args: [],
    );
  }

  /// `Total size: {v1}`
  String downloader_info_total_size(Object v1) {
    return Intl.message(
      'Total size: $v1',
      name: 'downloader_info_total_size',
      desc: '',
      args: [v1],
    );
  }

  /// `In the verification ... ({v2})`
  String downloader_info_verifying(Object v2) {
    return Intl.message(
      'In the verification ... ($v2)',
      name: 'downloader_info_verifying',
      desc: '',
      args: [v2],
    );
  }

  /// `Download ... ({v0}%)`
  String downloader_info_downloading(Object v0) {
    return Intl.message(
      'Download ... ($v0%)',
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

  /// `Option`
  String get downloader_action_options {
    return Intl.message(
      'Option',
      name: 'downloader_action_options',
      desc: '',
      args: [],
    );
  }

  /// `Continue download`
  String get downloader_action_continue_download {
    return Intl.message(
      'Continue download',
      name: 'downloader_action_continue_download',
      desc: '',
      args: [],
    );
  }

  /// `Pause download`
  String get downloader_action_pause_download {
    return Intl.message(
      'Pause download',
      name: 'downloader_action_pause_download',
      desc: '',
      args: [],
    );
  }

  /// `Cancel download`
  String get downloader_action_cancel_download {
    return Intl.message(
      'Cancel download',
      name: 'downloader_action_cancel_download',
      desc: '',
      args: [],
    );
  }

  /// `Open the folder`
  String get action_open_folder {
    return Intl.message(
      'Open the folder',
      name: 'action_open_folder',
      desc: '',
      args: [],
    );
  }

  /// `Download: {v0}/s Upload: {v1}/s`
  String downloader_info_download_upload_speed(Object v0, Object v1) {
    return Intl.message(
      'Download: $v0/s Upload: $v1/s',
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

  /// `Download failed`
  String get downloader_info_download_failed {
    return Intl.message(
      'Download failed',
      name: 'downloader_info_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `Download completed`
  String get downloader_info_download_completed {
    return Intl.message(
      'Download completed',
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

  /// `Over`
  String get downloader_title_ended {
    return Intl.message(
      'Over',
      name: 'downloader_title_ended',
      desc: '',
      args: [],
    );
  }

  /// `Confirm the cancellation of all tasks?`
  String get downloader_action_confirm_cancel_all_tasks {
    return Intl.message(
      'Confirm the cancellation of all tasks?',
      name: 'downloader_action_confirm_cancel_all_tasks',
      desc: '',
      args: [],
    );
  }

  /// `If the file is no longer needed, you may need to delete the download file manually.`
  String get downloader_info_manual_file_deletion_note {
    return Intl.message(
      'If the file is no longer needed, you may need to delete the download file manually.',
      name: 'downloader_info_manual_file_deletion_note',
      desc: '',
      args: [],
    );
  }

  /// `Confirm the cancellation download?`
  String get downloader_action_confirm_cancel_download {
    return Intl.message(
      'Confirm the cancellation download?',
      name: 'downloader_action_confirm_cancel_download',
      desc: '',
      args: [],
    );
  }

  /// `The SCToolBox uses the P2P network to accelerate file download. If you have limited traffic, you can set the upload bandwidth to 1 (byte) here.`
  String get downloader_info_p2p_network_note {
    return Intl.message(
      'The SCToolBox uses the P2P network to accelerate file download. If you have limited traffic, you can set the upload bandwidth to 1 (byte) here.',
      name: 'downloader_info_p2p_network_note',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the download unit.`
  String get downloader_info_download_unit_input_prompt {
    return Intl.message(
      'Please enter the download unit.',
      name: 'downloader_info_download_unit_input_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Upload speed limit:`
  String get downloader_input_upload_speed_limit {
    return Intl.message(
      'Upload speed limit:',
      name: 'downloader_input_upload_speed_limit',
      desc: '',
      args: [],
    );
  }

  /// `Download speed limit:`
  String get downloader_input_download_speed_limit {
    return Intl.message(
      'Download speed limit:',
      name: 'downloader_input_download_speed_limit',
      desc: '',
      args: [],
    );
  }

  /// `* P2P upload is only performed when downloading files, and the P2P connection will be turned off after downloading. If you want to participate in planting, please contact us about the page.`
  String get downloader_input_info_p2p_upload_note {
    return Intl.message(
      '* P2P upload is only performed when downloading files, and the P2P connection will be turned off after downloading. If you want to participate in planting, please contact us about the page.',
      name: 'downloader_input_info_p2p_upload_note',
      desc: '',
      args: [],
    );
  }

  /// `One -click diagnosis-> {v0}`
  String doctor_title_one_click_diagnosis(Object v0) {
    return Intl.message(
      'One -click diagnosis-> $v0',
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

  /// `Game running log`
  String get doctor_action_game_run_log {
    return Intl.message(
      'Game running log',
      name: 'doctor_action_game_run_log',
      desc: '',
      args: [],
    );
  }

  /// `After scanning, no problem was found!`
  String get doctor_info_scan_complete_no_issues {
    return Intl.message(
      'After scanning, no problem was found!',
      name: 'doctor_info_scan_complete_no_issues',
      desc: '',
      args: [],
    );
  }

  /// `Treatment ...`
  String get doctor_info_processing {
    return Intl.message(
      'Treatment ...',
      name: 'doctor_info_processing',
      desc: '',
      args: [],
    );
  }

  /// `You are about to go to the game abnormal rescue services provided by the Deep Space Treatment Center (QQ group number: 536454632), which mainly solve the failure and frequent flashback of game installation. If you are a gameplay problem, please do not add groups.`
  String get doctor_info_game_rescue_service_note {
    return Intl.message(
      'You are about to go to the game abnormal rescue services provided by the Deep Space Treatment Center (QQ group number: 536454632), which mainly solve the failure and frequent flashback of game installation. If you are a gameplay problem, please do not add groups.',
      name: 'doctor_info_game_rescue_service_note',
      desc: '',
      args: [],
    );
  }

  /// `Need help? Click to seek free artificial support!`
  String get doctor_info_need_help {
    return Intl.message(
      'Need help? Click to seek free artificial support!',
      name: 'doctor_info_need_help',
      desc: '',
      args: [],
    );
  }

  /// `Note: The test results of this tool are for reference only. If you do not understand the following operations, please provide screenshots for experienced players!`
  String get doctor_info_tool_check_result_note {
    return Intl.message(
      'Note: The test results of this tool are for reference only. If you do not understand the following operations, please provide screenshots for experienced players!',
      name: 'doctor_info_tool_check_result_note',
      desc: '',
      args: [],
    );
  }

  /// `The operating system that does not support, the game may not be able to run`
  String get doctor_info_result_unsupported_os {
    return Intl.message(
      'The operating system that does not support, the game may not be able to run',
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

  /// `The installation directory lacks a Live folder, which may cause the installation to fail`
  String get doctor_info_result_missing_live_folder {
    return Intl.message(
      'The installation directory lacks a Live folder, which may cause the installation to fail',
      name: 'doctor_info_result_missing_live_folder',
      desc: '',
      args: [],
    );
  }

  /// `Click to fix the Live folder for you, and install it after completion. ({v0})`
  String doctor_info_result_create_live_folder(Object v0) {
    return Intl.message(
      'Click to fix the Live folder for you, and install it after completion. ($v0)',
      name: 'doctor_info_result_create_live_folder',
      desc: '',
      args: [v0],
    );
  }

  /// `The new NVME device is not compatible with the RSI Launcher for the time being, which may cause the installation to fail`
  String get doctor_info_result_incompatible_nvme_device {
    return Intl.message(
      'The new NVME device is not compatible with the RSI Launcher for the time being, which may cause the installation to fail',
      name: 'doctor_info_result_incompatible_nvme_device',
      desc: '',
      args: [],
    );
  }

  /// `Add ForcedPhysicalsectorsizeinbytes value to the registry item to simulate old devices. Hard disk partition ({v0})`
  String doctor_info_result_add_registry_value(Object v0) {
    return Intl.message(
      'Add ForcedPhysicalsectorsizeinbytes value to the registry item to simulate old devices. Hard disk partition ($v0)',
      name: 'doctor_info_result_add_registry_value',
      desc: '',
      args: [v0],
    );
  }

  /// `Easyanticheat file loss`
  String get doctor_info_result_missing_easyanticheat_files {
    return Intl.message(
      'Easyanticheat file loss',
      name: 'doctor_info_result_missing_easyanticheat_files',
      desc: '',
      args: [],
    );
  }

  /// `Not found the EasyAnticheat file or file incomplete in the Live folder, please use the RSI Launcher to check the file`
  String get doctor_info_result_verify_files_with_rsi_launcher {
    return Intl.message(
      'Not found the EasyAnticheat file or file incomplete in the Live folder, please use the RSI Launcher to check the file',
      name: 'doctor_info_result_verify_files_with_rsi_launcher',
      desc: '',
      args: [],
    );
  }

  /// `Easyanticheat is not installed or not withdrawn normally`
  String get doctor_info_result_easyanticheat_not_installed {
    return Intl.message(
      'Easyanticheat is not installed or not withdrawn normally',
      name: 'doctor_info_result_easyanticheat_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `Easyanticheat is not installed, please click to repair it for you one click. (Before the game starts normally and ends, the problem will always appear. If you retreat for other reasons, you can ignore this entry)`
  String get doctor_info_result_install_easyanticheat {
    return Intl.message(
      'Easyanticheat is not installed, please click to repair it for you one click. (Before the game starts normally and ends, the problem will always appear. If you retreat for other reasons, you can ignore this entry)',
      name: 'doctor_info_result_install_easyanticheat',
      desc: '',
      args: [],
    );
  }

  /// `No-English username!`
  String get doctor_info_result_chinese_username {
    return Intl.message(
      'No-English username!',
      name: 'doctor_info_result_chinese_username',
      desc: '',
      args: [],
    );
  }

  /// `The No-English username may cause the game to start/install errors! Click the repair button to view the modification tutorial!`
  String get doctor_info_result_chinese_username_error {
    return Intl.message(
      'The No-English username may cause the game to start/install errors! Click the repair button to view the modification tutorial!',
      name: 'doctor_info_result_chinese_username_error',
      desc: '',
      args: [],
    );
  }

  /// `No-English installation path!`
  String get doctor_info_result_chinese_install_path {
    return Intl.message(
      'No-English installation path!',
      name: 'doctor_info_result_chinese_install_path',
      desc: '',
      args: [],
    );
  }

  /// `No-English installation path! This may cause the game to start/install errors! ({v0}), please replace the installation path at the RSI Launcher.`
  String doctor_info_result_chinese_install_path_error(Object v0) {
    return Intl.message(
      'No-English installation path! This may cause the game to start/install errors! ($v0), please replace the installation path at the RSI Launcher.',
      name: 'doctor_info_result_chinese_install_path_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Paralying memory is too low`
  String get doctor_info_result_low_physical_memory {
    return Intl.message(
      'Paralying memory is too low',
      name: 'doctor_info_result_low_physical_memory',
      desc: '',
      args: [],
    );
  }

  /// `You need at least 16GB of physical memory (Memory) to run this game. (Current size: {v0})`
  String doctor_info_result_memory_requirement(Object v0) {
    return Intl.message(
      'You need at least 16GB of physical memory (Memory) to run this game. (Current size: $v0)',
      name: 'doctor_info_result_memory_requirement',
      desc: '',
      args: [v0],
    );
  }

  /// `Repair suggestions: {v0}`
  String doctor_info_result_fix_suggestion(Object v0) {
    return Intl.message(
      'Repair suggestions: $v0',
      name: 'doctor_info_result_fix_suggestion',
      desc: '',
      args: [v0],
    );
  }

  /// `No solution, please take screenshots feedback`
  String get doctor_info_result_no_solution {
    return Intl.message(
      'No solution, please take screenshots feedback',
      name: 'doctor_info_result_no_solution',
      desc: '',
      args: [],
    );
  }

  /// `Repair`
  String get doctor_info_action_fix {
    return Intl.message(
      'Repair',
      name: 'doctor_info_action_fix',
      desc: '',
      args: [],
    );
  }

  /// `View solution`
  String get doctor_action_view_solution {
    return Intl.message(
      'View solution',
      name: 'doctor_action_view_solution',
      desc: '',
      args: [],
    );
  }

  /// `Please select the game installation directory on the homepage.`
  String get doctor_tip_title_select_game_directory {
    return Intl.message(
      'Please select the game installation directory on the homepage.',
      name: 'doctor_tip_title_select_game_directory',
      desc: '',
      args: [],
    );
  }

  /// `If your hardware meets the standard, try to install the latest Windows system.`
  String get doctor_action_result_try_latest_windows {
    return Intl.message(
      'If your hardware meets the standard, try to install the latest Windows system.',
      name: 'doctor_action_result_try_latest_windows',
      desc: '',
      args: [],
    );
  }

  /// `Create a folder success, try to continue download the game!`
  String get doctor_action_result_create_folder_success {
    return Intl.message(
      'Create a folder success, try to continue download the game!',
      name: 'doctor_action_result_create_folder_success',
      desc: '',
      args: [],
    );
  }

  /// `Create a folder failed, please try to create manually.\nDirectory: {v0}\nError: {v1}`
  String doctor_action_result_create_folder_fail(Object v0, Object v1) {
    return Intl.message(
      'Create a folder failed, please try to create manually.\nDirectory: $v0\nError: $v1',
      name: 'doctor_action_result_create_folder_fail',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `If the repair is successful, try to restart and continue to install the game! If the registry modification operation causes compatibility problems with other software, please use the NVMe registry in the tool to clean up.`
  String get doctor_action_result_fix_success {
    return Intl.message(
      'If the repair is successful, try to restart and continue to install the game! If the registry modification operation causes compatibility problems with other software, please use the NVMe registry in the tool to clean up.',
      name: 'doctor_action_result_fix_success',
      desc: '',
      args: [],
    );
  }

  /// `Failure to repair, {v0}`
  String doctor_action_result_fix_fail(Object v0) {
    return Intl.message(
      'Failure to repair, $v0',
      name: 'doctor_action_result_fix_fail',
      desc: '',
      args: [v0],
    );
  }

  /// `If the repair is successful, try to start the game. (If the problem cannot be solved, please use the toolbox's "Reinstall EAC")`
  String get doctor_action_result_game_start_success {
    return Intl.message(
      'If the repair is successful, try to start the game. (If the problem cannot be solved, please use the toolbox\'s "Reinstall EAC")',
      name: 'doctor_action_result_game_start_success',
      desc: '',
      args: [],
    );
  }

  /// `The tutorial is about to jump, the tutorial comes from the Internet, please operate carefully ...`
  String get doctor_action_result_redirect_warning {
    return Intl.message(
      'The tutorial is about to jump, the tutorial comes from the Internet, please operate carefully ...',
      name: 'doctor_action_result_redirect_warning',
      desc: '',
      args: [],
    );
  }

  /// `This problem does not support automatic processing for the time being, please provide screenshots for help`
  String get doctor_action_result_issue_not_supported {
    return Intl.message(
      'This problem does not support automatic processing for the time being, please provide screenshots for help',
      name: 'doctor_action_result_issue_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `Analysing...`
  String get doctor_action_analyzing {
    return Intl.message(
      'Analysing...',
      name: 'doctor_action_analyzing',
      desc: '',
      args: [],
    );
  }

  /// `After the analysis, no problems are found`
  String get doctor_action_result_analysis_no_issue {
    return Intl.message(
      'After the analysis, no problems are found',
      name: 'doctor_action_result_analysis_no_issue',
      desc: '',
      args: [],
    );
  }

  /// `After the analysis, I found that {v0} questions`
  String doctor_action_result_analysis_issues_found(Object v0) {
    return Intl.message(
      'After the analysis, I found that $v0 questions',
      name: 'doctor_action_result_analysis_issues_found',
      desc: '',
      args: [v0],
    );
  }

  /// `After scanning, no problem is found. If you still fail, try to use the RSI Launcher administrator mode in the toolbox.`
  String get doctor_action_result_toast_scan_no_issue {
    return Intl.message(
      'After scanning, no problem is found. If you still fail, try to use the RSI Launcher administrator mode in the toolbox.',
      name: 'doctor_action_result_toast_scan_no_issue',
      desc: '',
      args: [],
    );
  }

  /// `Inspection: Game.log`
  String get doctor_action_tip_checking_game_log {
    return Intl.message(
      'Inspection: Game.log',
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

  /// `Game abnormal exit: unknown abnormalities`
  String get doctor_action_info_game_abnormal_exit_unknown {
    return Intl.message(
      'Game abnormal exit: unknown abnormalities',
      name: 'doctor_action_info_game_abnormal_exit_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Info: {v0}, please click to add group feedback in the lower right corner.`
  String doctor_action_info_info_feedback(Object v0) {
    return Intl.message(
      'Info: $v0, please click to add group feedback in the lower right corner.',
      name: 'doctor_action_info_info_feedback',
      desc: '',
      args: [v0],
    );
  }

  /// `Inspection: EAC`
  String get doctor_action_info_checking_eac {
    return Intl.message(
      'Inspection: EAC',
      name: 'doctor_action_info_checking_eac',
      desc: '',
      args: [],
    );
  }

  /// `Inspection: operating environment`
  String get doctor_action_info_checking_runtime {
    return Intl.message(
      'Inspection: operating environment',
      name: 'doctor_action_info_checking_runtime',
      desc: '',
      args: [],
    );
  }

  /// `Operating system that does not support: {v0}`
  String doctor_action_result_info_unsupported_os(Object v0) {
    return Intl.message(
      'Operating system that does not support: $v0',
      name: 'doctor_action_result_info_unsupported_os',
      desc: '',
      args: [v0],
    );
  }

  /// `Inspection: Installation information`
  String get doctor_action_info_checking_install_info {
    return Intl.message(
      'Inspection: Installation information',
      name: 'doctor_action_info_checking_install_info',
      desc: '',
      args: [],
    );
  }

  /// `Check the details`
  String get doctor_action_view_details {
    return Intl.message(
      'Check the details',
      name: 'doctor_action_view_details',
      desc: '',
      args: [],
    );
  }

  /// `Installation location:`
  String get home_install_location {
    return Intl.message(
      'Installation location:',
      name: 'home_install_location',
      desc: '',
      args: [],
    );
  }

  /// `Unpacking or installation failed`
  String get home_not_installed_or_failed {
    return Intl.message(
      'Unpacking or installation failed',
      name: 'home_not_installed_or_failed',
      desc: '',
      args: [],
    );
  }

  /// `SC Official Localization`
  String get home_action_star_citizen_website_localization {
    return Intl.message(
      'SC Official Localization',
      name: 'home_action_star_citizen_website_localization',
      desc: '',
      args: [],
    );
  }

  /// `Roberts Aerospace Industry Corporation, the origin of all things`
  String get home_action_info_roberts_space_industries_origin {
    return Intl.message(
      'Roberts Aerospace Industry Corporation, the origin of all things',
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

  /// `Mining, refining, trade calculator, price, ship information`
  String get home_action_info_mining_refining_trade_calculator {
    return Intl.message(
      'Mining, refining, trade calculator, price, ship information',
      name: 'home_action_info_mining_refining_trade_calculator',
      desc: '',
      args: [],
    );
  }

  /// `DPS calculator Localization`
  String get home_action_dps_calculator_localization {
    return Intl.message(
      'DPS calculator Localization',
      name: 'home_action_dps_calculator_localization',
      desc: '',
      args: [],
    );
  }

  /// `Change the ship online, query the damage value and accessories location`
  String get home_action_info_ship_upgrade_damage_value_query {
    return Intl.message(
      'Change the ship online, query the damage value and accessories location',
      name: 'home_action_info_ship_upgrade_damage_value_query',
      desc: '',
      args: [],
    );
  }

  /// `External browser expansion:`
  String get home_action_external_browser_extension {
    return Intl.message(
      'External browser expansion:',
      name: 'home_action_external_browser_extension',
      desc: '',
      args: [],
    );
  }

  /// `Auto diagnosis`
  String get home_action_one_click_diagnosis {
    return Intl.message(
      'Auto diagnosis',
      name: 'home_action_one_click_diagnosis',
      desc: '',
      args: [],
    );
  }

  /// `Auto scan diagnosis of common problems in interstellar citizens`
  String get home_action_info_one_click_diagnosis_star_citizen {
    return Intl.message(
      'Auto scan diagnosis of common problems in interstellar citizens',
      name: 'home_action_info_one_click_diagnosis_star_citizen',
      desc: '',
      args: [],
    );
  }

  /// `Localizations`
  String get home_action_localization_management {
    return Intl.message(
      'Localizations',
      name: 'home_action_localization_management',
      desc: '',
      args: [],
    );
  }

  /// `Fast installation of localization resources`
  String get home_action_info_quick_install_localization_resources {
    return Intl.message(
      'Fast installation of localization resources',
      name: 'home_action_info_quick_install_localization_resources',
      desc: '',
      args: [],
    );
  }

  /// `Performance optimization`
  String get home_action_performance_optimization {
    return Intl.message(
      'Performance optimization',
      name: 'home_action_performance_optimization',
      desc: '',
      args: [],
    );
  }

  /// `Adjust the engine configuration file to optimize the game performance`
  String get home_action_info_engine_config_optimization {
    return Intl.message(
      'Adjust the engine configuration file to optimize the game performance',
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

  /// `EV`
  String get home_action_rsi_status_electronic_access {
    return Intl.message(
      'EV',
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

  /// `RSI server status`
  String get home_action_rsi_status_rsi_server_status {
    return Intl.message(
      'RSI server status',
      name: 'home_action_rsi_status_rsi_server_status',
      desc: '',
      args: [],
    );
  }

  /// `State:`
  String get home_action_rsi_status_status {
    return Intl.message(
      'State:',
      name: 'home_action_rsi_status_status',
      desc: '',
      args: [],
    );
  }

  /// `Announcement details`
  String get home_announcement_details {
    return Intl.message(
      'Announcement details',
      name: 'home_announcement_details',
      desc: '',
      args: [],
    );
  }

  /// `This function requires an effective installation location\n\nIf your game is not downloaded, wait for the download after downloading.\n\nIf your game has been downloaded but not recognized, please reopen the box after starting the game or manually set the installation position in the setting option.`
  String get home_action_info_valid_install_location_required {
    return Intl.message(
      'This function requires an effective installation location\n\nIf your game is not downloaded, wait for the download after downloading.\n\nIf your game has been downloaded but not recognized, please reopen the box after starting the game or manually set the installation position in the setting option.',
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

  /// `Scan completed, find {v0} valid installation directory`
  String home_action_info_scan_complete_valid_directories_found(Object v0) {
    return Intl.message(
      'Scan completed, find $v0 valid installation directory',
      name: 'home_action_info_scan_complete_valid_directories_found',
      desc: '',
      args: [v0],
    );
  }

  /// `Analysis of LOG files failed!`
  String get home_action_info_log_file_parse_fail {
    return Intl.message(
      'Analysis of LOG files failed!',
      name: 'home_action_info_log_file_parse_fail',
      desc: '',
      args: [],
    );
  }

  /// `Star Citizen Website Localization`
  String get home_action_title_star_citizen_website_localization {
    return Intl.message(
      'Star Citizen Website Localization',
      name: 'home_action_title_star_citizen_website_localization',
      desc: '',
      args: [],
    );
  }

  /// `This plug -in function is for general browsing, not responsible for any problems related to this function! Please pay attention to confirming the original content of the website before the account operation!\n\n\nWhen logging in to the account, please make sure your SCToolBox is downloaded from a trusted source.`
  String get home_action_info_web_localization_plugin_disclaimer {
    return Intl.message(
      'This plug -in function is for general browsing, not responsible for any problems related to this function! Please pay attention to confirming the original content of the website before the account operation!\n\n\nWhen logging in to the account, please make sure your SCToolBox is downloaded from a trusted source.',
      name: 'home_action_info_web_localization_plugin_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `It is initialized Localization resources ...`
  String get home_action_info_initializing_resources {
    return Intl.message(
      'It is initialized Localization resources ...',
      name: 'home_action_info_initializing_resources',
      desc: '',
      args: [],
    );
  }

  /// `Initialized webpage Localization resources failed! {v0}`
  String home_action_info_initialization_failed(Object v0) {
    return Intl.message(
      'Initialized webpage Localization resources failed! $v0',
      name: 'home_action_info_initialization_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `SCToolBox`
  String get home_title_app_name {
    return Intl.message(
      'SCToolBox',
      name: 'home_title_app_name',
      desc: '',
      args: [],
    );
  }

  /// `Localization has a new version!`
  String get home_localization_new_version_available {
    return Intl.message(
      'Localization has a new version!',
      name: 'home_localization_new_version_available',
      desc: '',
      args: [],
    );
  }

  /// `You have a new version of the Localization you installed in {v0}!`
  String home_localization_new_version_installed(Object v0) {
    return Intl.message(
      'You have a new version of the Localization you installed in $v0!',
      name: 'home_localization_new_version_installed',
      desc: '',
      args: [v0],
    );
  }

  /// `This function requires an effective installation location`
  String get home_info_valid_installation_required {
    return Intl.message(
      'This function requires an effective installation location',
      name: 'home_info_valid_installation_required',
      desc: '',
      args: [],
    );
  }

  /// `One -click start -up function prompt`
  String get home_info_one_click_launch_warning {
    return Intl.message(
      'One -click start -up function prompt',
      name: 'home_info_one_click_launch_warning',
      desc: '',
      args: [],
    );
  }

  /// `In order to ensure the security of the account, the one -click startup function has been disabled in the development version, and we will provide this feature in the Microsoft store version.\n\nThe Microsoft Store Edition is provided with a reliable distribution download and digital signature by Microsoft, which can effectively prevent software from being maliciously tampered with.\n\nTip: You can use Localization without using a box to start the game.`
  String get home_info_account_security_warning {
    return Intl.message(
      'In order to ensure the security of the account, the one -click startup function has been disabled in the development version, and we will provide this feature in the Microsoft store version.\n\nThe Microsoft Store Edition is provided with a reliable distribution download and digital signature by Microsoft, which can effectively prevent software from being maliciously tampered with.\n\nTip: You can use Localization without using a box to start the game.',
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

  /// `The game exits normally\nexitCode = {v0}\nstdout = {v1}\nstderr = {v2}\n\nDiagnostic information: {v3}\n{v4}`
  String home_action_info_abnormal_game_exit(
      Object v0, Object v1, Object v2, Object v3, Object v4) {
    return Intl.message(
      'The game exits normally\nexitCode = $v0\nstdout = $v1\nstderr = $v2\n\nDiagnostic information: $v3\n$v4',
      name: 'home_action_info_abnormal_game_exit',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `Unknown errors, please use one -click diagnosis to add group feedback.`
  String get home_action_info_unknown_error {
    return Intl.message(
      'Unknown errors, please use one -click diagnosis to add group feedback.',
      name: 'home_action_info_unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Please check the pop -up web link to get detailed information.`
  String get home_action_info_check_web_link {
    return Intl.message(
      'Please check the pop -up web link to get detailed information.',
      name: 'home_action_info_check_web_link',
      desc: '',
      args: [],
    );
  }

  /// `Built -in game`
  String get home_action_info_game_built_in {
    return Intl.message(
      'Built -in game',
      name: 'home_action_info_game_built_in',
      desc: '',
      args: [],
    );
  }

  /// `Warn`
  String get home_action_info_warning {
    return Intl.message(
      'Warn',
      name: 'home_action_info_warning',
      desc: '',
      args: [],
    );
  }

  /// `You are using the game built -in text. The official text is currently a machine translation (as of 3.21.0), and it is recommended that you install community Localization below.`
  String get localization_info_machine_translation_warning {
    return Intl.message(
      'You are using the game built -in text. The official text is currently a machine translation (as of 3.21.0), and it is recommended that you install community Localization below.',
      name: 'localization_info_machine_translation_warning',
      desc: '',
      args: [],
    );
  }

  /// `Localization status`
  String get localization_info_translation_status {
    return Intl.message(
      'Localization status',
      name: 'localization_info_translation_status',
      desc: '',
      args: [],
    );
  }

  /// `Enable ({v0}):`
  String localization_info_enabled(Object v0) {
    return Intl.message(
      'Enable ($v0):',
      name: 'localization_info_enabled',
      desc: '',
      args: [v0],
    );
  }

  /// `The installed version: {v0}`
  String localization_info_installed_version(Object v0) {
    return Intl.message(
      'The installed version: $v0',
      name: 'localization_info_installed_version',
      desc: '',
      args: [v0],
    );
  }

  /// `Feedback`
  String get localization_action_translation_feedback {
    return Intl.message(
      'Feedback',
      name: 'localization_action_translation_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Uninstall`
  String get localization_action_uninstall_translation {
    return Intl.message(
      'Uninstall',
      name: 'localization_action_uninstall_translation',
      desc: '',
      args: [],
    );
  }

  /// `Remark:`
  String get localization_info_note {
    return Intl.message(
      'Remark:',
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

  /// `This language/version is not available for Localization, so stay tuned!`
  String get localization_info_no_translation_available {
    return Intl.message(
      'This language/version is not available for Localization, so stay tuned!',
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

  /// `Update Time: {v0}`
  String localization_info_update_time(Object v0) {
    return Intl.message(
      'Update Time: $v0',
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

  /// `Language:   `
  String get localization_info_language {
    return Intl.message(
      'Language:   ',
      name: 'localization_info_language',
      desc: '',
      args: [],
    );
  }

  /// `Whether to remove incompatible Localization parameters`
  String get localization_info_remove_incompatible_translation_params {
    return Intl.message(
      'Whether to remove incompatible Localization parameters',
      name: 'localization_info_remove_incompatible_translation_params',
      desc: '',
      args: [],
    );
  }

  /// `User.cfg contains incompatible Localization parameters, which may be the residual information of the previous Localization file.\n\nThis may lead to ineffective or garbled Localization, click to confirm that you are removed with one click (it will not affect other configuration).`
  String get localization_info_incompatible_translation_params_warning {
    return Intl.message(
      'User.cfg contains incompatible Localization parameters, which may be the residual information of the previous Localization file.\n\nThis may lead to ineffective or garbled Localization, click to confirm that you are removed with one click (it will not affect other configuration).',
      name: 'localization_info_incompatible_translation_params_warning',
      desc: '',
      args: [],
    );
  }

  /// `The file is damaged, please download again`
  String get localization_info_corrupted_file {
    return Intl.message(
      'The file is damaged, please download again',
      name: 'localization_info_corrupted_file',
      desc: '',
      args: [],
    );
  }

  /// `Install an error!\n\n {v0}`
  String localization_info_installation_error(Object v0) {
    return Intl.message(
      'Install an error!\n\n $v0',
      name: 'localization_info_installation_error',
      desc: '',
      args: [v0],
    );
  }

  /// `Custom file`
  String get localization_info_custom_files {
    return Intl.message(
      'Custom file',
      name: 'localization_info_custom_files',
      desc: '',
      args: [],
    );
  }

  /// `Graph optimization tips`
  String get performance_info_graphic_optimization_hint {
    return Intl.message(
      'Graph optimization tips',
      name: 'performance_info_graphic_optimization_hint',
      desc: '',
      args: [],
    );
  }

  /// `This function is very helpful for optimizing the bottleneck of the graphics card, but it may have a reverse effect on the CPU bottleneck. If your graphics card performance is strong, you can try to use better picture quality to obtain higher graphics card utilization.`
  String get performance_info_graphic_optimization_warning {
    return Intl.message(
      'This function is very helpful for optimizing the bottleneck of the graphics card, but it may have a reverse effect on the CPU bottleneck. If your graphics card performance is strong, you can try to use better picture quality to obtain higher graphics card utilization.',
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

  /// `Unused`
  String get performance_info_not_applied {
    return Intl.message(
      'Unused',
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

  /// `Middle`
  String get performance_action_medium {
    return Intl.message(
      'Middle',
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

  /// `(Only graphic)`
  String get performance_action_info_preset_only_changes_graphics {
    return Intl.message(
      '(Only graphic)',
      name: 'performance_action_info_preset_only_changes_graphics',
      desc: '',
      args: [],
    );
  }

  /// ` Reset`
  String get performance_action_reset_to_default {
    return Intl.message(
      ' Reset',
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

  /// `Apply and clean up`
  String get performance_action_apply_and_clear_shaders {
    return Intl.message(
      'Apply and clean up',
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

  /// `You can enter the custom parameters that are not included in the box here. Configuration example:\n\nR_DISPLAYINFO = 0\nr_vsync = 0`
  String get performance_action_custom_parameters_input {
    return Intl.message(
      'You can enter the custom parameters that are not included in the box here. Configuration example:\n\nR_DISPLAYINFO = 0\nr_vsync = 0',
      name: 'performance_action_custom_parameters_input',
      desc: '',
      args: [],
    );
  }

  /// `{v0} minimum value: {v1} / maximum value: {v2}`
  String performance_info_min_max_values(Object v0, Object v1, Object v2) {
    return Intl.message(
      '$v0 minimum value: $v1 / maximum value: $v2',
      name: 'performance_info_min_max_values',
      desc: '',
      args: [v0, v1, v2],
    );
  }

  /// `Graphic`
  String get performance_info_graphics {
    return Intl.message(
      'Graphic',
      name: 'performance_info_graphics',
      desc: '',
      args: [],
    );
  }

  /// `Delete the configuration file ...`
  String get performance_info_delete_config_file {
    return Intl.message(
      'Delete the configuration file ...',
      name: 'performance_info_delete_config_file',
      desc: '',
      args: [],
    );
  }

  /// `Clean the color device`
  String get performance_action_clear_shaders {
    return Intl.message(
      'Clean the color device',
      name: 'performance_action_clear_shaders',
      desc: '',
      args: [],
    );
  }

  /// `Finish...`
  String get performance_info_done {
    return Intl.message(
      'Finish...',
      name: 'performance_info_done',
      desc: '',
      args: [],
    );
  }

  /// `After cleaning up the color device, it may appear stutter when entering the game for the first time. Please wait patiently for the initialization of the game.`
  String get performance_info_shader_clearing_warning {
    return Intl.message(
      'After cleaning up the color device, it may appear stutter when entering the game for the first time. Please wait patiently for the initialization of the game.',
      name: 'performance_info_shader_clearing_warning',
      desc: '',
      args: [],
    );
  }

  /// `Generate configuration file`
  String get performance_info_generate_config_file {
    return Intl.message(
      'Generate configuration file',
      name: 'performance_info_generate_config_file',
      desc: '',
      args: [],
    );
  }

  /// `Write the configuration file`
  String get performance_info_write_out_config_file {
    return Intl.message(
      'Write the configuration file',
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

  /// `The online lobby, so stay tuned!`
  String get lobby_online_lobby_coming_soon {
    return Intl.message(
      'The online lobby, so stay tuned!',
      name: 'lobby_online_lobby_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Sincerely invite you to participate `
  String get lobby_invitation_to_participate {
    return Intl.message(
      'Sincerely invite you to participate ',
      name: 'lobby_invitation_to_participate',
      desc: '',
      args: [],
    );
  }

  /// `Questionnaire.`
  String get lobby_survey {
    return Intl.message(
      'Questionnaire.',
      name: 'lobby_survey',
      desc: '',
      args: [],
    );
  }

  /// `Create shortcut`
  String get setting_action_create_settings_shortcut {
    return Intl.message(
      'Create shortcut',
      name: 'setting_action_create_settings_shortcut',
      desc: '',
      args: [],
    );
  }

  /// `Create "SC Localization Box" shortcut on the desktop`
  String get setting_action_create_desktop_shortcut {
    return Intl.message(
      'Create "SC Localization Box" shortcut on the desktop',
      name: 'setting_action_create_desktop_shortcut',
      desc: '',
      args: [],
    );
  }

  /// `Reset automatic password filling`
  String get setting_action_reset_auto_password_fill {
    return Intl.message(
      'Reset automatic password filling',
      name: 'setting_action_reset_auto_password_fill',
      desc: '',
      args: [],
    );
  }

  /// `When starting the game, ignore the core of energy efficiency (suitable for Intel 12th+ processor)`
  String get setting_action_ignore_efficiency_cores_on_launch {
    return Intl.message(
      'When starting the game, ignore the core of energy efficiency (suitable for Intel 12th+ processor)',
      name: 'setting_action_ignore_efficiency_cores_on_launch',
      desc: '',
      args: [],
    );
  }

  /// `Core quantity that has been set: {v0} (This function is suitable for the box -click startup or RSI Launcher manager mode on the homepage, which is not enabled when it is 0)`
  String setting_action_set_core_count(Object v0) {
    return Intl.message(
      'Core quantity that has been set: $v0 (This function is suitable for the box -click startup or RSI Launcher manager mode on the homepage, which is not enabled when it is 0)',
      name: 'setting_action_set_core_count',
      desc: '',
      args: [v0],
    );
  }

  /// `Set the promoter file (RSI Launcher.exe)`
  String get setting_action_set_launcher_file {
    return Intl.message(
      'Set the promoter file (RSI Launcher.exe)',
      name: 'setting_action_set_launcher_file',
      desc: '',
      args: [],
    );
  }

  /// `Set the position of the RSI Launcher manually, it is recommended to use it only when the installation position cannot be automatically scanned automatically`
  String get setting_action_info_manual_launcher_location_setting {
    return Intl.message(
      'Set the position of the RSI Launcher manually, it is recommended to use it only when the installation position cannot be automatically scanned automatically',
      name: 'setting_action_info_manual_launcher_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `Set the game file (StarCitizen.exe)`
  String get setting_action_set_game_file {
    return Intl.message(
      'Set the game file (StarCitizen.exe)',
      name: 'setting_action_set_game_file',
      desc: '',
      args: [],
    );
  }

  /// `Manually set the game installation location, it is recommended to use it only when the installation location cannot be automatically scanned`
  String get setting_action_info_manual_game_location_setting {
    return Intl.message(
      'Manually set the game installation location, it is recommended to use it only when the installation location cannot be automatically scanned',
      name: 'setting_action_info_manual_game_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `Clean up the Localization file cache`
  String get setting_action_clear_translation_file_cache {
    return Intl.message(
      'Clean up the Localization file cache',
      name: 'setting_action_clear_translation_file_cache',
      desc: '',
      args: [],
    );
  }

  /// `The cache size {v0} MB, clean up the Localization -based file cache of the download of the box, will not affect the installed Localization`
  String setting_action_info_cache_clearing_info(Object v0) {
    return Intl.message(
      'The cache size $v0 MB, clean up the Localization -based file cache of the download of the box, will not affect the installed Localization',
      name: 'setting_action_info_cache_clearing_info',
      desc: '',
      args: [v0],
    );
  }

  /// `Tool station access acceleration`
  String get setting_action_tool_site_access_acceleration {
    return Intl.message(
      'Tool station access acceleration',
      name: 'setting_action_tool_site_access_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `Use a mirror server to accelerate access to tool websites such as DPS UEX. If you access abnormal access, please turn off the function. To protect the security of the account, the RSI official website will not be accelerated in any case.`
  String get setting_action_info_mirror_server_info {
    return Intl.message(
      'Use a mirror server to accelerate access to tool websites such as DPS UEX. If you access abnormal access, please turn off the function. To protect the security of the account, the RSI official website will not be accelerated in any case.',
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

  /// `Check the log file of the SCToolBox to locate the bug of the box`
  String get setting_action_info_view_log_file {
    return Intl.message(
      'Check the log file of the SCToolBox to locate the bug of the box',
      name: 'setting_action_info_view_log_file',
      desc: '',
      args: [],
    );
  }

  /// `Confirm that resetting automatic filling?`
  String get setting_action_info_confirm_reset_autofill {
    return Intl.message(
      'Confirm that resetting automatic filling?',
      name: 'setting_action_info_confirm_reset_autofill',
      desc: '',
      args: [],
    );
  }

  /// `This will delete local account records, or it will automatically fill in the next time the game starts the game to disable automatic filling.`
  String get setting_action_info_delete_local_account_warning {
    return Intl.message(
      'This will delete local account records, or it will automatically fill in the next time the game starts the game to disable automatic filling.',
      name: 'setting_action_info_delete_local_account_warning',
      desc: '',
      args: [],
    );
  }

  /// `Automatic filling data has been cleaned up`
  String get setting_action_info_autofill_data_cleared {
    return Intl.message(
      'Automatic filling data has been cleaned up',
      name: 'setting_action_info_autofill_data_cleared',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the core number of CPUs to be ignored`
  String get setting_action_info_enter_cpu_core_to_ignore {
    return Intl.message(
      'Please enter the core number of CPUs to be ignored',
      name: 'setting_action_info_enter_cpu_core_to_ignore',
      desc: '',
      args: [],
    );
  }

  /// `Tip: Input a few of your equipment with a few energy efficiency cores, please keep 0 non -large and small nuclear equipment 0\n\nThis function is suitable for the box of one -click startup or the RSI Launcher Admin mode in the box on the homepage. This function is not enabled when it is 0.`
  String get setting_action_info_cpu_core_tip {
    return Intl.message(
      'Tip: Input a few of your equipment with a few energy efficiency cores, please keep 0 non -large and small nuclear equipment 0\n\nThis function is suitable for the box of one -click startup or the RSI Launcher Admin mode in the box on the homepage. This function is not enabled when it is 0.',
      name: 'setting_action_info_cpu_core_tip',
      desc: '',
      args: [],
    );
  }

  /// `Please select the RSI Launcher position (RSI LAUNCHER.EXE)`
  String get setting_action_info_select_rsi_launcher_location {
    return Intl.message(
      'Please select the RSI Launcher position (RSI LAUNCHER.EXE)',
      name: 'setting_action_info_select_rsi_launcher_location',
      desc: '',
      args: [],
    );
  }

  /// `Successfully set, click refresh on the corresponding page to scan the new path`
  String get setting_action_info_setting_success {
    return Intl.message(
      'Successfully set, click refresh on the corresponding page to scan the new path',
      name: 'setting_action_info_setting_success',
      desc: '',
      args: [],
    );
  }

  /// `The file is wrong!`
  String get setting_action_info_file_error {
    return Intl.message(
      'The file is wrong!',
      name: 'setting_action_info_file_error',
      desc: '',
      args: [],
    );
  }

  /// `Please select the game installation position (StarCitizen.exe)`
  String get setting_action_info_select_game_install_location {
    return Intl.message(
      'Please select the game installation position (StarCitizen.exe)',
      name: 'setting_action_info_select_game_install_location',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation of cleaning the Localization cache?`
  String get setting_action_info_confirm_clear_cache {
    return Intl.message(
      'Confirmation of cleaning the Localization cache?',
      name: 'setting_action_info_confirm_clear_cache',
      desc: '',
      args: [],
    );
  }

  /// `This will not affect the installed Localization.`
  String get setting_action_info_clear_cache_warning {
    return Intl.message(
      'This will not affect the installed Localization.',
      name: 'setting_action_info_clear_cache_warning',
      desc: '',
      args: [],
    );
  }

  /// `Due to Microsoft's version restrictions, manually drag the SCToolBox to the desktop in the next window to create a shortcut.`
  String get setting_action_info_microsoft_version_limitation {
    return Intl.message(
      'Due to Microsoft\'s version restrictions, manually drag the SCToolBox to the desktop in the next window to create a shortcut.',
      name: 'setting_action_info_microsoft_version_limitation',
      desc: '',
      args: [],
    );
  }

  /// `After the creation, please return to the desktop to view`
  String get setting_action_info_shortcut_created {
    return Intl.message(
      'After the creation, please return to the desktop to view',
      name: 'setting_action_info_shortcut_created',
      desc: '',
      args: [],
    );
  }

  /// `Discover the new version-> {v0}`
  String app_upgrade_title_new_version_found(Object v0) {
    return Intl.message(
      'Discover the new version-> $v0',
      name: 'app_upgrade_title_new_version_found',
      desc: '',
      args: [v0],
    );
  }

  /// `Get the new version details ...`
  String get app_upgrade_info_getting_new_version_details {
    return Intl.message(
      'Get the new version details ...',
      name: 'app_upgrade_info_getting_new_version_details',
      desc: '',
      args: [],
    );
  }

  /// `Tip: The current diversion server is updated, and the download speed may decline, but it will help us perform cost control. If you download the exception, please click here to jump and manually install it.`
  String get app_upgrade_info_update_server_tip {
    return Intl.message(
      'Tip: The current diversion server is updated, and the download speed may decline, but it will help us perform cost control. If you download the exception, please click here to jump and manually install it.',
      name: 'app_upgrade_info_update_server_tip',
      desc: '',
      args: [],
    );
  }

  /// `Installing:   `
  String get app_upgrade_info_installing {
    return Intl.message(
      'Installing:   ',
      name: 'app_upgrade_info_installing',
      desc: '',
      args: [],
    );
  }

  /// `Downloading: {v0}%    `
  String app_upgrade_info_downloading(Object v0) {
    return Intl.message(
      'Downloading: $v0%    ',
      name: 'app_upgrade_info_downloading',
      desc: '',
      args: [v0],
    );
  }

  /// `Update immediately`
  String get app_upgrade_action_update_now {
    return Intl.message(
      'Update immediately',
      name: 'app_upgrade_action_update_now',
      desc: '',
      args: [],
    );
  }

  /// `Next time`
  String get app_upgrade_action_next_time {
    return Intl.message(
      'Next time',
      name: 'app_upgrade_action_next_time',
      desc: '',
      args: [],
    );
  }

  /// `Failure to download, please try to install manually!`
  String get app_upgrade_info_download_failed {
    return Intl.message(
      'Failure to download, please try to install manually!',
      name: 'app_upgrade_info_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `Failure to run, try to install manually!`
  String get app_upgrade_info_run_failed {
    return Intl.message(
      'Failure to run, try to install manually!',
      name: 'app_upgrade_info_run_failed',
      desc: '',
      args: [],
    );
  }

  /// `It is detection availability, which may take a little time ...`
  String get app_splash_checking_availability {
    return Intl.message(
      'It is detection availability, which may take a little time ...',
      name: 'app_splash_checking_availability',
      desc: '',
      args: [],
    );
  }

  /// `Inspection and update ...`
  String get app_splash_checking_for_updates {
    return Intl.message(
      'Inspection and update ...',
      name: 'app_splash_checking_for_updates',
      desc: '',
      args: [],
    );
  }

  /// `Finish quickly…`
  String get app_splash_almost_done {
    return Intl.message(
      'Finish quickly…',
      name: 'app_splash_almost_done',
      desc: '',
      args: [],
    );
  }

  /// `RSI official website`
  String get tools_hosts_info_rsi_official_website {
    return Intl.message(
      'RSI official website',
      name: 'tools_hosts_info_rsi_official_website',
      desc: '',
      args: [],
    );
  }

  /// `RSI customer service station`
  String get tools_hosts_info_rsi_customer_service {
    return Intl.message(
      'RSI customer service station',
      name: 'tools_hosts_info_rsi_customer_service',
      desc: '',
      args: [],
    );
  }

  /// `Inquiring about DNS and testing accessibility, please wait patiently ...`
  String get tools_hosts_info_dns_query_and_test {
    return Intl.message(
      'Inquiring about DNS and testing accessibility, please wait patiently ...',
      name: 'tools_hosts_info_dns_query_and_test',
      desc: '',
      args: [],
    );
  }

  /// `I am writing Hosts ...`
  String get tools_hosts_info_writing_hosts {
    return Intl.message(
      'I am writing Hosts ...',
      name: 'tools_hosts_info_writing_hosts',
      desc: '',
      args: [],
    );
  }

  /// `Read the configuration ...`
  String get tools_hosts_info_reading_config {
    return Intl.message(
      'Read the configuration ...',
      name: 'tools_hosts_info_reading_config',
      desc: '',
      args: [],
    );
  }

  /// `Hosts accelerate`
  String get tools_hosts_info_hosts_acceleration {
    return Intl.message(
      'Hosts accelerate',
      name: 'tools_hosts_info_hosts_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `Open the hosts file`
  String get tools_hosts_info_open_hosts_file {
    return Intl.message(
      'Open the hosts file',
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

  /// `Whether to enable`
  String get tools_hosts_info_enable {
    return Intl.message(
      'Whether to enable',
      name: 'tools_hosts_info_enable',
      desc: '',
      args: [],
    );
  }

  /// `One -click acceleration`
  String get tools_hosts_action_one_click_acceleration {
    return Intl.message(
      'One -click acceleration',
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

  /// `Failure to handle! : {v0}`
  String tools_info_processing_failed(Object v0) {
    return Intl.message(
      'Failure to handle! : $v0',
      name: 'tools_info_processing_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `Game installation location:  `
  String get tools_info_game_install_location {
    return Intl.message(
      'Game installation location:  ',
      name: 'tools_info_game_install_location',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher position:`
  String get tools_info_rsi_launcher_location {
    return Intl.message(
      'RSI Launcher position:',
      name: 'tools_info_rsi_launcher_location',
      desc: '',
      args: [],
    );
  }

  /// `View system information`
  String get tools_action_view_system_info {
    return Intl.message(
      'View system information',
      name: 'tools_action_view_system_info',
      desc: '',
      args: [],
    );
  }

  /// `Check the key information of the system for quick consultation\n\nTime -consuming operation, please wait patiently.`
  String get tools_action_info_view_critical_system_info {
    return Intl.message(
      'Check the key information of the system for quick consultation\n\nTime -consuming operation, please wait patiently.',
      name: 'tools_action_info_view_critical_system_info',
      desc: '',
      args: [],
    );
  }

  /// `P4k diversion download / repair`
  String get tools_action_p4k_download_repair {
    return Intl.message(
      'P4k diversion download / repair',
      name: 'tools_action_p4k_download_repair',
      desc: '',
      args: [],
    );
  }

  /// `The diversion download service provided by citizenwiki.cn can be used to download or fix P4K.\nLimited resources, please do not abuse.`
  String get tools_action_info_p4k_download_repair_tip {
    return Intl.message(
      'The diversion download service provided by citizenwiki.cn can be used to download or fix P4K.\nLimited resources, please do not abuse.',
      name: 'tools_action_info_p4k_download_repair_tip',
      desc: '',
      args: [],
    );
  }

  /// `Hosts acceleration (experimental)`
  String get tools_action_hosts_acceleration_experimental {
    return Intl.message(
      'Hosts acceleration (experimental)',
      name: 'tools_action_hosts_acceleration_experimental',
      desc: '',
      args: [],
    );
  }

  /// `Write the IP information into the hosts file to solve problems such as DNS pollution in some regions that cannot log in to the official website.\nThis function is undergoing the first stage of testing. Please report it in time when you encounter problems.`
  String get tools_action_info_hosts_acceleration_experimental_tip {
    return Intl.message(
      'Write the IP information into the hosts file to solve problems such as DNS pollution in some regions that cannot log in to the official website.\nThis function is undergoing the first stage of testing. Please report it in time when you encounter problems.',
      name: 'tools_action_info_hosts_acceleration_experimental_tip',
      desc: '',
      args: [],
    );
  }

  /// `Reinstall EasyAnticheat`
  String get tools_action_reinstall_easyanticheat {
    return Intl.message(
      'Reinstall EasyAnticheat',
      name: 'tools_action_reinstall_easyanticheat',
      desc: '',
      args: [],
    );
  }

  /// `If you encounter EAC errors and are invalid automatically, try using this feature to reinstall EAC.`
  String get tools_action_info_reinstall_eac {
    return Intl.message(
      'If you encounter EAC errors and are invalid automatically, try using this feature to reinstall EAC.',
      name: 'tools_action_info_reinstall_eac',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher administrator mode`
  String get tools_action_rsi_launcher_admin_mode {
    return Intl.message(
      'RSI Launcher administrator mode',
      name: 'tools_action_rsi_launcher_admin_mode',
      desc: '',
      args: [],
    );
  }

  /// `Run RSI startups as an administrator may solve some problems.\n\nIf the energy efficiency core shielding parameters are set, it will also be applied here.`
  String get tools_action_info_run_rsi_as_admin {
    return Intl.message(
      'Run RSI startups as an administrator may solve some problems.\n\nIf the energy efficiency core shielding parameters are set, it will also be applied here.',
      name: 'tools_action_info_run_rsi_as_admin',
      desc: '',
      args: [],
    );
  }

  /// `Initialization failed, please take a screenshot report to the developer. {v0}`
  String tools_action_info_init_failed(Object v0) {
    return Intl.message(
      'Initialization failed, please take a screenshot report to the developer. $v0',
      name: 'tools_action_info_init_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `RSI LAUNCHER LOG repair`
  String get tools_action_rsi_launcher_log_fix {
    return Intl.message(
      'RSI LAUNCHER LOG repair',
      name: 'tools_action_rsi_launcher_log_fix',
      desc: '',
      args: [],
    );
  }

  /// `In some cases, the LOG file of the RSI promoter will be damaged, causing the problem to be scanned, and using this tool to clean up the damaged log file.\n\nCurrent log file size: {v0} MB`
  String tools_action_info_rsi_launcher_log_issue(Object v0) {
    return Intl.message(
      'In some cases, the LOG file of the RSI promoter will be damaged, causing the problem to be scanned, and using this tool to clean up the damaged log file.\n\nCurrent log file size: $v0 MB',
      name: 'tools_action_info_rsi_launcher_log_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `Remove the NVMe registry patch`
  String get tools_action_remove_nvme_registry_patch {
    return Intl.message(
      'Remove the NVMe registry patch',
      name: 'tools_action_remove_nvme_registry_patch',
      desc: '',
      args: [],
    );
  }

  /// `If you have a problem with the NVME patch, run this tool. (It may cause game installation/update to be unavailable.)\n\nCurrent patch status: {v0}`
  String tools_action_info_nvme_patch_issue(Object v0) {
    return Intl.message(
      'If you have a problem with the NVME patch, run this tool. (It may cause game installation/update to be unavailable.)\n\nCurrent patch status: $v0',
      name: 'tools_action_info_nvme_patch_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `Not Installed`
  String get tools_action_info_not_installed {
    return Intl.message(
      'Not Installed',
      name: 'tools_action_info_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `Remove the computer to take effect!`
  String get tools_action_info_removed_restart_effective {
    return Intl.message(
      'Remove the computer to take effect!',
      name: 'tools_action_info_removed_restart_effective',
      desc: '',
      args: [],
    );
  }

  /// `Write in the NVMe registry patch`
  String get tools_action_write_nvme_registry_patch {
    return Intl.message(
      'Write in the NVMe registry patch',
      name: 'tools_action_write_nvme_registry_patch',
      desc: '',
      args: [],
    );
  }

  /// `Manually write the NVM patch, this function is used only when you know what you do`
  String get tools_action_info_manual_nvme_patch {
    return Intl.message(
      'Manually write the NVM patch, this function is used only when you know what you do',
      name: 'tools_action_info_manual_nvme_patch',
      desc: '',
      args: [],
    );
  }

  /// `If the repair is successful, please try to restart the computer and continue to install the game! If the registry modification operation causes compatibility problems with other software, please use the NVMe registry in the tool to clean up.`
  String get tools_action_info_fix_success_restart {
    return Intl.message(
      'If the repair is successful, please try to restart the computer and continue to install the game! If the registry modification operation causes compatibility problems with other software, please use the NVMe registry in the tool to clean up.',
      name: 'tools_action_info_fix_success_restart',
      desc: '',
      args: [],
    );
  }

  /// `Clean up the color device cache`
  String get tools_action_clear_shader_cache {
    return Intl.message(
      'Clean up the color device cache',
      name: 'tools_action_clear_shader_cache',
      desc: '',
      args: [],
    );
  }

  /// `If the game screen appears abnormal or the version is updated, you can use the tool to clean the expired color (when it is greater than 500m, it is recommended to clean it)\n\nCache size: {v0} MB`
  String tools_action_info_shader_cache_issue(Object v0) {
    return Intl.message(
      'If the game screen appears abnormal or the version is updated, you can use the tool to clean the expired color (when it is greater than 500m, it is recommended to clean it)\n\nCache size: $v0 MB',
      name: 'tools_action_info_shader_cache_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `Turn off the photography mode`
  String get tools_action_close_photography_mode {
    return Intl.message(
      'Turn off the photography mode',
      name: 'tools_action_close_photography_mode',
      desc: '',
      args: [],
    );
  }

  /// `Turn on the photography mode`
  String get tools_action_open_photography_mode {
    return Intl.message(
      'Turn on the photography mode',
      name: 'tools_action_open_photography_mode',
      desc: '',
      args: [],
    );
  }

  /// `Restoring the lens shaking effect.\n\n@Lapernum offers parameter information.`
  String get tools_action_info_restore_lens_shake {
    return Intl.message(
      'Restoring the lens shaking effect.\n\n@Lapernum offers parameter information.',
      name: 'tools_action_info_restore_lens_shake',
      desc: '',
      args: [],
    );
  }

  /// `Close the game endoscope shaking to facilitate photography operations.\n\n @Lapernum offers parameter information.`
  String get tools_action_info_one_key_close_lens_shake {
    return Intl.message(
      'Close the game endoscope shaking to facilitate photography operations.\n\n @Lapernum offers parameter information.',
      name: 'tools_action_info_one_key_close_lens_shake',
      desc: '',
      args: [],
    );
  }

  /// `Analysis of LOG files failed!\nTry to use RSI Launcher Log repair tool!`
  String get tools_action_info_log_file_parse_failed {
    return Intl.message(
      'Analysis of LOG files failed!\nTry to use RSI Launcher Log repair tool!',
      name: 'tools_action_info_log_file_parse_failed',
      desc: '',
      args: [],
    );
  }

  /// `If the RSI label is not found, try to reinstall it or add it manually in the settings.`
  String get tools_action_info_rsi_launcher_not_found {
    return Intl.message(
      'If the RSI label is not found, try to reinstall it or add it manually in the settings.',
      name: 'tools_action_info_rsi_launcher_not_found',
      desc: '',
      args: [],
    );
  }

  /// `If the interstellar game installation location is not found, please complete the game startup operation at least once or add it manually in the settings.`
  String get tools_action_info_star_citizen_not_found {
    return Intl.message(
      'If the interstellar game installation location is not found, please complete the game startup operation at least once or add it manually in the settings.',
      name: 'tools_action_info_star_citizen_not_found',
      desc: '',
      args: [],
    );
  }

  /// `This function requires an effective game installation directory`
  String get tools_action_info_valid_game_directory_needed {
    return Intl.message(
      'This function requires an effective game installation directory',
      name: 'tools_action_info_valid_game_directory_needed',
      desc: '',
      args: [],
    );
  }

  /// `Remove the EAC file for you, and then open the RSI startup for you. Please go to Settings-> Verify to reinstall EAC.`
  String get tools_action_info_eac_file_removed {
    return Intl.message(
      'Remove the EAC file for you, and then open the RSI startup for you. Please go to Settings-> Verify to reinstall EAC.',
      name: 'tools_action_info_eac_file_removed',
      desc: '',
      args: [],
    );
  }

  /// `Error: {v0}`
  String tools_action_info_error_occurred(Object v0) {
    return Intl.message(
      'Error: $v0',
      name: 'tools_action_info_error_occurred',
      desc: '',
      args: [v0],
    );
  }

  /// `System: {v0}\n\nProcessor: {v1}\n\nMemory size: {v2} gb\n\nGraphics card information:\n{v3}\n\nStorage information:\n{v4}\n\n`
  String tools_action_info_system_info_content(
      Object v0, Object v1, Object v2, Object v3, Object v4) {
    return Intl.message(
      'System: $v0\n\nProcessor: $v1\n\nMemory size: $v2 gb\n\nGraphics card information:\n$v3\n\nStorage information:\n$v4\n\n',
      name: 'tools_action_info_system_info_content',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `If the RSI Launcher directory is not found, please try manually.`
  String get tools_action_info_rsi_launcher_directory_not_found {
    return Intl.message(
      'If the RSI Launcher directory is not found, please try manually.',
      name: 'tools_action_info_rsi_launcher_directory_not_found',
      desc: '',
      args: [],
    );
  }

  /// `The log file does not exist, please try to start a game startup or game installation, and exit the RSI Launcher. If the problem cannot be solved, try to update the launcher to the latest version!`
  String get tools_action_info_log_file_not_exist {
    return Intl.message(
      'The log file does not exist, please try to start a game startup or game installation, and exit the RSI Launcher. If the problem cannot be solved, try to update the launcher to the latest version!',
      name: 'tools_action_info_log_file_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `After cleaning up, complete the installation / game startup operation once.`
  String get tools_action_info_cleanup_complete {
    return Intl.message(
      'After cleaning up, complete the installation / game startup operation once.',
      name: 'tools_action_info_cleanup_complete',
      desc: '',
      args: [],
    );
  }

  /// `Failure to clean up, please remove manually, file location: {v0}`
  String tools_action_info_cleanup_failed(Object v0) {
    return Intl.message(
      'Failure to clean up, please remove manually, file location: $v0',
      name: 'tools_action_info_cleanup_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `System message`
  String get tools_action_info_system_info_title {
    return Intl.message(
      'System message',
      name: 'tools_action_info_system_info_title',
      desc: '',
      args: [],
    );
  }

  /// `The RSI Launcher is running! Please turn off the label first and then use this feature!`
  String get tools_action_info_rsi_launcher_running_warning {
    return Intl.message(
      'The RSI Launcher is running! Please turn off the label first and then use this feature!',
      name: 'tools_action_info_rsi_launcher_running_warning',
      desc: '',
      args: [],
    );
  }

  /// `P4K is the core game file of interstellar citizens, as high as 100GB+. The offline download provided by the box is to help some P4K files download super slow users or to repair the P4K file that the official launch cannot be repaired.\n\nNext, you will pop up the window and ask you to save the position (you can choose the Star Citizens Folder or you can choose elsewhere). After downloading, please make sure that the P4K folder is located in the LIVE folder, and then use the RSI Launcher to check it.`
  String get tools_action_info_p4k_file_description {
    return Intl.message(
      'P4K is the core game file of interstellar citizens, as high as 100GB+. The offline download provided by the box is to help some P4K files download super slow users or to repair the P4K file that the official launch cannot be repaired.\n\nNext, you will pop up the window and ask you to save the position (you can choose the Star Citizens Folder or you can choose elsewhere). After downloading, please make sure that the P4K folder is located in the LIVE folder, and then use the RSI Launcher to check it.',
      name: 'tools_action_info_p4k_file_description',
      desc: '',
      args: [],
    );
  }

  /// `There is already a P4K download task in progress, please go to the download manager to view!`
  String get tools_action_info_p4k_download_in_progress {
    return Intl.message(
      'There is already a P4K download task in progress, please go to the download manager to view!',
      name: 'tools_action_info_p4k_download_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `During functional maintenance, please try it later!`
  String get tools_action_info_function_under_maintenance {
    return Intl.message(
      'During functional maintenance, please try it later!',
      name: 'tools_action_info_function_under_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `The configuration file does not exist, please try to run the game once`
  String get tools_action_info_config_file_not_exist {
    return Intl.message(
      'The configuration file does not exist, please try to run the game once',
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

  /// `Total invitation:`
  String get webview_localization_total_invitations {
    return Intl.message(
      'Total invitation:',
      name: 'webview_localization_total_invitations',
      desc: '',
      args: [],
    );
  }

  /// `Undead invitation`
  String get webview_localization_unfinished_invitations {
    return Intl.message(
      'Undead invitation',
      name: 'webview_localization_unfinished_invitations',
      desc: '',
      args: [],
    );
  }

  /// `Completed invitations`
  String get webview_localization_finished_invitations {
    return Intl.message(
      'Completed invitations',
      name: 'webview_localization_finished_invitations',
      desc: '',
      args: [],
    );
  }

  /// `Initialization failure: {v0}`
  String app_init_failed_with_reason(Object v0) {
    return Intl.message(
      'Initialization failure: $v0',
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

  /// `Automatic`
  String get settings_app_language_auto {
    return Intl.message(
      'Automatic',
      name: 'settings_app_language_auto',
      desc: '',
      args: [],
    );
  }

  /// `Network anomaly!\nThis may be that your network environment has DNS pollution, please try to replace DNS.\nOr the server is being maintained or attacked and tried it later.\nEnter the offline mode ...\n\nPlease use it carefully in the offline mode.\nThe current version of the construction date: {v0}\n QQ group: 940696487\nError message: {v1}`
  String app_common_network_error(Object v0, Object v1) {
    return Intl.message(
      'Network anomaly!\nThis may be that your network environment has DNS pollution, please try to replace DNS.\nOr the server is being maintained or attacked and tried it later.\nEnter the offline mode ...\n\nPlease use it carefully in the offline mode.\nThe current version of the construction date: $v0\n QQ group: 940696487\nError message: $v1',
      name: 'app_common_network_error',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `If the update information fails, please try it later.`
  String get app_common_upgrade_info_error {
    return Intl.message(
      'If the update information fails, please try it later.',
      name: 'app_common_upgrade_info_error',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient memory`
  String get doctor_game_error_low_memory {
    return Intl.message(
      'Insufficient memory',
      name: 'doctor_game_error_low_memory',
      desc: '',
      args: [],
    );
  }

  /// `Please try to increase virtual memory (under 1080P, physical available+virtual memory need> 64g)`
  String get doctor_game_error_low_memory_info {
    return Intl.message(
      'Please try to increase virtual memory (under 1080P, physical available+virtual memory need> 64g)',
      name: 'doctor_game_error_low_memory_info',
      desc: '',
      args: [],
    );
  }

  /// `The game triggered a generic crash, please check the trouble shooting guide`
  String get doctor_game_error_generic_info {
    return Intl.message(
      'The game triggered a generic crash, please check the trouble shooting guide',
      name: 'doctor_game_error_generic_info',
      desc: '',
      args: [],
    );
  }

  /// `Your graphics card crashes! Please check the barrier guide`
  String get doctor_game_error_gpu_crash {
    return Intl.message(
      'Your graphics card crashes! Please check the barrier guide',
      name: 'doctor_game_error_gpu_crash',
      desc: '',
      args: [],
    );
  }

  /// `Detected SOCKET abnormalities`
  String get doctor_game_error_socket_error {
    return Intl.message(
      'Detected SOCKET abnormalities',
      name: 'doctor_game_error_socket_error',
      desc: '',
      args: [],
    );
  }

  /// `If you use the X black box accelerator, try to replace the acceleration mode`
  String get doctor_game_error_socket_error_info {
    return Intl.message(
      'If you use the X black box accelerator, try to replace the acceleration mode',
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

  /// `Please try to run a RSI Launcher at the administrator authority, or use the box (Microsoft Store version) to start.`
  String get doctor_game_error_permissions_error_info {
    return Intl.message(
      'Please try to run a RSI Launcher at the administrator authority, or use the box (Microsoft Store version) to start.',
      name: 'doctor_game_error_permissions_error_info',
      desc: '',
      args: [],
    );
  }

  /// `The game process is occupied`
  String get doctor_game_error_game_process_error {
    return Intl.message(
      'The game process is occupied',
      name: 'doctor_game_error_game_process_error',
      desc: '',
      args: [],
    );
  }

  /// `Please try to restart the RSI Launcher, or restart the computer directly`
  String get doctor_game_error_game_process_error_info {
    return Intl.message(
      'Please try to restart the RSI Launcher, or restart the computer directly',
      name: 'doctor_game_error_game_process_error_info',
      desc: '',
      args: [],
    );
  }

  /// `Game program file damage`
  String get doctor_game_error_game_damaged_file {
    return Intl.message(
      'Game program file damage',
      name: 'doctor_game_error_game_damaged_file',
      desc: '',
      args: [],
    );
  }

  /// `Please try to delete the Bin64 folder and check in the launcher.`
  String get doctor_game_error_game_damaged_file_info {
    return Intl.message(
      'Please try to delete the Bin64 folder and check in the launcher.',
      name: 'doctor_game_error_game_damaged_file_info',
      desc: '',
      args: [],
    );
  }

  /// `P4K file damage`
  String get doctor_game_error_game_damaged_p4k_file {
    return Intl.message(
      'P4K file damage',
      name: 'doctor_game_error_game_damaged_p4k_file',
      desc: '',
      args: [],
    );
  }

  /// `Please try to delete the data.p4k file and check or use the box to divert in the promoter.`
  String get doctor_game_error_game_damaged_p4k_file_info {
    return Intl.message(
      'Please try to delete the data.p4k file and check or use the box to divert in the promoter.',
      name: 'doctor_game_error_game_damaged_p4k_file_info',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient VRAM`
  String get doctor_game_error_low_gpu_memory {
    return Intl.message(
      'Insufficient VRAM',
      name: 'doctor_game_error_low_gpu_memory',
      desc: '',
      args: [],
    );
  }

  /// `Please do not run the game/application occupied by other high graphics cards in the background, or change the graphics card.`
  String get doctor_game_error_low_gpu_memory_info {
    return Intl.message(
      'Please do not run the game/application occupied by other high graphics cards in the background, or change the graphics card.',
      name: 'doctor_game_error_low_gpu_memory_info',
      desc: '',
      args: [],
    );
  }

  /// `Error: {v0}`
  String app_common_error_info(Object v0) {
    return Intl.message(
      'Error: $v0',
      name: 'app_common_error_info',
      desc: '',
      args: [v0],
    );
  }

  /// `Hint`
  String get app_common_tip {
    return Intl.message(
      'Hint',
      name: 'app_common_tip',
      desc: '',
      args: [],
    );
  }

  /// `I understand`
  String get app_common_tip_i_know {
    return Intl.message(
      'I understand',
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

  /// `Switch application Display language`
  String get settings_app_language_switch_info {
    return Intl.message(
      'Switch application Display language',
      name: 'settings_app_language_switch_info',
      desc: '',
      args: [],
    );
  }

  /// `{v0} Day  `
  String home_holiday_countdown_days(Object v0) {
    return Intl.message(
      '$v0 Day  ',
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

  /// `Loading image ...`
  String get app_common_loading_images {
    return Intl.message(
      'Loading image ...',
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

  /// `Thank you for choosing the SCToolBox box. We are committed to providing you with a safe, convenient and reliable experience. Before you start using your application, please read and agree to the following:\n\n 1. This application is an open source software under the GNU General Public License V3.0 protocol. You can use, modify, and distribute this software freely under the premise of obeying the agreement. Our source code is located at: [github.com/starCitizentoolBox/app] (https://github.com/starCitizantoolBox/app).\n2. The copyright of the Internet content in this application (including but not limited to localized documents, tool websites, news, videos, etc.) is created by its authors and is not part of GPL. Please use it under the corresponding authorization agreement.\n3. The official free release channels for this application are: [Microsoft App Store] (https://apps.microsoft.com/detail/9NF3SWFWNKL1) and [Official Website of Star Citizen Chinese] ), If you get from other third parties, please identify it carefully to avoid suffering from property losses.\n4. This application will send anonymous statistics to our server during use to improve software quality, and we will not collect any personal privacy information of your personal privacy.\n5. This application is supported by the community and has no direct connection with Cloud Imperium Games or other third -party commercial companies.\n6. We provide limited community support. If necessary, please go to the page to learn how to contact us.`
  String get app_splash_dialog_u_a_p_p_content {
    return Intl.message(
      'Thank you for choosing the SCToolBox box. We are committed to providing you with a safe, convenient and reliable experience. Before you start using your application, please read and agree to the following:\n\n 1. This application is an open source software under the GNU General Public License V3.0 protocol. You can use, modify, and distribute this software freely under the premise of obeying the agreement. Our source code is located at: [github.com/starCitizentoolBox/app] (https://github.com/starCitizantoolBox/app).\n2. The copyright of the Internet content in this application (including but not limited to localized documents, tool websites, news, videos, etc.) is created by its authors and is not part of GPL. Please use it under the corresponding authorization agreement.\n3. The official free release channels for this application are: [Microsoft App Store] (https://apps.microsoft.com/detail/9NF3SWFWNKL1) and [Official Website of Star Citizen Chinese] ), If you get from other third parties, please identify it carefully to avoid suffering from property losses.\n4. This application will send anonymous statistics to our server during use to improve software quality, and we will not collect any personal privacy information of your personal privacy.\n5. This application is supported by the community and has no direct connection with Cloud Imperium Games or other third -party commercial companies.\n6. We provide limited community support. If necessary, please go to the page to learn how to contact us.',
      name: 'app_splash_dialog_u_a_p_p_content',
      desc: '',
      args: [],
    );
  }

  /// `Initialization ...`
  String get tools_unp4k_msg_init {
    return Intl.message(
      'Initialization ...',
      name: 'tools_unp4k_msg_init',
      desc: '',
      args: [],
    );
  }

  /// `Reading P4K file ...`
  String get tools_unp4k_msg_reading {
    return Intl.message(
      'Reading P4K file ...',
      name: 'tools_unp4k_msg_reading',
      desc: '',
      args: [],
    );
  }

  /// `Treatment files ...`
  String get tools_unp4k_msg_reading2 {
    return Intl.message(
      'Treatment files ...',
      name: 'tools_unp4k_msg_reading2',
      desc: '',
      args: [],
    );
  }

  /// `Processing files ({v0}/{v1}) ...`
  String tools_unp4k_msg_reading3(Object v0, Object v1) {
    return Intl.message(
      'Processing files ($v0/$v1) ...',
      name: 'tools_unp4k_msg_reading3',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `After loading: {v0} a file, time: {v1} ms`
  String tools_unp4k_msg_read_completed(Object v0, Object v1) {
    return Intl.message(
      'After loading: $v0 a file, time: $v1 ms',
      name: 'tools_unp4k_msg_read_completed',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Open the file: {v0}`
  String tools_unp4k_msg_open_file(Object v0) {
    return Intl.message(
      'Open the file: $v0',
      name: 'tools_unp4k_msg_open_file',
      desc: '',
      args: [v0],
    );
  }

  /// `Read file: {v0} ...`
  String tools_unp4k_msg_read_file(Object v0) {
    return Intl.message(
      'Read file: $v0 ...',
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

  /// `Localization version has been loaded: {v0}`
  String home_localization_advanced_msg_version(Object v0) {
    return Intl.message(
      'Localization version has been loaded: $v0',
      name: 'home_localization_advanced_msg_version',
      desc: '',
      args: [v0],
    );
  }

  /// `Localization text lines: {v0} P4K text lines: {v1}`
  String home_localization_advanced_title_msg(Object v0, Object v1) {
    return Intl.message(
      'Localization text lines: $v0 P4K text lines: $v1',
      name: 'home_localization_advanced_title_msg',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `Installation of Localization`
  String get home_localization_advanced_action_install {
    return Intl.message(
      'Installation of Localization',
      name: 'home_localization_advanced_action_install',
      desc: '',
      args: [],
    );
  }

  /// `The text is being re -generated ...`
  String get home_localization_advanced_action_mod_change {
    return Intl.message(
      'The text is being re -generated ...',
      name: 'home_localization_advanced_action_mod_change',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get home_localization_advanced_action_mode {
    return Intl.message(
      'Model',
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

  /// `Location-Other`
  String get home_localization_advanced_json_text_location_other {
    return Intl.message(
      'Location-Other',
      name: 'home_localization_advanced_json_text_location_other',
      desc: '',
      args: [],
    );
  }

  /// `Location-Commonly used`
  String get home_localization_advanced_json_text_location_used {
    return Intl.message(
      'Location-Commonly used',
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

  /// `Items-Commonly used`
  String get home_localization_advanced_json_text_things_used {
    return Intl.message(
      'Items-Commonly used',
      name: 'home_localization_advanced_json_text_things_used',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle-Other`
  String get home_localization_advanced_json_text_vehicle_other {
    return Intl.message(
      'Vehicle-Other',
      name: 'home_localization_advanced_json_text_vehicle_other',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle-Commonly used`
  String get home_localization_advanced_json_text_vehicle_used {
    return Intl.message(
      'Vehicle-Commonly used',
      name: 'home_localization_advanced_json_text_vehicle_used',
      desc: '',
      args: [],
    );
  }

  /// `Mission/Log`
  String get home_localization_advanced_json_text_mission_or_logs {
    return Intl.message(
      'Mission/Log',
      name: 'home_localization_advanced_json_text_mission_or_logs',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle`
  String get home_localization_advanced_json_text_subtitle {
    return Intl.message(
      'Subtitle',
      name: 'home_localization_advanced_json_text_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `UI/HUD/menu`
  String get home_localization_advanced_json_text_ui_or_hud_or_menu {
    return Intl.message(
      'UI/HUD/menu',
      name: 'home_localization_advanced_json_text_ui_or_hud_or_menu',
      desc: '',
      args: [],
    );
  }

  /// `Unwaver`
  String get home_localization_advanced_json_text_un_localization {
    return Intl.message(
      'Unwaver',
      name: 'home_localization_advanced_json_text_un_localization',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get home_localization_advanced_json_text_others {
    return Intl.message(
      'Other',
      name: 'home_localization_advanced_json_text_others',
      desc: '',
      args: [],
    );
  }

  /// `Localization`
  String get home_localization_advanced_action_mod_change_localization {
    return Intl.message(
      'Localization',
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

  /// `Bilingual (newline)`
  String get home_localization_advanced_action_mod_change_mixed_newline {
    return Intl.message(
      'Bilingual (newline)',
      name: 'home_localization_advanced_action_mod_change_mixed_newline',
      desc: '',
      args: [],
    );
  }

  /// `Classified ...`
  String get home_localization_advanced_msg_classifying {
    return Intl.message(
      'Classified ...',
      name: 'home_localization_advanced_msg_classifying',
      desc: '',
      args: [],
    );
  }

  /// `Read p4k file ...`
  String get home_localization_advanced_msg_reading_p4k {
    return Intl.message(
      'Read p4k file ...',
      name: 'home_localization_advanced_msg_reading_p4k',
      desc: '',
      args: [],
    );
  }

  /// `Get Localization text ...`
  String get home_localization_advanced_msg_reading_server_localization_text {
    return Intl.message(
      'Get Localization text ...',
      name: 'home_localization_advanced_msg_reading_server_localization_text',
      desc: '',
      args: [],
    );
  }

  /// `Generate Localization file ...`
  String get home_localization_advanced_msg_gen_localization_text {
    return Intl.message(
      'Generate Localization file ...',
      name: 'home_localization_advanced_msg_gen_localization_text',
      desc: '',
      args: [],
    );
  }

  /// `Install Localization file ...`
  String get home_localization_advanced_msg_gen_localization_install {
    return Intl.message(
      'Install Localization file ...',
      name: 'home_localization_advanced_msg_gen_localization_install',
      desc: '',
      args: [],
    );
  }

  /// `(Advanced)`
  String get home_localization_msg_version_advanced {
    return Intl.message(
      '(Advanced)',
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

  /// `RSILauncher Localization`
  String get home_localization_action_rsi_launcher_localization {
    return Intl.message(
      'RSILauncher Localization',
      name: 'home_localization_action_rsi_launcher_localization',
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

  /// `Install custom file`
  String get home_localization_action_install_customize {
    return Intl.message(
      'Install custom file',
      name: 'home_localization_action_install_customize',
      desc: '',
      args: [],
    );
  }

  /// `Localization tool`
  String get home_localization_title_localization_tools {
    return Intl.message(
      'Localization tool',
      name: 'home_localization_title_localization_tools',
      desc: '',
      args: [],
    );
  }

  /// `Swip light after the screen light`
  String get performance_json_text_ssdo {
    return Intl.message(
      'Swip light after the screen light',
      name: 'performance_json_text_ssdo',
      desc: '',
      args: [],
    );
  }

  /// `After adjusting the light, processing level`
  String get performance_json_text_ssdo_info {
    return Intl.message(
      'After adjusting the light, processing level',
      name: 'performance_json_text_ssdo_info',
      desc: '',
      args: [],
    );
  }

  /// `Graphic`
  String get performance_json_text_title_graphics {
    return Intl.message(
      'Graphic',
      name: 'performance_json_text_title_graphics',
      desc: '',
      args: [],
    );
  }

  /// `Anti -aliasing`
  String get performance_json_text_antialiasing {
    return Intl.message(
      'Anti -aliasing',
      name: 'performance_json_text_antialiasing',
      desc: '',
      args: [],
    );
  }

  /// `0 Close, 1 SMAA, 2 time filter+SMAA, 3 time filtering and projection matrix shake SMAA`
  String get performance_json_text_antialiasing_info {
    return Intl.message(
      '0 Close, 1 SMAA, 2 time filter+SMAA, 3 time filtering and projection matrix shake SMAA',
      name: 'performance_json_text_antialiasing_info',
      desc: '',
      args: [],
    );
  }

  /// `Special effect level`
  String get performance_json_text_game_effects {
    return Intl.message(
      'Special effect level',
      name: 'performance_json_text_game_effects',
      desc: '',
      args: [],
    );
  }

  /// `Game special effect level`
  String get performance_json_text_game_effects_info {
    return Intl.message(
      'Game special effect level',
      name: 'performance_json_text_game_effects_info',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get performance_json_text_texture {
    return Intl.message(
      'Grade',
      name: 'performance_json_text_texture',
      desc: '',
      args: [],
    );
  }

  /// `Model texture details`
  String get performance_json_text_texture_info {
    return Intl.message(
      'Model texture details',
      name: 'performance_json_text_texture_info',
      desc: '',
      args: [],
    );
  }

  /// `Volume effect`
  String get performance_json_text_volumetric_effects {
    return Intl.message(
      'Volume effect',
      name: 'performance_json_text_volumetric_effects',
      desc: '',
      args: [],
    );
  }

  /// `Volume cloud, volume light, etc.`
  String get performance_json_text_volumetric_effects_info {
    return Intl.message(
      'Volume cloud, volume light, etc.',
      name: 'performance_json_text_volumetric_effects_info',
      desc: '',
      args: [],
    );
  }

  /// `Water effect`
  String get performance_json_text_water {
    return Intl.message(
      'Water effect',
      name: 'performance_json_text_water',
      desc: '',
      args: [],
    );
  }

  /// `Grade of various water`
  String get performance_json_text_water_info {
    return Intl.message(
      'Grade of various water',
      name: 'performance_json_text_water_info',
      desc: '',
      args: [],
    );
  }

  /// `Object detail`
  String get performance_json_text_object_detail {
    return Intl.message(
      'Object detail',
      name: 'performance_json_text_object_detail',
      desc: '',
      args: [],
    );
  }

  /// `Model object details, affect LOD, etc.`
  String get performance_json_text_object_detail_info {
    return Intl.message(
      'Model object details, affect LOD, etc.',
      name: 'performance_json_text_object_detail_info',
      desc: '',
      args: [],
    );
  }

  /// `Particle details`
  String get performance_json_text_particles {
    return Intl.message(
      'Particle details',
      name: 'performance_json_text_particles',
      desc: '',
      args: [],
    );
  }

  /// `Physical details`
  String get performance_json_text_physics {
    return Intl.message(
      'Physical details',
      name: 'performance_json_text_physics',
      desc: '',
      args: [],
    );
  }

  /// `Scope of physical effects`
  String get performance_json_text_physics_info {
    return Intl.message(
      'Scope of physical effects',
      name: 'performance_json_text_physics_info',
      desc: '',
      args: [],
    );
  }

  /// `Colorrhea details`
  String get performance_json_text_shading {
    return Intl.message(
      'Colorrhea details',
      name: 'performance_json_text_shading',
      desc: '',
      args: [],
    );
  }

  /// `Coloror related`
  String get performance_json_text_shading_info {
    return Intl.message(
      'Coloror related',
      name: 'performance_json_text_shading_info',
      desc: '',
      args: [],
    );
  }

  /// `Shadow details`
  String get performance_json_text_shadows {
    return Intl.message(
      'Shadow details',
      name: 'performance_json_text_shadows',
      desc: '',
      args: [],
    );
  }

  /// `Shadow effect`
  String get performance_json_text_shadows_info {
    return Intl.message(
      'Shadow effect',
      name: 'performance_json_text_shadows_info',
      desc: '',
      args: [],
    );
  }

  /// `Post -processing details`
  String get performance_json_text_postprocessing {
    return Intl.message(
      'Post -processing details',
      name: 'performance_json_text_postprocessing',
      desc: '',
      args: [],
    );
  }

  /// `After the color device, dynamic blur effect, etc.`
  String get performance_json_text_postprocessing_info {
    return Intl.message(
      'After the color device, dynamic blur effect, etc.',
      name: 'performance_json_text_postprocessing_info',
      desc: '',
      args: [],
    );
  }

  /// `Rendering device quality`
  String get performance_json_text_renderer {
    return Intl.message(
      'Rendering device quality',
      name: 'performance_json_text_renderer',
      desc: '',
      args: [],
    );
  }

  /// `Cryengine rendereer quality`
  String get performance_json_text_renderer_info {
    return Intl.message(
      'Cryengine rendereer quality',
      name: 'performance_json_text_renderer_info',
      desc: '',
      args: [],
    );
  }

  /// `Quality`
  String get performance_json_text_shader_decal {
    return Intl.message(
      'Quality',
      name: 'performance_json_text_shader_decal',
      desc: '',
      args: [],
    );
  }

  /// `(LOGO, logo, etc.)`
  String get performance_json_text_shader_decal_info {
    return Intl.message(
      '(LOGO, logo, etc.)',
      name: 'performance_json_text_shader_decal_info',
      desc: '',
      args: [],
    );
  }

  /// `Color quality`
  String get performance_json_text_shader_post_process {
    return Intl.message(
      'Color quality',
      name: 'performance_json_text_shader_post_process',
      desc: '',
      args: [],
    );
  }

  /// `FX quality`
  String get performance_json_text_shader_fx {
    return Intl.message(
      'FX quality',
      name: 'performance_json_text_shader_fx',
      desc: '',
      args: [],
    );
  }

  /// `Conventional quality`
  String get performance_json_text_shader_general {
    return Intl.message(
      'Conventional quality',
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

  /// `Glass quality`
  String get performance_json_text_shader_glass {
    return Intl.message(
      'Glass quality',
      name: 'performance_json_text_shader_glass',
      desc: '',
      args: [],
    );
  }

  /// `Window, mirror, etc.`
  String get performance_json_text_shader_glass_info {
    return Intl.message(
      'Window, mirror, etc.',
      name: 'performance_json_text_shader_glass_info',
      desc: '',
      args: [],
    );
  }

  /// `HDR quality`
  String get performance_json_text_shader_hdr {
    return Intl.message(
      'HDR quality',
      name: 'performance_json_text_shader_hdr',
      desc: '',
      args: [],
    );
  }

  /// `HDR color difference, brightness level treatment, etc.`
  String get performance_json_text_shader_hdr_info {
    return Intl.message(
      'HDR color difference, brightness level treatment, etc.',
      name: 'performance_json_text_shader_hdr_info',
      desc: '',
      args: [],
    );
  }

  /// `Particle quality`
  String get performance_json_text_shader_particle {
    return Intl.message(
      'Particle quality',
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

  /// `Ground quality`
  String get performance_json_text_shader_terrain {
    return Intl.message(
      'Ground quality',
      name: 'performance_json_text_shader_terrain',
      desc: '',
      args: [],
    );
  }

  /// `Shadow quality`
  String get performance_json_text_shader_shadow {
    return Intl.message(
      'Shadow quality',
      name: 'performance_json_text_shader_shadow',
      desc: '',
      args: [],
    );
  }

  /// `Sky quality`
  String get performance_json_text_shader_sky {
    return Intl.message(
      'Sky quality',
      name: 'performance_json_text_shader_sky',
      desc: '',
      args: [],
    );
  }

  /// `Particle collision`
  String get performance_json_text_particles_object_collisions {
    return Intl.message(
      'Particle collision',
      name: 'performance_json_text_particles_object_collisions',
      desc: '',
      args: [],
    );
  }

  /// `1 Static particles 2 include dynamic particles`
  String get performance_json_text_particles_object_collisions_info {
    return Intl.message(
      '1 Static particles 2 include dynamic particles',
      name: 'performance_json_text_particles_object_collisions_info',
      desc: '',
      args: [],
    );
  }

  /// `Screen information (display frame rate)`
  String get performance_json_text_displayinfo {
    return Intl.message(
      'Screen information (display frame rate)',
      name: 'performance_json_text_displayinfo',
      desc: '',
      args: [],
    );
  }

  /// `Display frame rates, server information, etc. in the upper right corner of the screen`
  String get performance_json_text_displayinfo_info {
    return Intl.message(
      'Display frame rates, server information, etc. in the upper right corner of the screen',
      name: 'performance_json_text_displayinfo_info',
      desc: '',
      args: [],
    );
  }

  /// `Maximum frame rate`
  String get performance_json_text_max_fps {
    return Intl.message(
      'Maximum frame rate',
      name: 'performance_json_text_max_fps',
      desc: '',
      args: [],
    );
  }

  /// `Adjust the maximum frame rate of the game, 0 is not limited`
  String get performance_json_text_max_fps_info {
    return Intl.message(
      'Adjust the maximum frame rate of the game, 0 is not limited',
      name: 'performance_json_text_max_fps_info',
      desc: '',
      args: [],
    );
  }

  /// `Display session information`
  String get performance_json_text_display_session {
    return Intl.message(
      'Display session information',
      name: 'performance_json_text_display_session',
      desc: '',
      args: [],
    );
  }

  /// `After turning on, display a QR code on the screen to allow CIG to quickly locate related information when feedback`
  String get performance_json_text_display_session_info {
    return Intl.message(
      'After turning on, display a QR code on the screen to allow CIG to quickly locate related information when feedback',
      name: 'performance_json_text_display_session_info',
      desc: '',
      args: [],
    );
  }

  /// `Vertical sync`
  String get performance_json_text_vsync {
    return Intl.message(
      'Vertical sync',
      name: 'performance_json_text_vsync',
      desc: '',
      args: [],
    );
  }

  /// `Open to prevent tearing, turn off to increase the frame rate`
  String get performance_json_text_vsync_info {
    return Intl.message(
      'Open to prevent tearing, turn off to increase the frame rate',
      name: 'performance_json_text_vsync_info',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic blur`
  String get performance_json_text_motion_blur {
    return Intl.message(
      'Dynamic blur',
      name: 'performance_json_text_motion_blur',
      desc: '',
      args: [],
    );
  }

  /// `Open to improve the sense of movement, turn off and enhance the perception`
  String get performance_json_text_motion_blur_info {
    return Intl.message(
      'Open to improve the sense of movement, turn off and enhance the perception',
      name: 'performance_json_text_motion_blur_info',
      desc: '',
      args: [],
    );
  }

  /// `Set viewing angle FOV`
  String get performance_json_text_fov {
    return Intl.message(
      'Set viewing angle FOV',
      name: 'performance_json_text_fov',
      desc: '',
      args: [],
    );
  }

  /// `UI fades into the animation`
  String get performance_json_text_ui_animation {
    return Intl.message(
      'UI fades into the animation',
      name: 'performance_json_text_ui_animation',
      desc: '',
      args: [],
    );
  }

  /// `Custom parameter`
  String get performance_json_text_custom_parameters {
    return Intl.message(
      'Custom parameter',
      name: 'performance_json_text_custom_parameters',
      desc: '',
      args: [],
    );
  }

  /// `Customize`
  String get performance_json_text_title_custom {
    return Intl.message(
      'Customize',
      name: 'performance_json_text_title_custom',
      desc: '',
      args: [],
    );
  }

  /// `Read the RSI Launcher information ...`
  String get tools_rsi_launcher_enhance_init_msg1 {
    return Intl.message(
      'Read the RSI Launcher information ...',
      name: 'tools_rsi_launcher_enhance_init_msg1',
      desc: '',
      args: [],
    );
  }

  /// `Obtaining enhanced data from the Internet ...`
  String get tools_rsi_launcher_enhance_init_msg2 {
    return Intl.message(
      'Obtaining enhanced data from the Internet ...',
      name: 'tools_rsi_launcher_enhance_init_msg2',
      desc: '',
      args: [],
    );
  }

  /// `Generate patch ...`
  String get tools_rsi_launcher_enhance_working_msg1 {
    return Intl.message(
      'Generate patch ...',
      name: 'tools_rsi_launcher_enhance_working_msg1',
      desc: '',
      args: [],
    );
  }

  /// `Installation patch takes a little time, depending on your computer performance ...`
  String get tools_rsi_launcher_enhance_working_msg2 {
    return Intl.message(
      'Installation patch takes a little time, depending on your computer performance ...',
      name: 'tools_rsi_launcher_enhance_working_msg2',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher enhancement`
  String get tools_rsi_launcher_enhance_title {
    return Intl.message(
      'RSI Launcher enhancement',
      name: 'tools_rsi_launcher_enhance_title',
      desc: '',
      args: [],
    );
  }

  /// `Internal version information of the RSI Launcher: {v0}`
  String tools_rsi_launcher_enhance_msg_version(Object v0) {
    return Intl.message(
      'Internal version information of the RSI Launcher: $v0',
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

  /// `Obtaining enhanced data failure may be the network problem or the current version does not support`
  String get tools_rsi_launcher_enhance_msg_error {
    return Intl.message(
      'Obtaining enhanced data failure may be the network problem or the current version does not support',
      name: 'tools_rsi_launcher_enhance_msg_error',
      desc: '',
      args: [],
    );
  }

  /// `RSI startup localization`
  String get tools_rsi_launcher_enhance_title_localization {
    return Intl.message(
      'RSI startup localization',
      name: 'tools_rsi_launcher_enhance_title_localization',
      desc: '',
      args: [],
    );
  }

  /// `Add multi -language support to the RSI Launcher.`
  String get tools_rsi_launcher_enhance_subtitle_localization {
    return Intl.message(
      'Add multi -language support to the RSI Launcher.',
      name: 'tools_rsi_launcher_enhance_subtitle_localization',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher download enhancement`
  String get tools_rsi_launcher_enhance_title_download_booster {
    return Intl.message(
      'RSI Launcher download enhancement',
      name: 'tools_rsi_launcher_enhance_title_download_booster',
      desc: '',
      args: [],
    );
  }

  /// `When downloading the game, you can use more threads to increase the download speed.`
  String get tools_rsi_launcher_enhance_subtitle_download_booster {
    return Intl.message(
      'When downloading the game, you can use more threads to increase the download speed.',
      name: 'tools_rsi_launcher_enhance_subtitle_download_booster',
      desc: '',
      args: [],
    );
  }

  /// `Installation enhanced patch`
  String get tools_rsi_launcher_enhance_action_install {
    return Intl.message(
      'Installation enhanced patch',
      name: 'tools_rsi_launcher_enhance_action_install',
      desc: '',
      args: [],
    );
  }

  /// `* If you need to uninstall the enhanced patch, cover the installation RSI promoter.`
  String get tools_rsi_launcher_enhance_msg_uninstall {
    return Intl.message(
      '* If you need to uninstall the enhanced patch, cover the installation RSI promoter.',
      name: 'tools_rsi_launcher_enhance_msg_uninstall',
      desc: '',
      args: [],
    );
  }

  /// `No RSI promoter was found`
  String get tools_rsi_launcher_enhance_msg_error_launcher_notfound {
    return Intl.message(
      'No RSI promoter was found',
      name: 'tools_rsi_launcher_enhance_msg_error_launcher_notfound',
      desc: '',
      args: [],
    );
  }

  /// `Reading the Launcher information failed!`
  String get tools_rsi_launcher_enhance_msg_error_get_launcher_info_error {
    return Intl.message(
      'Reading the Launcher information failed!',
      name: 'tools_rsi_launcher_enhance_msg_error_get_launcher_info_error',
      desc: '',
      args: [],
    );
  }

  /// `Read the RSI Launcher information failure: {v0}`
  String tools_rsi_launcher_enhance_msg_error_get_launcher_info_error_with_args(
      Object v0) {
    return Intl.message(
      'Read the RSI Launcher information failure: $v0',
      name:
          'tools_rsi_launcher_enhance_msg_error_get_launcher_info_error_with_args',
      desc: '',
      args: [v0],
    );
  }

  /// `Enhanced launcher Localization、 download thread`
  String get tools_action_rsi_launcher_enhance_info {
    return Intl.message(
      'Enhanced launcher Localization、 download thread',
      name: 'tools_action_rsi_launcher_enhance_info',
      desc: '',
      args: [],
    );
  }

  /// `Instructions for the use of RSI Launcher enhancement`
  String get tools_rsi_launcher_enhance_note_title {
    return Intl.message(
      'Instructions for the use of RSI Launcher enhancement',
      name: 'tools_rsi_launcher_enhance_note_title',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher enhancement is a community function. It will unpack "RSI LAUNCHER" on your computer and add additional enhancement functions. What functions are determined by you.\n\nAt present, the official (CIG) only permits us to perform multi -language operations. The launch of the booter download enhancement is an extra function we think of it. Violation of the CIG user protocol (https://robertsspaceindustries.com/eula) may cause serious consequences such as accounts. Whether or not you are determined by yourself, we are not responsible for the possible consequences (game damage, account ban, etc.).\n\nFor the modified content of the Launcher, we are open from: https://github.com/starcitizentoolbox/rsilauncherenhance. If necessary, you can check it yourself.\n\nIf you need to cancel this enhanced patch for any reason, cover the installation of the official RSI Launcher directly.`
  String get tools_rsi_launcher_enhance_note_msg {
    return Intl.message(
      'RSI Launcher enhancement is a community function. It will unpack "RSI LAUNCHER" on your computer and add additional enhancement functions. What functions are determined by you.\n\nAt present, the official (CIG) only permits us to perform multi -language operations. The launch of the booter download enhancement is an extra function we think of it. Violation of the CIG user protocol (https://robertsspaceindustries.com/eula) may cause serious consequences such as accounts. Whether or not you are determined by yourself, we are not responsible for the possible consequences (game damage, account ban, etc.).\n\nFor the modified content of the Launcher, we are open from: https://github.com/starcitizentoolbox/rsilauncherenhance. If necessary, you can check it yourself.\n\nIf you need to cancel this enhanced patch for any reason, cover the installation of the official RSI Launcher directly.',
      name: 'tools_rsi_launcher_enhance_note_msg',
      desc: '',
      args: [],
    );
  }

  /// `P4K viewer`
  String get tools_action_unp4k {
    return Intl.message(
      'P4K viewer',
      name: 'tools_action_unp4k',
      desc: '',
      args: [],
    );
  }

  /// `Package Star Citizen P4K File`
  String get tools_action_unp4k_info {
    return Intl.message(
      'Package Star Citizen P4K File',
      name: 'tools_action_unp4k_info',
      desc: '',
      args: [],
    );
  }

  /// `P4k viewer -> {v0}`
  String tools_unp4k_title(Object v0) {
    return Intl.message(
      'P4k viewer -> $v0',
      name: 'tools_unp4k_title',
      desc: '',
      args: [v0],
    );
  }

  /// `Click the file to preview`
  String get tools_unp4k_view_file {
    return Intl.message(
      'Click the file to preview',
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

  /// `Please select INI file`
  String get home_localization_select_customize_file_ini {
    return Intl.message(
      'Please select INI file',
      name: 'home_localization_select_customize_file_ini',
      desc: '',
      args: [],
    );
  }

  /// `Please select custom Localization file`
  String get home_localization_select_customize_file {
    return Intl.message(
      'Please select custom Localization file',
      name: 'home_localization_select_customize_file',
      desc: '',
      args: [],
    );
  }

  /// `Click to select INI file`
  String get home_localization_action_select_customize_file {
    return Intl.message(
      'Click to select INI file',
      name: 'home_localization_action_select_customize_file',
      desc: '',
      args: [],
    );
  }

  /// `Recommended advanced localization`
  String get home_localization_ptu_advanced_localization_tip_title {
    return Intl.message(
      'Recommended advanced localization',
      name: 'home_localization_ptu_advanced_localization_tip_title',
      desc: '',
      args: [],
    );
  }

  /// `On PTU/EPTU and other test channels, the current localization text text may not be synchronized with the game, and the use of advanced localization can reduce garbled production.`
  String get home_localization_ptu_advanced_localization_tip_title_info {
    return Intl.message(
      'On PTU/EPTU and other test channels, the current localization text text may not be synchronized with the game, and the use of advanced localization can reduce garbled production.',
      name: 'home_localization_ptu_advanced_localization_tip_title_info',
      desc: '',
      args: [],
    );
  }

  /// `Put up the additional function`
  String get tools_rsi_launcher_enhance_action_fold {
    return Intl.message(
      'Put up the additional function',
      name: 'tools_rsi_launcher_enhance_action_fold',
      desc: '',
      args: [],
    );
  }

  /// `Expand additional features`
  String get tools_rsi_launcher_enhance_action_expand {
    return Intl.message(
      'Expand additional features',
      name: 'tools_rsi_launcher_enhance_action_expand',
      desc: '',
      args: [],
    );
  }

  /// `Lack of runtime`
  String get tools_unp4k_missing_runtime {
    return Intl.message(
      'Lack of runtime',
      name: 'tools_unp4k_missing_runtime',
      desc: '',
      args: [],
    );
  }

  /// `Use this function to install the .NET8 runtime, please click the button below to download and install it. After the installation is successful, reopen this page to continue to use.`
  String get tools_unp4k_missing_runtime_info {
    return Intl.message(
      'Use this function to install the .NET8 runtime, please click the button below to download and install it. After the installation is successful, reopen this page to continue to use.',
      name: 'tools_unp4k_missing_runtime_info',
      desc: '',
      args: [],
    );
  }

  /// `Install the runtime`
  String get tools_unp4k_missing_runtime_action_install {
    return Intl.message(
      'Install the runtime',
      name: 'tools_unp4k_missing_runtime_action_install',
      desc: '',
      args: [],
    );
  }

  /// `You are not currently installed in the game body or the game installation directory is not selected, and you can only use the promoter Chinese function. Please make sure the game is installed or adds the game installation directory in the box settings.`
  String get home_localization_action_rsi_launcher_no_game_path_msg {
    return Intl.message(
      'You are not currently installed in the game body or the game installation directory is not selected, and you can only use the promoter Chinese function. Please make sure the game is installed or adds the game installation directory in the box settings.',
      name: 'home_localization_action_rsi_launcher_no_game_path_msg',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
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
