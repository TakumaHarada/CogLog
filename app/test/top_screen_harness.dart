import 'package:data_injection/data_injection.dart';
import 'package:data_repository_exercise_history_testing/data_repository_exercise_history_testing.dart';
import 'package:domain_exercise_history/domain_exercise_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_injection/screen_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usecase_injection/usecase_injection.dart';

import 'package:app/main.dart';

/// トップ画面を、テスト用の履歴付きで起動する。
Future<ScreenGraph> pumpTopScreen(
  WidgetTester tester, {
  List<ExerciseHistory> histories = const [],
  SharedPreferences? preferences,
}) async {
  final stored = preferences ?? await _newPreferences();
  final screens = ScreenGraph();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...dataRepositoryOverrides(
          preferences: stored,
          histories: FixedExerciseHistoryRepository(histories),
        ),
        ...usecaseOverrides(),
        ...screenOverrides(screens),
      ],
      child: Application(router: screens.router),
    ),
  );
  await tester.pumpAndSettle();
  return screens;
}

Future<SharedPreferences> _newPreferences() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

ExerciseHistory rideNow({double distanceKm = 1, double caloriesKcal = 1.25}) {
  const id = '11111111-1111-4111-8111-111111111111';
  final now = DateTime.now();
  return ExerciseHistory(
    id: id,
    savedAt: now,
    creationStartedAt: now,
    capturedAt: now,
    recordedAt: now,
    recordedAtManuallySet: false,
    distanceKm: distanceKm,
    duration: const Duration(minutes: 30),
    caloriesKcal: caloriesKcal,
    averageSpeedKmh: 1,
    photoRelativePath: 'exercise_histories/$id/meter.jpg',
  );
}
