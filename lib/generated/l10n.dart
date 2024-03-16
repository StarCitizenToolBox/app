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

  /// `SC汉化盒子  V{v0} {v1}`
  String app_index_version_info(Object v0, Object v1) {
    return Intl.message(
      'SC汉化盒子  V$v0 $v1',
      name: 'app_index_version_info',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `检查更新`
  String get about_check_update {
    return Intl.message(
      '检查更新',
      name: 'about_check_update',
      desc: '',
      args: [],
    );
  }

  /// `不仅仅是汉化！\n\nSC汉化盒子是你探索宇宙的好帮手，我们致力于为各位公民解决游戏中的常见问题，并为社区汉化、性能调优、常用网站汉化 等操作提供便利。`
  String get about_app_description {
    return Intl.message(
      '不仅仅是汉化！\n\nSC汉化盒子是你探索宇宙的好帮手，我们致力于为各位公民解决游戏中的常见问题，并为社区汉化、性能调优、常用网站汉化 等操作提供便利。',
      name: 'about_app_description',
      desc: '',
      args: [],
    );
  }

  /// `在线反馈`
  String get about_online_feedback {
    return Intl.message(
      '在线反馈',
      name: 'about_online_feedback',
      desc: '',
      args: [],
    );
  }

  /// `QQ群: 940696487`
  String get about_action_qq_group {
    return Intl.message(
      'QQ群: 940696487',
      name: 'about_action_qq_group',
      desc: '',
      args: [],
    );
  }

  /// `邮箱: scbox@xkeyc.com`
  String get about_action_email {
    return Intl.message(
      '邮箱: scbox@xkeyc.com',
      name: 'about_action_email',
      desc: '',
      args: [],
    );
  }

  /// `开源`
  String get about_action_open_source {
    return Intl.message(
      '开源',
      name: 'about_action_open_source',
      desc: '',
      args: [],
    );
  }

  /// `这是一个非官方的星际公民工具，不隶属于 Cloud Imperium 公司集团。 本软件中非由其主机或用户创作的所有内容均为其各自所有者的财产。 \nStar Citizen®、Roberts Space Industries® 和 Cloud Imperium® 是 Cloud Imperium Rights LLC 的注册商标。`
  String get about_disclaimer {
    return Intl.message(
      '这是一个非官方的星际公民工具，不隶属于 Cloud Imperium 公司集团。 本软件中非由其主机或用户创作的所有内容均为其各自所有者的财产。 \nStar Citizen®、Roberts Space Industries® 和 Cloud Imperium® 是 Cloud Imperium Rights LLC 的注册商标。',
      name: 'about_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `启动`
  String get about_analytics_launch {
    return Intl.message(
      '启动',
      name: 'about_analytics_launch',
      desc: '',
      args: [],
    );
  }

  /// `启动游戏`
  String get about_analytics_launch_game {
    return Intl.message(
      '启动游戏',
      name: 'about_analytics_launch_game',
      desc: '',
      args: [],
    );
  }

  /// `累计用户`
  String get about_analytics_total_users {
    return Intl.message(
      '累计用户',
      name: 'about_analytics_total_users',
      desc: '',
      args: [],
    );
  }

  /// `汉化安装`
  String get about_analytics_install_translation {
    return Intl.message(
      '汉化安装',
      name: 'about_analytics_install_translation',
      desc: '',
      args: [],
    );
  }

  /// `性能调优`
  String get about_analytics_performance_optimization {
    return Intl.message(
      '性能调优',
      name: 'about_analytics_performance_optimization',
      desc: '',
      args: [],
    );
  }

  /// `P4K分流`
  String get about_analytics_p4k_redirection {
    return Intl.message(
      'P4K分流',
      name: 'about_analytics_p4k_redirection',
      desc: '',
      args: [],
    );
  }

  /// `位`
  String get about_analytics_units_user {
    return Intl.message(
      '位',
      name: 'about_analytics_units_user',
      desc: '',
      args: [],
    );
  }

  /// `次`
  String get about_analytics_units_times {
    return Intl.message(
      '次',
      name: 'about_analytics_units_times',
      desc: '',
      args: [],
    );
  }

  /// `已经是最新版本！`
  String get about_info_latest_version {
    return Intl.message(
      '已经是最新版本！',
      name: 'about_info_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `节日倒计时`
  String get home_holiday_countdown {
    return Intl.message(
      '节日倒计时',
      name: 'home_holiday_countdown',
      desc: '',
      args: [],
    );
  }

  /// `* 以上节日日期由人工收录、维护，可能存在错误，欢迎反馈！`
  String get home_holiday_countdown_disclaimer {
    return Intl.message(
      '* 以上节日日期由人工收录、维护，可能存在错误，欢迎反馈！',
      name: 'home_holiday_countdown_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `一键启动`
  String get home_action_one_click_launch {
    return Intl.message(
      '一键启动',
      name: 'home_action_one_click_launch',
      desc: '',
      args: [],
    );
  }

  /// `登录中...`
  String get home_title_logging_in {
    return Intl.message(
      '登录中...',
      name: 'home_title_logging_in',
      desc: '',
      args: [],
    );
  }

  /// `* 若开启了自动填充，请留意弹出的 Windows Hello 窗口`
  String get home_info_auto_fill_notice {
    return Intl.message(
      '* 若开启了自动填充，请留意弹出的 Windows Hello 窗口',
      name: 'home_info_auto_fill_notice',
      desc: '',
      args: [],
    );
  }

  /// `欢迎回来！`
  String get home_login_title_welcome_back {
    return Intl.message(
      '欢迎回来！',
      name: 'home_login_title_welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `正在为您启动游戏...`
  String get home_login_title_launching_game {
    return Intl.message(
      '正在为您启动游戏...',
      name: 'home_login_title_launching_game',
      desc: '',
      args: [],
    );
  }

  /// `登录 RSI 账户`
  String get home_action_login_rsi_account {
    return Intl.message(
      '登录 RSI 账户',
      name: 'home_action_login_rsi_account',
      desc: '',
      args: [],
    );
  }

  /// `是否开启自动密码填充？`
  String get home_action_q_auto_password_fill_prompt {
    return Intl.message(
      '是否开启自动密码填充？',
      name: 'home_action_q_auto_password_fill_prompt',
      desc: '',
      args: [],
    );
  }

  /// `盒子将使用 PIN 与 Windows 凭据加密保存您的密码，密码只存储在您的设备中。\n\n当下次登录需要输入密码时，您只需授权PIN即可自动填充登录。`
  String get home_login_info_password_encryption_notice {
    return Intl.message(
      '盒子将使用 PIN 与 Windows 凭据加密保存您的密码，密码只存储在您的设备中。\n\n当下次登录需要输入密码时，您只需授权PIN即可自动填充登录。',
      name: 'home_login_info_password_encryption_notice',
      desc: '',
      args: [],
    );
  }

  /// `输入PIN以启用加密`
  String get home_login_info_enter_pin_to_encrypt {
    return Intl.message(
      '输入PIN以启用加密',
      name: 'home_login_info_enter_pin_to_encrypt',
      desc: '',
      args: [],
    );
  }

  /// `游戏版本过期`
  String get home_login_info_game_version_outdated {
    return Intl.message(
      '游戏版本过期',
      name: 'home_login_info_game_version_outdated',
      desc: '',
      args: [],
    );
  }

  /// `RSI 服务器报告版本号：{v1} \n\n本地版本号：{v2} \n\n建议使用 RSI Launcher 更新游戏！`
  String home_login_info_rsi_server_report(Object v1, Object v2) {
    return Intl.message(
      'RSI 服务器报告版本号：$v1 \n\n本地版本号：$v2 \n\n建议使用 RSI Launcher 更新游戏！',
      name: 'home_login_info_rsi_server_report',
      desc: '',
      args: [v1, v2],
    );
  }

  /// `忽略`
  String get home_login_info_action_ignore {
    return Intl.message(
      '忽略',
      name: 'home_login_info_action_ignore',
      desc: '',
      args: [],
    );
  }

  /// `盒子一键启动`
  String get home_login_action_title_box_one_click_launch {
    return Intl.message(
      '盒子一键启动',
      name: 'home_login_action_title_box_one_click_launch',
      desc: '',
      args: [],
    );
  }

  /// `本功能可以帮您更加便利的启动游戏。\n\n为确保账户安全 ，本功能使用汉化浏览器保留登录状态，且不会保存您的密码信息（除非你启用了自动填充功能）。\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。`
  String get home_login_info_one_click_launch_description {
    return Intl.message(
      '本功能可以帮您更加便利的启动游戏。\n\n为确保账户安全 ，本功能使用汉化浏览器保留登录状态，且不会保存您的密码信息（除非你启用了自动填充功能）。\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。',
      name: 'home_login_info_one_click_launch_description',
      desc: '',
      args: [],
    );
  }

  /// `需要安装 WebView2 Runtime`
  String get home_login_action_title_need_webview2_runtime {
    return Intl.message(
      '需要安装 WebView2 Runtime',
      name: 'home_login_action_title_need_webview2_runtime',
      desc: '',
      args: [],
    );
  }

  /// `关闭`
  String get action_close {
    return Intl.message(
      '关闭',
      name: 'action_close',
      desc: '',
      args: [],
    );
  }

  /// `限速设置`
  String get downloader_speed_limit_settings {
    return Intl.message(
      '限速设置',
      name: 'downloader_speed_limit_settings',
      desc: '',
      args: [],
    );
  }

  /// `全部暂停`
  String get downloader_action_pause_all {
    return Intl.message(
      '全部暂停',
      name: 'downloader_action_pause_all',
      desc: '',
      args: [],
    );
  }

  /// `恢复全部`
  String get downloader_action_resume_all {
    return Intl.message(
      '恢复全部',
      name: 'downloader_action_resume_all',
      desc: '',
      args: [],
    );
  }

  /// `全部取消`
  String get downloader_action_cancel_all {
    return Intl.message(
      '全部取消',
      name: 'downloader_action_cancel_all',
      desc: '',
      args: [],
    );
  }

  /// `无下载任务`
  String get downloader_info_no_download_tasks {
    return Intl.message(
      '无下载任务',
      name: 'downloader_info_no_download_tasks',
      desc: '',
      args: [],
    );
  }

  /// `总大小：{v1}`
  String downloader_info_total_size(Object v1) {
    return Intl.message(
      '总大小：$v1',
      name: 'downloader_info_total_size',
      desc: '',
      args: [v1],
    );
  }

  /// `校验中...（{v2}）`
  String downloader_info_verifying(Object v2) {
    return Intl.message(
      '校验中...（$v2）',
      name: 'downloader_info_verifying',
      desc: '',
      args: [v2],
    );
  }

  /// `下载中... ({0}%)`
  String get downloader_info_downloading {
    return Intl.message(
      '下载中... ({0}%)',
      name: 'downloader_info_downloading',
      desc: '',
      args: [],
    );
  }

  /// `状态：{v0}`
  String downloader_info_status(Object v0) {
    return Intl.message(
      '状态：$v0',
      name: 'downloader_info_status',
      desc: '',
      args: [v0],
    );
  }

  /// `已上传：{v0}`
  String downloader_info_uploaded(Object v0) {
    return Intl.message(
      '已上传：$v0',
      name: 'downloader_info_uploaded',
      desc: '',
      args: [v0],
    );
  }

  /// `已下载：{v0}`
  String downloader_info_downloaded(Object v0) {
    return Intl.message(
      '已下载：$v0',
      name: 'downloader_info_downloaded',
      desc: '',
      args: [v0],
    );
  }

  /// `选项`
  String get downloader_action_options {
    return Intl.message(
      '选项',
      name: 'downloader_action_options',
      desc: '',
      args: [],
    );
  }

  /// `继续下载`
  String get downloader_action_continue_download {
    return Intl.message(
      '继续下载',
      name: 'downloader_action_continue_download',
      desc: '',
      args: [],
    );
  }

  /// `暂停下载`
  String get downloader_action_pause_download {
    return Intl.message(
      '暂停下载',
      name: 'downloader_action_pause_download',
      desc: '',
      args: [],
    );
  }

  /// `取消下载`
  String get downloader_action_cancel_download {
    return Intl.message(
      '取消下载',
      name: 'downloader_action_cancel_download',
      desc: '',
      args: [],
    );
  }

  /// `打开文件夹`
  String get action_open_folder {
    return Intl.message(
      '打开文件夹',
      name: 'action_open_folder',
      desc: '',
      args: [],
    );
  }

  /// `下载： {v0}/s    上传：{v1}/s`
  String downloader_info_download_upload_speed(Object v0, Object v1) {
    return Intl.message(
      '下载： $v0/s    上传：$v1/s',
      name: 'downloader_info_download_upload_speed',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `下载中...`
  String get downloader_info_downloading_status {
    return Intl.message(
      '下载中...',
      name: 'downloader_info_downloading_status',
      desc: '',
      args: [],
    );
  }

  /// `等待中`
  String get downloader_info_waiting {
    return Intl.message(
      '等待中',
      name: 'downloader_info_waiting',
      desc: '',
      args: [],
    );
  }

  /// `已暂停`
  String get downloader_info_paused {
    return Intl.message(
      '已暂停',
      name: 'downloader_info_paused',
      desc: '',
      args: [],
    );
  }

  /// `下载失败`
  String get downloader_info_download_failed {
    return Intl.message(
      '下载失败',
      name: 'downloader_info_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `下载完成`
  String get downloader_info_download_completed {
    return Intl.message(
      '下载完成',
      name: 'downloader_info_download_completed',
      desc: '',
      args: [],
    );
  }

  /// `已删除`
  String get downloader_info_deleted {
    return Intl.message(
      '已删除',
      name: 'downloader_info_deleted',
      desc: '',
      args: [],
    );
  }

  /// `下载中`
  String get downloader_title_downloading {
    return Intl.message(
      '下载中',
      name: 'downloader_title_downloading',
      desc: '',
      args: [],
    );
  }

  /// `已结束`
  String get downloader_title_ended {
    return Intl.message(
      '已结束',
      name: 'downloader_title_ended',
      desc: '',
      args: [],
    );
  }

  /// `确认取消全部任务？`
  String get downloader_action_confirm_cancel_all_tasks {
    return Intl.message(
      '确认取消全部任务？',
      name: 'downloader_action_confirm_cancel_all_tasks',
      desc: '',
      args: [],
    );
  }

  /// `如果文件不再需要，你可能需要手动删除下载文件。`
  String get downloader_info_manual_file_deletion_note {
    return Intl.message(
      '如果文件不再需要，你可能需要手动删除下载文件。',
      name: 'downloader_info_manual_file_deletion_note',
      desc: '',
      args: [],
    );
  }

  /// `确认取消下载？`
  String get downloader_action_confirm_cancel_download {
    return Intl.message(
      '确认取消下载？',
      name: 'downloader_action_confirm_cancel_download',
      desc: '',
      args: [],
    );
  }

  /// `SC 汉化盒子使用 p2p 网络来加速文件下载，如果您流量有限，可在此处将上传带宽设置为 1(byte)。`
  String get downloader_info_p2p_network_note {
    return Intl.message(
      'SC 汉化盒子使用 p2p 网络来加速文件下载，如果您流量有限，可在此处将上传带宽设置为 1(byte)。',
      name: 'downloader_info_p2p_network_note',
      desc: '',
      args: [],
    );
  }

  /// `请输入下载单位，如：1、100k、10m， 0或留空为不限速。`
  String get downloader_info_download_unit_input_prompt {
    return Intl.message(
      '请输入下载单位，如：1、100k、10m， 0或留空为不限速。',
      name: 'downloader_info_download_unit_input_prompt',
      desc: '',
      args: [],
    );
  }

  /// `上传限速：`
  String get downloader_input_upload_speed_limit {
    return Intl.message(
      '上传限速：',
      name: 'downloader_input_upload_speed_limit',
      desc: '',
      args: [],
    );
  }

  /// `下载限速：`
  String get downloader_input_download_speed_limit {
    return Intl.message(
      '下载限速：',
      name: 'downloader_input_download_speed_limit',
      desc: '',
      args: [],
    );
  }

  /// `* P2P 上传仅在下载文件时进行，下载完成后会关闭 p2p 连接。如您想参与做种，请通过关于页面联系我们。`
  String get downloader_input_info_p2p_upload_note {
    return Intl.message(
      '* P2P 上传仅在下载文件时进行，下载完成后会关闭 p2p 连接。如您想参与做种，请通过关于页面联系我们。',
      name: 'downloader_input_info_p2p_upload_note',
      desc: '',
      args: [],
    );
  }

  /// `一键诊断 -> {v0}`
  String doctor_title_one_click_diagnosis(Object v0) {
    return Intl.message(
      '一键诊断 -> $v0',
      name: 'doctor_title_one_click_diagnosis',
      desc: '',
      args: [v0],
    );
  }

  /// `RSI启动器log`
  String get doctor_action_rsi_launcher_log {
    return Intl.message(
      'RSI启动器log',
      name: 'doctor_action_rsi_launcher_log',
      desc: '',
      args: [],
    );
  }

  /// `游戏运行log`
  String get doctor_action_game_run_log {
    return Intl.message(
      '游戏运行log',
      name: 'doctor_action_game_run_log',
      desc: '',
      args: [],
    );
  }

  /// `扫描完毕，没有找到问题！`
  String get doctor_info_scan_complete_no_issues {
    return Intl.message(
      '扫描完毕，没有找到问题！',
      name: 'doctor_info_scan_complete_no_issues',
      desc: '',
      args: [],
    );
  }

  /// `正在处理...`
  String get doctor_info_processing {
    return Intl.message(
      '正在处理...',
      name: 'doctor_info_processing',
      desc: '',
      args: [],
    );
  }

  /// `您即将前往由 深空治疗中心（QQ群号：536454632 ） 提供的游戏异常救援服务，主要解决游戏安装失败与频繁闪退，如游戏玩法问题，请勿加群。`
  String get doctor_info_game_rescue_service_note {
    return Intl.message(
      '您即将前往由 深空治疗中心（QQ群号：536454632 ） 提供的游戏异常救援服务，主要解决游戏安装失败与频繁闪退，如游戏玩法问题，请勿加群。',
      name: 'doctor_info_game_rescue_service_note',
      desc: '',
      args: [],
    );
  }

  /// `需要帮助？ 点击加群寻求免费人工支援！`
  String get doctor_info_need_help {
    return Intl.message(
      '需要帮助？ 点击加群寻求免费人工支援！',
      name: 'doctor_info_need_help',
      desc: '',
      args: [],
    );
  }

  /// `注意：本工具检测结果仅供参考，若您不理解以下操作，请提供截图给有经验的玩家！`
  String get doctor_info_tool_check_result_note {
    return Intl.message(
      '注意：本工具检测结果仅供参考，若您不理解以下操作，请提供截图给有经验的玩家！',
      name: 'doctor_info_tool_check_result_note',
      desc: '',
      args: [],
    );
  }

  /// `不支持的操作系统，游戏可能无法运行`
  String get doctor_info_result_unsupported_os {
    return Intl.message(
      '不支持的操作系统，游戏可能无法运行',
      name: 'doctor_info_result_unsupported_os',
      desc: '',
      args: [],
    );
  }

  /// `请升级您的系统 ({v0})`
  String doctor_info_result_upgrade_system(Object v0) {
    return Intl.message(
      '请升级您的系统 ($v0)',
      name: 'doctor_info_result_upgrade_system',
      desc: '',
      args: [v0],
    );
  }

  /// `安装目录缺少LIVE文件夹，可能导致安装失败`
  String get doctor_info_result_missing_live_folder {
    return Intl.message(
      '安装目录缺少LIVE文件夹，可能导致安装失败',
      name: 'doctor_info_result_missing_live_folder',
      desc: '',
      args: [],
    );
  }

  /// `点击修复为您创建 LIVE 文件夹，完成后重试安装。({v0})`
  String doctor_info_result_create_live_folder(Object v0) {
    return Intl.message(
      '点击修复为您创建 LIVE 文件夹，完成后重试安装。($v0)',
      name: 'doctor_info_result_create_live_folder',
      desc: '',
      args: [v0],
    );
  }

  /// `新型 NVME 设备，与 RSI 启动器暂不兼容，可能导致安装失败`
  String get doctor_info_result_incompatible_nvme_device {
    return Intl.message(
      '新型 NVME 设备，与 RSI 启动器暂不兼容，可能导致安装失败',
      name: 'doctor_info_result_incompatible_nvme_device',
      desc: '',
      args: [],
    );
  }

  /// `为注册表项添加 ForcedPhysicalSectorSizeInBytes 值 模拟旧设备。硬盘分区({0})`
  String get doctor_info_result_add_registry_value {
    return Intl.message(
      '为注册表项添加 ForcedPhysicalSectorSizeInBytes 值 模拟旧设备。硬盘分区({0})',
      name: 'doctor_info_result_add_registry_value',
      desc: '',
      args: [],
    );
  }

  /// `EasyAntiCheat 文件丢失`
  String get doctor_info_result_missing_easyanticheat_files {
    return Intl.message(
      'EasyAntiCheat 文件丢失',
      name: 'doctor_info_result_missing_easyanticheat_files',
      desc: '',
      args: [],
    );
  }

  /// `未在 LIVE 文件夹找到 EasyAntiCheat 文件 或 文件不完整，请使用 RSI 启动器校验文件`
  String get doctor_info_result_verify_files_with_rsi_launcher {
    return Intl.message(
      '未在 LIVE 文件夹找到 EasyAntiCheat 文件 或 文件不完整，请使用 RSI 启动器校验文件',
      name: 'doctor_info_result_verify_files_with_rsi_launcher',
      desc: '',
      args: [],
    );
  }

  /// `EasyAntiCheat 未安装 或 未正常退出`
  String get doctor_info_result_easyanticheat_not_installed {
    return Intl.message(
      'EasyAntiCheat 未安装 或 未正常退出',
      name: 'doctor_info_result_easyanticheat_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `EasyAntiCheat 未安装，请点击修复为您一键安装。（在游戏正常启动并结束前，该问题会一直出现，若您因为其他原因游戏闪退，可忽略此条目）`
  String get doctor_info_result_install_easyanticheat {
    return Intl.message(
      'EasyAntiCheat 未安装，请点击修复为您一键安装。（在游戏正常启动并结束前，该问题会一直出现，若您因为其他原因游戏闪退，可忽略此条目）',
      name: 'doctor_info_result_install_easyanticheat',
      desc: '',
      args: [],
    );
  }

  /// `中文用户名！`
  String get doctor_info_result_chinese_username {
    return Intl.message(
      '中文用户名！',
      name: 'doctor_info_result_chinese_username',
      desc: '',
      args: [],
    );
  }

  /// `中文用户名可能会导致游戏启动/安装错误！ 点击修复按钮查看修改教程！`
  String get doctor_info_result_chinese_username_error {
    return Intl.message(
      '中文用户名可能会导致游戏启动/安装错误！ 点击修复按钮查看修改教程！',
      name: 'doctor_info_result_chinese_username_error',
      desc: '',
      args: [],
    );
  }

  /// `中文安装路径！`
  String get doctor_info_result_chinese_install_path {
    return Intl.message(
      '中文安装路径！',
      name: 'doctor_info_result_chinese_install_path',
      desc: '',
      args: [],
    );
  }

  /// `中文安装路径！这可能会导致游戏 启动/安装 错误！（{0}），请在RSI启动器更换安装路径。`
  String get doctor_info_result_chinese_install_path_error {
    return Intl.message(
      '中文安装路径！这可能会导致游戏 启动/安装 错误！（{0}），请在RSI启动器更换安装路径。',
      name: 'doctor_info_result_chinese_install_path_error',
      desc: '',
      args: [],
    );
  }

  /// `物理内存过低`
  String get doctor_info_result_low_physical_memory {
    return Intl.message(
      '物理内存过低',
      name: 'doctor_info_result_low_physical_memory',
      desc: '',
      args: [],
    );
  }

  /// `您至少需要 16GB 的物理内存（Memory）才可运行此游戏。（当前大小：{v0}）`
  String doctor_info_result_memory_requirement(Object v0) {
    return Intl.message(
      '您至少需要 16GB 的物理内存（Memory）才可运行此游戏。（当前大小：$v0）',
      name: 'doctor_info_result_memory_requirement',
      desc: '',
      args: [v0],
    );
  }

  /// `修复建议： {v0}`
  String doctor_info_result_fix_suggestion(Object v0) {
    return Intl.message(
      '修复建议： $v0',
      name: 'doctor_info_result_fix_suggestion',
      desc: '',
      args: [v0],
    );
  }

  /// `暂无解决方法，请截图反馈`
  String get doctor_info_result_no_solution {
    return Intl.message(
      '暂无解决方法，请截图反馈',
      name: 'doctor_info_result_no_solution',
      desc: '',
      args: [],
    );
  }

  /// `修复`
  String get doctor_info_action_fix {
    return Intl.message(
      '修复',
      name: 'doctor_info_action_fix',
      desc: '',
      args: [],
    );
  }

  /// `查看解决方案`
  String get doctor_action_view_solution {
    return Intl.message(
      '查看解决方案',
      name: 'doctor_action_view_solution',
      desc: '',
      args: [],
    );
  }

  /// `请在首页选择游戏安装目录。`
  String get doctor_tip_title_select_game_directory {
    return Intl.message(
      '请在首页选择游戏安装目录。',
      name: 'doctor_tip_title_select_game_directory',
      desc: '',
      args: [],
    );
  }

  /// `若您的硬件达标，请尝试安装最新的 Windows 系统。`
  String get doctor_action_result_try_latest_windows {
    return Intl.message(
      '若您的硬件达标，请尝试安装最新的 Windows 系统。',
      name: 'doctor_action_result_try_latest_windows',
      desc: '',
      args: [],
    );
  }

  /// `创建文件夹成功，请尝试继续下载游戏！`
  String get doctor_action_result_create_folder_success {
    return Intl.message(
      '创建文件夹成功，请尝试继续下载游戏！',
      name: 'doctor_action_result_create_folder_success',
      desc: '',
      args: [],
    );
  }

  /// `创建文件夹失败，请尝试手动创建。\n目录：{v0} \n错误：{v1}`
  String doctor_action_result_create_folder_fail(Object v0, Object v1) {
    return Intl.message(
      '创建文件夹失败，请尝试手动创建。\n目录：$v0 \n错误：$v1',
      name: 'doctor_action_result_create_folder_fail',
      desc: '',
      args: [v0, v1],
    );
  }

  /// `修复成功，请尝试重启后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。`
  String get doctor_action_result_fix_success {
    return Intl.message(
      '修复成功，请尝试重启后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。',
      name: 'doctor_action_result_fix_success',
      desc: '',
      args: [],
    );
  }

  /// `修复失败，{v0}`
  String doctor_action_result_fix_fail(Object v0) {
    return Intl.message(
      '修复失败，$v0',
      name: 'doctor_action_result_fix_fail',
      desc: '',
      args: [v0],
    );
  }

  /// `修复成功，请尝试启动游戏。（若问题无法解决，请使用工具箱的 《重装 EAC》）`
  String get doctor_action_result_game_start_success {
    return Intl.message(
      '修复成功，请尝试启动游戏。（若问题无法解决，请使用工具箱的 《重装 EAC》）',
      name: 'doctor_action_result_game_start_success',
      desc: '',
      args: [],
    );
  }

  /// `即将跳转，教程来自互联网，请谨慎操作...`
  String get doctor_action_result_redirect_warning {
    return Intl.message(
      '即将跳转，教程来自互联网，请谨慎操作...',
      name: 'doctor_action_result_redirect_warning',
      desc: '',
      args: [],
    );
  }

  /// `该问题暂不支持自动处理，请提供截图寻求帮助`
  String get doctor_action_result_issue_not_supported {
    return Intl.message(
      '该问题暂不支持自动处理，请提供截图寻求帮助',
      name: 'doctor_action_result_issue_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `正在分析...`
  String get doctor_action_analyzing {
    return Intl.message(
      '正在分析...',
      name: 'doctor_action_analyzing',
      desc: '',
      args: [],
    );
  }

  /// `分析完毕，没有发现问题`
  String get doctor_action_result_analysis_no_issue {
    return Intl.message(
      '分析完毕，没有发现问题',
      name: 'doctor_action_result_analysis_no_issue',
      desc: '',
      args: [],
    );
  }

  /// `分析完毕，发现 {v0} 个问题`
  String doctor_action_result_analysis_issues_found(Object v0) {
    return Intl.message(
      '分析完毕，发现 $v0 个问题',
      name: 'doctor_action_result_analysis_issues_found',
      desc: '',
      args: [v0],
    );
  }

  /// `扫描完毕，没有发现问题，若仍然安装失败，请尝试使用工具箱中的 RSI启动器管理员模式。`
  String get doctor_action_result_toast_scan_no_issue {
    return Intl.message(
      '扫描完毕，没有发现问题，若仍然安装失败，请尝试使用工具箱中的 RSI启动器管理员模式。',
      name: 'doctor_action_result_toast_scan_no_issue',
      desc: '',
      args: [],
    );
  }

  /// `正在检查：Game.log`
  String get doctor_action_tip_checking_game_log {
    return Intl.message(
      '正在检查：Game.log',
      name: 'doctor_action_tip_checking_game_log',
      desc: '',
      args: [],
    );
  }

  /// `游戏异常退出：{v0}`
  String doctor_action_info_game_abnormal_exit(Object v0) {
    return Intl.message(
      '游戏异常退出：$v0',
      name: 'doctor_action_info_game_abnormal_exit',
      desc: '',
      args: [v0],
    );
  }

  /// `游戏异常退出：未知异常`
  String get doctor_action_info_game_abnormal_exit_unknown {
    return Intl.message(
      '游戏异常退出：未知异常',
      name: 'doctor_action_info_game_abnormal_exit_unknown',
      desc: '',
      args: [],
    );
  }

  /// `info:{v0}，请点击右下角加群反馈。`
  String doctor_action_info_info_feedback(Object v0) {
    return Intl.message(
      'info:$v0，请点击右下角加群反馈。',
      name: 'doctor_action_info_info_feedback',
      desc: '',
      args: [v0],
    );
  }

  /// `正在检查：EAC`
  String get doctor_action_info_checking_eac {
    return Intl.message(
      '正在检查：EAC',
      name: 'doctor_action_info_checking_eac',
      desc: '',
      args: [],
    );
  }

  /// `正在检查：运行环境`
  String get doctor_action_info_checking_runtime {
    return Intl.message(
      '正在检查：运行环境',
      name: 'doctor_action_info_checking_runtime',
      desc: '',
      args: [],
    );
  }

  /// `不支持的操作系统：{v0}`
  String doctor_action_result_info_unsupported_os(Object v0) {
    return Intl.message(
      '不支持的操作系统：$v0',
      name: 'doctor_action_result_info_unsupported_os',
      desc: '',
      args: [v0],
    );
  }

  /// `正在检查：安装信息`
  String get doctor_action_info_checking_install_info {
    return Intl.message(
      '正在检查：安装信息',
      name: 'doctor_action_info_checking_install_info',
      desc: '',
      args: [],
    );
  }

  /// `查看详情`
  String get doctor_action_view_details {
    return Intl.message(
      '查看详情',
      name: 'doctor_action_view_details',
      desc: '',
      args: [],
    );
  }

  /// `安装位置：`
  String get home_install_location {
    return Intl.message(
      '安装位置：',
      name: 'home_install_location',
      desc: '',
      args: [],
    );
  }

  /// `未安装 或 安装失败`
  String get home_not_installed_or_failed {
    return Intl.message(
      '未安装 或 安装失败',
      name: 'home_not_installed_or_failed',
      desc: '',
      args: [],
    );
  }

  /// `星际公民官网汉化`
  String get home_action_star_citizen_website_localization {
    return Intl.message(
      '星际公民官网汉化',
      name: 'home_action_star_citizen_website_localization',
      desc: '',
      args: [],
    );
  }

  /// `罗伯茨航天工业公司，万物的起源`
  String get home_action_info_roberts_space_industries_origin {
    return Intl.message(
      '罗伯茨航天工业公司，万物的起源',
      name: 'home_action_info_roberts_space_industries_origin',
      desc: '',
      args: [],
    );
  }

  /// `UEX 汉化`
  String get home_action_uex_localization {
    return Intl.message(
      'UEX 汉化',
      name: 'home_action_uex_localization',
      desc: '',
      args: [],
    );
  }

  /// `采矿、精炼、贸易计算器、价格、船信息`
  String get home_action_info_mining_refining_trade_calculator {
    return Intl.message(
      '采矿、精炼、贸易计算器、价格、船信息',
      name: 'home_action_info_mining_refining_trade_calculator',
      desc: '',
      args: [],
    );
  }

  /// `DPS计算器汉化`
  String get home_action_dps_calculator_localization {
    return Intl.message(
      'DPS计算器汉化',
      name: 'home_action_dps_calculator_localization',
      desc: '',
      args: [],
    );
  }

  /// `在线改船，查询伤害数值和配件购买地点`
  String get home_action_info_ship_upgrade_damage_value_query {
    return Intl.message(
      '在线改船，查询伤害数值和配件购买地点',
      name: 'home_action_info_ship_upgrade_damage_value_query',
      desc: '',
      args: [],
    );
  }

  /// `外部浏览器拓展：`
  String get home_action_external_browser_extension {
    return Intl.message(
      '外部浏览器拓展：',
      name: 'home_action_external_browser_extension',
      desc: '',
      args: [],
    );
  }

  /// `一键诊断`
  String get home_action_one_click_diagnosis {
    return Intl.message(
      '一键诊断',
      name: 'home_action_one_click_diagnosis',
      desc: '',
      args: [],
    );
  }

  /// `一键诊断星际公民常见问题`
  String get home_action_info_one_click_diagnosis_star_citizen {
    return Intl.message(
      '一键诊断星际公民常见问题',
      name: 'home_action_info_one_click_diagnosis_star_citizen',
      desc: '',
      args: [],
    );
  }

  /// `汉化管理`
  String get home_action_localization_management {
    return Intl.message(
      '汉化管理',
      name: 'home_action_localization_management',
      desc: '',
      args: [],
    );
  }

  /// `快捷安装汉化资源`
  String get home_action_info_quick_install_localization_resources {
    return Intl.message(
      '快捷安装汉化资源',
      name: 'home_action_info_quick_install_localization_resources',
      desc: '',
      args: [],
    );
  }

  /// `性能优化`
  String get home_action_performance_optimization {
    return Intl.message(
      '性能优化',
      name: 'home_action_performance_optimization',
      desc: '',
      args: [],
    );
  }

  /// `调整引擎配置文件，优化游戏性能`
  String get home_action_info_engine_config_optimization {
    return Intl.message(
      '调整引擎配置文件，优化游戏性能',
      name: 'home_action_info_engine_config_optimization',
      desc: '',
      args: [],
    );
  }

  /// `平台`
  String get home_action_rsi_status_platform {
    return Intl.message(
      '平台',
      name: 'home_action_rsi_status_platform',
      desc: '',
      args: [],
    );
  }

  /// `持续宇宙`
  String get home_action_rsi_status_persistent_universe {
    return Intl.message(
      '持续宇宙',
      name: 'home_action_rsi_status_persistent_universe',
      desc: '',
      args: [],
    );
  }

  /// `电子访问`
  String get home_action_rsi_status_electronic_access {
    return Intl.message(
      '电子访问',
      name: 'home_action_rsi_status_electronic_access',
      desc: '',
      args: [],
    );
  }

  /// `竞技场指挥官`
  String get home_action_rsi_status_arena_commander {
    return Intl.message(
      '竞技场指挥官',
      name: 'home_action_rsi_status_arena_commander',
      desc: '',
      args: [],
    );
  }

  /// `RSI 服务器状态`
  String get home_action_rsi_status_rsi_server_status {
    return Intl.message(
      'RSI 服务器状态',
      name: 'home_action_rsi_status_rsi_server_status',
      desc: '',
      args: [],
    );
  }

  /// `状态：`
  String get home_action_rsi_status_status {
    return Intl.message(
      '状态：',
      name: 'home_action_rsi_status_status',
      desc: '',
      args: [],
    );
  }

  /// `公告详情`
  String get home_announcement_details {
    return Intl.message(
      '公告详情',
      name: 'home_announcement_details',
      desc: '',
      args: [],
    );
  }

  /// `该功能需要一个有效的安装位置\n\n如果您的游戏未下载完成，请等待下载完毕后使用此功能。\n\n如果您的游戏已下载完毕但未识别，请启动一次游戏后重新打开盒子 或 在设置选项中手动设置安装位置。`
  String get home_action_info_valid_install_location_required {
    return Intl.message(
      '该功能需要一个有效的安装位置\n\n如果您的游戏未下载完成，请等待下载完毕后使用此功能。\n\n如果您的游戏已下载完毕但未识别，请启动一次游戏后重新打开盒子 或 在设置选项中手动设置安装位置。',
      name: 'home_action_info_valid_install_location_required',
      desc: '',
      args: [],
    );
  }

  /// `正在扫描 ...`
  String get home_action_info_scanning {
    return Intl.message(
      '正在扫描 ...',
      name: 'home_action_info_scanning',
      desc: '',
      args: [],
    );
  }

  /// `扫描完毕，共找到 {v0} 个有效安装目录`
  String home_action_info_scan_complete_valid_directories_found(Object v0) {
    return Intl.message(
      '扫描完毕，共找到 $v0 个有效安装目录',
      name: 'home_action_info_scan_complete_valid_directories_found',
      desc: '',
      args: [v0],
    );
  }

  /// `解析 log 文件失败！`
  String get home_action_info_log_file_parse_fail {
    return Intl.message(
      '解析 log 文件失败！',
      name: 'home_action_info_log_file_parse_fail',
      desc: '',
      args: [],
    );
  }

  /// `星际公民网站汉化`
  String get home_action_title_star_citizen_website_localization {
    return Intl.message(
      '星际公民网站汉化',
      name: 'home_action_title_star_citizen_website_localization',
      desc: '',
      args: [],
    );
  }

  /// `本插功能件仅供大致浏览使用，不对任何有关本功能产生的问题负责！在涉及账号操作前请注意确认网站的原本内容！\n\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。`
  String get home_action_info_web_localization_plugin_disclaimer {
    return Intl.message(
      '本插功能件仅供大致浏览使用，不对任何有关本功能产生的问题负责！在涉及账号操作前请注意确认网站的原本内容！\n\n\n使用此功能登录账号时请确保您的 SC汉化盒子 是从可信任的来源下载。',
      name: 'home_action_info_web_localization_plugin_disclaimer',
      desc: '',
      args: [],
    );
  }

  /// `正在初始化汉化资源...`
  String get home_action_info_initializing_resources {
    return Intl.message(
      '正在初始化汉化资源...',
      name: 'home_action_info_initializing_resources',
      desc: '',
      args: [],
    );
  }

  /// `初始化网页汉化资源失败！{v0}`
  String home_action_info_initialization_failed(Object v0) {
    return Intl.message(
      '初始化网页汉化资源失败！$v0',
      name: 'home_action_info_initialization_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `SC汉化盒子`
  String get home_title_app_name {
    return Intl.message(
      'SC汉化盒子',
      name: 'home_title_app_name',
      desc: '',
      args: [],
    );
  }

  /// `汉化有新版本！`
  String get home_localization_new_version_available {
    return Intl.message(
      '汉化有新版本！',
      name: 'home_localization_new_version_available',
      desc: '',
      args: [],
    );
  }

  /// `您在 {v0} 安装的汉化有新版本啦！`
  String home_localization_new_version_installed(Object v0) {
    return Intl.message(
      '您在 $v0 安装的汉化有新版本啦！',
      name: 'home_localization_new_version_installed',
      desc: '',
      args: [v0],
    );
  }

  /// `该功能需要一个有效的安装位置`
  String get home_info_valid_installation_required {
    return Intl.message(
      '该功能需要一个有效的安装位置',
      name: 'home_info_valid_installation_required',
      desc: '',
      args: [],
    );
  }

  /// `一键启动功能提示`
  String get home_info_one_click_launch_warning {
    return Intl.message(
      '一键启动功能提示',
      name: 'home_info_one_click_launch_warning',
      desc: '',
      args: [],
    );
  }

  /// `为确保账户安全，一键启动功能已在开发版中禁用，我们将在微软商店版本中提供此功能。\n\n微软商店版由微软提供可靠的分发下载与数字签名，可有效防止软件被恶意篡改。\n\n提示：您无需使用盒子启动游戏也可使用汉化。`
  String get home_info_account_security_warning {
    return Intl.message(
      '为确保账户安全，一键启动功能已在开发版中禁用，我们将在微软商店版本中提供此功能。\n\n微软商店版由微软提供可靠的分发下载与数字签名，可有效防止软件被恶意篡改。\n\n提示：您无需使用盒子启动游戏也可使用汉化。',
      name: 'home_info_account_security_warning',
      desc: '',
      args: [],
    );
  }

  /// `安装微软商店版本`
  String get home_action_install_microsoft_store_version {
    return Intl.message(
      '安装微软商店版本',
      name: 'home_action_install_microsoft_store_version',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get home_action_cancel {
    return Intl.message(
      '取消',
      name: 'home_action_cancel',
      desc: '',
      args: [],
    );
  }

  /// `游戏非正常退出\nexitCode={v0}\nstdout={v1}\nstderr={v2}\n\n诊断信息：{v3} \n{v4}`
  String home_action_info_abnormal_game_exit(
      Object v0, Object v1, Object v2, Object v3, Object v4) {
    return Intl.message(
      '游戏非正常退出\nexitCode=$v0\nstdout=$v1\nstderr=$v2\n\n诊断信息：$v3 \n$v4',
      name: 'home_action_info_abnormal_game_exit',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `未知错误，请通过一键诊断加群反馈。`
  String get home_action_info_unknown_error {
    return Intl.message(
      '未知错误，请通过一键诊断加群反馈。',
      name: 'home_action_info_unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `请查看弹出的网页链接获得详细信息。`
  String get home_action_info_check_web_link {
    return Intl.message(
      '请查看弹出的网页链接获得详细信息。',
      name: 'home_action_info_check_web_link',
      desc: '',
      args: [],
    );
  }

  /// `游戏内置`
  String get home_action_info_game_built_in {
    return Intl.message(
      '游戏内置',
      name: 'home_action_info_game_built_in',
      desc: '',
      args: [],
    );
  }

  /// `警告`
  String get home_action_info_warning {
    return Intl.message(
      '警告',
      name: 'home_action_info_warning',
      desc: '',
      args: [],
    );
  }

  /// `您正在使用游戏内置文本，官方文本目前为机器翻译（截至3.21.0），建议您在下方安装社区汉化。`
  String get localization_info_machine_translation_warning {
    return Intl.message(
      '您正在使用游戏内置文本，官方文本目前为机器翻译（截至3.21.0），建议您在下方安装社区汉化。',
      name: 'localization_info_machine_translation_warning',
      desc: '',
      args: [],
    );
  }

  /// `汉化状态`
  String get localization_info_translation_status {
    return Intl.message(
      '汉化状态',
      name: 'localization_info_translation_status',
      desc: '',
      args: [],
    );
  }

  /// `启用（{v0}）：`
  String localization_info_enabled(Object v0) {
    return Intl.message(
      '启用（$v0）：',
      name: 'localization_info_enabled',
      desc: '',
      args: [v0],
    );
  }

  /// `已安装版本：{v0}`
  String localization_info_installed_version(Object v0) {
    return Intl.message(
      '已安装版本：$v0',
      name: 'localization_info_installed_version',
      desc: '',
      args: [v0],
    );
  }

  /// `汉化反馈`
  String get localization_action_translation_feedback {
    return Intl.message(
      '汉化反馈',
      name: 'localization_action_translation_feedback',
      desc: '',
      args: [],
    );
  }

  /// `卸载汉化`
  String get localization_action_uninstall_translation {
    return Intl.message(
      '卸载汉化',
      name: 'localization_action_uninstall_translation',
      desc: '',
      args: [],
    );
  }

  /// `备注：`
  String get localization_info_note {
    return Intl.message(
      '备注：',
      name: 'localization_info_note',
      desc: '',
      args: [],
    );
  }

  /// `社区汉化`
  String get localization_info_community_translation {
    return Intl.message(
      '社区汉化',
      name: 'localization_info_community_translation',
      desc: '',
      args: [],
    );
  }

  /// `该语言/版本 暂无可用汉化，敬请期待！`
  String get localization_info_no_translation_available {
    return Intl.message(
      '该语言/版本 暂无可用汉化，敬请期待！',
      name: 'localization_info_no_translation_available',
      desc: '',
      args: [],
    );
  }

  /// `高级功能`
  String get localization_action_advanced_features {
    return Intl.message(
      '高级功能',
      name: 'localization_action_advanced_features',
      desc: '',
      args: [],
    );
  }

  /// `自定义文本`
  String get localization_info_custom_text {
    return Intl.message(
      '自定义文本',
      name: 'localization_info_custom_text',
      desc: '',
      args: [],
    );
  }

  /// `暂无自定义文本`
  String get localization_info_no_custom_text {
    return Intl.message(
      '暂无自定义文本',
      name: 'localization_info_no_custom_text',
      desc: '',
      args: [],
    );
  }

  /// `安装`
  String get localization_action_install {
    return Intl.message(
      '安装',
      name: 'localization_action_install',
      desc: '',
      args: [],
    );
  }

  /// `版本号：{v0}`
  String localization_info_version_number(Object v0) {
    return Intl.message(
      '版本号：$v0',
      name: 'localization_info_version_number',
      desc: '',
      args: [v0],
    );
  }

  /// `通道：{v0}`
  String localization_info_channel(Object v0) {
    return Intl.message(
      '通道：$v0',
      name: 'localization_info_channel',
      desc: '',
      args: [v0],
    );
  }

  /// `更新时间：{v0}`
  String localization_info_update_time(Object v0) {
    return Intl.message(
      '更新时间：$v0',
      name: 'localization_info_update_time',
      desc: '',
      args: [v0],
    );
  }

  /// `已安装`
  String get localization_info_installed {
    return Intl.message(
      '已安装',
      name: 'localization_info_installed',
      desc: '',
      args: [],
    );
  }

  /// `不可用`
  String get localization_info_unavailable {
    return Intl.message(
      '不可用',
      name: 'localization_info_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `语言：   `
  String get localization_info_language {
    return Intl.message(
      '语言：   ',
      name: 'localization_info_language',
      desc: '',
      args: [],
    );
  }

  /// `是否移除不兼容的汉化参数`
  String get localization_info_remove_incompatible_translation_params {
    return Intl.message(
      '是否移除不兼容的汉化参数',
      name: 'localization_info_remove_incompatible_translation_params',
      desc: '',
      args: [],
    );
  }

  /// `USER.cfg 包含不兼容的汉化参数，这可能是以前的汉化文件的残留信息。\n\n这将可能导致汉化无效或乱码，点击确认为您一键移除（不会影响其他配置）。`
  String get localization_info_incompatible_translation_params_warning {
    return Intl.message(
      'USER.cfg 包含不兼容的汉化参数，这可能是以前的汉化文件的残留信息。\n\n这将可能导致汉化无效或乱码，点击确认为您一键移除（不会影响其他配置）。',
      name: 'localization_info_incompatible_translation_params_warning',
      desc: '',
      args: [],
    );
  }

  /// `自定义_{v0}`
  String localization_info_custom_file(Object v0) {
    return Intl.message(
      '自定义_$v0',
      name: 'localization_info_custom_file',
      desc: '',
      args: [v0],
    );
  }

  /// `即将打开本地化文件夹，请将自定义的 任意名称.ini 文件放入 Customize_ini 文件夹。\n\n添加新文件后未显示请使用右上角刷新按钮。\n\n安装时请确保选择了正确的语言。`
  String get localization_info_custom_file_instructions {
    return Intl.message(
      '即将打开本地化文件夹，请将自定义的 任意名称.ini 文件放入 Customize_ini 文件夹。\n\n添加新文件后未显示请使用右上角刷新按钮。\n\n安装时请确保选择了正确的语言。',
      name: 'localization_info_custom_file_instructions',
      desc: '',
      args: [],
    );
  }

  /// `文件受损，请重新下载`
  String get localization_info_corrupted_file {
    return Intl.message(
      '文件受损，请重新下载',
      name: 'localization_info_corrupted_file',
      desc: '',
      args: [],
    );
  }

  /// `安装出错！\n\n {v0}`
  String localization_info_installation_error(Object v0) {
    return Intl.message(
      '安装出错！\n\n $v0',
      name: 'localization_info_installation_error',
      desc: '',
      args: [v0],
    );
  }

  /// `自定义文件`
  String get localization_info_custom_files {
    return Intl.message(
      '自定义文件',
      name: 'localization_info_custom_files',
      desc: '',
      args: [],
    );
  }

  /// `图形优化提示`
  String get performance_info_graphic_optimization_hint {
    return Intl.message(
      '图形优化提示',
      name: 'performance_info_graphic_optimization_hint',
      desc: '',
      args: [],
    );
  }

  /// `该功能对优化显卡瓶颈有很大帮助，但对 CPU 瓶颈可能起反效果，如果您显卡性能强劲，可以尝试使用更好的画质来获得更高的显卡利用率。`
  String get performance_info_graphic_optimization_warning {
    return Intl.message(
      '该功能对优化显卡瓶颈有很大帮助，但对 CPU 瓶颈可能起反效果，如果您显卡性能强劲，可以尝试使用更好的画质来获得更高的显卡利用率。',
      name: 'performance_info_graphic_optimization_warning',
      desc: '',
      args: [],
    );
  }

  /// `当前状态：{v0}`
  String performance_info_current_status(Object v0) {
    return Intl.message(
      '当前状态：$v0',
      name: 'performance_info_current_status',
      desc: '',
      args: [v0],
    );
  }

  /// `已应用`
  String get performance_info_applied {
    return Intl.message(
      '已应用',
      name: 'performance_info_applied',
      desc: '',
      args: [],
    );
  }

  /// `未应用`
  String get performance_info_not_applied {
    return Intl.message(
      '未应用',
      name: 'performance_info_not_applied',
      desc: '',
      args: [],
    );
  }

  /// `预设：`
  String get performance_action_preset {
    return Intl.message(
      '预设：',
      name: 'performance_action_preset',
      desc: '',
      args: [],
    );
  }

  /// `低`
  String get performance_action_low {
    return Intl.message(
      '低',
      name: 'performance_action_low',
      desc: '',
      args: [],
    );
  }

  /// `中`
  String get performance_action_medium {
    return Intl.message(
      '中',
      name: 'performance_action_medium',
      desc: '',
      args: [],
    );
  }

  /// `高`
  String get performance_action_high {
    return Intl.message(
      '高',
      name: 'performance_action_high',
      desc: '',
      args: [],
    );
  }

  /// `超级`
  String get performance_action_super {
    return Intl.message(
      '超级',
      name: 'performance_action_super',
      desc: '',
      args: [],
    );
  }

  /// `（预设只修改图形设置）`
  String get performance_action_info_preset_only_changes_graphics {
    return Intl.message(
      '（预设只修改图形设置）',
      name: 'performance_action_info_preset_only_changes_graphics',
      desc: '',
      args: [],
    );
  }

  /// ` 恢复默认 `
  String get performance_action_reset_to_default {
    return Intl.message(
      ' 恢复默认 ',
      name: 'performance_action_reset_to_default',
      desc: '',
      args: [],
    );
  }

  /// `应用`
  String get performance_action_apply {
    return Intl.message(
      '应用',
      name: 'performance_action_apply',
      desc: '',
      args: [],
    );
  }

  /// `应用并清理着色器（推荐）`
  String get performance_action_apply_and_clear_shaders {
    return Intl.message(
      '应用并清理着色器（推荐）',
      name: 'performance_action_apply_and_clear_shaders',
      desc: '',
      args: [],
    );
  }

  /// `性能优化 -> {v0}`
  String performance_title_performance_optimization(Object v0) {
    return Intl.message(
      '性能优化 -> $v0',
      name: 'performance_title_performance_optimization',
      desc: '',
      args: [v0],
    );
  }

  /// `您可以在这里输入未收录进盒子的自定义参数。配置示例:\n\nr_displayinfo=0\nr_VSync=0`
  String get performance_action_custom_parameters_input {
    return Intl.message(
      '您可以在这里输入未收录进盒子的自定义参数。配置示例:\n\nr_displayinfo=0\nr_VSync=0',
      name: 'performance_action_custom_parameters_input',
      desc: '',
      args: [],
    );
  }

  /// `{v0}    最小值: {v1} / 最大值: {v2}`
  String performance_info_min_max_values(Object v0, Object v1, Object v2) {
    return Intl.message(
      '$v0    最小值: $v1 / 最大值: $v2',
      name: 'performance_info_min_max_values',
      desc: '',
      args: [v0, v1, v2],
    );
  }

  /// `图形`
  String get performance_info_graphics {
    return Intl.message(
      '图形',
      name: 'performance_info_graphics',
      desc: '',
      args: [],
    );
  }

  /// `删除配置文件...`
  String get performance_info_delete_config_file {
    return Intl.message(
      '删除配置文件...',
      name: 'performance_info_delete_config_file',
      desc: '',
      args: [],
    );
  }

  /// `清理着色器`
  String get performance_action_clear_shaders {
    return Intl.message(
      '清理着色器',
      name: 'performance_action_clear_shaders',
      desc: '',
      args: [],
    );
  }

  /// `完成...`
  String get performance_info_done {
    return Intl.message(
      '完成...',
      name: 'performance_info_done',
      desc: '',
      args: [],
    );
  }

  /// `清理着色器后首次进入游戏可能会出现卡顿，请耐心等待游戏初始化完毕。`
  String get performance_info_shader_clearing_warning {
    return Intl.message(
      '清理着色器后首次进入游戏可能会出现卡顿，请耐心等待游戏初始化完毕。',
      name: 'performance_info_shader_clearing_warning',
      desc: '',
      args: [],
    );
  }

  /// `生成配置文件`
  String get performance_info_generate_config_file {
    return Intl.message(
      '生成配置文件',
      name: 'performance_info_generate_config_file',
      desc: '',
      args: [],
    );
  }

  /// `写出配置文件`
  String get performance_info_write_out_config_file {
    return Intl.message(
      '写出配置文件',
      name: 'performance_info_write_out_config_file',
      desc: '',
      args: [],
    );
  }

  /// `首页`
  String get app_index_menu_home {
    return Intl.message(
      '首页',
      name: 'app_index_menu_home',
      desc: '',
      args: [],
    );
  }

  /// `大厅`
  String get app_index_menu_lobby {
    return Intl.message(
      '大厅',
      name: 'app_index_menu_lobby',
      desc: '',
      args: [],
    );
  }

  /// `工具`
  String get app_index_menu_tools {
    return Intl.message(
      '工具',
      name: 'app_index_menu_tools',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get app_index_menu_settings {
    return Intl.message(
      '设置',
      name: 'app_index_menu_settings',
      desc: '',
      args: [],
    );
  }

  /// `关于`
  String get app_index_menu_about {
    return Intl.message(
      '关于',
      name: 'app_index_menu_about',
      desc: '',
      args: [],
    );
  }

  /// `联机大厅，敬请期待 ！`
  String get lobby_online_lobby_coming_soon {
    return Intl.message(
      '联机大厅，敬请期待 ！',
      name: 'lobby_online_lobby_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `诚邀您参与 `
  String get lobby_invitation_to_participate {
    return Intl.message(
      '诚邀您参与 ',
      name: 'lobby_invitation_to_participate',
      desc: '',
      args: [],
    );
  }

  /// `问卷调查。`
  String get lobby_survey {
    return Intl.message(
      '问卷调查。',
      name: 'lobby_survey',
      desc: '',
      args: [],
    );
  }

  /// `创建设置快捷方式`
  String get setting_action_create_settings_shortcut {
    return Intl.message(
      '创建设置快捷方式',
      name: 'setting_action_create_settings_shortcut',
      desc: '',
      args: [],
    );
  }

  /// `在桌面创建《SC汉化盒子》快捷方式`
  String get setting_action_create_desktop_shortcut {
    return Intl.message(
      '在桌面创建《SC汉化盒子》快捷方式',
      name: 'setting_action_create_desktop_shortcut',
      desc: '',
      args: [],
    );
  }

  /// `重置自动密码填充`
  String get setting_action_reset_auto_password_fill {
    return Intl.message(
      '重置自动密码填充',
      name: 'setting_action_reset_auto_password_fill',
      desc: '',
      args: [],
    );
  }

  /// `启用：{v0}    设备支持：{v1}     邮箱：{v2}      密码：{v3}`
  String setting_action_info_device_support_info(
      Object v0, Object v1, Object v2, Object v3) {
    return Intl.message(
      '启用：$v0    设备支持：$v1     邮箱：$v2      密码：$v3',
      name: 'setting_action_info_device_support_info',
      desc: '',
      args: [v0, v1, v2, v3],
    );
  }

  /// `已启用`
  String get setting_action_info_enabled {
    return Intl.message(
      '已启用',
      name: 'setting_action_info_enabled',
      desc: '',
      args: [],
    );
  }

  /// `已禁用`
  String get setting_action_info_disabled {
    return Intl.message(
      '已禁用',
      name: 'setting_action_info_disabled',
      desc: '',
      args: [],
    );
  }

  /// `支持`
  String get setting_action_info_support {
    return Intl.message(
      '支持',
      name: 'setting_action_info_support',
      desc: '',
      args: [],
    );
  }

  /// `不支持`
  String get setting_action_info_not_support {
    return Intl.message(
      '不支持',
      name: 'setting_action_info_not_support',
      desc: '',
      args: [],
    );
  }

  /// `已加密保存`
  String get setting_action_info_encrypted_saved {
    return Intl.message(
      '已加密保存',
      name: 'setting_action_info_encrypted_saved',
      desc: '',
      args: [],
    );
  }

  /// `未保存`
  String get setting_action_info_not_saved {
    return Intl.message(
      '未保存',
      name: 'setting_action_info_not_saved',
      desc: '',
      args: [],
    );
  }

  /// `启动游戏时忽略能效核心（ 适用于Intel 12th+ 处理器 ）`
  String get setting_action_ignore_efficiency_cores_on_launch {
    return Intl.message(
      '启动游戏时忽略能效核心（ 适用于Intel 12th+ 处理器 ）',
      name: 'setting_action_ignore_efficiency_cores_on_launch',
      desc: '',
      args: [],
    );
  }

  /// `已设置的核心数量：{v0}   （此功能适用于首页的盒子一键启动 或 工具中的RSI启动器管理员模式，当为 0 时不启用此功能 ）`
  String setting_action_set_core_count(Object v0) {
    return Intl.message(
      '已设置的核心数量：$v0   （此功能适用于首页的盒子一键启动 或 工具中的RSI启动器管理员模式，当为 0 时不启用此功能 ）',
      name: 'setting_action_set_core_count',
      desc: '',
      args: [v0],
    );
  }

  /// `设置启动器文件（RSI Launcher.exe）`
  String get setting_action_set_launcher_file {
    return Intl.message(
      '设置启动器文件（RSI Launcher.exe）',
      name: 'setting_action_set_launcher_file',
      desc: '',
      args: [],
    );
  }

  /// `手动设置启动器位置，建议仅在无法自动扫描安装位置时使用`
  String get setting_action_info_manual_launcher_location_setting {
    return Intl.message(
      '手动设置启动器位置，建议仅在无法自动扫描安装位置时使用',
      name: 'setting_action_info_manual_launcher_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `设置游戏文件 （StarCitizen.exe）`
  String get setting_action_set_game_file {
    return Intl.message(
      '设置游戏文件 （StarCitizen.exe）',
      name: 'setting_action_set_game_file',
      desc: '',
      args: [],
    );
  }

  /// `手动设置游戏安装位置，建议仅在无法自动扫描安装位置时使用`
  String get setting_action_info_manual_game_location_setting {
    return Intl.message(
      '手动设置游戏安装位置，建议仅在无法自动扫描安装位置时使用',
      name: 'setting_action_info_manual_game_location_setting',
      desc: '',
      args: [],
    );
  }

  /// `清理汉化文件缓存`
  String get setting_action_clear_translation_file_cache {
    return Intl.message(
      '清理汉化文件缓存',
      name: 'setting_action_clear_translation_file_cache',
      desc: '',
      args: [],
    );
  }

  /// `缓存大小 {v0}MB，清理盒子下载的汉化文件缓存，不会影响已安装的汉化`
  String setting_action_info_cache_clearing_info(Object v0) {
    return Intl.message(
      '缓存大小 ${v0}MB，清理盒子下载的汉化文件缓存，不会影响已安装的汉化',
      name: 'setting_action_info_cache_clearing_info',
      desc: '',
      args: [v0],
    );
  }

  /// `工具站访问加速`
  String get setting_action_tool_site_access_acceleration {
    return Intl.message(
      '工具站访问加速',
      name: 'setting_action_tool_site_access_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `使用镜像服务器加速访问 Dps Uex 等工具网站，若访问异常请关闭该功能。 为保护账户安全，任何情况下都不会加速RSI官网。`
  String get setting_action_info_mirror_server_info {
    return Intl.message(
      '使用镜像服务器加速访问 Dps Uex 等工具网站，若访问异常请关闭该功能。 为保护账户安全，任何情况下都不会加速RSI官网。',
      name: 'setting_action_info_mirror_server_info',
      desc: '',
      args: [],
    );
  }

  /// `查看log`
  String get setting_action_view_log {
    return Intl.message(
      '查看log',
      name: 'setting_action_view_log',
      desc: '',
      args: [],
    );
  }

  /// `查看汉化盒子的 log 文件，以定位盒子的 bug`
  String get setting_action_info_view_log_file {
    return Intl.message(
      '查看汉化盒子的 log 文件，以定位盒子的 bug',
      name: 'setting_action_info_view_log_file',
      desc: '',
      args: [],
    );
  }

  /// `确认重置自动填充？`
  String get setting_action_info_confirm_reset_autofill {
    return Intl.message(
      '确认重置自动填充？',
      name: 'setting_action_info_confirm_reset_autofill',
      desc: '',
      args: [],
    );
  }

  /// `这将会删除本地的账号记录，或在下次启动游戏时将自动填充选择 ‘否’ 以禁用自动填充。`
  String get setting_action_info_delete_local_account_warning {
    return Intl.message(
      '这将会删除本地的账号记录，或在下次启动游戏时将自动填充选择 ‘否’ 以禁用自动填充。',
      name: 'setting_action_info_delete_local_account_warning',
      desc: '',
      args: [],
    );
  }

  /// `已清理自动填充数据`
  String get setting_action_info_autofill_data_cleared {
    return Intl.message(
      '已清理自动填充数据',
      name: 'setting_action_info_autofill_data_cleared',
      desc: '',
      args: [],
    );
  }

  /// `请输入要忽略的 CPU 核心数`
  String get setting_action_info_enter_cpu_core_to_ignore {
    return Intl.message(
      '请输入要忽略的 CPU 核心数',
      name: 'setting_action_info_enter_cpu_core_to_ignore',
      desc: '',
      args: [],
    );
  }

  /// `Tip：您的设备拥有几个能效核心就输入几，非大小核设备请保持 0\n\n此功能适用于首页的盒子一键启动 或 工具中的 RSI启动器管理员模式，当为 0 时不启用此功能。`
  String get setting_action_info_cpu_core_tip {
    return Intl.message(
      'Tip：您的设备拥有几个能效核心就输入几，非大小核设备请保持 0\n\n此功能适用于首页的盒子一键启动 或 工具中的 RSI启动器管理员模式，当为 0 时不启用此功能。',
      name: 'setting_action_info_cpu_core_tip',
      desc: '',
      args: [],
    );
  }

  /// `请选择RSI启动器位置（RSI Launcher.exe）`
  String get setting_action_info_select_rsi_launcher_location {
    return Intl.message(
      '请选择RSI启动器位置（RSI Launcher.exe）',
      name: 'setting_action_info_select_rsi_launcher_location',
      desc: '',
      args: [],
    );
  }

  /// `设置成功，在对应页面点击刷新即可扫描出新路径`
  String get setting_action_info_setting_success {
    return Intl.message(
      '设置成功，在对应页面点击刷新即可扫描出新路径',
      name: 'setting_action_info_setting_success',
      desc: '',
      args: [],
    );
  }

  /// `文件有误！`
  String get setting_action_info_file_error {
    return Intl.message(
      '文件有误！',
      name: 'setting_action_info_file_error',
      desc: '',
      args: [],
    );
  }

  /// `请选择游戏安装位置（StarCitizen.exe）`
  String get setting_action_info_select_game_install_location {
    return Intl.message(
      '请选择游戏安装位置（StarCitizen.exe）',
      name: 'setting_action_info_select_game_install_location',
      desc: '',
      args: [],
    );
  }

  /// `确认清理汉化缓存？`
  String get setting_action_info_confirm_clear_cache {
    return Intl.message(
      '确认清理汉化缓存？',
      name: 'setting_action_info_confirm_clear_cache',
      desc: '',
      args: [],
    );
  }

  /// `这不会影响已安装的汉化。`
  String get setting_action_info_clear_cache_warning {
    return Intl.message(
      '这不会影响已安装的汉化。',
      name: 'setting_action_info_clear_cache_warning',
      desc: '',
      args: [],
    );
  }

  /// `因微软版功能限制，请在接下来打开的窗口中 手动将《SC汉化盒子》拖动到桌面，即可创建快捷方式。`
  String get setting_action_info_microsoft_version_limitation {
    return Intl.message(
      '因微软版功能限制，请在接下来打开的窗口中 手动将《SC汉化盒子》拖动到桌面，即可创建快捷方式。',
      name: 'setting_action_info_microsoft_version_limitation',
      desc: '',
      args: [],
    );
  }

  /// `创建完毕，请返回桌面查看`
  String get setting_action_info_shortcut_created {
    return Intl.message(
      '创建完毕，请返回桌面查看',
      name: 'setting_action_info_shortcut_created',
      desc: '',
      args: [],
    );
  }

  /// `发现新版本 -> {v0}`
  String app_upgrade_title_new_version_found(Object v0) {
    return Intl.message(
      '发现新版本 -> $v0',
      name: 'app_upgrade_title_new_version_found',
      desc: '',
      args: [v0],
    );
  }

  /// `正在获取新版本详情...`
  String get app_upgrade_info_getting_new_version_details {
    return Intl.message(
      '正在获取新版本详情...',
      name: 'app_upgrade_info_getting_new_version_details',
      desc: '',
      args: [],
    );
  }

  /// `提示：当前正在使用分流服务器进行更新，可能会出现下载速度下降，但有助于我们进行成本控制，若下载异常请点击这里跳转手动安装。`
  String get app_upgrade_info_update_server_tip {
    return Intl.message(
      '提示：当前正在使用分流服务器进行更新，可能会出现下载速度下降，但有助于我们进行成本控制，若下载异常请点击这里跳转手动安装。',
      name: 'app_upgrade_info_update_server_tip',
      desc: '',
      args: [],
    );
  }

  /// `正在安装：   `
  String get app_upgrade_info_installing {
    return Intl.message(
      '正在安装：   ',
      name: 'app_upgrade_info_installing',
      desc: '',
      args: [],
    );
  }

  /// `正在下载： {v0}%    `
  String app_upgrade_info_downloading(Object v0) {
    return Intl.message(
      '正在下载： $v0%    ',
      name: 'app_upgrade_info_downloading',
      desc: '',
      args: [v0],
    );
  }

  /// `立即更新`
  String get app_upgrade_action_update_now {
    return Intl.message(
      '立即更新',
      name: 'app_upgrade_action_update_now',
      desc: '',
      args: [],
    );
  }

  /// `下次吧`
  String get app_upgrade_action_next_time {
    return Intl.message(
      '下次吧',
      name: 'app_upgrade_action_next_time',
      desc: '',
      args: [],
    );
  }

  /// `下载失败，请尝试手动安装！`
  String get app_upgrade_info_download_failed {
    return Intl.message(
      '下载失败，请尝试手动安装！',
      name: 'app_upgrade_info_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `运行失败，请尝试手动安装！`
  String get app_upgrade_info_run_failed {
    return Intl.message(
      '运行失败，请尝试手动安装！',
      name: 'app_upgrade_info_run_failed',
      desc: '',
      args: [],
    );
  }

  /// `正在检测可用性，这可能需要一点时间...`
  String get app_splash_checking_availability {
    return Intl.message(
      '正在检测可用性，这可能需要一点时间...',
      name: 'app_splash_checking_availability',
      desc: '',
      args: [],
    );
  }

  /// `正在检查更新...`
  String get app_splash_checking_for_updates {
    return Intl.message(
      '正在检查更新...',
      name: 'app_splash_checking_for_updates',
      desc: '',
      args: [],
    );
  }

  /// `即将完成...`
  String get app_splash_almost_done {
    return Intl.message(
      '即将完成...',
      name: 'app_splash_almost_done',
      desc: '',
      args: [],
    );
  }

  /// `RSI 官网`
  String get tools_hosts_info_rsi_official_website {
    return Intl.message(
      'RSI 官网',
      name: 'tools_hosts_info_rsi_official_website',
      desc: '',
      args: [],
    );
  }

  /// `RSI Zendesk 客服站`
  String get tools_hosts_info_rsi_zendesk {
    return Intl.message(
      'RSI Zendesk 客服站',
      name: 'tools_hosts_info_rsi_zendesk',
      desc: '',
      args: [],
    );
  }

  /// `RSI 客服站`
  String get tools_hosts_info_rsi_customer_service {
    return Intl.message(
      'RSI 客服站',
      name: 'tools_hosts_info_rsi_customer_service',
      desc: '',
      args: [],
    );
  }

  /// `正在查询 DNS 并测试可访问性 请耐心等待...`
  String get tools_hosts_info_dns_query_and_test {
    return Intl.message(
      '正在查询 DNS 并测试可访问性 请耐心等待...',
      name: 'tools_hosts_info_dns_query_and_test',
      desc: '',
      args: [],
    );
  }

  /// `正在写入 Hosts ...`
  String get tools_hosts_info_writing_hosts {
    return Intl.message(
      '正在写入 Hosts ...',
      name: 'tools_hosts_info_writing_hosts',
      desc: '',
      args: [],
    );
  }

  /// `读取配置 ...`
  String get tools_hosts_info_reading_config {
    return Intl.message(
      '读取配置 ...',
      name: 'tools_hosts_info_reading_config',
      desc: '',
      args: [],
    );
  }

  /// `Hosts 加速`
  String get tools_hosts_info_hosts_acceleration {
    return Intl.message(
      'Hosts 加速',
      name: 'tools_hosts_info_hosts_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `打开 Hosts 文件`
  String get tools_hosts_info_open_hosts_file {
    return Intl.message(
      '打开 Hosts 文件',
      name: 'tools_hosts_info_open_hosts_file',
      desc: '',
      args: [],
    );
  }

  /// `状态`
  String get tools_hosts_info_status {
    return Intl.message(
      '状态',
      name: 'tools_hosts_info_status',
      desc: '',
      args: [],
    );
  }

  /// `站点`
  String get tools_hosts_info_site {
    return Intl.message(
      '站点',
      name: 'tools_hosts_info_site',
      desc: '',
      args: [],
    );
  }

  /// `是否启用`
  String get tools_hosts_info_enable {
    return Intl.message(
      '是否启用',
      name: 'tools_hosts_info_enable',
      desc: '',
      args: [],
    );
  }

  /// `一键加速`
  String get tools_hosts_action_one_click_acceleration {
    return Intl.message(
      '一键加速',
      name: 'tools_hosts_action_one_click_acceleration',
      desc: '',
      args: [],
    );
  }

  /// `正在扫描...`
  String get tools_info_scanning {
    return Intl.message(
      '正在扫描...',
      name: 'tools_info_scanning',
      desc: '',
      args: [],
    );
  }

  /// `处理失败！：{v0}`
  String tools_info_processing_failed(Object v0) {
    return Intl.message(
      '处理失败！：$v0',
      name: 'tools_info_processing_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `游戏安装位置：  `
  String get tools_info_game_install_location {
    return Intl.message(
      '游戏安装位置：  ',
      name: 'tools_info_game_install_location',
      desc: '',
      args: [],
    );
  }

  /// `RSI启动器位置：`
  String get tools_info_rsi_launcher_location {
    return Intl.message(
      'RSI启动器位置：',
      name: 'tools_info_rsi_launcher_location',
      desc: '',
      args: [],
    );
  }

  /// `查看系统信息`
  String get tools_action_view_system_info {
    return Intl.message(
      '查看系统信息',
      name: 'tools_action_view_system_info',
      desc: '',
      args: [],
    );
  }

  /// `查看系统关键信息，用于快速问诊 \n\n耗时操作，请耐心等待。`
  String get tools_action_info_view_critical_system_info {
    return Intl.message(
      '查看系统关键信息，用于快速问诊 \n\n耗时操作，请耐心等待。',
      name: 'tools_action_info_view_critical_system_info',
      desc: '',
      args: [],
    );
  }

  /// `P4K 分流下载 / 修复`
  String get tools_action_p4k_download_repair {
    return Intl.message(
      'P4K 分流下载 / 修复',
      name: 'tools_action_p4k_download_repair',
      desc: '',
      args: [],
    );
  }

  /// `使用星际公民中文百科提供的分流下载服务，可用于下载或修复 p4k。 \n资源有限，请勿滥用。`
  String get tools_action_info_p4k_download_repair_tip {
    return Intl.message(
      '使用星际公民中文百科提供的分流下载服务，可用于下载或修复 p4k。 \n资源有限，请勿滥用。',
      name: 'tools_action_info_p4k_download_repair_tip',
      desc: '',
      args: [],
    );
  }

  /// `Hosts 加速（实验性）`
  String get tools_action_hosts_acceleration_experimental {
    return Intl.message(
      'Hosts 加速（实验性）',
      name: 'tools_action_hosts_acceleration_experimental',
      desc: '',
      args: [],
    );
  }

  /// `将 IP 信息写入 Hosts 文件，解决部分地区的 DNS 污染导致无法登录官网等问题。\n该功能正在进行第一阶段测试，遇到问题请及时反馈。`
  String get tools_action_info_hosts_acceleration_experimental_tip {
    return Intl.message(
      '将 IP 信息写入 Hosts 文件，解决部分地区的 DNS 污染导致无法登录官网等问题。\n该功能正在进行第一阶段测试，遇到问题请及时反馈。',
      name: 'tools_action_info_hosts_acceleration_experimental_tip',
      desc: '',
      args: [],
    );
  }

  /// `重装 EasyAntiCheat 反作弊`
  String get tools_action_reinstall_easyanticheat {
    return Intl.message(
      '重装 EasyAntiCheat 反作弊',
      name: 'tools_action_reinstall_easyanticheat',
      desc: '',
      args: [],
    );
  }

  /// `若您遇到 EAC 错误，且自动修复无效，请尝试使用此功能重装 EAC。`
  String get tools_action_info_reinstall_eac {
    return Intl.message(
      '若您遇到 EAC 错误，且自动修复无效，请尝试使用此功能重装 EAC。',
      name: 'tools_action_info_reinstall_eac',
      desc: '',
      args: [],
    );
  }

  /// `RSI Launcher 管理员模式`
  String get tools_action_rsi_launcher_admin_mode {
    return Intl.message(
      'RSI Launcher 管理员模式',
      name: 'tools_action_rsi_launcher_admin_mode',
      desc: '',
      args: [],
    );
  }

  /// `以管理员身份运行RSI启动器，可能会解决一些问题。\n\n若设置了能效核心屏蔽参数，也会在此应用。`
  String get tools_action_info_run_rsi_as_admin {
    return Intl.message(
      '以管理员身份运行RSI启动器，可能会解决一些问题。\n\n若设置了能效核心屏蔽参数，也会在此应用。',
      name: 'tools_action_info_run_rsi_as_admin',
      desc: '',
      args: [],
    );
  }

  /// `初始化失败，请截图报告给开发者。{v0}`
  String tools_action_info_init_failed(Object v0) {
    return Intl.message(
      '初始化失败，请截图报告给开发者。$v0',
      name: 'tools_action_info_init_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `RSI Launcher Log 修复`
  String get tools_action_rsi_launcher_log_fix {
    return Intl.message(
      'RSI Launcher Log 修复',
      name: 'tools_action_rsi_launcher_log_fix',
      desc: '',
      args: [],
    );
  }

  /// `在某些情况下 RSI启动器 的 log 文件会损坏，导致无法完成问题扫描，使用此工具清理损坏的 log 文件。\n\n当前日志文件大小：{0} MB`
  String get tools_action_info_rsi_launcher_log_issue {
    return Intl.message(
      '在某些情况下 RSI启动器 的 log 文件会损坏，导致无法完成问题扫描，使用此工具清理损坏的 log 文件。\n\n当前日志文件大小：{0} MB',
      name: 'tools_action_info_rsi_launcher_log_issue',
      desc: '',
      args: [],
    );
  }

  /// `移除 nvme 注册表补丁`
  String get tools_action_remove_nvme_registry_patch {
    return Intl.message(
      '移除 nvme 注册表补丁',
      name: 'tools_action_remove_nvme_registry_patch',
      desc: '',
      args: [],
    );
  }

  /// `若您使用 nvme 补丁出现问题，请运行此工具。（可能导致游戏 安装/更新 不可用。）\n\n当前补丁状态：{v0}`
  String tools_action_info_nvme_patch_issue(Object v0) {
    return Intl.message(
      '若您使用 nvme 补丁出现问题，请运行此工具。（可能导致游戏 安装/更新 不可用。）\n\n当前补丁状态：$v0',
      name: 'tools_action_info_nvme_patch_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `未安装`
  String get tools_action_info_not_installed {
    return Intl.message(
      '未安装',
      name: 'tools_action_info_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `已移除，重启电脑生效！`
  String get tools_action_info_removed_restart_effective {
    return Intl.message(
      '已移除，重启电脑生效！',
      name: 'tools_action_info_removed_restart_effective',
      desc: '',
      args: [],
    );
  }

  /// `写入 nvme 注册表补丁`
  String get tools_action_write_nvme_registry_patch {
    return Intl.message(
      '写入 nvme 注册表补丁',
      name: 'tools_action_write_nvme_registry_patch',
      desc: '',
      args: [],
    );
  }

  /// `手动写入NVM补丁，该功能仅在您知道自己在作什么的情况下使用`
  String get tools_action_info_manual_nvme_patch {
    return Intl.message(
      '手动写入NVM补丁，该功能仅在您知道自己在作什么的情况下使用',
      name: 'tools_action_info_manual_nvme_patch',
      desc: '',
      args: [],
    );
  }

  /// `修复成功，请尝试重启电脑后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。`
  String get tools_action_info_fix_success_restart {
    return Intl.message(
      '修复成功，请尝试重启电脑后继续安装游戏！ 若注册表修改操作导致其他软件出现兼容问题，请使用 工具 中的 NVME 注册表清理。',
      name: 'tools_action_info_fix_success_restart',
      desc: '',
      args: [],
    );
  }

  /// `清理着色器缓存`
  String get tools_action_clear_shader_cache {
    return Intl.message(
      '清理着色器缓存',
      name: 'tools_action_clear_shader_cache',
      desc: '',
      args: [],
    );
  }

  /// `若游戏画面出现异常或版本更新后可使用本工具清理过期的着色器（当大于500M时，建议清理） \n\n缓存大小：{v0} MB`
  String tools_action_info_shader_cache_issue(Object v0) {
    return Intl.message(
      '若游戏画面出现异常或版本更新后可使用本工具清理过期的着色器（当大于500M时，建议清理） \n\n缓存大小：$v0 MB',
      name: 'tools_action_info_shader_cache_issue',
      desc: '',
      args: [v0],
    );
  }

  /// `关闭摄影模式`
  String get tools_action_close_photography_mode {
    return Intl.message(
      '关闭摄影模式',
      name: 'tools_action_close_photography_mode',
      desc: '',
      args: [],
    );
  }

  /// `开启摄影模式`
  String get tools_action_open_photography_mode {
    return Intl.message(
      '开启摄影模式',
      name: 'tools_action_open_photography_mode',
      desc: '',
      args: [],
    );
  }

  /// `还原镜头摇晃效果。\n\n@拉邦那 Lapernum 提供参数信息。`
  String get tools_action_info_restore_lens_shake {
    return Intl.message(
      '还原镜头摇晃效果。\n\n@拉邦那 Lapernum 提供参数信息。',
      name: 'tools_action_info_restore_lens_shake',
      desc: '',
      args: [],
    );
  }

  /// `一键关闭游戏内镜头晃动以便于摄影操作。\n\n @拉邦那 Lapernum 提供参数信息。`
  String get tools_action_info_one_key_close_lens_shake {
    return Intl.message(
      '一键关闭游戏内镜头晃动以便于摄影操作。\n\n @拉邦那 Lapernum 提供参数信息。',
      name: 'tools_action_info_one_key_close_lens_shake',
      desc: '',
      args: [],
    );
  }

  /// `解析 log 文件失败！\n请尝试使用 RSI Launcher log 修复 工具！`
  String get tools_action_info_log_file_parse_failed {
    return Intl.message(
      '解析 log 文件失败！\n请尝试使用 RSI Launcher log 修复 工具！',
      name: 'tools_action_info_log_file_parse_failed',
      desc: '',
      args: [],
    );
  }

  /// `未找到 RSI 启动器，请尝试重新安装，或在设置中手动添加。`
  String get tools_action_info_rsi_launcher_not_found {
    return Intl.message(
      '未找到 RSI 启动器，请尝试重新安装，或在设置中手动添加。',
      name: 'tools_action_info_rsi_launcher_not_found',
      desc: '',
      args: [],
    );
  }

  /// `未找到星际公民游戏安装位置，请至少完成一次游戏启动操作 或在设置中手动添加。`
  String get tools_action_info_star_citizen_not_found {
    return Intl.message(
      '未找到星际公民游戏安装位置，请至少完成一次游戏启动操作 或在设置中手动添加。',
      name: 'tools_action_info_star_citizen_not_found',
      desc: '',
      args: [],
    );
  }

  /// `该功能需要一个有效的游戏安装目录`
  String get tools_action_info_valid_game_directory_needed {
    return Intl.message(
      '该功能需要一个有效的游戏安装目录',
      name: 'tools_action_info_valid_game_directory_needed',
      desc: '',
      args: [],
    );
  }

  /// `已为您移除 EAC 文件，接下来将为您打开 RSI 启动器，请您前往 SETTINGS -> VERIFY 重装 EAC。`
  String get tools_action_info_eac_file_removed {
    return Intl.message(
      '已为您移除 EAC 文件，接下来将为您打开 RSI 启动器，请您前往 SETTINGS -> VERIFY 重装 EAC。',
      name: 'tools_action_info_eac_file_removed',
      desc: '',
      args: [],
    );
  }

  /// `出现错误：{v0}`
  String tools_action_info_error_occurred(Object v0) {
    return Intl.message(
      '出现错误：$v0',
      name: 'tools_action_info_error_occurred',
      desc: '',
      args: [v0],
    );
  }

  /// `系统：{v0}\n\n处理器：{v1}\n\n内存大小：{v2}GB\n\n显卡信息：\n{v3}\n\n硬盘信息：\n{v4}\n\n`
  String tools_action_info_system_info_content(
      Object v0, Object v1, Object v2, Object v3, Object v4) {
    return Intl.message(
      '系统：$v0\n\n处理器：$v1\n\n内存大小：${v2}GB\n\n显卡信息：\n$v3\n\n硬盘信息：\n$v4\n\n',
      name: 'tools_action_info_system_info_content',
      desc: '',
      args: [v0, v1, v2, v3, v4],
    );
  }

  /// `未找到 RSI 启动器目录，请您尝试手动操作。`
  String get tools_action_info_rsi_launcher_directory_not_found {
    return Intl.message(
      '未找到 RSI 启动器目录，请您尝试手动操作。',
      name: 'tools_action_info_rsi_launcher_directory_not_found',
      desc: '',
      args: [],
    );
  }

  /// `日志文件不存在，请尝试进行一次游戏启动或游戏安装，并退出启动器，若无法解决问题，请尝试将启动器更新至最新版本！`
  String get tools_action_info_log_file_not_exist {
    return Intl.message(
      '日志文件不存在，请尝试进行一次游戏启动或游戏安装，并退出启动器，若无法解决问题，请尝试将启动器更新至最新版本！',
      name: 'tools_action_info_log_file_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `清理完毕，请完成一次安装 / 游戏启动 操作。`
  String get tools_action_info_cleanup_complete {
    return Intl.message(
      '清理完毕，请完成一次安装 / 游戏启动 操作。',
      name: 'tools_action_info_cleanup_complete',
      desc: '',
      args: [],
    );
  }

  /// `清理失败，请手动移除，文件位置：{v0}`
  String tools_action_info_cleanup_failed(Object v0) {
    return Intl.message(
      '清理失败，请手动移除，文件位置：$v0',
      name: 'tools_action_info_cleanup_failed',
      desc: '',
      args: [v0],
    );
  }

  /// `系统信息`
  String get tools_action_info_system_info_title {
    return Intl.message(
      '系统信息',
      name: 'tools_action_info_system_info_title',
      desc: '',
      args: [],
    );
  }

  /// `RSI启动器正在运行！请先关闭启动器再使用此功能！`
  String get tools_action_info_rsi_launcher_running_warning {
    return Intl.message(
      'RSI启动器正在运行！请先关闭启动器再使用此功能！',
      name: 'tools_action_info_rsi_launcher_running_warning',
      desc: '',
      args: [],
    );
  }

  /// `P4k 是星际公民的核心游戏文件，高达 100GB+，盒子提供的离线下载是为了帮助一些p4k文件下载超级慢的用户 或用于修复官方启动器无法修复的 p4k 文件。\n\n接下来会弹窗询问您保存位置（可以选择星际公民文件夹也可以选择别处），下载完成后请确保 P4K 文件夹位于 LIVE 文件夹内，之后使用星际公民启动器校验更新即可。`
  String get tools_action_info_p4k_file_description {
    return Intl.message(
      'P4k 是星际公民的核心游戏文件，高达 100GB+，盒子提供的离线下载是为了帮助一些p4k文件下载超级慢的用户 或用于修复官方启动器无法修复的 p4k 文件。\n\n接下来会弹窗询问您保存位置（可以选择星际公民文件夹也可以选择别处），下载完成后请确保 P4K 文件夹位于 LIVE 文件夹内，之后使用星际公民启动器校验更新即可。',
      name: 'tools_action_info_p4k_file_description',
      desc: '',
      args: [],
    );
  }

  /// `P4k 是星际公民的核心游戏文件，高达 100GB+，盒子提供的离线下载是为了帮助一些p4k文件下载超级慢的用户 或用于修复官方启动器无法修复的 p4k 文件。`
  String get tools_action_info_p4k_file_description_part1 {
    return Intl.message(
      'P4k 是星际公民的核心游戏文件，高达 100GB+，盒子提供的离线下载是为了帮助一些p4k文件下载超级慢的用户 或用于修复官方启动器无法修复的 p4k 文件。',
      name: 'tools_action_info_p4k_file_description_part1',
      desc: '',
      args: [],
    );
  }

  /// `\n\n接下来会弹窗询问您保存位置（可以选择星际公民文件夹也可以选择别处），下载完成后请确保 P4K 文件夹位于 LIVE 文件夹内，之后使用星际公民启动器校验更新即可。`
  String get tools_action_info_p4k_file_description_part2 {
    return Intl.message(
      '\n\n接下来会弹窗询问您保存位置（可以选择星际公民文件夹也可以选择别处），下载完成后请确保 P4K 文件夹位于 LIVE 文件夹内，之后使用星际公民启动器校验更新即可。',
      name: 'tools_action_info_p4k_file_description_part2',
      desc: '',
      args: [],
    );
  }

  /// `已经有一个p4k下载任务正在进行中，请前往下载管理器查看！`
  String get tools_action_info_p4k_download_in_progress {
    return Intl.message(
      '已经有一个p4k下载任务正在进行中，请前往下载管理器查看！',
      name: 'tools_action_info_p4k_download_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `功能维护中，请稍后重试！`
  String get tools_action_info_function_under_maintenance {
    return Intl.message(
      '功能维护中，请稍后重试！',
      name: 'tools_action_info_function_under_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `配置文件不存在，请尝试运行一次游戏`
  String get tools_action_info_config_file_not_exist {
    return Intl.message(
      '配置文件不存在，请尝试运行一次游戏',
      name: 'tools_action_info_config_file_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `名成员`
  String get webview_localization_name_member {
    return Intl.message(
      '名成员',
      name: 'webview_localization_name_member',
      desc: '',
      args: [],
    );
  }

  /// `总邀请数：`
  String get webview_localization_total_invitations {
    return Intl.message(
      '总邀请数：',
      name: 'webview_localization_total_invitations',
      desc: '',
      args: [],
    );
  }

  /// `未完成的邀请`
  String get webview_localization_unfinished_invitations {
    return Intl.message(
      '未完成的邀请',
      name: 'webview_localization_unfinished_invitations',
      desc: '',
      args: [],
    );
  }

  /// `已完成的邀请`
  String get webview_localization_finished_invitations {
    return Intl.message(
      '已完成的邀请',
      name: 'webview_localization_finished_invitations',
      desc: '',
      args: [],
    );
  }

  /// `初始化失败：{v0}`
  String app_init_failed_with_reason(Object v0) {
    return Intl.message(
      '初始化失败：$v0',
      name: 'app_init_failed_with_reason',
      desc: '',
      args: [v0],
    );
  }

  /// `请输入设备PIN以自动登录RSI账户`
  String get webview_localization_enter_device_pin {
    return Intl.message(
      '请输入设备PIN以自动登录RSI账户',
      name: 'webview_localization_enter_device_pin',
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
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
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
