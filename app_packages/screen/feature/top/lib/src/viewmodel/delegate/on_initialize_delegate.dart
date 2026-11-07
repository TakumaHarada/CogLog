import 'package:state_stream/state_stream.dart';
import 'package:usecase_generate_top_advice/usecase_generate_top_advice.dart';
import 'package:usecase_load_top_screen/usecase_load_top_screen.dart';

import '../state/top_screen_state.dart';

/// トップ画面の期間合計とアドバイスを読み、State を置き換える。
///
/// Example:
/// ```dart
/// OnInitializeDelegate(
///   state: state,
///   loadTopScreenUsecase: loadTopScreenUsecase,
///   generateTopAdviceUsecase: generateTopAdviceUsecase,
/// ).execute(
///   locale: 'ja',
///   noExerciseTemplate: '今日はまだ運動していません',
///   fallbackTemplates: const ['a', 'b', 'c'],
/// );
/// ```
final class OnInitializeDelegate {
  /// [state] と読み込み・アドバイス生成 Usecase を受け取る。
  ///
  /// Example:
  /// ```dart
  /// OnInitializeDelegate(
  ///   state: state,
  ///   loadTopScreenUsecase: loadTopScreenUsecase,
  ///   generateTopAdviceUsecase: generateTopAdviceUsecase,
  /// );
  /// ```
  const OnInitializeDelegate({
    required this.state,
    required this.loadTopScreenUsecase,
    required this.generateTopAdviceUsecase,
  });

  /// 更新する画面状態。
  final MutableStateStream<TopScreenState> state;

  /// 期間合計の読み込み。
  final LoadTopScreenUsecase loadTopScreenUsecase;

  /// ワンポイントアドバイスの生成。
  final GenerateTopAdviceUsecase generateTopAdviceUsecase;

  /// 現在時刻で読み込み、アドバイスを生成して loaded にする。
  ///
  /// Example:
  /// ```dart
  /// delegate.execute(
  ///   locale: 'ja',
  ///   noExerciseTemplate: '今日はまだ運動していません',
  ///   fallbackTemplates: const ['a', 'b', 'c'],
  /// );
  /// ```
  Future<void> execute({
    required String locale,
    required String noExerciseTemplate,
    required List<String> fallbackTemplates,
  }) async {
    await state.updateWithLock((_, emitter) async {
      final result = await loadTopScreenUsecase.execute(
        LoadTopScreenRequest(now: DateTime.now()),
      );
      final advice = await generateTopAdviceUsecase.execute(
        GenerateTopAdviceRequest(
          histories: result.todayHistories,
          locale: locale,
          noExerciseTemplate: noExerciseTemplate,
          fallbackTemplates: fallbackTemplates,
        ),
      );
      await emitter.emit(
        TopScreenState(
          loaded: true,
          metric: result.metric,
          today: result.today,
          week: result.week,
          month: result.month,
          goal: result.goal,
          adviceText: advice.advice,
        ),
      );
    });
  }
}
