part of 'top_screen_view_model.dart';

/// トップ画面の操作。
@internal
extension TopScreenViewModelActions on TopScreenViewModel {
  /// 現在時刻で期間合計を読み、アドバイスを再生成する。
  ///
  /// Example:
  /// ```dart
  /// viewModel.onInitialize(
  ///   locale: 'ja',
  ///   noExerciseTemplate: '今日はまだ運動していません',
  ///   fallbackTemplates: const ['a', 'b', 'c'],
  /// );
  /// ```
  Future<void> onInitialize({
    required String locale,
    required String noExerciseTemplate,
    required List<String> fallbackTemplates,
  }) {
    final delegate = OnInitializeDelegate(
      state: state,
      loadTopScreenUsecase: loadTopScreenUsecase,
      generateTopAdviceUsecase: generateTopAdviceUsecase,
    );
    return delegate.execute(
      locale: locale,
      noExerciseTemplate: noExerciseTemplate,
      fallbackTemplates: fallbackTemplates,
    );
  }

  /// [metric] を保存し、表示中の合計は振り分け直さない。
  ///
  /// Example:
  /// ```dart
  /// viewModel.onSelectMetric(PeriodTotalMetric.distance);
  /// ```
  Future<void> onSelectMetric(PeriodTotalMetric metric) {
    final delegate = OnSelectMetricDelegate(
      state: state,
      saveTopScreenMetricUsecase: saveTopScreenMetricUsecase,
    );
    return delegate.execute(metric);
  }
}
