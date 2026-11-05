import 'exercise_history.dart';
import 'period_window.dart';

/// 1 つの期間に入る運動履歴の合計。
///
/// 丸めはしない。画面表記は [PeriodAggregate] を受け取った側が行う。
///
/// Example:
/// ```dart
/// PeriodAggregate.of(const [], PeriodWindow.today(DateTime(2026, 11, 5)));
/// ```
final class PeriodAggregate {
  /// 件数と合計を持つ。
  ///
  /// Example:
  /// ```dart
  /// const PeriodAggregate(
  ///   count: 0,
  ///   distanceKm: 0,
  ///   caloriesKcal: 0,
  ///   duration: Duration.zero,
  /// );
  /// ```
  const PeriodAggregate({
    required this.count,
    required this.distanceKm,
    required this.caloriesKcal,
    required this.duration,
  });

  /// 運動履歴が無い期間。
  static const empty = PeriodAggregate(
    count: 0,
    distanceKm: 0,
    caloriesKcal: 0,
    duration: Duration.zero,
  );

  /// 入った件数。
  final int count;

  /// 走行距離の合計。単位は km。
  final double distanceKm;

  /// 消費カロリーの合計。単位は kcal。
  final double caloriesKcal;

  /// 運動時間の合計。
  final Duration duration;

  /// 1 件も入っていない。
  bool get hasHistory => count > 0;

  /// [window] に入る履歴だけを 1 回ずつ足す。
  ///
  /// Example:
  /// ```dart
  /// PeriodAggregate.of(const [], PeriodWindow.today(DateTime(2026, 11, 5)));
  /// ```
  factory PeriodAggregate.of(
    Iterable<ExerciseHistory> histories,
    PeriodWindow window,
  ) {
    var count = 0;
    var distanceKm = 0.0;
    var caloriesKcal = 0.0;
    var duration = Duration.zero;
    for (final history in histories) {
      if (!window.contains(history.recordedAt)) {
        continue;
      }
      count += 1;
      distanceKm += history.distanceKm;
      caloriesKcal += history.caloriesKcal;
      duration += history.duration;
    }
    return PeriodAggregate(
      count: count,
      distanceKm: distanceKm,
      caloriesKcal: caloriesKcal,
      duration: duration,
    );
  }
}
