import 'package:infra_on_device_llm/infra_on_device_llm.dart';

/// テスト用の固定応答 LLM。
///
/// [throwOnGenerate] で生成失敗を再現できる。
///
/// Example:
/// ```dart
/// FakeOnDeviceLlm(response: '定型ではない助言');
/// ```
final class FakeOnDeviceLlm implements OnDeviceLlm {
  /// [response] を返し、[available] で利用可否を切り替える。
  ///
  /// [throwOnGenerate] が true のときは [generate] で例外を投げる。
  ///
  /// Example:
  /// ```dart
  /// FakeOnDeviceLlm(available: false);
  /// ```
  FakeOnDeviceLlm({
    this.available = true,
    this.response = 'fake advice',
    this.throwOnGenerate = false,
  });

  /// [isAvailable] が返す値。
  final bool available;

  /// [generate] が返す文。
  final String response;

  /// true のとき [generate] が失敗する。
  final bool throwOnGenerate;

  /// [generate] が呼ばれた回数。
  int generateCallCount = 0;

  /// 最後に渡されたプロンプト。
  String? lastPrompt;

  /// [available] を返す。
  ///
  /// Example:
  /// ```dart
  /// await llm.isAvailable;
  /// ```
  @override
  Future<bool> get isAvailable async => available;

  /// [response] を返すか、設定に応じて失敗する。
  ///
  /// Example:
  /// ```dart
  /// await llm.generate('prompt');
  /// ```
  @override
  Future<String> generate(String prompt) async {
    generateCallCount += 1;
    lastPrompt = prompt;
    if (throwOnGenerate) {
      throw StateError('FakeOnDeviceLlm generate failed');
    }
    return response;
  }
}
