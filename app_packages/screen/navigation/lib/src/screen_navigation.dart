import 'package:riverpod/riverpod.dart';

/// トップ画面からメーターパネル撮影の遷移先を開く。
///
/// Example:
/// ```dart
/// navigation.openMeterPanelCamera();
/// ```
abstract interface class ScreenNavigation {
  /// `/camera` を開き、閉じられるまで待つ。
  ///
  /// Example:
  /// ```dart
  /// await navigation.openMeterPanelCamera();
  /// ```
  Future<void> openMeterPanelCamera();
}

/// 画面遷移の注入点。未接続のときは失敗する。
///
/// Example:
/// ```dart
/// screenNavigationProvider;
/// ```
final screenNavigationProvider = Provider<ScreenNavigation>(
  (ref) => throw UnimplementedError('screenNavigationProvider'),
);
