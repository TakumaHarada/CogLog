import 'dart:typed_data';

import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:uuid/uuid.dart';

/// メモリ上で CUD 契約を再現するテスト用 Repository。
///
/// Example:
/// ```dart
/// MemoryExerciseHistoryRepository().list();
/// ```
final class MemoryExerciseHistoryRepository
    implements ExerciseHistoryRepository {
  /// [uuid] を差し替えられる口を作る。
  ///
  /// Example:
  /// ```dart
  /// MemoryExerciseHistoryRepository();
  /// ```
  MemoryExerciseHistoryRepository({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  final List<ExerciseHistory> _items = [];
  final Map<String, Uint8List> _photos = {};

  /// 記録日時の降順で返す。
  @override
  Future<List<ExerciseHistory>> list() async {
    final copy = [..._items];
    copy.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return copy;
  }

  /// 新規作成する。運動時間 0 は [ArgumentError]。
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
  }) async {
    if (duration.inMilliseconds == 0) {
      throw ArgumentError.value(duration, 'duration', '0 では保存できない');
    }
    final id = _uuid.v4();
    final savedAt = DateTime.timestamp();
    final path = 'exercise_histories/$id/meter.jpg';
    _photos[id] = Uint8List.fromList(photoBytes);
    final item = ExerciseHistory(
      id: id,
      savedAt: savedAt,
      creationStartedAt: creationStartedAt.toUtc(),
      capturedAt: capturedAt.toUtc(),
      recordedAt: recordedAt.toUtc(),
      recordedAtManuallySet: recordedAtManuallySet,
      distanceKm: distanceKm,
      duration: duration,
      caloriesKcal: caloriesKcal,
      averageSpeedKmh: averageSpeedKmh,
      photoRelativePath: path,
    );
    _items.add(item);
    return item;
  }

  /// 更新する。未知 ID は [StateError]。
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
  }) async {
    if (duration.inMilliseconds == 0) {
      throw ArgumentError.value(duration, 'duration', '0 では保存できない');
    }
    final index = _items.indexWhere((e) => e.id == id);
    if (index < 0) {
      throw StateError('運動履歴が無い: $id');
    }
    final previous = _items[index];
    if (photoBytes != null) {
      _photos[id] = Uint8List.fromList(photoBytes);
    }
    final next = ExerciseHistory(
      id: id,
      savedAt: previous.savedAt,
      creationStartedAt: creationStartedAt.toUtc(),
      capturedAt: capturedAt.toUtc(),
      recordedAt: recordedAt.toUtc(),
      recordedAtManuallySet: recordedAtManuallySet,
      distanceKm: distanceKm,
      duration: duration,
      caloriesKcal: caloriesKcal,
      averageSpeedKmh: averageSpeedKmh,
      photoRelativePath: previous.photoRelativePath,
    );
    _items[index] = next;
    return next;
  }

  /// 削除する。未知 ID は [StateError]。
  @override
  Future<void> delete(String id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index < 0) {
      throw StateError('運動履歴が無い: $id');
    }
    _items.removeAt(index);
    _photos.remove(id);
  }
}
