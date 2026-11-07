import 'package:domain_exercise_history/domain_exercise_history.dart';

/// ワンポイントアドバイス生成の依頼。
///
/// [fallbackTemplates] は LLM 不可・失敗時用で 3 件以上あること。
///
/// Example:
/// ```dart
/// GenerateTopAdviceRequest(
///   histories: const [],
///   locale: 'ja',
///   noExerciseTemplate: '今日はまだ運動していません',
///   fallbackTemplates: const ['水分を取ろう', '無理せず続けよう', 'よく休め'],
/// );
/// ```
final class GenerateTopAdviceRequest {
  /// 本日履歴・言語・定型文を持つ。
  ///
  /// Example:
  /// ```dart
  /// GenerateTopAdviceRequest(
  ///   histories: const [],
  ///   locale: 'ja',
  ///   noExerciseTemplate: '今日はまだ運動していません',
  ///   fallbackTemplates: const ['a', 'b', 'c'],
  /// );
  /// ```
  const GenerateTopAdviceRequest({
    required this.histories,
    required this.locale,
    required this.noExerciseTemplate,
    required this.fallbackTemplates,
  });

  /// 本日の運動履歴。空なら未運動定型を使う。
  final List<ExerciseHistory> histories;

  /// 言語コード（例: ja / en）。
  final String locale;

  /// 履歴 0 件のときに返す定型。
  final String noExerciseTemplate;

  /// LLM 不可・失敗時に選ぶ定型（3 件以上）。
  final List<String> fallbackTemplates;
}
