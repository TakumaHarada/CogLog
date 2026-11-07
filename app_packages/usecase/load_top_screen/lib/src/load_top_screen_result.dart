import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';

/// トップ画面の指標と 3 期間の合計、目標、本日履歴。
///
/// 合計は丸めていない。
///
/// Example:
/// ```dart
/// LoadTopScreenResult(
///   metric: PeriodTotalMetric.calories,
///   today: PeriodAggregate.empty,
///   week: PeriodAggregate.empty,
///   month: PeriodAggregate.empty,
///   goal: DailyGoal.unset,
///   todayHistories: const [],
/// );
/// ```
final class LoadTopScreenResult {
  /// 指標・期間・目標・本日履歴を持つ。
  ///
  /// Example:
  /// ```dart
  /// LoadTopScreenResult(
  ///   metric: PeriodTotalMetric.calories,
  ///   today: PeriodAggregate.empty,
  ///   week: PeriodAggregate.empty,
  ///   month: PeriodAggregate.empty,
  ///   goal: DailyGoal.unset,
  ///   todayHistories: const [],
  /// );
  /// ```
  const LoadTopScreenResult({
    required this.metric,
    required this.today,
    required this.week,
    required this.month,
    required this.goal,
    required this.todayHistories,
  });

  /// 表示する指標。保存が無いときは消費カロリー。
  final PeriodTotalMetric metric;

  /// 本日の合計。
  final PeriodAggregate today;

  /// 今週の合計。
  final PeriodAggregate week;

  /// 今月の合計。
  final PeriodAggregate month;

  /// 一日あたり目標。未保存なら未設定。
  final DailyGoal goal;

  /// 本日の期間に入る運動履歴。
  final List<ExerciseHistory> todayHistories;

  /// 指標だけを差し替える。期間の合計・目標・本日履歴は変えない。
  ///
  /// Example:
  /// ```dart
  /// result.withMetric(PeriodTotalMetric.distance);
  /// ```
  LoadTopScreenResult withMetric(PeriodTotalMetric metric) =>
      LoadTopScreenResult(
        metric: metric,
        today: today,
        week: week,
        month: month,
        goal: goal,
        todayHistories: todayHistories,
      );
}
