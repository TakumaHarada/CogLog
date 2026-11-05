import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';

/// コンストラクタで受け取った履歴を返す。
///
/// Example:
/// ```dart
/// FixedExerciseHistoryRepository(const []).list();
/// ```
final class FixedExerciseHistoryRepository
    implements ExerciseHistoryRepository {
  /// [histories] をそのまま返す読み出し口を作る。
  ///
  /// Example:
  /// ```dart
  /// FixedExerciseHistoryRepository(const []);
  /// ```
  const FixedExerciseHistoryRepository(this.histories);

  /// テストが用意した履歴。
  final List<ExerciseHistory> histories;

  /// [histories] を返す。
  ///
  /// Example:
  /// ```dart
  /// FixedExerciseHistoryRepository(const []).list();
  /// ```
  @override
  Future<List<ExerciseHistory>> list() async => histories;
}
