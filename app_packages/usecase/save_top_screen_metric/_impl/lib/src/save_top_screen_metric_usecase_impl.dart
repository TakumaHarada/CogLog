import 'package:data_repository_top_screen_metric/data_repository_top_screen_metric.dart';
import 'package:usecase_save_top_screen_metric/usecase_save_top_screen_metric.dart';

/// 指標の保存を Repository に渡す。
///
/// Example:
/// ```dart
/// SaveTopScreenMetricUsecaseImpl(metrics: metrics).execute(
///   const SaveTopScreenMetricRequest(metric: PeriodTotalMetric.distance),
/// );
/// ```
final class SaveTopScreenMetricUsecaseImpl
    implements SaveTopScreenMetricUsecase {
  /// [metrics] へ書く実装を作る。
  ///
  /// Example:
  /// ```dart
  /// SaveTopScreenMetricUsecaseImpl(metrics: metrics);
  /// ```
  const SaveTopScreenMetricUsecaseImpl({required this.metrics});

  /// 指標の保存先。
  final TopScreenMetricRepository metrics;

  /// [request] の指標を書き、同じ指標を返す。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(
  ///   const SaveTopScreenMetricRequest(metric: PeriodTotalMetric.duration),
  /// );
  /// ```
  @override
  Future<SaveTopScreenMetricResult> execute(
    SaveTopScreenMetricRequest request,
  ) async {
    await metrics.write(request.metric);
    return SaveTopScreenMetricResult(metric: request.metric);
  }
}
