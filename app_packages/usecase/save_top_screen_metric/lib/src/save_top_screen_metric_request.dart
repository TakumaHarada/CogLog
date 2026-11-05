import 'package:domain_exercise_history/domain_exercise_history.dart';

/// 保存する指標。
///
/// Example:
/// ```dart
/// SaveTopScreenMetricRequest(metric: PeriodTotalMetric.distance);
/// ```
final class SaveTopScreenMetricRequest {
  /// [metric] を保存する依頼を作る。
  ///
  /// Example:
  /// ```dart
  /// SaveTopScreenMetricRequest(metric: PeriodTotalMetric.distance);
  /// ```
  const SaveTopScreenMetricRequest({required this.metric});

  /// 保存する指標。
  final PeriodTotalMetric metric;
}
