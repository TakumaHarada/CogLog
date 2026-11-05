import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:data_repository_exercise_history_impl/data_repository_exercise_history_impl.dart';
import 'package:data_repository_top_screen_metric/data_repository_top_screen_metric.dart';
import 'package:data_repository_top_screen_metric_impl/data_repository_top_screen_metric_impl.dart';
import 'package:riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 運動履歴と指標選択の本番実装を上書きする。
///
/// Example:
/// ```dart
/// dataRepositoryOverrides(preferences: preferences);
/// ```
List<Override> dataRepositoryOverrides({
  required SharedPreferences preferences,
}) => [
  exerciseHistoryRepositoryProvider.overrideWith(
    (ref) => const EmptyExerciseHistoryRepository(),
  ),
  topScreenMetricRepositoryProvider.overrideWith(
    (ref) => SharedPreferencesTopScreenMetricRepository(preferences),
  ),
];
