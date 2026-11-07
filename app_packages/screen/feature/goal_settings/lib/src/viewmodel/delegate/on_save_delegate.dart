import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:meta/meta.dart';
import 'package:state_stream/state_stream.dart';
import 'package:usecase_save_daily_goal/usecase_save_daily_goal.dart';

import '../state/goal_settings_screen_state.dart';

/// 入力欄の文字列から [DailyGoal] を組み立てる。
///
/// パースできない、または負の値があるときは null。例外は投げない。
///
/// Example:
/// ```dart
/// tryParseDailyGoalInputs(
///   hours: '',
///   minutes: '',
///   seconds: '',
///   calories: '',
///   distance: '',
/// );
/// ```
@visibleForTesting
DailyGoal? tryParseDailyGoalInputs({
  required String hours,
  required String minutes,
  required String seconds,
  required String calories,
  required String distance,
}) {
  final duration = _parseDuration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  );
  if (duration.failed) {
    return null;
  }
  final caloriesKcal = _parseOptionalNonNegativeDouble(calories);
  if (caloriesKcal.failed) {
    return null;
  }
  final distanceKm = _parseOptionalNonNegativeDouble(distance);
  if (distanceKm.failed) {
    return null;
  }
  return DailyGoal(
    duration: duration.value,
    caloriesKcal: caloriesKcal.value,
    distanceKm: distanceKm.value,
  );
}

/// 運動時間 3 欄の解釈結果。
final class _DurationParse {
  const _DurationParse._({required this.failed, this.value});

  /// パース拒否。
  static const fail = _DurationParse._(failed: true);

  /// 未設定。
  static const unset = _DurationParse._(failed: false);

  /// 設定済み。
  factory _DurationParse.ok(Duration value) =>
      _DurationParse._(failed: false, value: value);

  final bool failed;
  final Duration? value;
}

/// 任意の非負数値の解釈結果。
final class _OptionalDoubleParse {
  const _OptionalDoubleParse._({required this.failed, this.value});

  /// パース拒否。
  static const fail = _OptionalDoubleParse._(failed: true);

  /// 未設定。
  static const unset = _OptionalDoubleParse._(failed: false);

  /// 設定済み。
  factory _OptionalDoubleParse.ok(double value) =>
      _OptionalDoubleParse._(failed: false, value: value);

  final bool failed;
  final double? value;
}

/// 時・分・秒を [Duration] にする。すべて空なら未設定。
///
/// Example:
/// ```dart
/// _parseDuration(hours: '1', minutes: '', seconds: '');
/// ```
_DurationParse _parseDuration({
  required String hours,
  required String minutes,
  required String seconds,
}) {
  final h = hours.trim();
  final m = minutes.trim();
  final s = seconds.trim();
  if (h.isEmpty && m.isEmpty && s.isEmpty) {
    return _DurationParse.unset;
  }
  final hoursValue = _parseNonNegativeIntOrZeroWhenEmpty(h);
  final minutesValue = _parseNonNegativeIntOrZeroWhenEmpty(m);
  final secondsValue = _parseNonNegativeIntOrZeroWhenEmpty(s);
  if (hoursValue == null || minutesValue == null || secondsValue == null) {
    return _DurationParse.fail;
  }
  return _DurationParse.ok(
    Duration(hours: hoursValue, minutes: minutesValue, seconds: secondsValue),
  );
}

/// 空は 0。非空は非負整数。解釈できないか負なら null。
///
/// Example:
/// ```dart
/// _parseNonNegativeIntOrZeroWhenEmpty('');
/// ```
int? _parseNonNegativeIntOrZeroWhenEmpty(String trimmed) {
  if (trimmed.isEmpty) {
    return 0;
  }
  final value = int.tryParse(trimmed);
  if (value == null || value < 0) {
    return null;
  }
  return value;
}

/// 空は未設定。非空は非負の [double]。解釈できないか負なら失敗。
///
/// Example:
/// ```dart
/// _parseOptionalNonNegativeDouble('0');
/// ```
_OptionalDoubleParse _parseOptionalNonNegativeDouble(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return _OptionalDoubleParse.unset;
  }
  final value = double.tryParse(trimmed);
  if (value == null || value < 0) {
    return _OptionalDoubleParse.fail;
  }
  return _OptionalDoubleParse.ok(value);
}

/// 入力文字列を解釈して一日あたり目標を保存する。
///
/// Example:
/// ```dart
/// OnSaveDelegate(
///   state: state,
///   saveDailyGoalUsecase: saveDailyGoalUsecase,
/// ).execute(
///   hours: '',
///   minutes: '',
///   seconds: '',
///   calories: '',
///   distance: '',
/// );
/// ```
final class OnSaveDelegate {
  /// [state] と [saveDailyGoalUsecase] を受け取る。
  ///
  /// Example:
  /// ```dart
  /// OnSaveDelegate(
  ///   state: state,
  ///   saveDailyGoalUsecase: saveDailyGoalUsecase,
  /// );
  /// ```
  const OnSaveDelegate({
    required this.state,
    required this.saveDailyGoalUsecase,
  });

  /// 更新する画面状態。
  final MutableStateStream<GoalSettingsScreenState> state;

  /// 一日あたり目標の保存。
  final SaveDailyGoalUsecase saveDailyGoalUsecase;

  /// 入力を解釈し、成功したときだけ保存して State を更新する。
  ///
  /// 未読込、またはパース拒否のときは Usecase を呼ばず State も変えない。
  ///
  /// Example:
  /// ```dart
  /// delegate.execute(
  ///   hours: '0',
  ///   minutes: '0',
  ///   seconds: '0',
  ///   calories: '0',
  ///   distance: '0',
  /// );
  /// ```
  Future<void> execute({
    required String hours,
    required String minutes,
    required String seconds,
    required String calories,
    required String distance,
  }) async {
    await state.updateWithLock((current, emitter) async {
      if (!current.loaded) {
        return;
      }
      final goal = tryParseDailyGoalInputs(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        calories: calories,
        distance: distance,
      );
      if (goal == null) {
        return;
      }
      final result = await saveDailyGoalUsecase.execute(
        SaveDailyGoalRequest(goal: goal),
      );
      await emitter.emit(
        GoalSettingsScreenState(loaded: true, goal: result.goal),
      );
    });
  }
}
