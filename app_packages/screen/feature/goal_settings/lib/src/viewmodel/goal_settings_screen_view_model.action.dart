part of 'goal_settings_screen_view_model.dart';

/// 目標設定画面の操作。
@internal
extension GoalSettingsScreenViewModelActions on GoalSettingsScreenViewModel {
  /// 保存済みの一日あたり目標を読み込む。
  ///
  /// Example:
  /// ```dart
  /// viewModel.onInitialize();
  /// ```
  Future<void> onInitialize() {
    final delegate = OnInitializeDelegate(
      state: state,
      loadDailyGoalUsecase: loadDailyGoalUsecase,
    );
    return delegate.execute();
  }

  /// 入力欄の文字列を解釈して保存する。
  ///
  /// Example:
  /// ```dart
  /// viewModel.onSave(
  ///   hours: '1',
  ///   minutes: '0',
  ///   seconds: '0',
  ///   calories: '200',
  ///   distance: '5',
  /// );
  /// ```
  Future<void> onSave({
    required String hours,
    required String minutes,
    required String seconds,
    required String calories,
    required String distance,
  }) {
    final delegate = OnSaveDelegate(
      state: state,
      saveDailyGoalUsecase: saveDailyGoalUsecase,
    );
    return delegate.execute(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      calories: calories,
      distance: distance,
    );
  }
}
