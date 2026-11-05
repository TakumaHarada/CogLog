import 'package:data_repository_top_screen_metric_impl/data_repository_top_screen_metric_impl.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('未保存は null で、書いた指標を再び読める', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = SharedPreferencesTopScreenMetricRepository(preferences);

    expect(await repository.read(), isNull);
    await repository.write(PeriodTotalMetric.distance);
    expect(await repository.read(), PeriodTotalMetric.distance);
  });

  test('不明な文字列は null', () async {
    SharedPreferences.setMockInitialValues({'top_screen_metric': 'unknown'});
    final preferences = await SharedPreferences.getInstance();
    final repository = SharedPreferencesTopScreenMetricRepository(preferences);

    expect(await repository.read(), isNull);
  });
}
