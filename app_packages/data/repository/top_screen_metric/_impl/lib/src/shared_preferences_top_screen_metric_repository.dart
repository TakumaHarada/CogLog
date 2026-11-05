import 'package:data_repository_top_screen_metric/data_repository_top_screen_metric.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 指標を `top_screen_metric` へ文字列で残す。
///
/// Example:
/// ```dart
/// SharedPreferencesTopScreenMetricRepository(preferences).read();
/// ```
final class SharedPreferencesTopScreenMetricRepository
    implements TopScreenMetricRepository {
  /// [preferences] へ読み書きする。
  ///
  /// Example:
  /// ```dart
  /// SharedPreferencesTopScreenMetricRepository(preferences);
  /// ```
  const SharedPreferencesTopScreenMetricRepository(this._preferences);

  /// 指標を保存するキー。
  static const _key = 'top_screen_metric';

  /// 読み書き先。
  final SharedPreferences _preferences;

  /// 未保存と不明な文字列は null。
  ///
  /// Example:
  /// ```dart
  /// repository.read();
  /// ```
  @override
  Future<PeriodTotalMetric?> read() async {
    return switch (_preferences.getString(_key)) {
      'distance' => PeriodTotalMetric.distance,
      'calories' => PeriodTotalMetric.calories,
      'duration' => PeriodTotalMetric.duration,
      _ => null,
    };
  }

  /// [metric] を distance、calories、duration のいずれかで書く。
  ///
  /// Example:
  /// ```dart
  /// repository.write(PeriodTotalMetric.calories);
  /// ```
  @override
  Future<void> write(PeriodTotalMetric metric) async {
    final value = switch (metric) {
      PeriodTotalMetric.distance => 'distance',
      PeriodTotalMetric.calories => 'calories',
      PeriodTotalMetric.duration => 'duration',
    };
    var saved = false;
    try {
      saved = await _preferences.setString(_key, value);
    } on Object {
      await _preferences.reload();
      rethrow;
    }
    if (!saved) {
      await _preferences.reload();
      throw StateError('$_key を保存できなかった。');
    }
  }
}
