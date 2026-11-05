/// 現地時刻の半開区間。
///
/// [start] は含み、[end] は含まない。週の開始は月曜であり、ロケールの週開始は見ない。
///
/// Example:
/// ```dart
/// final today = PeriodWindow.today(DateTime(2026, 11, 5, 15));
/// ```
final class PeriodWindow {
  /// 両端を持つ区間を作る。
  ///
  /// Example:
  /// ```dart
  /// PeriodWindow(
  ///   start: DateTime(2026, 11, 5),
  ///   end: DateTime(2026, 11, 6),
  /// );
  /// ```
  const PeriodWindow({required this.start, required this.end});

  /// 含む端。
  final DateTime start;

  /// 含まない端。
  final DateTime end;

  /// [now] の現地日付の 0:00 から翌日 0:00 の直前まで。
  ///
  /// Example:
  /// ```dart
  /// PeriodWindow.today(DateTime(2026, 11, 5, 15));
  /// ```
  factory PeriodWindow.today(DateTime now) {
    final local = now.toLocal();
    final start = DateTime(local.year, local.month, local.day);
    return PeriodWindow(
      start: start,
      end: DateTime(local.year, local.month, local.day + 1),
    );
  }

  /// [now] が属する月曜 0:00 から次の月曜 0:00 の直前まで。
  ///
  /// Example:
  /// ```dart
  /// PeriodWindow.week(DateTime(2026, 11, 5, 15));
  /// ```
  factory PeriodWindow.week(DateTime now) {
    final local = now.toLocal();
    final today = DateTime(local.year, local.month, local.day);
    final start = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );
    return PeriodWindow(start: start, end: start.add(const Duration(days: 7)));
  }

  /// [now] の現地暦の月の 1 日 0:00 から翌月 1 日 0:00 の直前まで。
  ///
  /// Example:
  /// ```dart
  /// PeriodWindow.month(DateTime(2026, 11, 5, 15));
  /// ```
  factory PeriodWindow.month(DateTime now) {
    final local = now.toLocal();
    return PeriodWindow(
      start: DateTime(local.year, local.month),
      end: DateTime(local.year, local.month + 1),
    );
  }

  /// [recordedAt] を現地時刻へ直して、この区間に入るか。
  ///
  /// Example:
  /// ```dart
  /// PeriodWindow.today(DateTime(2026, 11, 5)).contains(DateTime(2026, 11, 5));
  /// ```
  bool contains(DateTime recordedAt) {
    final local = recordedAt.toLocal();
    return !local.isBefore(start) && local.isBefore(end);
  }
}
