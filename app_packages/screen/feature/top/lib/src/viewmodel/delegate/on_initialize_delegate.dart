import 'package:state_stream/state_stream.dart';
import 'package:usecase_load_top_screen/usecase_load_top_screen.dart';

import '../state/top_screen_state.dart';

/// トップ画面の期間合計を読み、State を置き換える。
///
/// Example:
/// ```dart
/// OnInitializeDelegate(
///   state: state,
///   loadTopScreenUsecase: loadTopScreenUsecase,
/// ).execute();
/// ```
final class OnInitializeDelegate {
  /// [state] と [loadTopScreenUsecase] を受け取る。
  ///
  /// Example:
  /// ```dart
  /// OnInitializeDelegate(
  ///   state: state,
  ///   loadTopScreenUsecase: loadTopScreenUsecase,
  /// );
  /// ```
  const OnInitializeDelegate({
    required this.state,
    required this.loadTopScreenUsecase,
  });

  /// 更新する画面状態。
  final MutableStateStream<TopScreenState> state;

  /// 期間合計の読み込み。
  final LoadTopScreenUsecase loadTopScreenUsecase;

  /// 現在時刻で読み込み、成功したら loaded にする。
  ///
  /// Example:
  /// ```dart
  /// delegate.execute();
  /// ```
  Future<void> execute() async {
    await state.updateWithLock((_, emitter) async {
      final result = await loadTopScreenUsecase.execute(
        LoadTopScreenRequest(now: DateTime.now()),
      );
      await emitter.emit(
        TopScreenState(
          loaded: true,
          metric: result.metric,
          today: result.today,
          week: result.week,
          month: result.month,
        ),
      );
    });
  }
}
