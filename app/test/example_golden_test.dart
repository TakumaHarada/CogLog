import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:app/main.dart';
import 'package:app/src/example.dart';

void main() {
  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('起動画面の light / ja / $platform の見た目を比較する', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      tester.platformDispatcher.localesTestValue = const [Locale('ja')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      try {
        await tester.pumpWidget(const Application());
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Example),
          matchesGoldenFile('goldens/example.png'),
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  }
}
