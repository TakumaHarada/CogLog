import 'package:data_repository_daily_goal_testing/data_repository_daily_goal_testing.dart';
import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:test/test.dart';
import 'package:usecase_save_daily_goal/usecase_save_daily_goal.dart';
import 'package:usecase_save_daily_goal_impl/usecase_save_daily_goal_impl.dart';

void main() {
  test('書いた目標を再び読める', () async {
    final goals = MemoryDailyGoalRepository();
    const goal = DailyGoal(
      duration: Duration(minutes: 30),
      caloriesKcal: 200,
      distanceKm: 0,
    );

    final result = await SaveDailyGoalUsecaseImpl(goals: goals)
        .execute(const SaveDailyGoalRequest(goal: goal));

    expect(result.goal.duration, const Duration(minutes: 30));
    expect(result.goal.caloriesKcal, 200);
    expect(result.goal.distanceKm, 0);

    final stored = await goals.read();
    expect(stored.duration, const Duration(minutes: 30));
    expect(stored.caloriesKcal, 200);
    expect(stored.distanceKm, 0);
  });

  test('未設定を書くと未設定で読める', () async {
    final goals = MemoryDailyGoalRepository();
    await goals.write(
      const DailyGoal(duration: Duration.zero, caloriesKcal: 1, distanceKm: 2),
    );

    final result = await SaveDailyGoalUsecaseImpl(goals: goals)
        .execute(const SaveDailyGoalRequest(goal: DailyGoal.unset));

    expect(result.goal.duration, isNull);
    expect(result.goal.caloriesKcal, isNull);
    expect(result.goal.distanceKm, isNull);

    final stored = await goals.read();
    expect(stored.duration, isNull);
    expect(stored.caloriesKcal, isNull);
    expect(stored.distanceKm, isNull);
  });
}
