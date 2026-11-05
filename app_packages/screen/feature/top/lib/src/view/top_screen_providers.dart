import 'package:state_stream_riverpod/state_stream_riverpod.dart';

import '../viewmodel/top_screen_view_model.dart';

/// トップ画面の表示状態を Widget へ渡す。
///
/// Example:
/// ```dart
/// ref.watch(TopScreenProviders.entity);
/// ```
final class TopScreenProviders {
  /// ViewModel の entity を監視する。
  static final entity = StateStreamProvider.autoDispose.stateBy(
    TopScreenViewModel.provider,
    (TopScreenViewModel viewModel) => viewModel.entity,
  );

  const TopScreenProviders._();
}
