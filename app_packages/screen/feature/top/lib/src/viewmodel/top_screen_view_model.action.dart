part of 'top_screen_view_model.dart';

/// トップ画面の操作。
@internal
extension TopScreenViewModelActions on TopScreenViewModel {
  /// 現在時刻で期間合計を読み直す。
  ///
  /// Example:
  /// ```dart
  /// viewModel.onInitialize();
  /// ```
  Future<void> onInitialize() {
    final delegate = OnInitializeDelegate(
      state: state,
      loadTopScreenUsecase: loadTopScreenUsecase,
    );
    return delegate.execute();
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
