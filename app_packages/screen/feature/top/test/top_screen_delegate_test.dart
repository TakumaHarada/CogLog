import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_feature_top/src/viewmodel/delegate/on_initialize_delegate.dart';
import 'package:screen_feature_top/src/viewmodel/delegate/on_select_metric_delegate.dart';
import 'package:screen_feature_top/src/viewmodel/delegate/top_screen_state_to_entity_delegate.dart';
import 'package:screen_feature_top/src/viewmodel/state/top_screen_state.dart';
import 'package:state_stream/state_stream.dart';
import 'package:usecase_load_top_screen/usecase_load_top_screen.dart';
import 'package:usecase_save_top_screen_metric/usecase_save_top_screen_metric.dart';

final class _Load implements LoadTopScreenUsecase {
  _Load(this.result);

  final LoadTopScreenResult result;
  var calls = 0;

  @override
  Future<LoadTopScreenResult> execute(LoadTopScreenRequest request) async {
    calls += 1;
    return result;
  }
}

final class _Save implements SaveTopScreenMetricUsecase {
  _Save({this.error});

  final Object? error;
  var calls = 0;

  @override
  Future<SaveTopScreenMetricResult> execute(
    SaveTopScreenMetricRequest request,
  ) async {
    calls += 1;
    final error = this.error;
    if (error != null) {
      throw error;
    }
    return SaveTopScreenMetricResult(metric: request.metric);
  }
}

void main() {
  late MutableStateStream<TopScreenState> state;

  setUp(() {
    state = MutableStateStream(TopScreenState.initial);
  });

  tearDown(() async {
    await state.close();
  });

  test('初期化で合計を入れ、loaded にする', () async {
    final load = _Load(
      const LoadTopScreenResult(
        metric: PeriodTotalMetric.calories,
        today: PeriodAggregate(
          count: 1,
          distanceKm: 1.25,
          caloriesKcal: 1.25,
          duration: Duration(minutes: 1),
        ),
        week: PeriodAggregate.empty,
        month: PeriodAggregate.empty,
      ),
    );
    await OnInitializeDelegate(
      state: state,
      loadTopScreenUsecase: load,
    ).execute();

    expect(state.state.loaded, isTrue);
    expect(state.state.today.count, 1);
    expect(load.calls, 1);
  });

  test('未読込の指標選択は状態を変えない', () async {
    final save = _Save();
    await OnSelectMetricDelegate(
      state: state,
      saveTopScreenMetricUsecase: save,
    ).execute(PeriodTotalMetric.distance);

    expect(state.state.metric, PeriodTotalMetric.calories);
    expect(save.calls, 0);
  });

  test('指標選択は合計を読み直さない', () async {
    state = MutableStateStream(
      const TopScreenState(
        loaded: true,
        metric: PeriodTotalMetric.calories,
        today: PeriodAggregate(
          count: 1,
          distanceKm: 1.25,
          caloriesKcal: 4,
          duration: Duration(minutes: 1),
        ),
        week: PeriodAggregate.empty,
        month: PeriodAggregate.empty,
      ),
    );
    final save = _Save();
    await OnSelectMetricDelegate(
      state: state,
      saveTopScreenMetricUsecase: save,
    ).execute(PeriodTotalMetric.distance);

    expect(state.state.metric, PeriodTotalMetric.distance);
    expect(state.state.today.distanceKm, 1.25);
    expect(save.calls, 1);
  });

  test('保存が失敗したときは指標を変えない', () async {
    state = MutableStateStream(
      const TopScreenState(
        loaded: true,
        metric: PeriodTotalMetric.calories,
        today: PeriodAggregate.empty,
        week: PeriodAggregate.empty,
        month: PeriodAggregate.empty,
      ),
    );
    await expectLater(
      OnSelectMetricDelegate(
        state: state,
        saveTopScreenMetricUsecase: _Save(error: StateError('save')),
      ).execute(PeriodTotalMetric.distance),
      throwsStateError,
    );
    expect(state.state.metric, PeriodTotalMetric.calories);
  });

  test('空の合計は -- で、1.25 kcal は 1.3', () {
    const delegate = TopScreenStateToEntityDelegate();
    expect(delegate.execute(TopScreenState.initial).todayText, '--');
    final entity = delegate.execute(
      const TopScreenState(
        loaded: true,
        metric: PeriodTotalMetric.calories,
        today: PeriodAggregate(
          count: 1,
          distanceKm: 1,
          caloriesKcal: 1.25,
          duration: Duration(minutes: 1),
        ),
        week: PeriodAggregate.empty,
        month: PeriodAggregate.empty,
      ),
    );
    expect(entity.todayText, '1.3');
    expect(entity.weekText, '--');
  });
}
