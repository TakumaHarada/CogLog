/// 一日あたり目標に対する 1 指標の達成区分。
///
/// [unset] は目標未設定、[zeroGoal] は目標 0、[ratio] は正の目標に対する割合。
///
/// Example:
/// ```dart
/// GoalMetricStatus.ratio;
/// ```
enum GoalMetricStatus {
  /// 目標が未設定。
  unset,

  /// 目標が 0（設定済み）。
  zeroGoal,

  /// 正の目標に対する実績の割合。
  ratio,
}
