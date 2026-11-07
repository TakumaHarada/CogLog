import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_feature_goal_settings/src/viewmodel/delegate/goal_settings_state_to_entity_delegate.dart';
import 'package:screen_feature_goal_settings/src/viewmodel/delegate/on_initialize_delegate.dart';
import 'package:screen_feature_goal_settings/src/viewmodel/delegate/on_save_delegate.dart';
import 'package:screen_feature_goal_settings/src/viewmodel/state/goal_settings_screen_state.dart';
import 'package:state_stream/state_stream.dart';
import 'package:usecase_load_daily_goal/usecase_load_daily_goal.dart';
import 'package:usecase_save_daily_goal/usecase_save_daily_goal.dart';

final class _Load implements LoadDailyGoalUsecase {
  _Load(this.result);

  final LoadDailyGoalResult result;
  var calls = 0;

  @override
  Future<LoadDailyGoalResult> execute(LoadDailyGoalRequest request) async {
    calls += 1;
    return result;
  }
}

final class _Save implements SaveDailyGoalUsecase {
  _Save({this.error});

  final Object? error;
  var calls = 0;
  DailyGoal? lastGoal;

  @override
  Future<SaveDailyGoalResult> execute(SaveDailyGoalRequest request) async {
    calls += 1;
    lastGoal = request.goal;
    final error = this.error;
    if (error != null) {
      throw error;
    }
    return SaveDailyGoalResult(goal: request.goal);
  }
}

void main() {
  late MutableStateStream<GoalSettingsScreenState> state;

  setUp(() {
    state = MutableStateStream(GoalSettingsScreenState.initial);
  });

  tearDown(() async {
    await state.close();
  });

  test('初期化で目標を入れ、loaded にする', () async {
    final load = _Load(
      const LoadDailyGoalResult(goal: DailyGoal(caloriesKcal: 100)),
    );
    await OnInitializeDelegate(
      state: state,
      loadDailyGoalUsecase: load,
    ).execute();

    expect(state.state.loaded, isTrue);
    expect(state.state.goal.caloriesKcal, 100);
    expect(load.calls, 1);
  });

  test('全空の保存は unset になる', () async {
    state = MutableStateStream(
      const GoalSettingsScreenState(loaded: true, goal: DailyGoal.unset),
    );
    final save = _Save();
    final outcome = await OnSaveDelegate(
      state: state,
      saveDailyGoalUsecase: save,
    ).execute(hours: '', minutes: '', seconds: '', calories: '', distance: '');

    expect(outcome, GoalSettingsSaveOutcome.success);
    expect(save.calls, 1);
    expect(save.lastGoal?.duration, isNull);
    expect(save.lastGoal?.caloriesKcal, isNull);
    expect(save.lastGoal?.distanceKm, isNull);
    expect(state.state.goal.duration, isNull);
    expect(state.state.goal.caloriesKcal, isNull);
    expect(state.state.goal.distanceKm, isNull);
  });

  test('0 設定は運動時間・カロリー・距離すべて設定済みの 0', () async {
    state = MutableStateStream(
      const GoalSettingsScreenState(loaded: true, goal: DailyGoal.unset),
    );
    final save = _Save();
    await OnSaveDelegate(state: state, saveDailyGoalUsecase: save).execute(
      hours: '0',
      minutes: '0',
      seconds: '0',
      calories: '0',
      distance: '0',
    );

    expect(save.calls, 1);
    expect(save.lastGoal?.duration, Duration.zero);
    expect(save.lastGoal?.caloriesKcal, 0);
    expect(save.lastGoal?.distanceKm, 0);
    expect(state.state.goal.duration, Duration.zero);
  });

  test('運動時間の一部入力は空欄を 0 とみなす', () async {
    state = MutableStateStream(
      const GoalSettingsScreenState(loaded: true, goal: DailyGoal.unset),
    );
    final save = _Save();
    await OnSaveDelegate(state: state, saveDailyGoalUsecase: save).execute(
      hours: '1',
      minutes: '',
      seconds: '5',
      calories: '',
      distance: '',
    );

    expect(save.calls, 1);
    expect(
      save.lastGoal?.duration,
      const Duration(hours: 1, minutes: 0, seconds: 5),
    );
    expect(save.lastGoal?.caloriesKcal, isNull);
    expect(save.lastGoal?.distanceKm, isNull);
  });

  test('不正入力は write せず State を変えない', () async {
    const before = DailyGoal(caloriesKcal: 50);
    state = MutableStateStream(
      const GoalSettingsScreenState(loaded: true, goal: before),
    );
    final save = _Save();
    final invalid =
        await OnSaveDelegate(state: state, saveDailyGoalUsecase: save).execute(
          hours: 'x',
          minutes: '',
          seconds: '',
          calories: '10',
          distance: '1',
        );

    expect(invalid, GoalSettingsSaveOutcome.invalidInput);
    expect(save.calls, 0);
    expect(state.state.goal, before);

    final negative =
        await OnSaveDelegate(state: state, saveDailyGoalUsecase: save).execute(
          hours: '',
          minutes: '',
          seconds: '',
          calories: '-1',
          distance: '',
        );
    expect(negative, GoalSettingsSaveOutcome.invalidInput);
    expect(save.calls, 0);
    expect(state.state.goal, before);

    final nan = await OnSaveDelegate(state: state, saveDailyGoalUsecase: save)
        .execute(
          hours: '',
          minutes: '',
          seconds: '',
          calories: 'NaN',
          distance: 'Infinity',
        );
    expect(nan, GoalSettingsSaveOutcome.invalidInput);
    expect(save.calls, 0);
  });

  test('未読込の保存は no-op', () async {
    final save = _Save();
    final outcome =
        await OnSaveDelegate(state: state, saveDailyGoalUsecase: save).execute(
          hours: '1',
          minutes: '0',
          seconds: '0',
          calories: '1',
          distance: '1',
        );

    expect(outcome, GoalSettingsSaveOutcome.saveFailed);
    expect(save.calls, 0);
    expect(state.state.loaded, isFalse);
    expect(state.state.goal, DailyGoal.unset);
  });

  test('永続化失敗は saveFailed で State を変えない', () async {
    const before = DailyGoal(caloriesKcal: 50);
    state = MutableStateStream(
      const GoalSettingsScreenState(loaded: true, goal: before),
    );
    final save = _Save(error: StateError('fail'));
    final outcome =
        await OnSaveDelegate(state: state, saveDailyGoalUsecase: save).execute(
          hours: '1',
          minutes: '0',
          seconds: '0',
          calories: '1',
          distance: '1',
        );

    expect(outcome, GoalSettingsSaveOutcome.saveFailed);
    expect(save.calls, 1);
    expect(state.state.goal, before);
  });

  test('tryParse は全空を unset、0 と一部入力を解釈する', () {
    final empty = tryParseDailyGoalInputs(
      hours: '',
      minutes: '',
      seconds: '',
      calories: '',
      distance: '',
    );
    expect(empty?.duration, isNull);
    expect(empty?.caloriesKcal, isNull);
    expect(empty?.distanceKm, isNull);

    final zeros = tryParseDailyGoalInputs(
      hours: '0',
      minutes: '0',
      seconds: '0',
      calories: '0.0',
      distance: '0',
    );
    expect(zeros?.duration, Duration.zero);
    expect(zeros?.caloriesKcal, 0);
    expect(zeros?.distanceKm, 0);

    expect(
      tryParseDailyGoalInputs(
        hours: '',
        minutes: '30',
        seconds: '',
        calories: '',
        distance: '',
      )?.duration,
      const Duration(minutes: 30),
    );
    expect(
      tryParseDailyGoalInputs(
        hours: 'a',
        minutes: '',
        seconds: '',
        calories: '',
        distance: '',
      ),
      isNull,
    );
    expect(
      tryParseDailyGoalInputs(
        hours: '',
        minutes: '',
        seconds: '',
        calories: 'NaN',
        distance: '',
      ),
      isNull,
    );
    expect(
      tryParseDailyGoalInputs(
        hours: '',
        minutes: '',
        seconds: '',
        calories: '',
        distance: 'Infinity',
      ),
      isNull,
    );
    expect(
      tryParseDailyGoalInputs(
        hours: '100',
        minutes: '',
        seconds: '',
        calories: '',
        distance: '',
      ),
      isNull,
    );
  });

  test('未設定は空文字、設定済み 0 は 0 の文字列', () {
    const delegate = GoalSettingsStateToEntityDelegate();
    final unset = delegate.execute(GoalSettingsScreenState.initial);
    expect(unset.hours, '');
    expect(unset.minutes, '');
    expect(unset.seconds, '');
    expect(unset.calories, '');
    expect(unset.distance, '');

    final zeros = delegate.execute(
      const GoalSettingsScreenState(
        loaded: true,
        goal: DailyGoal(
          duration: Duration.zero,
          caloriesKcal: 0,
          distanceKm: 0,
        ),
      ),
    );
    expect(zeros.hours, '0');
    expect(zeros.minutes, '0');
    expect(zeros.seconds, '0');
    expect(zeros.calories, '0.0');
    expect(zeros.distance, '0.0');
  });
}
