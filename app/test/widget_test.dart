import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'top_screen_harness.dart';

void main() {
  testWidgets('起動すると本日の合計を示す', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await pumpTopScreen(tester);

    expect(find.text('CogLog'), findsOneWidget);
    expect(find.text('本日'), findsOneWidget);
    expect(find.text('--'), findsNWidgets(3));
    expect(find.text('kcal'), findsNWidgets(3));
  });
}
