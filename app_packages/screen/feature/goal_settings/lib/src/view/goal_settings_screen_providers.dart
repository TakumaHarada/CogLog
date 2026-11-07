import 'package:state_stream_riverpod/state_stream_riverpod.dart';

import '../viewmodel/goal_settings_screen_view_model.dart';

/// 目標設定画面の表示状態を Widget へ渡す。
///
/// Example:
/// ```dart
/// ref.watch(GoalSettingsScreenProviders.entity);
/// ```
final class GoalSettingsScreenProviders {
  /// ViewModel の entity を監視する。
  static final entity = StateStreamProvider.autoDispose.stateBy(
    GoalSettingsScreenViewModel.provider,
    (GoalSettingsScreenViewModel viewModel) => viewModel.entity,
  );

  const GoalSettingsScreenProviders._();
}
