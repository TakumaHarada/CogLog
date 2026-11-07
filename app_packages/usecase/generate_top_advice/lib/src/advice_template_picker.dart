/// 定型アドバイスから 1 件を選ぶ。
///
/// 本番は乱数、テストは固定実装を注入する。
///
/// Example:
/// ```dart
/// picker.pick(const ['a', 'b', 'c']);
/// ```
abstract interface class AdviceTemplatePicker {
  /// [templates] から 1 件を返す。[templates] は空でないこと。
  ///
  /// Example:
  /// ```dart
  /// picker.pick(const ['よく歩けた', '水分を取ろう']);
  /// ```
  String pick(List<String> templates);
}
