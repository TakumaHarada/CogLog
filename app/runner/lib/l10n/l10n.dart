import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ja'),
    Locale('en'),
  ];

  /// 現在の回数
  ///
  /// In ja, this message translates to:
  /// **'回数 {count}'**
  String app_count(String count);

  /// カウントを増やすボタン
  ///
  /// In ja, this message translates to:
  /// **'増やす'**
  String get app_increase;

  /// アプリケーション名
  ///
  /// In ja, this message translates to:
  /// **'CogLog'**
  String get foundation_resources_app_name;

  /// 画面タイトル
  ///
  /// In ja, this message translates to:
  /// **'運動履歴'**
  String get screen_feature_exercise_history_title;

  /// 一日あたり消費カロリーの欄
  ///
  /// In ja, this message translates to:
  /// **'消費カロリー'**
  String get screen_feature_goal_settings_calories_label;

  /// 消費カロリーの単位
  ///
  /// In ja, this message translates to:
  /// **'kcal'**
  String get screen_feature_goal_settings_calories_unit;

  /// 一日あたり走行距離の欄
  ///
  /// In ja, this message translates to:
  /// **'走行距離'**
  String get screen_feature_goal_settings_distance_label;

  /// 走行距離の単位
  ///
  /// In ja, this message translates to:
  /// **'km'**
  String get screen_feature_goal_settings_distance_unit;

  /// 一日あたり運動時間の欄
  ///
  /// In ja, this message translates to:
  /// **'運動時間'**
  String get screen_feature_goal_settings_duration_label;

  /// 運動時間の時
  ///
  /// In ja, this message translates to:
  /// **'時間'**
  String get screen_feature_goal_settings_hours_label;

  /// 運動時間の分
  ///
  /// In ja, this message translates to:
  /// **'分'**
  String get screen_feature_goal_settings_minutes_label;

  /// 目標を保存するボタン
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get screen_feature_goal_settings_save;

  /// 運動時間の秒
  ///
  /// In ja, this message translates to:
  /// **'秒'**
  String get screen_feature_goal_settings_seconds_label;

  /// 画面タイトル
  ///
  /// In ja, this message translates to:
  /// **'目標設定'**
  String get screen_feature_goal_settings_title;

  /// 未設定の説明
  ///
  /// In ja, this message translates to:
  /// **'未設定の欄は空のまま保存できます'**
  String get screen_feature_goal_settings_unset_hint;

  /// ボトムナビ
  ///
  /// In ja, this message translates to:
  /// **'運動履歴'**
  String get screen_feature_main_nav_exercise_history;

  /// ボトムナビ
  ///
  /// In ja, this message translates to:
  /// **'目標設定'**
  String get screen_feature_main_nav_goal_settings;

  /// ボトムナビ
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get screen_feature_main_nav_home;

  /// ボトムナビ
  ///
  /// In ja, this message translates to:
  /// **'メーター撮影'**
  String get screen_feature_main_nav_meter_capture;

  /// 画面タイトル
  ///
  /// In ja, this message translates to:
  /// **'メーター撮影'**
  String get screen_feature_meter_capture_title;

  /// 指標
  ///
  /// In ja, this message translates to:
  /// **'消費カロリー'**
  String get screen_feature_top_calories;

  /// 消費カロリーの単位
  ///
  /// In ja, this message translates to:
  /// **'kcal'**
  String get screen_feature_top_calories_unit;

  /// 指標
  ///
  /// In ja, this message translates to:
  /// **'走行距離'**
  String get screen_feature_top_distance;

  /// 走行距離の単位
  ///
  /// In ja, this message translates to:
  /// **'km'**
  String get screen_feature_top_distance_unit;

  /// 指標
  ///
  /// In ja, this message translates to:
  /// **'運動時間'**
  String get screen_feature_top_duration;

  /// 集計期間
  ///
  /// In ja, this message translates to:
  /// **'今月'**
  String get screen_feature_top_this_month;

  /// 集計期間
  ///
  /// In ja, this message translates to:
  /// **'今週'**
  String get screen_feature_top_this_week;

  /// 集計期間
  ///
  /// In ja, this message translates to:
  /// **'本日'**
  String get screen_feature_top_today;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ja':
      return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
