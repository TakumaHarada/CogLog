import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

import '../strings.dart';

/// 目標設定の画面。中身は別計画で足す。
///
/// Example:
/// ```dart
/// const GoalSettingsScreen();
/// ```
class GoalSettingsScreen extends StatelessWidget {
  /// 目標設定画面を作る。
  ///
  /// Example:
  /// ```dart
  /// const GoalSettingsScreen();
  /// ```
  const GoalSettingsScreen({super.key});

  /// タイトルだけの空画面を出す。
  ///
  /// Example:
  /// ```dart
  /// const GoalSettingsScreen();
  /// ```
  @override
  Widget build(BuildContext context) => FScaffold(
    header: FHeader(title: Text(strings.screen_feature_goal_settings_title)),
    child: const SizedBox.shrink(),
  );
}
