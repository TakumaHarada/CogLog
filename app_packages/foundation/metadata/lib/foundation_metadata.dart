/// フレーバーごとの dart-define 定数。
///
/// 値の真実源はルートの `monolith.yaml`。変更後は
/// `dart run monolith_runner:define` で再生成する。
///
/// Example:
/// ```dart
/// final flavor = Defines.FLAVOR;
/// ```
library;

export "gen/defines.dart";
