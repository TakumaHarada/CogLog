/// 一日あたりの運動目標。
///
/// 各指標は null のとき未設定、非 null のとき設定済み（0 を含む）。
///
/// Example:
/// ```dart
/// const DailyGoal(
///   duration: Duration(minutes: 30),
///   caloriesKcal: 200,
///   distanceKm: 5,
/// );
/// ```
final class DailyGoal {
  /// 各指標を持つ一日あたり目標を作る。
  ///
  /// Example:
  /// ```dart
  /// const DailyGoal(
  ///   duration: Duration.zero,
  ///   caloriesKcal: 0,
  ///   distanceKm: 0,
  /// );
  /// ```
  const DailyGoal({this.duration, this.caloriesKcal, this.distanceKm});

  /// 全指標が未設定の目標。
  static const unset = DailyGoal();

  /// 一日あたりの運動時間。null は未設定。
  final Duration? duration;

  /// 一日あたりの消費カロリー。単位は kcal。null は未設定。
  final double? caloriesKcal;

  /// 一日あたりの走行距離。単位は km。null は未設定。
  final double? distanceKm;

  /// 運動時間が設定済みか。
  ///
  /// Example:
  /// ```dart
  /// const DailyGoal(duration: Duration.zero).hasDuration;
  /// ```
  bool get hasDuration => duration != null;

  /// 消費カロリーが設定済みか。
  ///
  /// Example:
  /// ```dart
  /// const DailyGoal(caloriesKcal: 0).hasCalories;
  /// ```
  bool get hasCalories => caloriesKcal != null;

  /// 走行距離が設定済みか。
  ///
  /// Example:
  /// ```dart
  /// const DailyGoal(distanceKm: 0).hasDistance;
  /// ```
  bool get hasDistance => distanceKm != null;
}
