import 'package:riverpod/riverpod.dart';

import 'load_top_screen_request.dart';
import 'load_top_screen_result.dart';

/// トップ画面の期間合計を読み込む。
///
/// Example:
/// ```dart
/// usecase.execute(LoadTopScreenRequest(now: DateTime(2026, 11, 5, 15)));
/// ```
abstract interface class LoadTopScreenUsecase {
  /// 未接続のときは失敗する注入点。
  static final provider = Provider<LoadTopScreenUsecase>(
    (ref) => throw UnimplementedError('LoadTopScreenUsecase.provider'),
  );

  /// [request] の時刻で 3 期間を切る。
  ///
  /// Example:
  /// ```dart
  /// usecase.execute(LoadTopScreenRequest(now: DateTime(2026, 11, 5, 15)));
  /// ```
  Future<LoadTopScreenResult> execute(LoadTopScreenRequest request);
}
