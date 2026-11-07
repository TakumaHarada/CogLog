/// 生成したワンポイントアドバイス。
///
/// Example:
/// ```dart
/// const GenerateTopAdviceResult(advice: '今日はよく動けた');
/// ```
final class GenerateTopAdviceResult {
  /// [advice] を持つ。
  ///
  /// Example:
  /// ```dart
  /// const GenerateTopAdviceResult(advice: '水分を取ろう');
  /// ```
  const GenerateTopAdviceResult({required this.advice});

  /// 画面に出す短い助言。
  final String advice;
}
