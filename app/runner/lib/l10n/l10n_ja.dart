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
}
