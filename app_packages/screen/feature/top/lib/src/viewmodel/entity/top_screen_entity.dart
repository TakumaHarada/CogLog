import 'package:domain_exercise_history/domain_exercise_history.dart';

import 'top_goal_ring_entity.dart';

/// トップ画面が表示する文字列と達成率。
///
/// Example:
/// ```dart
/// TopScreenEntity(
///   metric: PeriodTotalMetric.calories,
///   todayText: '--',
///   weekText: '--',
///   monthText: '--',
///   adviceText: '',
///   duration: const TopGoalRingEntity(
///     status: GoalMetricStatus.unset,
///     lap1: 0,
///     lap2: 0,
///     percentText: '',
///     actualText: '',
///     goalText: '',
///   ),
///   calories: const TopGoalRingEntity(
///     status: GoalMetricStatus.unset,
///     lap1: 0,
///     lap2: 0,
///     percentText: '',
///     actualText: '',
///     goalText: '',
///   ),
///   distance: const TopGoalRingEntity(
///     status: GoalMetricStatus.unset,
///     lap1: 0,
///     lap2: 0,
///     percentText: '',
///     actualText: '',
///     goalText: '',
///   ),
/// );
/// ```
final class TopScreenEntity {
  /// 指標・期間表記・アドバイス・3 指標の達成を持つ。
  ///
  /// Example:
  /// ```dart
  /// TopScreenEntity(
  ///   metric: PeriodTotalMetric.calories,
  ///   todayText: '--',
  ///   weekText: '--',
  ///   monthText: '--',
  ///   adviceText: '',
  ///   duration: ring,
  ///   calories: ring,
  ///   distance: ring,
  /// );
  /// ```
  const TopScreenEntity({
    required this.metric,
    required this.todayText,
    required this.weekText,
    required this.monthText,
    required this.adviceText,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  /// 選択中の指標。
  final PeriodTotalMetric metric;

  /// 本日の表記。
  final String todayText;

  /// 今週の表記。
  final String weekText;

  /// 今月の表記。
  final String monthText;

  /// ワンポイントアドバイス。
  final String adviceText;

  /// 運動時間の達成リング。
  final TopGoalRingEntity duration;

  /// 消費カロリーの達成リング。
  final TopGoalRingEntity calories;

  /// 走行距離の達成リング。
  final TopGoalRingEntity distance;
}
