import 'package:riverpod/riverpod.dart';

import 'save_top_screen_metric_request.dart';
import 'save_top_screen_metric_result.dart';

/// トップ画面の指標選択を保存する。
///
/// Example:
/// ```dart
/// usecase.execute(
///   const SaveTopScreenMetricRequest(metric: PeriodTotalMetric.distance),
/// );
/// ```
abstract interface class SaveTopScreenMetricUsecase {
  /// 未接続のときは失敗する注入点。
  static final provider = Provider<SaveTopScreenMetricUsecase>(
    (ref) => throw UnimplementedError('SaveTopScreenMetricUsecase.provider'),
  );

  /// [request] の指標を保存する。失敗したときは例外のまま。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(
  ///   const SaveTopScreenMetricRequest(metric: PeriodTotalMetric.calories),
  /// );
  /// ```
  Future<SaveTopScreenMetricResult> execute(SaveTopScreenMetricRequest request);
}
