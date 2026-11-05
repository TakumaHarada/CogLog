/// トップ画面を読み込むときの現地時刻。
///
/// Example:
/// ```dart
/// LoadTopScreenRequest(now: DateTime(2026, 11, 5, 15));
/// ```
final class LoadTopScreenRequest {
  /// [now] の現地時刻で期間を切る。
  ///
  /// Example:
  /// ```dart
  /// LoadTopScreenRequest(now: DateTime(2026, 11, 5, 15));
  /// ```
  const LoadTopScreenRequest({required this.now});

  /// 期間の境界に使う時刻。
  final DateTime now;
}
