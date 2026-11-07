/// Drift による運動履歴の永続化。
///
/// Example:
/// ```dart
/// DriftExerciseHistoryRepository(
///   database: openMemoryDatabase(),
///   photos: ExerciseHistoryPhotoStore(Directory.systemTemp),
/// );
/// ```
library;

export 'src/drift_exercise_history_repository.dart';
export 'src/exercise_history_photo_store.dart';
