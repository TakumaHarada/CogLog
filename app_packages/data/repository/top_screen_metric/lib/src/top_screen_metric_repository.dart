import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:riverpod/riverpod.dart';

/// トップ画面の指標選択をプロセス終了後も残す。
///
/// Example:
/// ```dart
/// repository.read();
/// ```
abstract interface class TopScreenMetricRepository {
  /// 保存が無いか解釈できないときは null。
  ///
  /// Example:
  /// ```dart
  /// repository.read();
  /// ```
  Future<PeriodTotalMetric?> read();

  /// [metric] を保存する。
  ///
  /// Example:
  /// ```dart
  /// repository.write(PeriodTotalMetric.distance);
  /// ```
  Future<void> write(PeriodTotalMetric metric);
}

/// 指標 Repository の注入点。未接続のときは失敗する。
///
/// Example:
/// ```dart
/// topScreenMetricRepositoryProvider;
/// ```
final topScreenMetricRepositoryProvider = Provider<TopScreenMetricRepository>(
  (ref) => throw UnimplementedError('topScreenMetricRepositoryProvider'),
);
