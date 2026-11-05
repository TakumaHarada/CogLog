import 'package:domain_exercise_history/domain_exercise_history.dart';

/// 保存できた指標。
///
/// Example:
/// ```dart
/// SaveTopScreenMetricResult(metric: PeriodTotalMetric.distance);
/// ```
final class SaveTopScreenMetricResult {
  /// 保存した [metric] を持つ。
  ///
  /// Example:
  /// ```dart
  /// SaveTopScreenMetricResult(metric: PeriodTotalMetric.distance);
  /// ```
  const SaveTopScreenMetricResult({required this.metric});

  /// 保存した指標。
  final PeriodTotalMetric metric;
}
