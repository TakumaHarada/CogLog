import 'package:riverpod/riverpod.dart';

import 'generate_top_advice_request.dart';
import 'generate_top_advice_result.dart';

/// ホーム用のワンポイントアドバイスを生成する。
///
/// Example:
/// ```dart
/// usecase.execute(
///   GenerateTopAdviceRequest(
///     histories: const [],
///     locale: 'ja',
///     noExerciseTemplate: '今日はまだ運動していません',
///     fallbackTemplates: const ['a', 'b', 'c'],
///   ),
/// );
/// ```
abstract interface class GenerateTopAdviceUsecase {
  /// 未接続のときは失敗する注入点。
  static final provider = Provider<GenerateTopAdviceUsecase>(
    (ref) => throw UnimplementedError('GenerateTopAdviceUsecase.provider'),
  );

  /// [request] から助言文を返す。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(
  ///   GenerateTopAdviceRequest(
  ///     histories: const [],
  ///     locale: 'ja',
  ///     noExerciseTemplate: '今日はまだ運動していません',
  ///     fallbackTemplates: const ['a', 'b', 'c'],
  ///   ),
  /// );
  /// ```
  Future<GenerateTopAdviceResult> execute(GenerateTopAdviceRequest request);
}
