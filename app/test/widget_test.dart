import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('日本語の回数表示を増やせる', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const Application());
    await tester.pumpAndSettle();

    expect(find.text('CogLog'), findsOneWidget);
    expect(find.text('回数 0'), findsOneWidget);

    await tester.tap(find.widgetWithText(FButton, '増やす'));
    await tester.pumpAndSettle();

    expect(find.text('回数 1'), findsOneWidget);
  });
}
