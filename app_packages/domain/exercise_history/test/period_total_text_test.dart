import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:test/test.dart';

PeriodAggregate history({
  double distanceKm = 0,
  double caloriesKcal = 0,
  Duration duration = Duration.zero,
}) {
  return PeriodAggregate(
    count: 1,
    distanceKm: distanceKm,
    caloriesKcal: caloriesKcal,
    duration: duration,
  );
}

void main() {
  test('小数第2位を四捨五入する', () {
    expect(PeriodTotalText.oneDecimal(1.24), '1.2');
    expect(PeriodTotalText.oneDecimal(1.25), '1.3');
    expect(PeriodTotalText.oneDecimal(1.95), '2.0');
    expect(PeriodTotalText.oneDecimal(0.04), '0.0');
  });

  test('履歴が無い合計は -- で、0 への四捨五入は 0.0', () {
    expect(
      PeriodTotalText.of(
        aggregate: PeriodAggregate.empty,
        metric: PeriodTotalMetric.distance,
      ),
      '--',
    );
    expect(
      PeriodTotalText.of(
        aggregate: history(distanceKm: 0.04),
        metric: PeriodTotalMetric.distance,
      ),
      '0.0',
    );
  });

  test('運動時間は時と分で、30秒以上を繰り上げる', () {
    expect(
      PeriodTotalText.duration(const Duration(hours: 1, minutes: 30)),
      '1h30m',
    );
    expect(PeriodTotalText.duration(const Duration(minutes: 29)), '0h29m');
    expect(PeriodTotalText.duration(const Duration(minutes: 5)), '0h5m');
    expect(PeriodTotalText.duration(const Duration(hours: 2)), '2h0m');
    expect(
      PeriodTotalText.duration(
        const Duration(hours: 1, minutes: 30, seconds: 29),
      ),
      '1h30m',
    );
    expect(
      PeriodTotalText.duration(
        const Duration(hours: 1, minutes: 30, seconds: 30),
      ),
      '1h31m',
    );
    expect(PeriodTotalText.duration(const Duration(seconds: 30)), '0h1m');
    expect(
      PeriodTotalText.duration(
        const Duration(hours: 1, minutes: 59, seconds: 30),
      ),
      '2h0m',
    );
    expect(PeriodTotalText.duration(const Duration(hours: 25)), '25h0m');
    expect(
      PeriodTotalText.of(
        aggregate: history(duration: const Duration(seconds: 29)),
        metric: PeriodTotalMetric.duration,
      ),
      '0h0m',
    );
  });
}
