/// 保存済みの 1 回の乗車。
///
/// 期間集計が足すのは走行距離、消費カロリー、運動時間である。
/// 平均速度は保持するが、合計には入れない。
///
/// Example:
/// ```dart
/// ExerciseHistory(
///   recordedAt: DateTime(2026, 11, 5, 12),
///   distanceKm: 1.25,
///   duration: Duration(minutes: 30),
///   caloriesKcal: 1.25,
///   averageSpeedKmh: 2.5,
/// );
/// ```
final class ExerciseHistory {
  /// 記録日時と 4 つの計測値を持つ乗車を作る。
  ///
  /// Example:
  /// ```dart
  /// ExerciseHistory(
  ///   recordedAt: DateTime(2026, 11, 5),
  ///   distanceKm: 1,
  ///   duration: Duration(minutes: 1),
  ///   caloriesKcal: 1,
  ///   averageSpeedKmh: 1,
  /// );
  /// ```
  const ExerciseHistory({
    required this.recordedAt,
    required this.distanceKm,
    required this.duration,
    required this.caloriesKcal,
    required this.averageSpeedKmh,
  });

  /// 期間へ振り分ける日時。
  final DateTime recordedAt;

  /// 走行距離。単位は km。
  final double distanceKm;

  /// 運動時間。
  final Duration duration;

  /// 消費カロリー。単位は kcal。
  final double caloriesKcal;

  /// 平均速度。単位は km/h。期間の合計には使わない。
  final double averageSpeedKmh;
}
