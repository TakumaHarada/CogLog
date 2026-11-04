# go_routerのextension

プロジェクト固有の事情が発生することが多々あるため、次のようなクラスをプロジェクトの要件に応じて作成・拡張することを推奨する.
また、GoRouterには特定のパターンで意図通りに動作しない不具合があるため、ワークアラウンドとしても用意しておくと良い.

```dart
extension BuildContextExtensions on BuildContext {
  /// [pushNamed] の前後にライフサイクルチェックを行い、
  /// 遷移できない場合はnullを返却する.
  ///
  /// NOTE.
  /// これは go_routerのpushNamed()をラップしたものであり、
  /// pushNamed()実行後にgo()を実行した際、pushNamed()のFutureが永遠に解決されないバグがある.
  ///
  /// このバグへの対応のため、pushNamed()の前後にライフサイクルチェックを行い、
  /// 遷移できない場合はnullを返却する.
  Future<T?> pushNamedWorkaround<T>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, Object?> queryParameters = const {},
  }) async {
    // pushNamed()のFutureをStreamに変換し、
    // GoRouterWorkaroundNavigatorObserver.subjectが通知されたタイミングで
    // Futureを解決する.
    final pushNamedStream =
        Stream.fromFuture(
          pushNamed<T>(
            name,
            pathParameters: pathParameters,
            queryParameters: queryParameters,
            extra: extra,
          ),
        ).map((e) {
          _log.d("pushNamed<$T>() completed");
          return e;
        });

    // BuildContextが破棄されたタイミングでStreamから通知を出す
    final buildContextDestroyedStream = GoRouterWorkaroundNavigatorObserver
        .subject
        .where((e) => !mounted) // BuildContextが破棄されるまで待つ.
        .take(1)
        .delay(Duration.zero)
        .map<T?>((e) {
          _log.d("pushNamed<$T>() aborted");
          return null;
        });

    // Streamを競争させて、先に解決した方を返却する.
    return Rx.race([
      pushNamedStream,
      buildContextDestroyedStream,
    ]).first;
  }

  Future<T?> safeGoNamed<T>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, Object?> queryParameters = const {},
    required T Function(RouteLifecycle lifecycle) onNavigationFailed,
  }) async {
    bool canNextStep(RouteLifecycle lifecycle) {
      return switch (lifecycle) {
        // 遷移可能
        RouteLifecycleActive() => true,
        // 遷移不可能
        RouteLifecycleDestroyed() => false,
        RouteLifecycleBuilding() => false,
        RouteLifecycleInactive() => false,
      };
    }

    try {
      await waitLifecycleWith(canNextStep);
    } on BadLifecycleException catch (e) {
      return onNavigationFailed(e.latestLifecycle);
    }

    // 画面遷移
    // go()メソッドは戻り値がない.
    goNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
    return null;
  }

  /// [pop] の前後にライフサイクルチェックを行い、
  /// 遷移できない場合は何もしない.
  Future<void> safePop<T>([T? result]) async {
    bool canPop(RouteLifecycle lifecycle) {
      return switch (lifecycle) {
        // 遷移可能
        RouteLifecycleActive() => true,
        // 遷移不可能
        RouteLifecycleDestroyed() => false,
        RouteLifecycleBuilding() => false,
        RouteLifecycleInactive() => false,
      };
    }

    try {
      await waitLifecycleWith(canPop);
      await vsync();
      pop(result);
    } on BadLifecycleException catch (_) {
      // 閉じられない.
      // ライフサイクル待ちの途中に画面から強制離脱させられた可能性がある.
      return;
    }
  }

  /// [pushNamed] の前後にライフサイクルチェックを行い、
  /// 遷移できない場合は[onNavigationFailed]を呼び出す.
  Future<T?> safePushNamed<T>(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const {},
    Map<String, Object?> queryParameters = const {},
    required T Function(RouteLifecycle lifecycle) onNavigationFailed,
  }) async {
    bool canNextStep(RouteLifecycle lifecycle) {
      return switch (lifecycle) {
        // 遷移可能
        RouteLifecycleActive() => true,
        // 遷移不可能
        RouteLifecycleDestroyed() => false,
        RouteLifecycleBuilding() => false,
        RouteLifecycleInactive() => false,
      };
    }

    try {
      // 画面遷移前にライフサイクルチェック
      await waitLifecycleWith(canNextStep);
    } on BadLifecycleException catch (e) {
      return onNavigationFailed(e.latestLifecycle);
    }

    final result = await pushNamedWorkaround<T>(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );

    try {
      // 画面遷移前にライフサイクルチェック
      await waitLifecycleWith(canNextStep);
      await vsync();
    } on BadLifecycleException catch (e) {
      return onNavigationFailed(e.latestLifecycle);
    }

    return result;
  }
}

```
