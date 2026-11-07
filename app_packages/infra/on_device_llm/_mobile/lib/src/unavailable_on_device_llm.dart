import 'package:infra_on_device_llm/infra_on_device_llm.dart';

/// 初回アプリ向けの未接続 LLM。
///
/// 常に利用不可。Foundation Models / Gemini Nano の実接続は後続で差し替える。
///
/// Example:
/// ```dart
/// const UnavailableOnDeviceLlm();
/// ```
final class UnavailableOnDeviceLlm implements OnDeviceLlm {
  /// 利用不可の実装を作る。
  ///
  /// Example:
  /// ```dart
  /// const UnavailableOnDeviceLlm();
  /// ```
  const UnavailableOnDeviceLlm();

  /// 常に false。
  ///
  /// Example:
  /// ```dart
  /// await const UnavailableOnDeviceLlm().isAvailable;
  /// ```
  @override
  Future<bool> get isAvailable async => false;

  /// 利用不可のため呼ばない想定。呼ばれたら失敗する。
  ///
  /// Example:
  /// ```dart
  /// await const UnavailableOnDeviceLlm().generate('prompt');
  /// ```
  @override
  Future<String> generate(String prompt) async {
    throw StateError('OnDeviceLlm is unavailable');
  }
}
