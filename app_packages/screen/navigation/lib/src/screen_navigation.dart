import 'package:riverpod/riverpod.dart';

/// 画面遷移の窓口。
///
/// タブ切替は go_router の StatefulShellRoute が担う。
/// スタック型の子画面遷移が必要になったときにメソッドを足す。
///
/// Example:
/// ```dart
/// screenNavigationProvider;
/// ```
abstract interface class ScreenNavigation {}

/// 画面遷移の注入点。未接続のときは失敗する。
///
/// Example:
/// ```dart
/// screenNavigationProvider;
/// ```
final screenNavigationProvider = Provider<ScreenNavigation>(
  (ref) => throw UnimplementedError('screenNavigationProvider'),
);
