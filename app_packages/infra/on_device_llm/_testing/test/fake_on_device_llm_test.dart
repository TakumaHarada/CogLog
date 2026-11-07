import 'package:infra_on_device_llm_testing/infra_on_device_llm_testing.dart';
import 'package:test/test.dart';

void main() {
  test('利用可のとき固定文を返す', () async {
    final llm = FakeOnDeviceLlm(response: '今日はよく動けた');
    expect(await llm.isAvailable, isTrue);
    expect(await llm.generate('prompt'), '今日はよく動けた');
    expect(llm.generateCallCount, 1);
    expect(llm.lastPrompt, 'prompt');
  });

  test('throwOnGenerate で失敗する', () async {
    final llm = FakeOnDeviceLlm(throwOnGenerate: true);
    expect(await llm.isAvailable, isTrue);
    await expectLater(llm.generate('x'), throwsStateError);
    expect(llm.generateCallCount, 1);
  });

  test('available false を返す', () async {
    final llm = FakeOnDeviceLlm(available: false);
    expect(await llm.isAvailable, isFalse);
  });

  test('throwOnIsAvailable で失敗する', () async {
    final llm = FakeOnDeviceLlm(throwOnIsAvailable: true);
    await expectLater(llm.isAvailable, throwsStateError);
  });
}
