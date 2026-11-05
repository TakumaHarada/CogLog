import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:data_repository_top_screen_metric/data_repository_top_screen_metric.dart';
import 'package:riverpod/misc.dart';
import 'package:usecase_load_top_screen/usecase_load_top_screen.dart';
import 'package:usecase_load_top_screen_impl/usecase_load_top_screen_impl.dart';
import 'package:usecase_save_top_screen_metric/usecase_save_top_screen_metric.dart';
import 'package:usecase_save_top_screen_metric_impl/usecase_save_top_screen_metric_impl.dart';

/// トップ画面の読み込みと指標保存を上書きする。
///
/// Example:
/// ```dart
/// usecaseOverrides();
/// ```
List<Override> usecaseOverrides() => [
  LoadTopScreenUsecase.provider.overrideWith(
    (ref) => LoadTopScreenUsecaseImpl(
      histories: ref.watch(exerciseHistoryRepositoryProvider),
      metrics: ref.watch(topScreenMetricRepositoryProvider),
    ),
  ),
  SaveTopScreenMetricUsecase.provider.overrideWith(
    (ref) => SaveTopScreenMetricUsecaseImpl(
      metrics: ref.watch(topScreenMetricRepositoryProvider),
    ),
  ),
];
