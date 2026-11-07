import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:usecase_generate_top_advice/usecase_generate_top_advice.dart';

/// 本日履歴の件数と合計を要約した既定プロンプト。
///
/// Example:
/// ```dart
/// const DefaultTopAdvicePromptBuilder();
/// ```
final class DefaultTopAdvicePromptBuilder implements TopAdvicePromptBuilder {
  /// 差し替え可能な既定実装を作る。
  ///
  /// Example:
  /// ```dart
  /// const DefaultTopAdvicePromptBuilder();
  /// ```
  const DefaultTopAdvicePromptBuilder();

  /// 言語と本日の合計を短く並べたプロンプトを返す。
  ///
  /// Example:
  /// ```dart
  /// const DefaultTopAdvicePromptBuilder().build(
  ///   histories: const [],
  ///   locale: 'ja',
  /// );
  /// ```
  @override
  String build({
    required List<ExerciseHistory> histories,
    required String locale,
  }) {
    var distanceKm = 0.0;
    var caloriesKcal = 0.0;
    var duration = Duration.zero;
    for (final history in histories) {
      distanceKm += history.distanceKm;
      caloriesKcal += history.caloriesKcal;
      duration += history.duration;
    }
    return 'locale=$locale; '
        'count=${histories.length}; '
        'distanceKm=$distanceKm; '
        'caloriesKcal=$caloriesKcal; '
        'durationMinutes=${duration.inMinutes}. '
        'Give a short one-point exercise advice.';
  }
}
