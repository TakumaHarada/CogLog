import 'package:domain_daily_goal/domain_daily_goal.dart';

/// 1 指標の達成率リング用の表示値。
///
/// Example:
/// ```dart
/// const TopGoalRingEntity(
///   status: GoalMetricStatus.ratio,
///   lap1: 1,
///   lap2: 0.5,
///   percentText: '150%',
///   actualText: '300.0',
///   goalText: '200.0',
/// );
/// ```
final class TopGoalRingEntity {
  /// 達成区分と描画割合、実績・目標の表記を持つ。
  ///
  /// Example:
  /// ```dart
  /// const TopGoalRingEntity(
  ///   status: GoalMetricStatus.unset,
  ///   lap1: 0,
  ///   lap2: 0,
  ///   percentText: '',
  ///   actualText: '',
  ///   goalText: '',
  /// );
  /// ```
  const TopGoalRingEntity({
    required this.status,
    required this.lap1,
    required this.lap2,
    required this.percentText,
    required this.actualText,
    required this.goalText,
  });

  /// 達成の区分。
  final GoalMetricStatus status;

  /// 第 1 周の塗り割合（0〜1）。
  final double lap1;

  /// 第 2 周の塗り割合（0〜1）。
  final double lap2;

  /// 達成率のパーセント表記。未設定時は空。
  final String percentText;

  /// 実績の数値表記。未設定時は空。
  final String actualText;

  /// 目標の数値表記。未設定時は空。
  final String goalText;

  /// 未設定なら true。
  ///
  /// Example:
  /// ```dart
  /// entity.isUnset;
  /// ```
  bool get isUnset => status == GoalMetricStatus.unset;
}
