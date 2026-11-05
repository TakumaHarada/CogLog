import 'package:data_repository_exercise_history_testing/data_repository_exercise_history_testing.dart';
import 'package:data_repository_top_screen_metric_testing/data_repository_top_screen_metric_testing.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:test/test.dart';
import 'package:usecase_load_top_screen/usecase_load_top_screen.dart';
import 'package:usecase_load_top_screen_impl/usecase_load_top_screen_impl.dart';

ExerciseHistory ride({required DateTime recordedAt, double distanceKm = 1}) {
  return ExerciseHistory(
    recordedAt: recordedAt,
    distanceKm: distanceKm,
    duration: const Duration(minutes: 1),
    caloriesKcal: 1,
    averageSpeedKmh: 1,
  );
}

void main() {
  final now = DateTime(2026, 11, 5, 15);

  test('履歴が無いときは消費カロリーで、3期間とも履歴が無い', () async {
    final result = await LoadTopScreenUsecaseImpl(
      histories: const FixedExerciseHistoryRepository([]),
      metrics: MemoryTopScreenMetricRepository(),
    ).execute(LoadTopScreenRequest(now: now));

    expect(result.metric, PeriodTotalMetric.calories);
    expect(result.today.hasHistory, isFalse);
    expect(result.week.hasHistory, isFalse);
    expect(result.month.hasHistory, isFalse);
  });

  test('11月5日、11月1日、10月31日をそれぞれの期間へ入れる', () async {
    final result = await LoadTopScreenUsecaseImpl(
      histories: FixedExerciseHistoryRepository([
        ride(recordedAt: DateTime(2026, 11, 5, 12)),
        ride(recordedAt: DateTime(2026, 11, 1, 12)),
        ride(recordedAt: DateTime(2026, 10, 31, 12)),
      ]),
      metrics: MemoryTopScreenMetricRepository(),
    ).execute(LoadTopScreenRequest(now: now));

    expect(result.today.count, 1);
    expect(result.week.count, 1);
    expect(result.month.count, 2);
  });

  test('1.14 km が 2 件の表記は 2.3', () async {
    final result = await LoadTopScreenUsecaseImpl(
      histories: FixedExerciseHistoryRepository([
        ride(recordedAt: DateTime(2026, 11, 5, 10), distanceKm: 1.14),
        ride(recordedAt: DateTime(2026, 11, 5, 11), distanceKm: 1.14),
      ]),
      metrics: MemoryTopScreenMetricRepository(),
    ).execute(LoadTopScreenRequest(now: now));

    expect(result.today.distanceKm, closeTo(2.28, 1e-9));
    expect(
      PeriodTotalText.of(
        aggregate: result.today,
        metric: PeriodTotalMetric.distance,
      ),
      '2.3',
    );
  });

  test('保存した指標で再び読む', () async {
    final metrics = MemoryTopScreenMetricRepository();
    await metrics.write(PeriodTotalMetric.duration);
    final result = await LoadTopScreenUsecaseImpl(
      histories: const FixedExerciseHistoryRepository([]),
      metrics: metrics,
    ).execute(LoadTopScreenRequest(now: now));

    expect(result.metric, PeriodTotalMetric.duration);
  });
}
