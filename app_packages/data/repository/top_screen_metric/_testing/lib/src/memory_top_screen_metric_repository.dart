import 'package:data_repository_top_screen_metric/data_repository_top_screen_metric.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';

/// メモリ上の 1 つの指標。初期値は未保存。
///
/// Example:
/// ```dart
/// final repository = MemoryTopScreenMetricRepository();
/// repository.write(PeriodTotalMetric.distance);
/// ```
final class MemoryTopScreenMetricRepository
    implements TopScreenMetricRepository {
  /// 未保存の状態で作る。
  ///
  /// Example:
  /// ```dart
  /// MemoryTopScreenMetricRepository();
  /// ```
  MemoryTopScreenMetricRepository();

  PeriodTotalMetric? _value;

  /// まだ書いていなければ null。
  ///
  /// Example:
  /// ```dart
  /// repository.read();
  /// ```
  @override
  Future<PeriodTotalMetric?> read() async => _value;

  /// [metric] を次の [read] で返す。
  ///
  /// Example:
  /// ```dart
  /// repository.write(PeriodTotalMetric.calories);
  /// ```
  @override
  Future<void> write(PeriodTotalMetric metric) async {
    _value = metric;
  }
}
