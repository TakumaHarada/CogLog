import 'package:foundation_resources/gen/strings.dart' as foundation_resources;
import 'package:meta/meta.dart';

import '../gen/strings.dart';

/// このパッケージと共通リソースの文言へアクセスする。
final class _Strings
    with L10nStringsMixin, foundation_resources.L10nStringsMixin {
  /// 生成 mixin を束ねる。
  const _Strings();
}

/// 画面から参照する文言。
///
/// パッケージ外へは出さない。ロケールはアプリのローカライゼーションロード後に解決される。
///
/// Example:
/// ```dart
/// Text(strings.app_increase);
/// ```
@internal
final strings = _Strings();
