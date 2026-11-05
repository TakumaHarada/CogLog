import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'top_screen_harness.dart';

void main() {
  testWidgets('履歴が無い期間は --', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await pumpTopScreen(tester);

    expect(find.text('本日'), findsOneWidget);
    expect(find.text('今週'), findsOneWidget);
    expect(find.text('今月'), findsOneWidget);
    expect(find.text('-- kcal'), findsNWidgets(3));
  });

  testWidgets('距離へ切り替えると 3 期間が距離になる', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await pumpTopScreen(
      tester,
      histories: [rideNow(distanceKm: 2.5, caloriesKcal: 1.25)],
    );

    expect(find.text('1.3 kcal'), findsNWidgets(3));
    await tester.tap(find.widgetWithText(FButton, '走行距離'));
    await tester.pumpAndSettle();
    expect(find.text('2.5 km'), findsNWidgets(3));
  });

  testWidgets('選んだ指標は再び開いても残る', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final histories = [rideNow(distanceKm: 2.5, caloriesKcal: 1.25)];

    await pumpTopScreen(tester, histories: histories, preferences: preferences);
    await tester.tap(find.widgetWithText(FButton, '走行距離'));
    await tester.pumpAndSettle();

    await pumpTopScreen(tester, histories: histories, preferences: preferences);
    expect(find.text('2.5 km'), findsNWidgets(3));
  });

  testWidgets('英語で期間と指標を区別できる', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await pumpTopScreen(tester);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('This month'), findsOneWidget);
    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Exercise time'), findsOneWidget);
  });

  testWidgets('撮影操作で /camera へ進み、戻るとトップ画面がある', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final screens = await pumpTopScreen(tester);
    await tester.tap(find.bySemanticsLabel('メーターパネルを撮影'));
    await tester.pumpAndSettle();

    expect(screens.router.state.uri.path, '/camera');
    screens.router.pop();
    await tester.pumpAndSettle();
    expect(find.text('本日'), findsOneWidget);
  });
}
