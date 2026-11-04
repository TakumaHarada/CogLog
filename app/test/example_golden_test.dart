import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:app/main.dart';
import 'package:app/src/example.dart';

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      final golden = brightness == Brightness.light
          ? 'goldens/example.png'
          : 'goldens/example_dark.png';
      testWidgets('起動画面の $brightness / ja / $platform の見た目を比較する', (
        tester,
      ) async {
        debugDefaultTargetPlatformOverride = platform;
        tester.platformDispatcher.platformBrightnessTestValue = brightness;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        tester.platformDispatcher.localesTestValue = const [Locale('ja')];
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        try {
          await tester.pumpWidget(const Application());
          await tester.pumpAndSettle();

          await expectLater(find.byType(Example), matchesGoldenFile(golden));
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      });
    }
  }
}
