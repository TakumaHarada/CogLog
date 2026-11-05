import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screen_feature_top/screen_feature_top.dart';
import 'package:screen_navigation/screen_navigation.dart';

/// `/` をトップ画面、`/camera` を空の遷移先にする。
///
/// カメラ画面の中身は別の要件である。
///
/// Example:
/// ```dart
/// final navigation = GoRouterScreenNavigation();
/// navigation.openMeterPanelCamera();
/// ```
final class GoRouterScreenNavigation implements ScreenNavigation {
  /// ルートを組む。
  ///
  /// Example:
  /// ```dart
  /// GoRouterScreenNavigation();
  /// ```
  GoRouterScreenNavigation()
    : router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const TopScreen(),
            routes: [
              GoRoute(
                path: 'camera',
                builder: (context, state) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      );

  /// アプリが使うルーター。
  final GoRouter router;

  /// `/camera` を積む。閉じられるまで待つ。
  ///
  /// Example:
  /// ```dart
  /// navigation.openMeterPanelCamera();
  /// ```
  @override
  Future<void> openMeterPanelCamera() {
    return router.push('/camera');
  }
}
