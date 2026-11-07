import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../viewmodel/goal_settings_screen_view_model.dart';
import 'goal_settings_screen_body.dart';

/// 一日あたり目標を入力・保存する画面。
///
/// Example:
/// ```dart
/// const GoalSettingsScreen();
/// ```
class GoalSettingsScreen extends HookConsumerWidget {
  /// 目標設定画面を作る。
  ///
  /// Example:
  /// ```dart
  /// const GoalSettingsScreen();
  /// ```
  const GoalSettingsScreen({super.key});

  /// 初期化で目標を読み、見た目は [GoalSettingsScreenBody] に任せる。
  ///
  /// Example:
  /// ```dart
  /// const GoalSettingsScreen();
  /// ```
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(GoalSettingsScreenViewModel.provider);
    useEffect(() {
      viewModel.onInitialize();
      return null;
    }, [viewModel]);
    return const GoalSettingsScreenBody();
  }
}
