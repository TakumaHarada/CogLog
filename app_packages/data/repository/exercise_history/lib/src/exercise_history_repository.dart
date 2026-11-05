import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:riverpod/riverpod.dart';

/// 保存済みの運動履歴を読む。
///
/// Example:
/// ```dart
/// Future<List<ExerciseHistory>> read(ExerciseHistoryRepository repository) {
///   return repository.list();
/// }
/// ```
abstract interface class ExerciseHistoryRepository {
  /// 保存済みの運動履歴を返す。
  ///
  /// Example:
  /// ```dart
  /// repository.list();
  /// ```
  Future<List<ExerciseHistory>> list();
}

/// 運動履歴 Repository の注入点。未接続のときは失敗する。
///
/// Example:
/// ```dart
/// exerciseHistoryRepositoryProvider;
/// ```
final exerciseHistoryRepositoryProvider = Provider<ExerciseHistoryRepository>(
  (ref) => throw UnimplementedError('exerciseHistoryRepositoryProvider'),
);
