import 'dart:math' as math;

import 'goal_metric_status.dart';

/// 1 指標の達成率と、円グラフ二周分の描画割合。
///
/// [ratio] は実績 / 目標の実値。リング用の [lap1] / [lap2] はそれぞれ 0〜1 に
/// クリップし、視覚は最大二周（200% 相当）まで。
///
/// Example:
/// ```dart
/// GoalMetricAchievement.fromRatio(1.5);
/// ```
final class GoalMetricAchievement {
  /// 未設定の達成。
  ///
  /// Example:
  /// ```dart
  /// const GoalMetricAchievement.unset();
  /// ```
  const GoalMetricAchievement.unset()
    : status = GoalMetricStatus.unset,
      ratio = null,
      lap1 = 0,
      lap2 = 0;

  /// 目標 0 の達成（進捗ゼロ）。
  ///
  /// Example:
  /// ```dart
  /// const GoalMetricAchievement.zeroGoal();
  /// ```
  const GoalMetricAchievement.zeroGoal()
    : status = GoalMetricStatus.zeroGoal,
      ratio = null,
      lap1 = 0,
      lap2 = 0;

  /// 正の目標に対する割合 [p] から達成を作る。
  ///
  /// Example:
  /// ```dart
  /// GoalMetricAchievement.fromRatio(0.5);
  /// ```
  factory GoalMetricAchievement.fromRatio(double p) {
    return GoalMetricAchievement._(
      status: GoalMetricStatus.ratio,
      ratio: p,
      lap1: math.min(p, 1),
      lap2: math.min(math.max(p - 1, 0), 1),
    );
  }

  const GoalMetricAchievement._({
    required this.status,
    required this.ratio,
    required this.lap1,
    required this.lap2,
  });

  /// 達成の区分。
  final GoalMetricStatus status;

  /// 実績 / 目標。未設定と目標 0 のときは null。
  final double? ratio;

  /// 第 1 周の塗り割合（0〜1）。
  final double lap1;

  /// 第 2 周の塗り割合（0〜1）。p>2 でも 1。
  final double lap2;

  /// null の目標は未設定、0 は進捗ゼロ、正なら [actual] / 目標。
  ///
  /// Example:
  /// ```dart
  /// GoalMetricAchievement.ofNullable(
  ///   goal: 100,
  ///   actual: 50,
  /// );
  /// ```
  static GoalMetricAchievement ofNullable({
    required double? goal,
    required double actual,
  }) {
    if (goal == null) {
      return const GoalMetricAchievement.unset();
    }
    if (goal == 0) {
      return const GoalMetricAchievement.zeroGoal();
    }
    return GoalMetricAchievement.fromRatio(actual / goal);
  }

  /// null の運動時間目標は未設定、ゼロは進捗ゼロ、正なら実績 / 目標。
  ///
  /// Example:
  /// ```dart
  /// GoalMetricAchievement.ofDuration(
  ///   goal: const Duration(minutes: 30),
  ///   actual: const Duration(minutes: 15),
  /// );
  /// ```
  static GoalMetricAchievement ofDuration({
    required Duration? goal,
    required Duration actual,
  }) {
    if (goal == null) {
      return const GoalMetricAchievement.unset();
    }
    if (goal == Duration.zero) {
      return const GoalMetricAchievement.zeroGoal();
    }
    return GoalMetricAchievement.fromRatio(
      actual.inMicroseconds / goal.inMicroseconds,
    );
  }
}
