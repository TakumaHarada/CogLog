import 'package:meta/meta.dart';
import 'package:material_ui/material_ui.dart';

import 'top_screen_body.dart';

/// トップ画面の骨格。
@internal
class TopScreenImpl extends StatelessWidget {
  /// 骨格を作る。
  ///
  /// Example:
  /// ```dart
  /// const TopScreenImpl();
  /// ```
  const TopScreenImpl({super.key});

  /// 中身は [TopScreenBody] に渡す。
  ///
  /// Example:
  /// ```dart
  /// const TopScreenImpl();
  /// ```
  @override
  Widget build(BuildContext context) => const TopScreenBody();
}
