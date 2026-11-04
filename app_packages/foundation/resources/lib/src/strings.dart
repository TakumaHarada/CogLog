import 'package:meta/meta.dart';

import '../gen/strings.dart';

/// 共通リソースの文言へアクセスする。
final class _Strings with L10nStringsMixin {
  /// 生成 mixin を束ねる。
  const _Strings();
}

/// このパッケージ内から参照する文言。
///
/// 他パッケージは生成された `L10nStringsMixin` を mixin して読む。
///
/// Example:
/// ```dart
/// final name = strings.foundation_resources_app_name;
/// ```
@internal
final strings = _Strings();
