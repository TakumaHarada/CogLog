import 'package:usecase_generate_top_advice/usecase_generate_top_advice.dart';

/// 常に先頭（または指定 index）の定型を返す。
///
/// Example:
/// ```dart
/// const FixedAdviceTemplatePicker();
/// ```
final class FixedAdviceTemplatePicker implements AdviceTemplatePicker {
  /// [index] 番目を返す。範囲外なら先頭。
  ///
  /// Example:
  /// ```dart
  /// const FixedAdviceTemplatePicker(index: 0);
  /// ```
  const FixedAdviceTemplatePicker({this.index = 0});

  /// 選ぶ添字。
  final int index;

  /// [templates] の [index] を返す。
  ///
  /// Example:
  /// ```dart
  /// const FixedAdviceTemplatePicker().pick(const ['a', 'b']);
  /// ```
  @override
  String pick(List<String> templates) {
    if (templates.isEmpty) {
      throw ArgumentError.value(templates, 'templates', 'must not be empty');
    }
    if (index < 0 || index >= templates.length) {
      return templates.first;
    }
    return templates[index];
  }
}
