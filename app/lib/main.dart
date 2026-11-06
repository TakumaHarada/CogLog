import 'package:data_injection/data_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screen_injection/screen_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usecase_injection/usecase_injection.dart';

import 'package:app_runner/app_runner.dart';

import 'theme/theme.dart';

/// CogLog を起動する。
///
/// 保存済みの指標を読み、ホームを最初に出す。
///
/// Example:
/// ```dart
/// Future<void> main() async {
///   await launchCogLog();
/// }
/// ```
Future<void> main() => launchCogLog();

/// 依存を組んで [Application] を起動する。
///
/// Example:
/// ```dart
/// await launchCogLog();
/// ```
Future<void> launchCogLog() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final screens = ScreenGraph();
  runApp(
    ProviderScope(
      overrides: [
        ...dataRepositoryOverrides(preferences: preferences),
        ...usecaseOverrides(),
        ...screenOverrides(screens),
      ],
      child: Application(router: screens.router),
    ),
  );
}

/// Forui テーマとローカライゼーションを束ねたアプリケーション。
///
/// 明暗はプラットフォームの明るさに追従する。文言は [L10nHelper] の ja / en。
///
/// Example:
/// ```dart
/// Application(router: router);
/// ```
class Application extends StatelessWidget {
  /// [router] をルートにする。
  ///
  /// Example:
  /// ```dart
  /// Application(router: router);
  /// ```
  const Application({required this.router, super.key});

  /// ホームから始まる遷移。
  final GoRouter router;

  /// [FTheme] と [L10nHelper] を [MaterialApp] に載せる。
  ///
  /// Example:
  /// ```dart
  /// Application(router: router);
  /// ```
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: router,
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
      data: Theme.brightnessOf(context) == Brightness.light
          ? lightTheme
          : darkTheme,
      child: FToaster(child: FTooltipGroup(child: child!)),
    ),
  );
}
