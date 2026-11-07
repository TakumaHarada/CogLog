import 'package:domain_daily_goal/domain_daily_goal.dart';

/// 読み込んだ一日あたり目標。
///
/// Example:
/// ```dart
/// const LoadDailyGoalResult(goal: DailyGoal.unset);
/// ```
final class LoadDailyGoalResult {
  /// [goal] を持つ。
  ///
  /// Example:
  /// ```dart
  /// const LoadDailyGoalResult(goal: DailyGoal.unset);
  /// ```
  const LoadDailyGoalResult({required this.goal});

  /// 保存済み、または未設定の目標。
  final DailyGoal goal;
}
