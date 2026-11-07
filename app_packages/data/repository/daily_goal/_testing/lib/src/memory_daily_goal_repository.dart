import 'package:data_repository_daily_goal/data_repository_daily_goal.dart';
import 'package:domain_daily_goal/domain_daily_goal.dart';

/// メモリ上の 1 つの一日あたり目標。初期値は未設定。
///
/// Example:
/// ```dart
/// final repository = MemoryDailyGoalRepository();
/// repository.write(const DailyGoal(caloriesKcal: 0));
/// ```
final class MemoryDailyGoalRepository implements DailyGoalRepository {
  /// 未設定の状態で作る。
  ///
  /// Example:
  /// ```dart
  /// MemoryDailyGoalRepository();
  /// ```
  MemoryDailyGoalRepository();

  DailyGoal _goal = DailyGoal.unset;

  /// まだ書いていなければ [DailyGoal.unset]。
  ///
  /// Example:
  /// ```dart
  /// repository.read();
  /// ```
  @override
  Future<DailyGoal> read() async => _goal;

  /// [goal] を次の [read] で返す。
  ///
  /// Example:
  /// ```dart
  /// repository.write(const DailyGoal(distanceKm: 0));
  /// ```
  @override
  Future<void> write(DailyGoal goal) async {
    _goal = goal;
  }
}
