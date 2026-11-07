import 'package:infra_on_device_llm_mobile/infra_on_device_llm_mobile.dart';
import 'package:test/test.dart';

void main() {
  test('isAvailable は false', () async {
    expect(await const UnavailableOnDeviceLlm().isAvailable, isFalse);
  });

  test('generate は失敗する', () async {
    await expectLater(
      const UnavailableOnDeviceLlm().generate('prompt'),
      throwsStateError,
    );
  });
}
