import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

import '../strings.dart';

/// 運動履歴の画面。中身は別計画で足す。
///
/// Example:
/// ```dart
/// const ExerciseHistoryScreen();
/// ```
class ExerciseHistoryScreen extends StatelessWidget {
  /// 運動履歴画面を作る。
  ///
  /// Example:
  /// ```dart
  /// const ExerciseHistoryScreen();
  /// ```
  const ExerciseHistoryScreen({super.key});

  /// タイトルだけの空画面を出す。
  ///
  /// Example:
  /// ```dart
  /// const ExerciseHistoryScreen();
  /// ```
  @override
  Widget build(BuildContext context) => FScaffold(
    header: FHeader(title: Text(strings.screen_feature_exercise_history_title)),
    child: const SizedBox.shrink(),
  );
}
