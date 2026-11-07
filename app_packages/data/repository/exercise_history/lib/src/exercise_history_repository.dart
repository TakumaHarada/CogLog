import 'dart:typed_data';

import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:riverpod/riverpod.dart';

/// 保存済みの運動履歴を読む・書く。
///
/// Example:
/// ```dart
/// Future<List<ExerciseHistory>> read(ExerciseHistoryRepository repository) {
///   return repository.list();
/// }
/// ```
abstract interface class ExerciseHistoryRepository {
  /// 記録日時の降順ですべて返す。
  ///
  /// Example:
  /// ```dart
  /// repository.list();
  /// ```
  Future<List<ExerciseHistory>> list();

  /// 新規作成する。運動時間 0 は [ArgumentError]。
  ///
  /// 写真を書いてから行を挿入する。INSERT 失敗時は写真を削除する。
  ///
  /// Example:
  /// ```dart
  /// repository.create(
  ///   creationStartedAt: DateTime.timestamp(),
  ///   capturedAt: DateTime.timestamp(),
  ///   recordedAt: DateTime.timestamp(),
  ///   recordedAtManuallySet: false,
  ///   distanceKm: 1,
  ///   duration: Duration(minutes: 1),
  ///   caloriesKcal: 1,
  ///   averageSpeedKmh: 1,
  ///   photoBytes: Uint8List.fromList([1]),
  /// );
  /// ```
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
  });

  /// 更新する。[ExerciseHistory.savedAt] は変えない。未知 ID は [StateError]。
  ///
  /// [photoBytes] が非 null のときだけ写真を置換する。
  ///
  /// Example:
  /// ```dart
  /// repository.update(
  ///   id: id,
  ///   creationStartedAt: DateTime.timestamp(),
  ///   capturedAt: DateTime.timestamp(),
  ///   recordedAt: DateTime.timestamp(),
  ///   recordedAtManuallySet: true,
  ///   distanceKm: 2,
  ///   duration: Duration(minutes: 2),
  ///   caloriesKcal: 2,
  ///   averageSpeedKmh: 2,
  /// );
  /// ```
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
  });

  /// 行と写真ディレクトリを削除する。未知 ID は [StateError]。
  ///
  /// Example:
  /// ```dart
  /// repository.delete(id);
  /// ```
  Future<void> delete(String id);
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
