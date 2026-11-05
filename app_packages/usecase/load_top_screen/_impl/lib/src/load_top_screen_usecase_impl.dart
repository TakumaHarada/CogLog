import 'package:data_repository_exercise_history/data_repository_exercise_history.dart';
import 'package:data_repository_top_screen_metric/data_repository_top_screen_metric.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:usecase_load_top_screen/usecase_load_top_screen.dart';

/// Repository からトップ画面の合計を読む。
///
/// Example:
/// ```dart
/// LoadTopScreenUsecaseImpl(histories: histories, metrics: metrics).execute(
///   LoadTopScreenRequest(now: DateTime(2026, 11, 5, 15)),
/// );
/// ```
final class LoadTopScreenUsecaseImpl implements LoadTopScreenUsecase {
  /// [histories] と [metrics] を読む実装を作る。
  ///
  /// Example:
  /// ```dart
  /// LoadTopScreenUsecaseImpl(histories: histories, metrics: metrics);
  /// ```
  const LoadTopScreenUsecaseImpl({
    required this.histories,
    required this.metrics,
  });

  /// 運動履歴の読み出し。
  final ExerciseHistoryRepository histories;

  /// 指標選択の読み出し。
  final TopScreenMetricRepository metrics;

  /// 保存済み指標が無ければ消費カロリーにする。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(LoadTopScreenRequest(now: DateTime(2026, 11, 5, 15)));
  /// ```
  @override
  Future<LoadTopScreenResult> execute(LoadTopScreenRequest request) async {
    final all = await histories.list();
    final metric = await metrics.read() ?? PeriodTotalMetric.calories;
    final now = request.now;
    return LoadTopScreenResult(
      metric: metric,
      today: PeriodAggregate.of(all, PeriodWindow.today(now)),
      week: PeriodAggregate.of(all, PeriodWindow.week(now)),
      month: PeriodAggregate.of(all, PeriodWindow.month(now)),
    );
  }
}
