import 'package:data_repository_top_screen_metric_testing/data_repository_top_screen_metric_testing.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:test/test.dart';
import 'package:usecase_save_top_screen_metric/usecase_save_top_screen_metric.dart';
import 'package:usecase_save_top_screen_metric_impl/usecase_save_top_screen_metric_impl.dart';

void main() {
  test('書いた指標を再び読める', () async {
    final metrics = MemoryTopScreenMetricRepository();
    final result = await SaveTopScreenMetricUsecaseImpl(metrics: metrics)
        .execute(
          const SaveTopScreenMetricRequest(metric: PeriodTotalMetric.distance),
        );

    expect(result.metric, PeriodTotalMetric.distance);
    expect(await metrics.read(), PeriodTotalMetric.distance);
  });
}
