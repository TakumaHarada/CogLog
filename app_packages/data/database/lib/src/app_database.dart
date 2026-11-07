import 'package:drift/drift.dart';

import 'tables/exercise_histories.dart';

part 'app_database.g.dart';

/// CogLog のローカルデータベース。
///
/// Example:
/// ```dart
/// AppDatabase(NativeDatabase.memory());
/// ```
@DriftDatabase(tables: [ExerciseHistories])
class AppDatabase extends _$AppDatabase {
  /// [executor] で開く（ファイルまたはメモリ）。
  ///
  /// Example:
  /// ```dart
  /// AppDatabase(NativeDatabase.memory());
  /// ```
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
