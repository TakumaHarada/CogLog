/// CogLog のローカライゼーション入口。
///
/// `material_ui` の `MaterialApp` には [appLocalizationsDelegates] を渡す。
/// [L10nHelper.localizationsDelegates] だけでは、日本語の Material 文言にならない。
///
/// Example:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: appLocalizationsDelegates,
///   supportedLocales: L10nHelper.supportedLocales,
/// );
/// ```
library;

export "l10n/l10n_helper.dart" show L10nHelper;
export "src/material_localizations.dart";
