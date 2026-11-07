import 'package:domain_daily_goal/domain_daily_goal.dart';

/// 目標設定画面が持つ永続済みの一日あたり目標。
///
/// [loaded] が false のあいだは保存を受け付けない。編集下書きは持たない。
///
/// Example:
/// ```dart
/// GoalSettingsScreenState.initial;
/// ```
final class GoalSettingsScreenState {
  /// 読み込み済みフラグと [goal] を持つ。
  ///
  /// Example:
  /// ```dart
  /// GoalSettingsScreenState.initial;
  /// ```
  const GoalSettingsScreenState({required this.loaded, required this.goal});

  /// まだ読み込んでいない状態。目標は未設定。
  static const initial = GoalSettingsScreenState(
    loaded: false,
    goal: DailyGoal.unset,
  );

  /// 読み込みが成功したあとに true。
  final bool loaded;

  /// 永続化されている一日あたり目標。
  final DailyGoal goal;
}
