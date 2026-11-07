import 'package:data_repository_daily_goal/data_repository_daily_goal.dart';
import 'package:usecase_save_daily_goal/usecase_save_daily_goal.dart';

/// 一日あたり目標の保存を Repository に渡す。
///
/// Example:
/// ```dart
/// SaveDailyGoalUsecaseImpl(goals: goals).execute(
///   const SaveDailyGoalRequest(goal: DailyGoal.unset),
/// );
/// ```
final class SaveDailyGoalUsecaseImpl implements SaveDailyGoalUsecase {
  /// [goals] へ書く実装を作る。
  ///
  /// Example:
  /// ```dart
  /// SaveDailyGoalUsecaseImpl(goals: goals);
  /// ```
  const SaveDailyGoalUsecaseImpl({required this.goals});

  /// 一日あたり目標の保存先。
  final DailyGoalRepository goals;

  /// [request] の目標を書き、同じ目標を返す。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(const SaveDailyGoalRequest(goal: DailyGoal.unset));
  /// ```
  @override
  Future<SaveDailyGoalResult> execute(SaveDailyGoalRequest request) async {
    await goals.write(request.goal);
    return SaveDailyGoalResult(goal: request.goal);
  }
}
