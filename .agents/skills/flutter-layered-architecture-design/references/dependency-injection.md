# Flutter-Layered-Architecture / Dependency Injection

## 概要

`Flutter-Layered-Architecture` では、依存性注入（Dependency Injection）をRiverpodのProvider Containerを使用して実装している。インターフェースと実装を分離し、`DependencyBuilder`を使用して依存関係を管理する。

## ライブラリ選定

* DIライブラリとして、RiverpodのProvider Containerを利用する
* `DependencyBuilder`クラスを使用して、Providerのオーバーライドを管理する

### ライブラリ選定の補足

RiverpodのProvider Containerは、Flutterアプリケーションの状態管理とDIを統合的に提供する。`DependencyBuilder`を使用することで、インターフェースと実装の結びつけを一元管理できる。

## DependencyBuilder（参考情報）

`DependencyBuilder`は、DIコンテナの構築を担当するクラスである。このクラスは既に実装済みであり、量産は不要なインターフェースである。

### 主な使用方法

注入クラスでは、以下のメソッドを使用する：

* `inject()`: インターフェースのProviderを実装のProviderで上書きする
* `injectValue()`: Providerを直接値で上書きする（テスト時など）

```dart
builder.inject(
  ${インターフェース}.provider,      // インターフェース側のProvider
  ${実装}.provider,                  // 実装側のProvider
);
```

詳細な実装は `app_packages/foundation/dependency_injection/lib/src/dependency_builder.dart` を参照。

## package分離

インターフェースと実装を分離する場合、下記のような構成が基本となる。

### package分離の補足

インターフェースと実装を分離することで、以下の利点がある：

* テスト時のモック実装が容易になる
* 実装の変更がインターフェースに影響を与えない
* 依存関係の方向が明確になる

### 一般的な構成（Usecase、Data、Infraなど）

一般的なレイヤー（Usecase、Data、Infraなど）では、以下のような構成となる：

```text
app_packages/
├── ${レイヤー名}/
│   ├── ${機能名}/              # インターフェースパッケージ
│   │   ├── lib/src/
│   │   │   └── ${機能名}.dart
│   │   └── _impl/              # 実装パッケージ
│   │       └── lib/src/
│   │           └── ${機能名}/${機能名}_impl.dart
│   └── injection/              # 依存注入パッケージ
│       └── lib/src/
│           └── ${レイヤー名}_injection.dart
```

#### 実装例：Usecase/Dataレイヤー

UsecaseレイヤーとDataレイヤーは同等の構成となる：

```text
app_packages/usecase/
├── school/                 # usecase_school（インターフェース）
│   ├── lib/
│   │   ├── usecase_school.dart  # パッケージ名と同一
│   │   └── src/kanji_search/
│   │       ├── kanji_search_usecase.dart
│   │       ├── kanji_search_request.dart
│   │       └── kanji_search_result.dart
│   └── _impl/              # usecase_school_impl（実装）
│       └── lib/
│           ├── usecase_school_impl.dart  # パッケージ名と同一
│           └── src/kanji_search_usecase/
│               └── kanji_search_usecase_impl.dart
└── injection/              # usecase_injection（依存注入）
    └── lib/
        ├── usecase_injection.dart  # パッケージ名と同一
        └── src/
            └── injection.dart
```

インポート例：

```dart
// インターフェースパッケージのインポート
import "package:usecase_school/usecase_school.dart";

// 実装パッケージのインポート
import "package:usecase_school_impl/usecase_school_impl.dart";

// Injectionパッケージのインポート
import "package:usecase_injection/usecase_injection.dart";
```

```text
app_packages/data/
├── repository/
│   └── preferences/        # data_repository_preferences（インターフェース）
│       ├── lib/src/
│       │   └── preferences_repository.dart
│       └── _impl/          # data_repository_preferences_impl（実装）
│           └── lib/src/
│               └── preferences_repository/
│                   └── preferences_repository_impl.dart
├── source/
│   └── embedded/          # data_source_embedded（インターフェース）
│       ├── lib/src/
│       │   └── embedded_local_datasource.dart
│       └── _impl/         # data_source_embedded_impl（実装）
│           └── lib/src/
│               └── embedded_local_datasource/
│                   └── embedded_local_datasource_impl.dart
└── injection/             # data_injection（依存注入）
    └── lib/src/
        └── data_injection.dart
```

### Screenレイヤーの構成

Screenレイヤーは、`navigation`と`feature`により分離されている：

```text
app_packages/screen/
├── navigation/            # screen_navigation（インターフェース）
│   ├── lib/src/
│   │   └── ${機能}/
│   │       └── ${機能}.dart
│   └── _go_router/        # screen_navigation_go_router（実装）
│       └── lib/src/
│           └── ${機能}/
│               └── ${機能}_impl.dart
├── feature/              # screen_feature_${画面名}2
│   └── ${画面名}2/
│       └── lib/src/
│           ├── screen/
│           ├── viewmodel/
│           └── factory/
└── injection/            # screen_injection（依存注入）
    └── lib/src/
        └── screen_injection.dart
```

#### Screenレイヤー構成の補足

Screenレイヤーでは、以下のような構成となる：

* `navigation`: 画面遷移のインターフェースを定義
* `navigation/_go_router`: go_routerを使用した画面遷移の実装
* `feature`: 各画面の実装（`screen_feature_${画面名}2`形式）
* `injection`: 画面レイヤーの依存注入

#### Screenレイヤー構成の実装例

```text
app_packages/screen/
├── navigation/
│   ├── lib/src/app/
│   │   └── app_router_factory.dart
│   └── _go_router/
│       └── lib/src/router/
│           └── app_router_factory_impl.dart
├── feature/
│   ├── home2/
│   │   └── lib/src/
│   │       ├── screen/
│   │       ├── viewmodel/
│   │       └── factory/
│   └── login/
│       └── lib/src/
│           ├── screen/
│           ├── viewmodel/
│           └── factory/
└── injection/
    └── lib/src/
        └── screen_injection.dart
```

### テスト用パッケージ

テスト環境では、`testing`、`test`、`mock`、`fake`などのサフィックスを持つパッケージを使用する：

```text
app_packages/
├── ${レイヤー名}/
│   └── ${機能名}/              # インターフェース
│       ├── _impl/              # 実装
│       └── _test/              # テスト（オプション）
└── infra/
    └── injection/
        └── _testing/           # テスト環境向けのインフラ注入
            └── lib/src/
                └── testing_infra_injection.dart
```

#### 実装例：テスト環境でのDI

```dart
// infra_injection/_testing, testing_infra_injection.dart
/// テスト環境向けのインフラ構築.
final class TestingInfraInjection {
  const TestingInfraInjection._();

  /// インフラ構築.
  static Future<void> inject(DependencyBuilder builder) async {
    builder.inject(
      BundleLoader.provider,
      TestingBundleLoader.provider,
    );
    await TestingStorageInjection.inject(builder);
    builder.inject(
      AppDatabase.provider,
      AppDatabaseImpl.provider,
    );
  }
}
```

## テスト用と本番用のInjectionの分離

テスト環境と本番環境では、異なる実装を注入する必要がある場合がある。この場合、テスト用のInjectionクラスを別パッケージに分離する。

### テスト用と本番用のInjection分離の補足

テスト用と本番用のInjectionを分離することで、以下の利点がある：

* テスト環境向けのFake実装を簡潔に注入できる
* 本番コードにテスト用の実装が混入しない
* 外部サービス（Firebase等）への依存を軽量化できる

### パッケージ構成

テスト用のInjectionは、`_testing`サブディレクトリに配置する：

```text
app_packages/
├── usecase/
│   └── injection/              # usecase_injection（本番用）
│       ├── lib/src/
│       │   └── usecase_injection.dart
│       └── _testing/           # usecase_injection_testing（テスト用）
│           ├── pubspec.yaml
│           └── lib/src/
│               └── testing_usecase_injection.dart
└── infra/
    └── injection/
        ├── _mobile/            # infra_injection_mobile（本番用）
        │   └── lib/src/
        │       └── mobile_infra_injection.dart
        └── _testing/           # infra_injection_testing（テスト用）
            ├── pubspec.yaml
            └── lib/src/
                └── testing_infra_injection.dart
```

#### 実装例：実際のディレクトリ構成

```text
app_packages/usecase/injection/
├── lib/src/
│   └── usecase_injection.dart
├── pubspec.yaml
└── _testing/
    ├── lib/
    │   ├── usecase_injection_testing.dart
    │   └── src/
    │       └── testing_usecase_injection.dart
    └── pubspec.yaml
```

### 命名規則

* 本番用Injectionクラス: `${レイヤー名}Injection`（例：`UsecaseInjection`）
* テスト用Injectionクラス: `Testing${レイヤー名}Injection`（例：`TestingUsecaseInjection`）
* テスト用パッケージ名: `${パッケージ名}_testing`（例：`usecase_injection_testing`）

### テスト用Injectionの実装パターン

テスト用Injectionクラスは、テスト環境向けのFake実装を注入する：

```dart
// usecase_injection/_testing, testing_usecase_injection.dart
import "package:foundation_dependency_injection/dependency_injection.dart";
import "package:usecase_error/usecase_error.dart";
import "package:usecase_error_impl/error_impl.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// テスト環境向けのUsecase依存注入.
final class TestingUsecaseInjection {
  const TestingUsecaseInjection._();

  /// Usecase依存注入.
  static Future<void> inject(DependencyBuilder builder) async {
    builder.inject(
      CrashReportSendUsecase.provider,
      CrashReportSendUsecaseFake.provider,
    );
  }
}
```

#### テスト用Injectionの実装パターンのポイント

1. **final class**: テスト用Injectionクラスも `final class` で定義する
2. **プライベートコンストラクタ**: `const Testing${レイヤー名}Injection._();` を定義する
3. **Fake実装の注入**: テスト用のFake実装をインターフェースに注入する
4. **依存関係の最小化**: テスト用Injectionは、必要最小限のFake実装のみを注入する

### テストヘルパーでの統合

複数のレイヤーのテスト用Injectionを統合するヘルパー関数を提供する：

```dart
// testing_injection, testing_injection_functions.dart
import "package:armyknife_test_context/armyknife_test_context.dart";
import "package:data_injection/injection.dart";
import "package:infra_injection/_testing/injection_testing.dart";
import "package:testing_core/testing_core.dart";
import "package:usecase_injection/injection.dart";
import "package:usecase_injection/_testing/usecase_injection_testing.dart";

extension TestContextInjectionExtensions on TestContext {
  /// Unit Test用の依存注入を行う.
  /// DIとDartの仕様上、この処理を利用するためにはすべての実装モジュールへの暗黙的参照が発生する点に注意すること.
  Future<void> injectForTesting() async {
    await TestingInfraInjection.inject(refBuilder);
    await DataInjection.inject(refBuilder);
    await UsecaseInjection.inject(refBuilder);
    await TestingUsecaseInjection.inject(refBuilder);
  }
}
```

#### テストヘルパーでの統合のポイント

1. **注入順序**: Infra → Data → Usecase → TestingUsecase の順序で注入する
2. **本番用とテスト用の混在**: 本番用Injectionを先に呼び出し、テスト用Injectionで上書きする
3. **統合ヘルパー**: `testContext.injectForTesting()` で一括注入できるようにする

### 注入順序とオーバーライド

テスト環境では、以下の順序で依存注入を行う：

1. **Infraレイヤー（テスト用）**: `TestingInfraInjection.inject(builder)`
2. **Dataレイヤー（本番用）**: `DataInjection.inject(builder)`
3. **Usecaseレイヤー（本番用）**: `UsecaseInjection.inject(builder)`
4. **Usecaseレイヤー（テスト用）**: `TestingUsecaseInjection.inject(builder)`

この順序により、本番用の実装を先に注入し、テスト用の実装で必要な部分のみを上書きできる。

#### 注入順序とオーバーライドの実装例

```dart
// testing_injection, testing_injection_functions.dart
extension TestContextInjectionExtensions on TestContext {
  Future<void> injectForTesting() async {
    // 1. テスト用Infra注入（BundleLoader等のFake）
    await TestingInfraInjection.inject(refBuilder);
    
    // 2. 本番用Data注入（Repository等の実装）
    await DataInjection.inject(refBuilder);
    
    // 3. 本番用Usecase注入（Usecaseの実装）
    await UsecaseInjection.inject(refBuilder);
    
    // 4. テスト用Usecase注入（特定のUsecaseのFake実装で上書き）
    await TestingUsecaseInjection.inject(refBuilder);
  }
}
```

## 依存注入の実装

### 注入クラスのパターン

各レイヤーには、依存注入を担当するクラスが存在する。命名規則は `${レイヤー名}Injection` となる。

#### 実装例：Usecaseレイヤー

```dart
/// ビジネスロジックの依存性注入を行う.
final class UsecaseInjection {
  const UsecaseInjection._();

  static Future<void> inject(DependencyBuilder builder) async {
    await _injectSystem(builder);
    await _injectKanjiPractice(builder);
    await _injectJapanese(builder);
    await _injectSchool(builder);
    await _injectTutorial(builder);
    await _injectError(builder);
  }

  static Future<void> _injectError(DependencyBuilder builder) async {
    builder.inject(
      ErrorQueryUsecase.provider,
      ErrorQueryUsecaseImpl.provider,
    );
  }

  static Future<void> _injectJapanese(DependencyBuilder builder) async {
    builder.inject(
      JapaneseParseUsecase.provider,
      JapaneseParseUsecaseImpl.provider,
    );
  }

  static Future<void> _injectKanjiPractice(DependencyBuilder builder) async {
    builder.inject(
      PassageParseUsecase.provider,
      PassageParseUsecaseImpl.provider,
    );
  }

  static Future<void> _injectSchool(DependencyBuilder builder) async {
    builder.inject(
      KanjiSearchUsecase.provider,
      KanjiSearchUsecaseImpl.provider,
    );
  }

  static Future<void> _injectSystem(DependencyBuilder builder) async {
    builder.inject(
      StartupUsecase.provider,
      StartupUsecaseImpl.provider,
    );
  }

  static Future<void> _injectTutorial(DependencyBuilder builder) async {
    builder.inject(
      FirstLoginTutorialUsecase.provider,
      FirstLoginTutorialUsecaseImpl.provider,
    );
  }
}
```

#### 実装例：Dataレイヤー

```dart
/// Dataレイヤーの依存注入.
final class DataInjection {
  const DataInjection._();

  static Future<void> inject(DependencyBuilder builder) async {
    builder.inject(
      EmbeddedLocalDataSource.provider,
      EmbeddedLocalDataSourceImpl.provider,
    );

    await _injectAccount(builder);
    await _injectPreferences(builder);
  }

  static Future<void> _injectAccount(DependencyBuilder builder) async {
    builder.inject(
      authenticationRepository.provider,
      () {
        if (isFlutterTesting) {
          return TestingAuthenticationRepository.provider;
        } else {
          return FirebaseAccountRepositoryImpl.provider;
        }
      }(),
    );
    builder.inject(
      AuthenticationRepository.provider,
      () {
        if (isFlutterTesting) {
          return TestingAuthenticationRepository.provider;
        } else {
          return FirebaseAccountRepositoryImpl.provider;
        }
      }(),
    );
  }

  static Future<void> _injectPreferences(DependencyBuilder builder) async {
    builder.inject(
      PreferencesRepository.provider,
      PreferencesRepositoryImpl.provider,
    );
  }
}
```

#### 実装例：Screenレイヤー

```dart
/// 各画面のDIを行う
final class ScreenInjection {
  const ScreenInjection._();

  static Future<void> inject(DependencyBuilder builder) async {
    await GoRouterNavigationInjection.inject(builder);
    await _injectHomeScreenRouter(builder);
    await _injectGanbariStampScreenRouter(builder);
    await _injectLoginScreenRouter(builder);
    await _injectSettingsScreenRouter(builder);
  }

  /// がんばりスタンプ画面のルーティング実装を注入する
  static Future<void> _injectGanbariStampScreenRouter(
    DependencyBuilder builder,
  ) async {
    builder.inject(
      GanbariStampScreenFactory.provider,
      GanbariStampScreenRouterImpl.provider,
    );
  }

  /// ホーム画面のルーティング実装を注入する
  static Future<void> _injectHomeScreenRouter(DependencyBuilder builder) async {
    builder.inject(
      HomeScreenFactory.provider,
      HomeScreenFactoryImpl.provider,
    );
    builder.inject(
      KanjiPracticeScreenFactory.provider,
      KanjiPracticeScreenFactoryImpl.provider,
    );
  }

  /// ログイン画面のルーティング実装を注入する
  static Future<void> _injectLoginScreenRouter(
    DependencyBuilder builder,
  ) async {
    builder.inject(
      LoginScreenFactory.provider,
      LoginScreenFactoryImpl.provider,
    );
  }

  /// 設定画面のルーティング実装を注入する
  static Future<void> _injectSettingsScreenRouter(
    DependencyBuilder builder,
  ) async {
    builder.inject(
      SettingsScreenFactory.provider,
      SettingsScreenFactoryImpl.provider,
    );
  }
}
```

### 注入クラスの実装パターン

注入クラスは、以下のパターンで実装する：

```dart
/// ${レイヤー名}の依存注入.
final class ${レイヤー名}Injection {
  const ${レイヤー名}Injection._();

  static Future<void> inject(DependencyBuilder builder) async {
    await _inject${機能名1}(builder);
    await _inject${機能名2}(builder);
    // ...
  }

  static Future<void> _inject${機能名1}(DependencyBuilder builder) async {
    builder.inject(
      ${インターフェース}.provider,
      ${実装}.provider,
    );
  }

  static Future<void> _inject${機能名2}(DependencyBuilder builder) async {
    builder.inject(
      ${インターフェース}.provider,
      ${実装}.provider,
    );
  }
}
```

### 注入クラスのポイント

1. **final class**: 注入クラスは `final class` で定義する
2. **プライベートコンストラクタ**: `const ${レイヤー名}Injection._();` を定義し、外部からの直接インスタンス化を防ぐ
3. **staticメソッド**: `inject()` メソッドは `static` で定義する
4. **機能ごとに分離**: 各機能の注入は、プライベートメソッドで分離する
5. **非同期処理**: 必要に応じて `async` を使用する

### 条件付き注入

テスト環境など、条件によって実装を切り替える場合は、以下のパターンを使用する：

```dart
static Future<void> _injectAccount(DependencyBuilder builder) async {
  builder.inject(
    authenticationRepository.provider,
    () {
      if (isFlutterTesting) {
        return TestingAuthenticationRepository.provider;
      } else {
        return FirebaseAccountRepositoryImpl.provider;
      }
    }(),
  );
}
```

## アプリケーションエントリポイントでのDI

アプリケーションのエントリポイント（`main.dart`）で、すべてのレイヤーの依存注入を行う。

### アプリケーションエントリポイントでのDI実装例

```dart
Future<void> main() async {
  final app = Application(
    /// ルートレベルのDIコンテナを作成する.
    newProviderContainer: () async {
      final builder = DependencyBuilder();
      await MobileInfraInjection.inject(builder);
      await DataInjection.inject(builder);
      await UsecaseInjection.inject(builder);
      await screen_injection_release.ScreenInjection.inject(builder);
      await screen_injection_debug.ScreenInjection.inject(builder);
      return builder.build();
    },
  );
  await app.main();
}
```

### 注入の順序

依存関係の順序に従って、以下の順序で注入する：

1. **Infraレイヤー**: インフラストラクチャの依存注入（`MobileInfraInjection`）
2. **Dataレイヤー**: データアクセス層の依存注入（`DataInjection`）
3. **Usecaseレイヤー**: ビジネスロジック層の依存注入（`UsecaseInjection`）
4. **Screenレイヤー**: 画面層の依存注入（`ScreenInjection`）

この順序により、上位レイヤーが下位レイヤーに依存する構造が明確になる。

### ビルド種別による注入

デバッグビルドなど、ビルド種別によって異なる実装を注入する場合は、条件分岐を使用する：

```dart
await screen_injection_release.ScreenInjection.inject(builder);
await screen_injection_debug.ScreenInjection.inject(builder);
```

デバッグビルド用の注入は、リリースビルド用の注入の後に実行することで、デバッグ用の実装で上書きできる。

## Unit TestのsetUp()パターン

Unit Testでは、`setUp()` 関数内でDI（依存性注入）を行い、テスト環境を準備する。

### 統合ヘルパーパターン

`testing_injection` パッケージが提供する `testContext.injectForTesting()` を使用することで、一行で全レイヤーのDIを完了できる。

```dart
// screen_feature_home2/test, home_screen_view_model_test.dart
import "package:flutter_test/flutter_test.dart";
import "package:riverpod_container_async_test/riverpod_container_async_test.dart";
import "package:testing_core/testing_core.dart";
import "package:testing_injection/testing_injection.dart";

void main() {
  late HomeScreenViewModel viewModel;

  setUp(() async {
    await testContext.injectForTesting();
  });

  Future<void> configure() async {
    viewModel = await ref.testReady(HomeScreenViewModel.provider);
  }

  test("初期化", () async {
    await configure();
    expect(viewModel, isNotNull);
  });
}
```

#### 統合ヘルパーパターンのポイント

1. **簡潔な記述**: 一行で全レイヤーのDIが完了する
2. **統一されたテスト環境**: すべてのテストで同じDI構成を使用できる
3. **暗黙的な依存関係**: すべての実装モジュールへの参照が発生する点に注意する

### 個別注入パターン

特定のレイヤーのみをテスト対象とする場合、個別にInjectionを呼び出すことで、依存関係を最小化できる。

```dart
// usecase_tutorial/_test/test, first_login_tutorial_usecase_test.dart
import "package:data_injection/data_injection.dart";
import "package:flutter_test/flutter_test.dart";
import "package:infra_injection_testing/infra_injection_testing.dart";
import "package:riverpod_container_async_test/riverpod_container_async_test.dart";
import "package:testing_core/testing_core.dart";
import "package:usecase_injection/usecase_injection.dart";

void main() {
  late FirstLoginTutorialUsecase usecase;

  setUp(() async {
    await TestingInfraInjection.inject(refBuilder);
    await DataInjection.inject(refBuilder);
    await UsecaseInjection.inject(refBuilder);

    usecase = await ref.testReady(FirstLoginTutorialUsecase.provider);
  });

  test("インスタンスが取得できている", () async {
    expect(usecase, isNotNull);
  });
}
```

#### 個別注入パターンのポイント

1. **依存関係の最小化**: テストに必要なレイヤーのみを注入する
2. **注入順序の遵守**: Infra → Data → Usecase の順序を守る
3. **明示的な依存関係**: 使用するInjectionが明確になる

### ネストされたsetUp()パターン

グループごとに異なる初期化処理が必要な場合、`setUp()` をネストして使用する。

```dart
// screen_feature_kanji_practice2/test, kanji_practice_view_model_test.dart
void main() {
  late KanjiPracticeScreenViewModel viewModel;

  // 最上位のsetUp: 全テスト共通のDI
  setUp(() async {
    await testContext.injectForTesting();
  });

  // Providerの初期化を行うヘルパー関数
  Future<void> configure() async {
    viewModel = await ref.testReady(KanjiPracticeScreenViewModel.provider);
  }

  test("初期化", () async {
    await configure();
    expect(viewModel, isNotNull);
  });

  group("テキスト入力", () {
    // グループ用のsetUp: このグループ固有の初期化
    setUp(() async {
      await configure();
    });

    test("テキスト入力", () async {
      await viewModel.onInputText("寿限無");
      expect(viewModel.state.state.text, equals("寿限無"));
    });
  });
}
```

#### ネストされたsetUp()パターンのポイント

1. **最上位のsetUp()**: 全テスト共通のDI処理を行う
2. **configure()ヘルパー関数**: Providerの初期化など、テストごとに必要な処理を定義する
3. **グループ用のsetUp()**: グループ固有の初期化処理を行う
4. **実行順序**: 最上位のsetUp() → グループ用のsetUp() → テスト本体の順に実行される

## ナレッジベース

### DO: レイヤーごとに Injection クラスを定義する

* 命名規則は `${レイヤー名}Injection` とする
* 1 レイヤーに 1 つの注入クラスを原則とする

```dart
final class UsecaseInjection {
  const UsecaseInjection._();

  static Future<void> inject(DependencyBuilder builder) async {
    await _injectSystem(builder);
    await _injectSchool(builder);
  }
}
```

### DO: 機能ごとの注入を `_inject${機能名}` で分離する

* `inject()` から機能単位のプライベートメソッドを呼び出す
* 注入対象の追加・変更が局所化される

```dart
static Future<void> inject(DependencyBuilder builder) async {
  await _injectKanjiPractice(builder);
  await _injectSchool(builder);
}

static Future<void> _injectSchool(DependencyBuilder builder) async {
  builder.inject(
    KanjiSearchUsecase.provider,
    KanjiSearchUsecaseImpl.provider,
  );
}
```

### DO: DependencyBuilder でインターフェースと実装を結びつける

* 注入クラス以外から実装の Provider を直接参照しない
* `builder.inject(インターフェース.provider, 実装.provider)` で一元管理する

```dart
builder.inject(
  KanjiSearchUsecase.provider,
  KanjiSearchUsecaseImpl.provider,
);
```

### DO: 注入順序を Foundation → Infra → Data → Usecase → Screen に保つ

* 下位レイヤーを先に注入し、上位が下位に依存できるようにする
* テスト時は本番 Injection の後にテスト用 Injection で上書きする

```dart
await TestingInfraInjection.inject(refBuilder);
await DataInjection.inject(refBuilder);
await UsecaseInjection.inject(refBuilder);
await TestingUsecaseInjection.inject(refBuilder);
```

### DO: 条件付き注入で環境に応じた実装を切り替える

* テスト環境など、条件によって実装を切り替える場合に使用する
* 条件分岐は必要最小限に留める

```dart
builder.inject(
  authenticationRepository.provider,
  () {
    if (isFlutterTesting) {
      return TestingAuthenticationRepository.provider;
    } else {
      return FirebaseAccountRepositoryImpl.provider;
    }
  }(),
);
```

### DO: async は非同期処理が必要、もしくは予想される場合のみ使う

* 注入処理自体が非同期の依存を含む場合に `async` を付与する
* 同期で完結する注入には `async` を付けない

```dart
static Future<void> inject(DependencyBuilder builder) async {
  builder.inject(
    PreferencesRepository.provider,
    PreferencesRepositoryImpl.provider,
  );
  await _injectAccount(builder);
}
```

### DO: Unit Test では setUp() DI する

* `testContext.injectForTesting()` または個別 Injection を `setUp()` で実行する
* テスト本体では初期化済みの Provider を利用する
* 各テストで同じ DI 処理を繰り返さない

```dart
setUp(() async {
  await testContext.injectForTesting();
});
```

### DO: シナリオ制御が必要な Repository は inject 後に Mock で override する

* `injectForTesting()` の直後に `refBuilder.override(..., overrideWithValue(mock))` する
* Testing\* 専用 API（`emitProfile` 等）に依存しない
* `registerFallbackValue` を `setUpAll` で登録する

```dart
await testContext.injectForTesting();
final mockRepo = _MockAccountRepository();
when(() => mockRepo.watchProfile()).thenAnswer((_) => profileStream.stream);
refBuilder.override(
  AccountRepository.provider,
  AccountRepository.provider.overrideWithValue(mockRepo),
);
```

### DO NOT: レイヤー間の循環参照を作る

* 理由: 依存関係の方向が不明確になり、注入順序を決定できなくなる
* 理由: ビルドやテスト時に解決不能な依存が発生する

### DO NOT: 同一レイヤーに複数の Injection クラスを作る

* 理由: 注入責務が分散し、呼び出し側が注入漏れを起こしやすくなる
* 理由: 注入順序の管理が複雑になる

### DO NOT: 注入クラス以外から実装の Provider を直接参照する

* 理由: インターフェース契約が壊れ、差し替えが困難になる
* 理由: テスト時の Fake 注入が分散する

```dart
// DO NOT: 実装 Provider を画面や Usecase から直接 watch する
ref.watch(KanjiSearchUsecaseImpl.provider);
```

```dart
// DO: インターフェース Provider を参照する
ref.watch(KanjiSearchUsecase.provider);
```

### DO NOT: Unit Test で Injection の順序を無視する

* 理由: 下位依存が未解決のまま上位を注入するとエラーになる
* 理由: テスト用上書きが効かず本番実装のままになる場合がある

```dart
// DO NOT: Usecase を先に注入してから Infra を注入する
await UsecaseInjection.inject(refBuilder);
await TestingInfraInjection.inject(refBuilder);
```

```dart
// DO: Infra → Data → Usecase の順で注入する
await TestingInfraInjection.inject(refBuilder);
await DataInjection.inject(refBuilder);
await UsecaseInjection.inject(refBuilder);
```

### DO NOT: 注入クラス内で過度な条件分岐を行う

* 理由: 注入ロジックが複雑化し、テスト時の差し替えが困難になる
* 理由: 環境ごとの実装切り替えが追いにくくなる
