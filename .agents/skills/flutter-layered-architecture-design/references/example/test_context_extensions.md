# TestContextクラス拡張

プロジェクト固有の事情が発生することが多々あるため、次のようなクラスをプロジェクトの要件に応じて作成・拡張することを推奨する

```dart
// app_packages/testing/core/lib/src/test_context_extensions.dart

final _init = () {
  FlutterLogger.inject();
  return 0;
}();

/// 実行中のTestContextを取得する.
TestContext get testContext {
  touch(_init);
  return TestContext.current();
}

/// 依存性注入のビルダーを取得する.
DependencyBuilder get refBuilder => testContext.value(
  DependencyBuilder,
  (context) {
    WidgetsFlutterBinding.ensureInitialized();
    return DependencyBuilder();
  },
);

/// 依存性注入のコンテナを取得する.
ProviderContainer get ref => testContext.value(
  ProviderContainer,
  (context) {
    return refBuilder.build();
  },
  onTearDown: (context, container) {
    return container.disposeAsync();
  },
);

```
