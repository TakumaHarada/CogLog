import 'package:go_router/go_router.dart';
import 'package:screen_navigation_go_router/screen_navigation_go_router.dart';

/// ルーターと遷移実装を一組で持つ。
///
/// Example:
/// ```dart
/// final graph = ScreenGraph();
/// graph.router;
/// ```
final class ScreenGraph {
  /// 遷移実装と、そのルーターを作る。
  ///
  /// Example:
  /// ```dart
  /// ScreenGraph();
  /// ```
  ScreenGraph() : navigation = GoRouterScreenNavigation();

  /// go_router の実装。
  final GoRouterScreenNavigation navigation;

  /// アプリのルーターに渡す。
  GoRouter get router => navigation.router;
}
