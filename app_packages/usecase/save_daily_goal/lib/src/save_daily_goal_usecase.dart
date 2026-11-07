import 'package:riverpod/riverpod.dart';

import 'save_daily_goal_request.dart';
import 'save_daily_goal_result.dart';

/// 一日あたりの運動目標を保存する。
///
/// Example:
/// ```dart
/// usecase.execute(const SaveDailyGoalRequest(goal: DailyGoal.unset));
/// ```
abstract interface class SaveDailyGoalUsecase {
  /// 未接続のときは失敗する注入点。
  static final provider = Provider<SaveDailyGoalUsecase>(
    (ref) => throw UnimplementedError('SaveDailyGoalUsecase.provider'),
  );

  /// [request] の目標を保存する。失敗したときは例外のまま。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(const SaveDailyGoalRequest(goal: DailyGoal.unset));
  /// ```
  Future<SaveDailyGoalResult> execute(SaveDailyGoalRequest request);
}
