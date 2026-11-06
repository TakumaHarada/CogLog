// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String app_count(String count) {
    return '回数 $count';
  }

  @override
  String get app_increase => '増やす';

  @override
  String get foundation_resources_app_name => 'CogLog';

  @override
  String get screen_feature_exercise_history_title => '運動履歴';

  @override
  String get screen_feature_goal_settings_title => '目標設定';

  @override
  String get screen_feature_main_nav_exercise_history => '運動履歴';

  @override
  String get screen_feature_main_nav_goal_settings => '目標設定';

  @override
  String get screen_feature_main_nav_home => 'ホーム';

  @override
  String get screen_feature_main_nav_meter_capture => 'メーター撮影';

  @override
  String get screen_feature_meter_capture_title => 'メーター撮影';

  @override
  String get screen_feature_top_calories => '消費カロリー';

  @override
  String get screen_feature_top_calories_unit => 'kcal';

  @override
  String get screen_feature_top_distance => '走行距離';

  @override
  String get screen_feature_top_distance_unit => 'km';

  @override
  String get screen_feature_top_duration => '運動時間';

  @override
  String get screen_feature_top_this_month => '今月';

  @override
  String get screen_feature_top_this_week => '今週';

  @override
  String get screen_feature_top_today => '本日';
}
