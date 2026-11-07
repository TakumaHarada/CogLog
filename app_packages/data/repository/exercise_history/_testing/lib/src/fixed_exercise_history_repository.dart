import 'dart:typed_data';

import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';

/// コンストラクタで受け取った履歴を返す読み取り専用の口。
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

  /// 読み取り専用のため常に失敗する。
  ///
  /// Example:
  /// ```dart
  /// FixedExerciseHistoryRepository(const []).create(
  ///   creationStartedAt: DateTime.timestamp(),
  ///   capturedAt: DateTime.timestamp(),
  ///   recordedAt: DateTime.timestamp(),
  ///   recordedAtManuallySet: false,
  ///   distanceKm: 1,
  ///   duration: Duration(minutes: 1),
  ///   caloriesKcal: 1,
  ///   averageSpeedKmh: 1,
  ///   photoBytes: Uint8List(0),
  /// );
  /// ```
  @override
  Future<ExerciseHistory> create({
    required DateTime creationStartedAt,
    required DateTime capturedAt,
    required DateTime recordedAt,
    required bool recordedAtManuallySet,
    required double distanceKm,
    required Duration duration,
    required double caloriesKcal,
    required double averageSpeedKmh,
    required Uint8List photoBytes,
  }) async => throw UnsupportedError('FixedExerciseHistoryRepository は読み取り専用');

  /// 読み取り専用のため常に失敗する。
  @override
  Future<ExerciseHistory> update({
    required String id,
    required DateTime creationStartedAt,
    required DateTime capturedAt,
    required DateTime recordedAt,
    required bool recordedAtManuallySet,
    required double distanceKm,
    required Duration duration,
    required double caloriesKcal,
    required double averageSpeedKmh,
    Uint8List? photoBytes,
  }) async => throw UnsupportedError('FixedExerciseHistoryRepository は読み取り専用');

  /// 読み取り専用のため常に失敗する。
  @override
  Future<void> delete(String id) async =>
      throw UnsupportedError('FixedExerciseHistoryRepository は読み取り専用');
}
