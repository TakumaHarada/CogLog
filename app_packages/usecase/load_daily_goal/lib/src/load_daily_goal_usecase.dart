import 'package:riverpod/riverpod.dart';

import 'load_daily_goal_request.dart';
import 'load_daily_goal_result.dart';

/// 一日あたりの運動目標を読み込む。
///
/// Example:
/// ```dart
/// usecase.execute(const LoadDailyGoalRequest());
/// ```
abstract interface class LoadDailyGoalUsecase {
  /// 未接続のときは失敗する注入点。
  static final provider = Provider<LoadDailyGoalUsecase>(
    (ref) => throw UnimplementedError('LoadDailyGoalUsecase.provider'),
  );

  /// 保存済みの目標を返す。未保存なら未設定。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(const LoadDailyGoalRequest());
  /// ```
  Future<LoadDailyGoalResult> execute(LoadDailyGoalRequest request);
}
