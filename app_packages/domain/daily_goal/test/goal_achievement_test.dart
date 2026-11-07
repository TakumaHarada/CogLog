import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:test/test.dart';

void main() {
  group('GoalMetricAchievement.fromRatio', () {
    test('0 は両周 0', () {
      final a = GoalMetricAchievement.fromRatio(0);
      expect(a.status, GoalMetricStatus.ratio);
      expect(a.ratio, 0);
      expect(a.lap1, 0);
      expect(a.lap2, 0);
    });

    test('0.5 は第1周半分', () {
      final a = GoalMetricAchievement.fromRatio(0.5);
      expect(a.ratio, 0.5);
      expect(a.lap1, 0.5);
      expect(a.lap2, 0);
    });

    test('1.0 は第1周満杯', () {
      final a = GoalMetricAchievement.fromRatio(1);
      expect(a.ratio, 1);
      expect(a.lap1, 1);
      expect(a.lap2, 0);
    });

    test('1.5 は第2周半分', () {
      final a = GoalMetricAchievement.fromRatio(1.5);
      expect(a.ratio, 1.5);
      expect(a.lap1, 1);
      expect(a.lap2, 0.5);
    });

    test('2.5 は視覚を二周に留め実値は残す', () {
      final a = GoalMetricAchievement.fromRatio(2.5);
      expect(a.ratio, 2.5);
      expect(a.lap1, 1);
      expect(a.lap2, 1);
    });
  });

  group('GoalAchievement.of', () {
    test('未設定は unset', () {
      final a = GoalAchievement.of(DailyGoal.unset, PeriodAggregate.empty);
      expect(a.duration.status, GoalMetricStatus.unset);
      expect(a.calories.status, GoalMetricStatus.unset);
      expect(a.distance.status, GoalMetricStatus.unset);
      expect(a.duration.ratio, isNull);
      expect(a.calories.lap1, 0);
      expect(a.distance.lap2, 0);
    });

    test('目標 0 は zeroGoal', () {
      const goal = DailyGoal(
        duration: Duration.zero,
        caloriesKcal: 0,
        distanceKm: 0,
      );
      final a = GoalAchievement.of(
        goal,
        const PeriodAggregate(
          count: 1,
          distanceKm: 3,
          caloriesKcal: 100,
          duration: Duration(minutes: 10),
        ),
      );
      expect(a.duration.status, GoalMetricStatus.zeroGoal);
      expect(a.calories.status, GoalMetricStatus.zeroGoal);
      expect(a.distance.status, GoalMetricStatus.zeroGoal);
      expect(a.duration.lap1, 0);
      expect(a.calories.lap2, 0);
    });

    test('0.5 / 1.0 / 1.5 / 2.5 を指標ごとに出す', () {
      const goal = DailyGoal(
        duration: Duration(minutes: 40),
        caloriesKcal: 200,
        distanceKm: 4,
      );
      final half = GoalAchievement.of(
        goal,
        const PeriodAggregate(
          count: 1,
          distanceKm: 0,
          caloriesKcal: 100,
          duration: Duration.zero,
        ),
      );
      expect(half.calories.ratio, 0.5);
      expect(half.calories.lap1, 0.5);

      final full = GoalAchievement.of(
        goal,
        const PeriodAggregate(
          count: 1,
          distanceKm: 0,
          caloriesKcal: 200,
          duration: Duration.zero,
        ),
      );
      expect(full.calories.ratio, 1);
      expect(full.calories.lap1, 1);
      expect(full.calories.lap2, 0);

      final over = GoalAchievement.of(
        goal,
        const PeriodAggregate(
          count: 1,
          distanceKm: 0,
          caloriesKcal: 300,
          duration: Duration.zero,
        ),
      );
      expect(over.calories.ratio, 1.5);
      expect(over.calories.lap1, 1);
      expect(over.calories.lap2, 0.5);

      final capped = GoalAchievement.of(
        goal,
        const PeriodAggregate(
          count: 1,
          distanceKm: 10,
          caloriesKcal: 0,
          duration: Duration.zero,
        ),
      );
      expect(capped.distance.ratio, 2.5);
      expect(capped.distance.lap1, 1);
      expect(capped.distance.lap2, 1);

      final durationHalf = GoalAchievement.of(
        goal,
        const PeriodAggregate(
          count: 1,
          distanceKm: 0,
          caloriesKcal: 0,
          duration: Duration(minutes: 20),
        ),
      );
      expect(durationHalf.duration.ratio, 0.5);
      expect(durationHalf.duration.lap1, 0.5);
    });
  });
}
