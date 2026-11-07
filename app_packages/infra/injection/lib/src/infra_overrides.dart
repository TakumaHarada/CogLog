import 'package:infra_on_device_llm/infra_on_device_llm.dart';
import 'package:infra_on_device_llm_mobile/infra_on_device_llm_mobile.dart';
import 'package:riverpod/misc.dart';

/// 端末上 LLM など infra の本番実装を上書きする。
///
/// Example:
/// ```dart
/// infraOverrides();
/// ```
List<Override> infraOverrides() => [
  onDeviceLlmProvider.overrideWith((ref) => const UnavailableOnDeviceLlm()),
];
