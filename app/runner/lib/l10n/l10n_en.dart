// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String app_count(String count) {
    return 'Count $count';
  }

  @override
  String get app_increase => 'Increase';

  @override
  String get foundation_resources_app_name => 'CogLog';

  @override
  String get screen_feature_exercise_history_title => 'Exercise history';

  @override
  String get screen_feature_goal_settings_calories_label => 'Calories';

  @override
  String get screen_feature_goal_settings_calories_unit => 'kcal';

  @override
  String get screen_feature_goal_settings_distance_label => 'Distance';

  @override
  String get screen_feature_goal_settings_distance_unit => 'km';

  @override
  String get screen_feature_goal_settings_duration_label => 'Exercise time';

  @override
  String get screen_feature_goal_settings_hours_label => 'Hours';

  @override
  String get screen_feature_goal_settings_minutes_label => 'Minutes';

  @override
  String get screen_feature_goal_settings_save => 'Save';

  @override
  String get screen_feature_goal_settings_save_failed => 'Could not save goals';

  @override
  String get screen_feature_goal_settings_save_invalid_input =>
      'Check your input values';

  @override
  String get screen_feature_goal_settings_save_success => 'Goals saved';

  @override
  String get screen_feature_goal_settings_seconds_label => 'Seconds';

  @override
  String get screen_feature_goal_settings_title => 'Goals';

  @override
  String get screen_feature_goal_settings_unset_hint =>
      'Leave fields empty to keep them unset';

  @override
  String get screen_feature_main_nav_exercise_history => 'Exercise history';

  @override
  String get screen_feature_main_nav_goal_settings => 'Goals';

  @override
  String get screen_feature_main_nav_home => 'Home';

  @override
  String get screen_feature_main_nav_meter_capture => 'Meter capture';

  @override
  String get screen_feature_meter_capture_title => 'Meter capture';

  @override
  String get screen_feature_top_calories => 'Calories';

  @override
  String get screen_feature_top_calories_unit => 'kcal';

  @override
  String get screen_feature_top_distance => 'Distance';

  @override
  String get screen_feature_top_distance_unit => 'km';

  @override
  String get screen_feature_top_duration => 'Exercise time';

  @override
  String get screen_feature_top_this_month => 'This month';

  @override
  String get screen_feature_top_this_week => 'This week';

  @override
  String get screen_feature_top_today => 'Today';
}
