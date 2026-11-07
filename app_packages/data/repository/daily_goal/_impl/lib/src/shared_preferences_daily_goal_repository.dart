import 'package:data_repository_daily_goal/data_repository_daily_goal.dart';
import 'package:domain_daily_goal/domain_daily_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 一日あたり目標を SharedPreferences の 3 キーへ残す。
///
/// Example:
/// ```dart
/// SharedPreferencesDailyGoalRepository(preferences).read();
/// ```
final class SharedPreferencesDailyGoalRepository
    implements DailyGoalRepository {
  /// [preferences] へ読み書きする。
  ///
  /// Example:
  /// ```dart
  /// SharedPreferencesDailyGoalRepository(preferences);
  /// ```
  const SharedPreferencesDailyGoalRepository(this._preferences);

  /// 運動時間（秒）を保存するキー。
  static const _durationSecondsKey = 'daily_goal_duration_seconds';

  /// 消費カロリー（kcal）を保存するキー。
  static const _caloriesKcalKey = 'daily_goal_calories_kcal';

  /// 走行距離（km）を保存するキー。
  static const _distanceKmKey = 'daily_goal_distance_km';

  /// 読み書き先。
  final SharedPreferences _preferences;

  /// キー無しは未設定。有り（0 含む）は設定済み。
  ///
  /// Example:
  /// ```dart
  /// repository.read();
  /// ```
  @override
  Future<DailyGoal> read() async {
    final durationSeconds = _preferences.getInt(_durationSecondsKey);
    final caloriesKcal = _preferences.getDouble(_caloriesKcalKey);
    final distanceKm = _preferences.getDouble(_distanceKmKey);
    return DailyGoal(
      duration: durationSeconds == null
          ? null
          : Duration(seconds: durationSeconds),
      caloriesKcal: caloriesKcal,
      distanceKm: distanceKm,
    );
  }

  /// 指標ごと、null ならキー削除、非 null なら書き込む。
  ///
  /// Example:
  /// ```dart
  /// repository.write(const DailyGoal(caloriesKcal: 0));
  /// ```
  @override
  Future<void> write(DailyGoal goal) async {
    final duration = goal.duration;
    if (duration == null) {
      await _remove(_durationSecondsKey);
    } else {
      await _setInt(_durationSecondsKey, duration.inSeconds);
    }

    final caloriesKcal = goal.caloriesKcal;
    if (caloriesKcal == null) {
      await _remove(_caloriesKcalKey);
    } else {
      await _setDouble(_caloriesKcalKey, caloriesKcal);
    }

    final distanceKm = goal.distanceKm;
    if (distanceKm == null) {
      await _remove(_distanceKmKey);
    } else {
      await _setDouble(_distanceKmKey, distanceKm);
    }
  }

  /// [key] を整数で書く。失敗時は reload して例外を返す。
  Future<void> _setInt(String key, int value) async {
    var saved = false;
    try {
      saved = await _preferences.setInt(key, value);
    } on Object {
      await _preferences.reload();
      rethrow;
    }
    if (!saved) {
      await _preferences.reload();
      throw StateError('$key を保存できなかった。');
    }
  }

  /// [key] を小数で書く。失敗時は reload して例外を返す。
  Future<void> _setDouble(String key, double value) async {
    var saved = false;
    try {
      saved = await _preferences.setDouble(key, value);
    } on Object {
      await _preferences.reload();
      rethrow;
    }
    if (!saved) {
      await _preferences.reload();
      throw StateError('$key を保存できなかった。');
    }
  }

  /// [key] を消す。失敗時は reload して例外を返す。
  Future<void> _remove(String key) async {
    var removed = false;
    try {
      removed = await _preferences.remove(key);
    } on Object {
      await _preferences.reload();
      rethrow;
    }
    if (!removed) {
      await _preferences.reload();
      throw StateError('$key を削除できなかった。');
    }
  }
}
