import 'package:domain_exercise_history/domain_exercise_history.dart';

/// ワンポイントアドバイス用のプロンプトを組み立てる。
///
/// 差し替え可能。Foundation Models 接続後も同一口から差し替える。
///
/// Example:
/// ```dart
/// builder.build(histories: const [], locale: 'ja');
/// ```
abstract interface class TopAdvicePromptBuilder {
  /// [histories] と [locale] からプロンプト文字列を返す。
  ///
  /// Example:
  /// ```dart
  /// builder.build(histories: histories, locale: 'ja');
  /// ```
  String build({
    required List<ExerciseHistory> histories,
    required String locale,
  });
}
