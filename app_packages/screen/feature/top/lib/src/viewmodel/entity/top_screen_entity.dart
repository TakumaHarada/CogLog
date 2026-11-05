import 'package:domain_exercise_history/domain_exercise_history.dart';

/// トップ画面が表示する文字列。
///
/// Example:
/// ```dart
/// TopScreenEntity(
///   metric: PeriodTotalMetric.calories,
///   todayText: '--',
///   weekText: '--',
///   monthText: '--',
/// );
/// ```
final class TopScreenEntity {
  /// 指標と 3 期間の表記を持つ。
  ///
  /// Example:
  /// ```dart
  /// TopScreenEntity(
  ///   metric: PeriodTotalMetric.calories,
  ///   todayText: '--',
  ///   weekText: '--',
  ///   monthText: '--',
  /// );
  /// ```
  const TopScreenEntity({
    required this.metric,
    required this.todayText,
    required this.weekText,
    required this.monthText,
  });

  /// 選択中の指標。
  final PeriodTotalMetric metric;

  /// 本日の表記。
  final String todayText;

  /// 今週の表記。
  final String weekText;

  /// 今月の表記。
  final String monthText;
}
