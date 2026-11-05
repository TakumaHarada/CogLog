// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: depend_on_referenced_packages, implementation_imports, invalid_use_of_internal_member
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:monolith_localization_runtime/src/localize_string_delegate.dart';
import 'package:monolith_localization_runtime/src/localize_string_source.dart';

import 'l10n.dart';

/// e.g.
/// localizationsDelegates: [
///   L10nHelper.delegate,
///   GlobalMaterialLocalizations.delegate,
///   GlobalCupertinoLocalizations.delegate,
///   GlobalWidgetsLocalizations.delegate,
/// ]
final class L10nHelper {
  const L10nHelper._();

  /// L10n Delegate instance.
  static const delegate = _L10nHelperDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const supportedLocales = L10n.supportedLocales;

  static void configure(L10n? l10n) {
    if (l10n == null) {
      return;
    }
    final table = <String, String Function(LocalizeStringSource source)>{
      'app_count': (source) {
        // Has Placeholders
        var index = 0;
        String count = source.arguments[index];
        index++;
        return l10n.app_count(count);
      },
      'app_increase': (source) {
        // No Placeholders
        return l10n.app_increase;
      },
      'foundation_resources_app_name': (source) {
        // No Placeholders
        return l10n.foundation_resources_app_name;
      },
      'screen_feature_top_calories': (source) {
        // No Placeholders
        return l10n.screen_feature_top_calories;
      },
      'screen_feature_top_calories_unit': (source) {
        // No Placeholders
        return l10n.screen_feature_top_calories_unit;
      },
      'screen_feature_top_distance': (source) {
        // No Placeholders
        return l10n.screen_feature_top_distance;
      },
      'screen_feature_top_distance_unit': (source) {
        // No Placeholders
        return l10n.screen_feature_top_distance_unit;
      },
      'screen_feature_top_duration': (source) {
        // No Placeholders
        return l10n.screen_feature_top_duration;
      },
      'screen_feature_top_open_camera': (source) {
        // No Placeholders
        return l10n.screen_feature_top_open_camera;
      },
      'screen_feature_top_this_month': (source) {
        // No Placeholders
        return l10n.screen_feature_top_this_month;
      },
      'screen_feature_top_this_week': (source) {
        // No Placeholders
        return l10n.screen_feature_top_this_week;
      },
      'screen_feature_top_today': (source) {
        // No Placeholders
        return l10n.screen_feature_top_today;
      },
    };

    LocalizeStringDelegate.delegate = (source) {
      final id = source.id;
      final func = table[id]!;
      return func(source);
    };
  }
}

class _L10nHelperDelegate implements LocalizationsDelegate<L10n> {
  final delegate = L10n.delegate;

  const _L10nHelperDelegate();

  @override
  Type get type => delegate.type;

  @override
  bool isSupported(Locale locale) => delegate.isSupported(locale);

  @override
  Future<L10n> load(Locale locale) async {
    final result = await delegate.load(locale);
    L10nHelper.configure(result);
    return result;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<L10n> old) => false;
}
