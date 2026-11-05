import 'package:foundation_resources/foundation_resources.dart';
import 'package:foundation_resources/src/strings.dart';
import 'package:monolith_localization_runtime/monolith_localization_runtime.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() async {
    await LocalizeStringDelegate.injectDelegateForTest(
      arbJson: StringsTestHelper.ja,
    );
  });

  tearDownAll(() async {
    await LocalizeStringDelegate.resetDelegateForTest();
  });

  test('ja のアプリケーション名を返す', () {
    expect(strings.foundation_resources_app_name, 'CogLog');
  });
}
