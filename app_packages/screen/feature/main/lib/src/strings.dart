import 'package:meta/meta.dart';

import '../gen/strings.dart';

/// シェルの文言。
final class _Strings with L10nStringsMixin {
  /// 生成 mixin を束ねる。
  const _Strings();
}

/// シェルから参照する文言。
///
/// Example:
/// ```dart
/// strings.screen_feature_main_nav_home;
/// ```
@internal
final strings = _Strings();
