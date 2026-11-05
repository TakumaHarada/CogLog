import 'package:riverpod/misc.dart';
import 'package:screen_navigation/screen_navigation.dart';

import 'screen_graph.dart';

/// [graph] の遷移実装で注入点を上書きする。
///
/// Example:
/// ```dart
/// screenOverrides(ScreenGraph());
/// ```
List<Override> screenOverrides(ScreenGraph graph) => [
  screenNavigationProvider.overrideWith((ref) => graph.navigation),
];
