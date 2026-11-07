import 'package:infra_on_device_llm/infra_on_device_llm.dart';
import 'package:usecase_generate_top_advice/usecase_generate_top_advice.dart';

import 'default_top_advice_prompt_builder.dart';
import 'random_advice_template_picker.dart';

/// LLM または定型からワンポイントアドバイスを返す。
///
/// 履歴が空なら LLM を呼ばず未運動定型を返す。利用不可・生成失敗時は
/// [picker] で定型を選ぶ。
///
/// Example:
/// ```dart
/// GenerateTopAdviceUsecaseImpl(llm: llm);
/// ```
final class GenerateTopAdviceUsecaseImpl implements GenerateTopAdviceUsecase {
  /// [llm] と任意の [promptBuilder] / [picker] を持つ実装を作る。
  ///
  /// Example:
  /// ```dart
  /// GenerateTopAdviceUsecaseImpl(llm: llm);
  /// ```
  GenerateTopAdviceUsecaseImpl({
    required this.llm,
    TopAdvicePromptBuilder? promptBuilder,
    AdviceTemplatePicker? picker,
  }) : promptBuilder = promptBuilder ?? const DefaultTopAdvicePromptBuilder(),
       picker = picker ?? RandomAdviceTemplatePicker();

  /// 端末上 LLM。
  final OnDeviceLlm llm;

  /// プロンプト組み立て。差し替え可能。
  final TopAdvicePromptBuilder promptBuilder;

  /// 定型の選択。本番は乱数。
  final AdviceTemplatePicker picker;

  /// 空履歴 → 未運動定型。それ以外は LLM、失敗時は定型。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(
  ///   GenerateTopAdviceRequest(
  ///     histories: const [],
  ///     locale: 'ja',
  ///     noExerciseTemplate: '今日はまだ運動していません',
  ///     fallbackTemplates: const ['a', 'b', 'c'],
  ///   ),
  /// );
  /// ```
  @override
  Future<GenerateTopAdviceResult> execute(
    GenerateTopAdviceRequest request,
  ) async {
    if (request.histories.isEmpty) {
      return GenerateTopAdviceResult(advice: request.noExerciseTemplate);
    }

    final available = await llm.isAvailable;
    if (available) {
      try {
        final prompt = promptBuilder.build(
          histories: request.histories,
          locale: request.locale,
        );
        final generated = await llm.generate(prompt);
        final trimmed = generated.trim();
        if (trimmed.isNotEmpty) {
          return GenerateTopAdviceResult(advice: trimmed);
        }
      } on Object {
        // 定型へフォールバックする。
      }
    }

    return GenerateTopAdviceResult(
      advice: picker.pick(request.fallbackTemplates),
    );
  }
}
