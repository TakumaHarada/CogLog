import 'package:app/src/example.dart';
import 'package:app_runner/app_runner.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

import 'theme/theme.dart';

/// CogLog を起動する。
///
/// Forui の [Application] をルートにする。
///
/// Example:
/// ```dart
/// void main() {
///   runApp(const Application());
/// }
/// ```
void main() {
  runApp(const Application());
}

/// Forui テーマとローカライゼーションを束ねたアプリケーション。
///
/// 明暗はプラットフォームの明るさに追従する。文言は [L10nHelper] の ja / en。
class Application extends StatelessWidget {
  /// Forui のテーマとローカライゼーションを持つルートを作る。
  const Application({super.key});

  /// [FTheme] と [L10nHelper] を [MaterialApp] に載せる。
  ///
  /// Example:
  /// ```dart
  /// const Application();
  /// ```
  @override
  Widget build(BuildContext context) => MaterialApp(
    supportedLocales: L10nHelper.supportedLocales,
    // material_ui の MaterialApp は英語だけの Default*Localizations を足す。
    // ja を含む delegate を先に渡す。
    localizationsDelegates: const [
      ...appLocalizationsDelegates,
      FLocalizations.delegate,
    ],
    theme: lightTheme.toApproximateMaterialTheme(),
    darkTheme: darkTheme.toApproximateMaterialTheme(),
    builder: (context, child) => FTheme(
      data: Theme.brightnessOf(context) == .light ? lightTheme : darkTheme,
      child: FToaster(child: FTooltipGroup(child: child!)),
    ),
    home: const Example(),
  );
}
