import 'package:riverpod/riverpod.dart';

/// 端末上の LLM への窓口。
///
/// 利用不可や生成失敗の扱いは呼び出し側が決める。
///
/// Example:
/// ```dart
/// final available = await llm.isAvailable;
/// ```
abstract interface class OnDeviceLlm {
  /// モデルが使えるとき true。
  ///
  /// Example:
  /// ```dart
  /// await llm.isAvailable;
  /// ```
  Future<bool> get isAvailable;

  /// [prompt] から短文を生成する。
  ///
  /// Example:
  /// ```dart
  /// await llm.generate('今日の運動について短く助言して');
  /// ```
  Future<String> generate(String prompt);
}

/// 端末上 LLM の注入点。未接続のときは失敗する。
///
/// Example:
/// ```dart
/// onDeviceLlmProvider;
/// ```
final onDeviceLlmProvider = Provider<OnDeviceLlm>(
  (ref) => throw UnimplementedError('onDeviceLlmProvider'),
);
