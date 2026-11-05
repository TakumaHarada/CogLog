import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';

/// 常に空の運動履歴を返す。
///
/// 撮影からの保存は別の要件である。
///
/// Example:
/// ```dart
/// const EmptyExerciseHistoryRepository().list();
/// ```
final class EmptyExerciseHistoryRepository
    implements ExerciseHistoryRepository {
  /// 空の読み出し口を作る。
  ///
  /// Example:
  /// ```dart
  /// const EmptyExerciseHistoryRepository();
  /// ```
  const EmptyExerciseHistoryRepository();

  /// 保存済みの履歴はまだ無いので、空リストを返す。
  ///
  /// Example:
  /// ```dart
  /// const EmptyExerciseHistoryRepository().list();
  /// ```
  @override
  Future<List<ExerciseHistory>> list() async => const [];
}
