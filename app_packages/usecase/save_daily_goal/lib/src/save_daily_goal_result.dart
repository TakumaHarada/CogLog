import 'package:domain_daily_goal/domain_daily_goal.dart';

/// 保存できた一日あたり目標。
///
/// Example:
/// ```dart
/// const SaveDailyGoalResult(goal: DailyGoal.unset);
/// ```
final class SaveDailyGoalResult {
  /// 保存した [goal] を持つ。
  ///
  /// Example:
  /// ```dart
  /// const SaveDailyGoalResult(goal: DailyGoal.unset);
  /// ```
  const SaveDailyGoalResult({required this.goal});

  /// 保存した目標。
  final DailyGoal goal;
}
