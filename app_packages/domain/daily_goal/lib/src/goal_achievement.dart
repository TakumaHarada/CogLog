import 'package:domain_exercise_history/domain_exercise_history.dart';

import 'daily_goal.dart';
import 'goal_metric_achievement.dart';

/// 本日実績に対する一日あたり目標の達成率。
///
/// 指標は運動時間・消費カロリー・走行距離。組み立ては ViewModel 側で
/// [DailyGoal] と本日の [PeriodAggregate] から行う。
///
/// Example:
/// ```dart
/// GoalAchievement.of(
///   const DailyGoal(caloriesKcal: 200),
///   const PeriodAggregate(
///     count: 1,
///     distanceKm: 0,
///     caloriesKcal: 100,
///     duration: Duration.zero,
///   ),
/// );
/// ```
final class GoalAchievement {
  /// 3 指標の達成を持つ。
  ///
  /// Example:
  /// ```dart
  /// GoalAchievement(
  ///   duration: const GoalMetricAchievement.unset(),
  ///   calories: GoalMetricAchievement.fromRatio(0.5),
  ///   distance: const GoalMetricAchievement.zeroGoal(),
  /// );
  /// ```
  const GoalAchievement({
    required this.duration,
    required this.calories,
    required this.distance,
  });

  /// [goal] と本日の [today] から 3 指標の達成を求める。
  ///
  /// Example:
  /// ```dart
  /// GoalAchievement.of(DailyGoal.unset, PeriodAggregate.empty);
  /// ```
  factory GoalAchievement.of(DailyGoal goal, PeriodAggregate today) {
    return GoalAchievement(
      duration: GoalMetricAchievement.ofDuration(
        goal: goal.duration,
        actual: today.duration,
      ),
      calories: GoalMetricAchievement.ofNullable(
        goal: goal.caloriesKcal,
        actual: today.caloriesKcal,
      ),
      distance: GoalMetricAchievement.ofNullable(
        goal: goal.distanceKm,
        actual: today.distanceKm,
      ),
    );
  }

  /// 運動時間の達成。
  final GoalMetricAchievement duration;

  /// 消費カロリーの達成。
  final GoalMetricAchievement calories;

  /// 走行距離の達成。
  final GoalMetricAchievement distance;
}
