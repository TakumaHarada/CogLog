# DependencyBuilderリファレンス実装

プロジェクト固有の事情が発生することが多々あるため、次のようなクラスをプロジェクトの要件に応じて作成・拡張することを推奨する.

```dart
// app_packages/foundation/dependency_injection/lib/src/dependency_builder.dart

/// DI構築を行うインターフェース.
class DependencyBuilder {
  /// プロバイダーのオーバーライドを設定する.
  final _providerOverrides = <Provider<dynamic>, Override>{};

  /// オーバーライドを設定する.
  final _overrides = <Override>{};

  /// オーバーライドを追加する.
  void addOverrides(Iterable<Override> overrides) {
    _overrides.addAll(overrides);
  }

  /// [ProviderContainer]を構築する.
  ProviderContainer build({
    ProviderContainer? parent,
  }) {
    return ProviderContainer(
      parent: parent,
      overrides: [
        ...ProviderContainerAsyncHelper.inject(),
        ..._providerOverrides.entries.map((e) => e.value),
        ..._overrides,
      ],
    );
  }

  /// 指定したProviderを別なProviderで上書きする.
  void inject<T, T2 extends T>(Provider<T> origin, Provider<T2> override) {
    this.override(
      origin,
      origin.overrideWith(
        (ref) => ref.watch(override),
      ),
    );
  }

  /// 指定したProviderを指定した値で上書きする.
  void injectValue<T>(Provider<T> origin, T value) {
    override(
      origin,
      origin.overrideWith((ref) => value),
    );
  }

  /// プロバイダーのオーバーライドを設定する.
  void override<T>(Provider<T> provider, Override override) {
    _providerOverrides[provider] = override;
  }
}

```
