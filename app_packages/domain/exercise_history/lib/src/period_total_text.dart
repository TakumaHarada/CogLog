import 'period_aggregate.dart';
import 'period_total_metric.dart';

/// 期間合計の画面表記。
///
/// 履歴が無いときは `--`。四捨五入は合計のあと 1 回だけ行う。
///
/// Example:
/// ```dart
/// PeriodTotalText.of(
///   aggregate: PeriodAggregate.empty,
///   metric: PeriodTotalMetric.calories,
/// );
/// ```
final class PeriodTotalText {
  const PeriodTotalText._();

  /// [aggregate] を [metric] の表記にする。
  ///
  /// Example:
  /// ```dart
  /// PeriodTotalText.of(
  ///   aggregate: PeriodAggregate.empty,
  ///   metric: PeriodTotalMetric.distance,
  /// );
  /// ```
  static String of({
    required PeriodAggregate aggregate,
    required PeriodTotalMetric metric,
  }) {
    if (!aggregate.hasHistory) {
      return '--';
    }
    return switch (metric) {
      PeriodTotalMetric.distance => oneDecimal(aggregate.distanceKm),
      PeriodTotalMetric.calories => oneDecimal(aggregate.caloriesKcal),
      PeriodTotalMetric.duration => duration(aggregate.duration),
    };
  }

  /// 非負の数を、直後の桁が 0〜4 なら切り捨て、5〜9 なら切り上げて小数第1位にする。
  ///
  /// Example:
  /// ```dart
  /// PeriodTotalText.oneDecimal(1.25);
  /// ```
  static String oneDecimal(double value) {
    final shifted = value * 10;
    var kept = shifted.truncate();
    final discarded = ((shifted - kept) * 10 + 1e-8).floor();
    if (discarded >= 5) {
      kept += 1;
    }
    final whole = kept ~/ 10;
    final fraction = kept.abs() % 10;
    return '$whole.$fraction';
  }

  /// 秒までを分へ四捨五入し、`{時}h{分}m` にする。
  ///
  /// 30 秒未満は分を増やさない。30 秒以上は分を 1 増やす。60 分は時へ繰り上げる。
  ///
  /// Example:
  /// ```dart
  /// PeriodTotalText.duration(const Duration(hours: 1, minutes: 30, seconds: 30));
  /// ```
  static String duration(Duration value) {
    final totalSeconds = value.inSeconds;
    var minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds.remainder(60);
    if (seconds >= 30) {
      minutes += 1;
    }
    final hours = minutes ~/ 60;
    final minuteOfHour = minutes.remainder(60);
    return '${hours}h${minuteOfHour}m';
  }
}
