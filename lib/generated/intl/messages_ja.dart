// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m2(v0, v1) => "SCToolBox V ${v0} ${v1}";

  static String m19(v0, v1) => "ダウンロード： ${v0}/s    アップロード：${v1}/s";

  static String m20(v0) => "ダウンロード済み：${v0}";

  static String m21(v0) => "ダウンロード... (${v0}%)";

  static String m22(v0) => "ステータス：${v0}";

  static String m23(v1) => "サイズ合計：${v1}";

  static String m24(v0) => "アップロード済み：${v0}";

  static String m25(v2) => "検証中...（${v2}）";

  static String m31(v1, v2) =>
      "RSI サーバレポートのバージョン：${v1} \n\nローカルのバージョン：${v2} \n\nRSI Launcher を使ってゲームをアップデートしてください！";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_action_email":
            MessageLookupByLibrary.simpleMessage("メール: xkeyc@qq.com"),
        "about_action_open_source":
            MessageLookupByLibrary.simpleMessage("オープンソース"),
        "about_analytics_install_translation":
            MessageLookupByLibrary.simpleMessage("日本語化インストール"),
        "about_analytics_launch": MessageLookupByLibrary.simpleMessage("起動"),
        "about_analytics_launch_game":
            MessageLookupByLibrary.simpleMessage("ゲームを起動"),
        "about_analytics_p4k_redirection":
            MessageLookupByLibrary.simpleMessage("P4Kダウンロード"),
        "about_analytics_total_users":
            MessageLookupByLibrary.simpleMessage("利用者数"),
        "about_analytics_units_times":
            MessageLookupByLibrary.simpleMessage("回"),
        "about_analytics_units_user": MessageLookupByLibrary.simpleMessage("人"),
        "about_check_update": MessageLookupByLibrary.simpleMessage("更新チェック"),
        "about_disclaimer": MessageLookupByLibrary.simpleMessage(
            "これは Star Citizen の非公式ツールです、Cloud Imperium Games LLC の所有ではない。 本ソフトウェアのホストまたは使用者によって作成されていないすべての情報は、それぞれの所有者に帰属します。 \nStar Citizen®、Roberts Space Industries®、Cloud Imperium® は Cloud Imperium Rights LLC のトレードマーク。"),
        "about_info_latest_version":
            MessageLookupByLibrary.simpleMessage("すでに最新バージョンだ！"),
        "about_online_feedback":
            MessageLookupByLibrary.simpleMessage("フィードバック"),
        "action_close": MessageLookupByLibrary.simpleMessage("クローズ"),
        "action_open_folder": MessageLookupByLibrary.simpleMessage("フォルダを開く"),
        "app_index_version_info": m2,
        "app_language_code": MessageLookupByLibrary.simpleMessage("ja"),
        "app_language_name": MessageLookupByLibrary.simpleMessage("日本語"),
        "downloader_action_cancel_all":
            MessageLookupByLibrary.simpleMessage("すべてキャンセル"),
        "downloader_action_cancel_download":
            MessageLookupByLibrary.simpleMessage("ダウンロードをキャンセル"),
        "downloader_action_confirm_cancel_all_tasks":
            MessageLookupByLibrary.simpleMessage("すべてのタスクのキャンセルを確認する？"),
        "downloader_action_confirm_cancel_download":
            MessageLookupByLibrary.simpleMessage("ダウンロードのキャンセルを確認しますか？"),
        "downloader_action_continue_download":
            MessageLookupByLibrary.simpleMessage("ダウンロードを続ける"),
        "downloader_action_options":
            MessageLookupByLibrary.simpleMessage("オプション"),
        "downloader_action_pause_all":
            MessageLookupByLibrary.simpleMessage("すべて一時停止"),
        "downloader_action_pause_download":
            MessageLookupByLibrary.simpleMessage("ダウンロードの一時停止"),
        "downloader_action_resume_all":
            MessageLookupByLibrary.simpleMessage("すべて復元"),
        "downloader_info_deleted": MessageLookupByLibrary.simpleMessage("削除済み"),
        "downloader_info_download_completed":
            MessageLookupByLibrary.simpleMessage("ダウンロード完了"),
        "downloader_info_download_failed":
            MessageLookupByLibrary.simpleMessage("ダウンロード失敗"),
        "downloader_info_download_upload_speed": m19,
        "downloader_info_downloaded": m20,
        "downloader_info_downloading": m21,
        "downloader_info_downloading_status":
            MessageLookupByLibrary.simpleMessage("ダウンロード中..."),
        "downloader_info_manual_file_deletion_note":
            MessageLookupByLibrary.simpleMessage(
                "ダウンロードしたファイルが不要になった場合は、手動で削除する必要があります。"),
        "downloader_info_no_download_tasks":
            MessageLookupByLibrary.simpleMessage("ダウンロードタスクなし"),
        "downloader_info_paused": MessageLookupByLibrary.simpleMessage("一時停止中"),
        "downloader_info_status": m22,
        "downloader_info_total_size": m23,
        "downloader_info_uploaded": m24,
        "downloader_info_verifying": m25,
        "downloader_info_waiting": MessageLookupByLibrary.simpleMessage("待機中"),
        "downloader_speed_limit_settings":
            MessageLookupByLibrary.simpleMessage("速度制限設定"),
        "downloader_title_downloading":
            MessageLookupByLibrary.simpleMessage("ダウンロード中"),
        "downloader_title_ended": MessageLookupByLibrary.simpleMessage("終了"),
        "home_action_login_rsi_account":
            MessageLookupByLibrary.simpleMessage("RSI アカウントログイン"),
        "home_action_one_click_launch":
            MessageLookupByLibrary.simpleMessage("ワンクリック起動"),
        "home_action_q_auto_password_fill_prompt":
            MessageLookupByLibrary.simpleMessage("パスワードの自動入力はオンになっていますか？"),
        "home_holiday_countdown":
            MessageLookupByLibrary.simpleMessage("祝日カウントダウン"),
        "home_holiday_countdown_disclaimer":
            MessageLookupByLibrary.simpleMessage(
                "* 上記の祝日は手作業で収集・管理されているため、誤りがある可能性があります、フィードバックは歓迎する！！"),
        "home_info_auto_fill_notice": MessageLookupByLibrary.simpleMessage(
            "* 自動入力がオンになっている場合は、Windows Hello のポップアップに注意してください"),
        "home_login_action_title_box_one_click_launch":
            MessageLookupByLibrary.simpleMessage("ボックスワンクリック起動"),
        "home_login_action_title_need_webview2_runtime":
            MessageLookupByLibrary.simpleMessage("WebView2 Runtime のインストールが必要"),
        "home_login_info_action_ignore":
            MessageLookupByLibrary.simpleMessage("無視する"),
        "home_login_info_enter_pin_to_encrypt":
            MessageLookupByLibrary.simpleMessage("PINを入力して暗号化を有効にする"),
        "home_login_info_game_version_outdated":
            MessageLookupByLibrary.simpleMessage("ゲームバージョンが古すぎる"),
        "home_login_info_one_click_launch_description":
            MessageLookupByLibrary.simpleMessage(
                "この機能は、ゲームをより便利に起動するのに役立ちます。\n\nアカウントのセキュリティを確保するため、この機能はローカライズブラウザを使用してログイン状態を保持し、パスワード情報を保存しません（自動入力オンの場合を除く）。\n\nこの機能を使用してアカウントにログインする際は、SCToolBox が信頼できるソースからダウンロードされていることを確認してください。"),
        "home_login_info_password_encryption_notice":
            MessageLookupByLibrary.simpleMessage(
                "このツールには PIN と Windows 認証を使用して暗号化のパスワードが保存され、パスワードはローカルのみ保存されます。\n\n次回のログインでパスワードが必要になった場合、PIN だけてを許可する後、パスワードは自動的に入力して、ログインできます。"),
        "home_login_info_rsi_server_report": m31,
        "home_login_title_launching_game":
            MessageLookupByLibrary.simpleMessage("ゲーム起動中..."),
        "home_login_title_welcome_back":
            MessageLookupByLibrary.simpleMessage("お帰りなさい！"),
        "home_title_logging_in":
            MessageLookupByLibrary.simpleMessage("ログイン中...")
      };
}
