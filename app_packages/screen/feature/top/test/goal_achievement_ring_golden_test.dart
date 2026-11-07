import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:foundation_resources/gen/strings_test_helper.dart';
import 'package:material_ui/material_ui.dart';
import 'package:monolith_localization_runtime/monolith_localization_runtime.dart';
import 'package:screen_feature_top/src/view/goal_achievement_ring.dart';

void main() {
  testWidgets('達成率リング 100% / ja / Android / light', (tester) async {
    await _pumpRingGolden(
      tester,
      lap1: 1,
      lap2: 0,
      percent: '100%',
      golden: 'goldens/goal_achievement_ring_100.png',
    );
  });

  testWidgets('達成率リング 150% / ja / Android / light', (tester) async {
    await _pumpRingGolden(
      tester,
      lap1: 1,
      lap2: 0.5,
      percent: '150%',
      golden: 'goldens/goal_achievement_ring_150.png',
    );
  });

  testWidgets('達成率リング 250% / ja / Android / light', (tester) async {
    await _pumpRingGolden(
      tester,
      lap1: 1,
      lap2: 1,
      percent: '250%',
      golden: 'goldens/goal_achievement_ring_250.png',
    );
  });
}

Future<void> _pumpRingGolden(
  WidgetTester tester, {
  required double lap1,
  required double lap2,
  required String percent,
  required String golden,
}) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  tester.platformDispatcher.localesTestValue = const [Locale('ja')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  tester.view.physicalSize = const Size(200, 240);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await LocalizeStringDelegate.injectDelegateForTest(
    arbJson: StringsTestHelper.ja,
  );
  addTearDown(LocalizeStringDelegate.resetDelegateForTest);

  try {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        home: FTheme(
          data: FThemeData(touch: true, colors: FColors.neutralLight),
          child: ColoredBox(
            color: FColors.neutralLight.background,
            child: Center(
              child: GoalAchievementRing(
                title: '消費カロリー',
                lap1: lap1,
                lap2: lap2,
                percentText: percent,
                actualText: '実績値',
                goalText: '目標値',
                actualLabel: '実績',
                goalLabel: '目標',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(GoalAchievementRing),
      matchesGoldenFile(golden),
    );
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}
