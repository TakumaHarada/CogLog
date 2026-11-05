import 'package:domain_exercise_history/domain_exercise_history.dart';

import '../entity/top_screen_entity.dart';
import '../state/top_screen_state.dart';

/// トップ画面の State を表示用の文字列へ変える。
///
/// Example:
/// ```dart
/// const TopScreenStateToEntityDelegate().execute(TopScreenState.initial);
/// ```
final class TopScreenStateToEntityDelegate {
  /// 変換を作る。
  ///
  /// Example:
  /// ```dart
  /// const TopScreenStateToEntityDelegate();
  /// ```
  const TopScreenStateToEntityDelegate();

  /// [state] の合計を、選ばれている指標の表記にする。
  ///
  /// Example:
  /// ```dart
  /// const TopScreenStateToEntityDelegate().execute(TopScreenState.initial);
  /// ```
  TopScreenEntity execute(TopScreenState state) => TopScreenEntity(
    metric: state.metric,
    todayText: PeriodTotalText.of(aggregate: state.today, metric: state.metric),
    weekText: PeriodTotalText.of(aggregate: state.week, metric: state.metric),
    monthText: PeriodTotalText.of(aggregate: state.month, metric: state.metric),
  );
}
