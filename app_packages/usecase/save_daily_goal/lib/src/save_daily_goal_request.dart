import 'package:domain_daily_goal/domain_daily_goal.dart';

/// 保存する一日あたり目標。
///
/// Example:
/// ```dart
/// const SaveDailyGoalRequest(goal: DailyGoal.unset);
/// ```
final class SaveDailyGoalRequest {
  /// [goal] を保存する依頼を作る。
  ///
  /// Example:
  /// ```dart
  /// const SaveDailyGoalRequest(goal: DailyGoal.unset);
  /// ```
  const SaveDailyGoalRequest({required this.goal});

  /// 保存する目標。
  final DailyGoal goal;
}
