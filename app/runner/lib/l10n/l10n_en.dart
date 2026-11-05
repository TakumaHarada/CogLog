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
  String get screen_feature_top_open_camera => 'Photograph the meter panel';

  @override
  String get screen_feature_top_this_month => 'This month';

  @override
  String get screen_feature_top_this_week => 'This week';

  @override
  String get screen_feature_top_today => 'Today';
}
