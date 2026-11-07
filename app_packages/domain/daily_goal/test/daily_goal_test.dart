import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:test/test.dart';

void main() {
  test('unset は全指標が null', () {
    const goal = DailyGoal.unset;
    expect(goal.duration, isNull);
    expect(goal.caloriesKcal, isNull);
    expect(goal.distanceKm, isNull);
    expect(goal.hasDuration, isFalse);
    expect(goal.hasCalories, isFalse);
    expect(goal.hasDistance, isFalse);
  });

  test('Duration.zero と 0.0 は設定済み', () {
    const goal = DailyGoal(
      duration: Duration.zero,
      caloriesKcal: 0,
      distanceKm: 0,
    );
    expect(goal.duration, Duration.zero);
    expect(goal.caloriesKcal, 0.0);
    expect(goal.distanceKm, 0.0);
    expect(goal.hasDuration, isTrue);
    expect(goal.hasCalories, isTrue);
    expect(goal.hasDistance, isTrue);
  });
}
