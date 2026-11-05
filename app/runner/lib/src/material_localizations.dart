import 'package:material_ui/material_ui.dart';

import '../l10n/l10n_helper.dart';

/// `material_ui` の `MaterialApp` に渡すローカライゼーション delegate。
///
/// [L10nHelper.localizationsDelegates] は `flutter_localizations` の delegate である。
/// `material_ui` は別の Material / Cupertino delegate を使う。このリストは、日本語を含む
/// `material_ui` の delegate を先に置く。Forui の delegate はアプリ側で足す。
///
/// Example:
/// ```dart
/// MaterialApp(
///   localizationsDelegates: appLocalizationsDelegates,
///   supportedLocales: L10nHelper.supportedLocales,
/// );
/// ```
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates =
    <LocalizationsDelegate<dynamic>>[
      L10nHelper.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ];
