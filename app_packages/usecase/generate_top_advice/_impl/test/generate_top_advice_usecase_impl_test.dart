import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:infra_on_device_llm_testing/infra_on_device_llm_testing.dart';
import 'package:test/test.dart';
import 'package:usecase_generate_top_advice/usecase_generate_top_advice.dart';
import 'package:usecase_generate_top_advice_impl/usecase_generate_top_advice_impl.dart';

ExerciseHistory ride({required DateTime recordedAt}) {
  const id = '11111111-1111-4111-8111-111111111111';
  return ExerciseHistory(
    id: id,
    savedAt: recordedAt,
    creationStartedAt: recordedAt,
    capturedAt: recordedAt,
    recordedAt: recordedAt,
    recordedAtManuallySet: false,
    distanceKm: 2,
    duration: const Duration(minutes: 20),
    caloriesKcal: 80,
    averageSpeedKmh: 6,
    photoRelativePath: 'exercise_histories/$id/meter.jpg',
  );
}

GenerateTopAdviceRequest request({
  List<ExerciseHistory> histories = const [],
}) => GenerateTopAdviceRequest(
  histories: histories,
  locale: 'ja',
  noExerciseTemplate: '今日はまだ運動していません',
  fallbackTemplates: const ['定型A', '定型B', '定型C'],
);

void main() {
  test('履歴が空のときは未運動定型で LLM を呼ばない', () async {
    final llm = FakeOnDeviceLlm(response: '生成文');
    final result = await GenerateTopAdviceUsecaseImpl(
      llm: llm,
      picker: const FixedAdviceTemplatePicker(),
    ).execute(request());

    expect(result.advice, '今日はまだ運動していません');
    expect(llm.generateCallCount, 0);
  });

  test('LLM 成功時は生成文を返す', () async {
    final llm = FakeOnDeviceLlm(response: '  よく動けた  ');
    final result =
        await GenerateTopAdviceUsecaseImpl(
          llm: llm,
          picker: const FixedAdviceTemplatePicker(),
        ).execute(
          request(histories: [ride(recordedAt: DateTime(2026, 11, 5, 12))]),
        );

    expect(result.advice, 'よく動けた');
    expect(llm.generateCallCount, 1);
    expect(llm.lastPrompt, contains('locale=ja'));
    expect(llm.lastPrompt, contains('distanceKm=2.0'));
    expect(llm.lastPrompt, contains('caloriesKcal=80.0'));
    expect(llm.lastPrompt, contains('Reply in the language of locale=ja'));
  });

  test('LLM 失敗時は定型を返す', () async {
    final llm = FakeOnDeviceLlm(throwOnGenerate: true);
    final result =
        await GenerateTopAdviceUsecaseImpl(
          llm: llm,
          picker: const FixedAdviceTemplatePicker(index: 1),
        ).execute(
          request(histories: [ride(recordedAt: DateTime(2026, 11, 5, 12))]),
        );

    expect(result.advice, '定型B');
    expect(llm.generateCallCount, 1);
  });

  test('LLM 利用不可のときは定型で generate しない', () async {
    final llm = FakeOnDeviceLlm(available: false);
    final result =
        await GenerateTopAdviceUsecaseImpl(
          llm: llm,
          picker: const FixedAdviceTemplatePicker(),
        ).execute(
          request(histories: [ride(recordedAt: DateTime(2026, 11, 5, 12))]),
        );

    expect(result.advice, '定型A');
    expect(llm.generateCallCount, 0);
  });

  test('isAvailable 失敗時は定型へフォールバックする', () async {
    final llm = FakeOnDeviceLlm(throwOnIsAvailable: true);
    final result =
        await GenerateTopAdviceUsecaseImpl(
          llm: llm,
          picker: const FixedAdviceTemplatePicker(),
        ).execute(
          request(histories: [ride(recordedAt: DateTime(2026, 11, 5, 12))]),
        );

    expect(result.advice, '定型A');
    expect(llm.generateCallCount, 0);
  });

  test('generate タイムアウト時は定型へフォールバックする', () async {
    final llm = FakeOnDeviceLlm(hangOnGenerate: true);
    final result =
        await GenerateTopAdviceUsecaseImpl(
          llm: llm,
          picker: const FixedAdviceTemplatePicker(index: 2),
          generateTimeout: const Duration(milliseconds: 20),
        ).execute(
          request(histories: [ride(recordedAt: DateTime(2026, 11, 5, 12))]),
        );

    expect(result.advice, '定型C');
    expect(llm.generateCallCount, 1);
  });
}
