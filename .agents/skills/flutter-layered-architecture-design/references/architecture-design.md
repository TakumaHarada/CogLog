# Flutter-Layered-Architecture / アーキテクチャ概要

## 概要

`Flutter-Layered-Architecture` では、複数階層からなるアーキテクチャレイヤーを採用している。レイヤーごとに責任範囲を明確に分離し、上位レイヤーが下位レイヤーに依存する構造を取る。これにより、テスタビリティと保守性が向上する。

## レイヤー一覧

| レイヤー名 | package名プレフィックス | レイヤーレベル | 役割 |
| -- | -- | -- | -- |
| app | app | 7 | アプリケーション |
| screen | screen_* | 6 | 各画面 |
| view | view_* | 5 | Widget等、UI要素 |
| usecase | usecase_*, data_* | 4 | ビジネスロジックを提供する |
| data | data_* | 4 | データRead/Writeロジックを提供する |
| infra | infra_* | 3 | OS差異・Unit Testと実機差異の吸収等、アプリ実行インフラを提供する |
| domain | domain_* | 2 | アプリドメインを提供する |
| foundation | foundation_* | 1 | DI等、アプリ実行基盤 |
| testing | testing_* | - | テストサポート、アーキテクチャレベル範囲外 |

### レイヤー一覧の補足

レイヤーレベルが低いレイヤーほど、アプリの`基盤`として重要なレイヤーである。上位レイヤーは下位レイヤーに依存するが、下位レイヤーは上位レイヤーに依存しない。

## 各レイヤーの詳細

### app レイヤー（レベル7）

アプリケーションのエントリポイントを提供するレイヤーである。

#### 役割

* アプリケーションの起動処理を担当する
* すべてのレイヤーの依存注入を統合する
* `main()`関数を含む

### screen レイヤー（レベル6）

各画面の実装を提供するレイヤーである。

#### screenレイヤーの役割

* 画面のUIとViewModelを実装する
* 画面遷移のインターフェースを定義する
* 画面固有の状態管理を担当する

#### screenレイヤーの補足

screenレイヤーは、`screen_navigation`（画面遷移のインターフェース）と`screen_feature_${画面名}2`（各画面の実装）に分離されている。詳細は`navigation.md`と`model_view_viewmodel.md`を参照。

#### screenレイヤーの依存関係

* usecaseレイヤーに依存する（ViewModelがUsecaseを呼び出す）
* viewレイヤーに依存する（UIコンポーネントを使用する）
* domainレイヤーに依存する（ドメインモデルを使用する）

### view レイヤー（レベル5）

Widget等、UI要素を提供するレイヤーである。

#### viewレイヤーの役割

* 再利用可能なUIコンポーネントを提供する
* デザインシステムを実装する
* アプリ固有のWidgetを提供する

#### viewレイヤーの補足

viewレイヤーは、アプリ全体で使用されるUIコンポーネントを提供する。screenレイヤーが使用する。

#### viewレイヤーの依存関係

* domainレイヤーに依存する場合がある（ドメインモデルを使用する場合）

### usecase レイヤー（レベル4）

ビジネスロジックを提供するレイヤーである。

#### usecaseレイヤーの役割

* アプリケーション固有のビジネスロジックを実装する
* ViewModelや他のビジネスロジックから呼び出される
* データアクセスを抽象化する

#### usecaseレイヤーの補足

usecaseレイヤーは、インターフェースと実装を分離する。詳細は`usecase.md`を参照。

#### usecaseレイヤーの依存関係

* dataレイヤーに依存する（RepositoryやDatasourceを使用する）
* domainレイヤーに依存する（ドメインモデルを使用する）
* 他のusecaseレイヤーに依存できる（循環参照を避ける）

#### usecaseレイヤーの実装例

```dart
/// 漢字を検索するUsecase.
abstract class KanjiSearchUsecase {
  static final provider = Provider<KanjiSearchUsecase>(
    (ref) => throw UnimplementedError(),
  );

  /// 漢字を検索する.
  Future<KanjiSearchResult> search(KanjiSearchRequest request);

  const KanjiSearchUsecase._();
}
```

### data レイヤー（レベル4）

データRead/Writeロジックを提供するレイヤーである。

#### dataレイヤーの役割

* データの読み取りと書き込みを担当する
* RepositoryやDatasourceインターフェースを提供する
* データベースや外部APIとの連携を抽象化する

#### dataレイヤーの補足

dataレイヤーは、`data_source_*`（Read Only）と`data_repository_*`（Read/Write）に分離されている。詳細は`usecase.md`の「Datasource/Repository との関係」を参照。

#### dataレイヤーの依存関係

* infraレイヤーに依存する（データベースやストレージの実装を使用する）
* domainレイヤーに依存する（ドメインモデルを使用する）

#### dataレイヤーの実装例

```dart
/// 組み込みデータを取得するためのデータソース.
abstract class EmbeddedLocalDataSource {
  static final provider = Provider<EmbeddedLocalDataSource>(
    (ref) =>
        throw UnimplementedError("$EmbeddedLocalDataSource is not implemented"),
  );

  const EmbeddedLocalDataSource._();

  /// 組み込み漢字データを取得する.
  Future<List<EmbeddedKanjiEntry>> getAllKanjiEntries();
}
```

### infra レイヤー（レベル3）

OS差異・Unit Testと実機差異の吸収等、アプリ実行インフラを提供するレイヤーである。

#### infraレイヤーの役割

* OS差異を吸収する
* 外部サービス（Firebase、ストレージ等）との連携を提供する
* テスト環境と実機環境の差異を吸収する

#### infraレイヤーの補足

infraレイヤーは、環境ごとに実装が分離される場合がある（例：`infra_storage_mobile`、`infra_storage_testing`）。

#### infraレイヤーの依存関係

* foundationレイヤーに依存する場合がある

### domain レイヤー（レベル2）

アプリドメインを提供するレイヤーである。

#### domainレイヤーの役割

* ビジネスロジックの中核となるドメインモデルを定義する
* 他のレイヤーに依存しない純粋なドメインロジックを提供する
* アプリ固有の概念を表現する

#### domainレイヤーの補足

domainレイヤーは、他のレイヤーから依存されるが、他のレイヤーに依存しない。これにより、ビジネスロジックの独立性が保たれる。

#### domainレイヤーの依存関係

* 他のレイヤーに依存しない（例外：Flutterの標準ライブラリのみ）

#### domainレイヤーの実装例

```dart
/// 学校の学年を示す定数.
class SchoolGrade {
  /// 種別
  final EducationLevel type;

  /// 学年
  final int value;

  const SchoolGrade(this.type, this.value);

  const SchoolGrade.elementary(this.value) : type = EducationLevel.elementary;

  const SchoolGrade.juniorHigh(this.value) : type = EducationLevel.juniorHigh;

  @override
  String toString() => "SchoolGrade(type: $type, value: $value)";
}
```

### foundation レイヤー（レベル1）

DI等、アプリ実行基盤を提供するレイヤーである。

#### foundationレイヤーの役割

* 依存注入の基盤を提供する
* アプリ全体で使用される基盤機能を提供する
* メタデータやリソース管理を提供する

#### foundationレイヤーの補足

foundationレイヤーは、アプリ全体の基盤となる機能を提供する。実装済みで量産が不要なインターフェースを含む場合がある。

#### foundationレイヤーの依存関係

* 他のレイヤーに依存しない（基盤として最下位レイヤー）

### testing レイヤー

テストサポートを提供するレイヤーである。

#### testingレイヤーの役割

* テスト用のユーティリティを提供する
* テスト環境向けの依存注入を提供する
* Fake実装を提供する（Mockやファイクの実装）
* テスト用のヘルパー関数を提供する

#### testingレイヤーの補足

testingレイヤーは、アーキテクチャレベル範囲外である。テスト時に使用される。このレイヤーは、本番コードには影響を与えず、テスト時のみ使用される。

#### パッケージ命名規則

testingレイヤーのパッケージは、以下の命名規則に従う：

* **`_testing`サブディレクトリ**: インターフェースパッケージの`_testing`サブディレクトリに配置
* **パッケージ名**: `${パッケージ名}_testing`（例：`infra_injection_testing`、`usecase_injection_testing`）
* **`testing_*`パッケージ**: 横断的なテストサポート（例：`testing_core`、`testing_injection`）

#### ディレクトリ構成

testingレイヤーのディレクトリ構成は以下の通り：

```text
app_packages/
├── usecase/
│   └── injection/
│       └── _testing/              # usecase_injection_testing
│           ├── pubspec.yaml
│           └── lib/
│               └── src/
│                   └── testing_usecase_injection.dart
├── infra/
│   └── injection/
│       └── _testing/              # infra_injection_testing
│           ├── pubspec.yaml
│           └── lib/
│               └── src/
│                   └── testing_infra_injection.dart
└── testing/
    ├── core/                      # testing_core
    │   └── lib/
    │       └── src/
    │           └── test_utilities.dart
    └── injection/                 # testing_injection
        └── lib/
            └── src/
                └── testing_injection_functions.dart
```

#### テスト用Injectionパッケージ

各レイヤーには、テスト用のInjectionパッケージが存在する場合がある：

* **`infra_injection_testing`**: Infraレイヤーのテスト用Injection（BundleLoader、Storage等のFake実装）
* **`usecase_injection_testing`**: Usecaseレイヤーのテスト用Injection（外部サービス依存UsecaseのFake実装）

これらのパッケージは、`Testing${レイヤー名}Injection`クラスを提供し、テスト環境向けのFake実装を注入する。

#### 実装例：テスト用Injectionクラス

```dart
// usecase_injection/_testing, testing_usecase_injection.dart
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

#### 横断的なtestingパッケージ

プロジェクト全体で使用されるテストサポートは、`testing_*`パッケージとして提供される：

* **`testing_core`**: テスト用の基本的なユーティリティ（TestContext等）
* **`testing_injection`**: テスト用の統合Injection（`testContext.injectForTesting()`）

#### 実装例：統合テストヘルパー

```dart
// testing_injection, testing_injection_functions.dart
extension TestContextInjectionExtensions on TestContext {
  /// Unit Test用の依存注入を行う.
  Future<void> injectForTesting() async {
    await TestingInfraInjection.inject(refBuilder);
    await DataInjection.inject(refBuilder);
    await UsecaseInjection.inject(refBuilder);
    await TestingUsecaseInjection.inject(refBuilder);
  }
}
```

#### Fake実装の配置

Fake実装は、本番実装と同じパッケージ（`${パッケージ名}_impl`）に配置される：

* **Usecaseの場合**: `usecase_${機能名}_impl/lib/src/${機能名}_usecase/${機能名}_usecase_fake.dart`
* **Repositoryの場合**: `data_repository_${機能名}_impl/lib/src/${機能名}_repository/${機能名}_repository_fake.dart`

これにより、インターフェース、本番実装、Fake実装の依存関係が明確になる。

#### testingレイヤーの依存関係

testingレイヤーは、以下のレイヤーに依存する：

* infraレイヤー（Fake実装を提供するため）
* usecaseレイヤー（Fake実装を提供するため）
* dataレイヤー（Fake実装を提供するため）
* foundationレイヤー（DependencyBuilder等の基盤を使用するため）

testingレイヤーは、他のレイヤーから依存されることはない（テスト時のみ使用される）。

#### 実装例：testingレイヤーの使用

```dart
// usecase_system_test, startup_usecase_test.dart
import "package:flutter_test/flutter_test.dart";
import "package:testing_injection/testing_injection.dart";
import "package:usecase_system/usecase_system.dart";

void main() {
  late StartupUsecase startupUsecase;

  setUp(() async {
    await testContext.injectForTesting();  // testingレイヤーの統合ヘルパーを使用

    startupUsecase = await ref.testReady(StartupUsecase.provider);
  });

  group("StartupUsecase", () {
    test("実行し、エラーが発生しない", () async {
      final result = await startupUsecase.startUp();
      expect(result.isMigratedSettings, isTrue);
    });
  });
}
```

詳細は `dependency-injection.md` の「テスト用と本番用のInjectionの分離」および `usecase.md` の「Fake Usecaseの実装」を参照。

## 下位レイヤーにのみ依存する原則

* 上層レイヤーもしくは同一レイヤーは、下層レイヤーのインターフェースを使用してよい
* 下層レイヤーは、上層レイヤーに依存してはならない
* 同一レイヤー内での依存は許容するが、循環参照を避ける

### 依存原則の補足

この原則により、レイヤー間の依存関係が明確になり、テスタビリティと保守性が向上する。下位レイヤーの変更が上位レイヤーに影響を与えることを防ぐ。

### 依存原則の実装例

#### 良い例：上位レイヤーが下位レイヤーに依存する

usecaseレイヤーがdataレイヤーに依存する：

```dart
import "package:collection/collection.dart";
import "package:data_source_embedded/embedded.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:usecase_school/school.dart";
```

usecaseレイヤーがdomainレイヤーに依存する：

```dart
import "package:domain_japanese/japanese.dart";
import "package:domain_school/school.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "kanji_search_result.freezed.dart";
```

screenレイヤーがusecaseレイヤーに依存する：

```dart
import "package:data_source_authentication/data_source_authentication.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:meta/meta.dart";
import "package:riverpod_container_async/riverpod_container_async.dart";
import "package:screen_feature_home2/src/viewmodel/entity/home_screen_entity.dart";
import "package:screen_feature_home2/src/viewmodel/state/home_screen_event.dart";
import "package:screen_feature_home2/src/viewmodel/state/home_screen_state.dart";
import "package:screen_feature_home2/src/viewmodel/usecase/data_sync_usecase.dart";
```

## ディレクトリ配置

* `app_packages/{レイヤー名}/` の配下に、基本的なpackageが存在する

### ディレクトリ配置の補足

各レイヤーのpackageは、`app_packages/{レイヤー名}/`配下に配置される。レイヤーごとに異なる構成パターンを持つ場合がある。

### ディレクトリ配置の実装例

実際のディレクトリ構成：

```text
app_packages/
├── app/                      # appレイヤー
│   └── lib/
│       └── main.dart
├── screen/                   # screenレイヤー
│   ├── feature/
│   ├── navigation/
│   └── injection/
├── view/                     # viewレイヤー
│   └── designkit/
├── usecase/                 # usecaseレイヤー
│   ├── school/
│   │   └── _impl/          # usecase_school_impl（実装）
│   └── injection/
├── data/                    # dataレイヤー
│   ├── repository/
│   ├── source/
│   └── injection/
├── infra/                   # infraレイヤー
│   ├── asset/
│   ├── firebase/
│   └── injection_*/
├── domain/                  # domainレイヤー
│   ├── account/
│   ├── japanese/
│   └── school/
└── foundation/              # foundationレイヤー
    ├── dependency_injection/
    └── metadata/
```

## ライブラリファイル名の命名規則

workspace内部のパッケージには、**パッケージ名と同一のライブラリファイル名を配置する**ことを原則とする。

### ライブラリファイル名の命名規則の補足

この規則により、パッケージ名とインポートライブラリの関係が明確になり、可読性と保守性が向上する。

### 命名パターン

* パッケージ名: `${パッケージ名}`
* ライブラリファイル: `lib/${パッケージ名}.dart`
* インポート: `import "package:${パッケージ名}/${パッケージ名}.dart";`

### 命名規則の実装例

#### Usecaseレイヤー

```text
app_packages/usecase/error/
├── pubspec.yaml                      # name: usecase_error
└── lib/
    ├── usecase_error.dart            # パッケージ名と同一
    └── src/
        └── crash_report/
            └── crash_report_usecase.dart
```

インポート例：

```dart
import "package:usecase_error/usecase_error.dart";
```

#### Dataレイヤー

```text
app_packages/data/repository/preferences/
├── pubspec.yaml                      # name: data_repository_preferences
└── lib/
    ├── data_repository_preferences.dart  # パッケージ名と同一
    └── src/
        └── preferences_repository.dart
```

インポート例：

```dart
import "package:data_repository_preferences/data_repository_preferences.dart";
```

#### Infraレイヤー

```text
app_packages/infra/firebase/
├── pubspec.yaml                      # name: infra_firebase
└── lib/
    ├── infra_firebase.dart           # パッケージ名と同一
    └── src/
        └── firebase_providers.dart
```

インポート例：

```dart
import "package:infra_firebase/infra_firebase.dart";
```

#### Domainレイヤー

```text
app_packages/domain/school/
├── pubspec.yaml                      # name: domain_school
└── lib/
    ├── domain_school.dart            # パッケージ名と同一
    └── src/
        └── grade/
            └── school_grade.dart
```

インポート例：

```dart
import "package:domain_school/domain_school.dart";
```

### 実装パッケージ（`_impl`）の場合

実装パッケージも同様の規則に従う：

```text
app_packages/usecase/error/_impl/
├── pubspec.yaml                      # name: usecase_error_impl
└── lib/
    ├── usecase_error_impl.dart       # パッケージ名と同一
    └── src/
        └── crash_report_usecase/
            └── crash_report_usecase_impl.dart
```

インポート例：

```dart
import "package:usecase_error_impl/usecase_error_impl.dart";
```

### テストパッケージ（`_testing`）の場合

テストパッケージも同様の規則に従う：

```text
app_packages/usecase/injection/_testing/
├── pubspec.yaml                      # name: usecase_injection_testing
└── lib/
    ├── usecase_injection_testing.dart  # パッケージ名と同一
    └── src/
        └── testing_usecase_injection.dart
```

インポート例：

```dart
import "package:usecase_injection_testing/usecase_injection_testing.dart";
```

## 依存注入の順序

レイヤーの依存関係に従って、以下の順序で依存注入を行う：

1. **foundationレイヤー**: 基盤の依存注入
2. **infraレイヤー**: インフラの依存注入
3. **dataレイヤー**: データアクセスの依存注入
4. **usecaseレイヤー**: ビジネスロジックの依存注入
5. **screenレイヤー**: 画面の依存注入

### 依存注入順序の補足

この順序により、下位レイヤーが先に注入され、上位レイヤーが下位レイヤーに依存できるようになる。

### 依存注入順序の実装例

```dart
newProviderContainer: () async {
  final builder = DependencyBuilder();
  await MobileInfraInjection.inject(builder);
  await DataInjection.inject(builder);
  await UsecaseInjection.inject(builder);
  await screen_injection_release.ScreenInjection.inject(builder);
  await screen_injection_debug.ScreenInjection.inject(builder);
  return builder.build();
},
```

## ナレッジベース

### DO: レイヤーごとに package を分離する

* 各レイヤーごとに package を分離する
* package 名は `${レイヤー名}_${機能名}` の形式とする

```text
app_packages/usecase/school/     # usecase_school
app_packages/data/repository/preferences/  # data_repository_preferences
```

### DO: 上位レイヤーは下位レイヤーのインターフェースに依存する

* 下位レイヤーの変更が上位へ波及しにくくなり、テスタビリティが向上する
* 下位レイヤーの実装に直接依存しない

```dart
// usecase が data のインターフェースに依存する例
import "package:data_source_embedded/embedded.dart";
```

### DO: インターフェースと実装を package 分離し `_impl` に実装を置く

* 各レイヤーでインターフェースと実装を分離する
* 実装は `_impl` サブディレクトリ（入れ子パッケージ）に配置する

```text
app_packages/usecase/school/
├── lib/                 # インターフェース
└── _impl/               # 実装
```

### DO: 依存注入は下位レイヤーから順に行う

* foundation → infra → data → usecase → screen の順で注入する

```dart
await MobileInfraInjection.inject(builder);
await DataInjection.inject(builder);
await UsecaseInjection.inject(builder);
```

### DO: 外部入力のパース失敗は Data 層で吸収する

* Firestore / リモート JSON などの信頼できない入力のデシリアライズ失敗は、Repository / Delegate 境界で empty や Result に落とす
* 詳細は `flutter-layered-architecture-design-patterns` の repository-pattern と `flutter-coding-rules` の try-catch / data_object を参照する

### DO NOT: 下位レイヤーが上位レイヤーに依存する

* 理由: 依存の向きが逆転し、基盤の独立性が崩れる
* 理由: 循環参照やテスト困難の原因になる

```dart
// DO NOT: domain が usecase を import する
import "package:usecase_school/usecase_school.dart";
```

```dart
// DO: domain は他レイヤーに依存しない
// domain_school 内では Flutter 標準ライブラリのみを利用する
```

### DO NOT: レイヤー間または同一レイヤー内で循環参照する

* 理由: 依存の向きが不明確になり保守性が低下する
* 理由: 共通機能の切り出し機会を失う

```dart
// DO NOT: usecase A → usecase B かつ usecase B → usecase A
```

```dart
// DO: 共通処理を別 Usecase または下位レイヤーに分離し一方向依存にする
```

### DO NOT: 上位レイヤーが下位レイヤーの実装 package に直接依存する

* 理由: 実装差し替えやテスト時の Fake 注入が困難になる
* 理由: インターフェース契約が曖昧になる

```dart
// DO NOT: 実装 package を直接参照する
import "package:usecase_school_impl/usecase_school_impl.dart";
```

```dart
// DO: インターフェース package を参照し、実装は Injection で結びつける
import "package:usecase_school/usecase_school.dart";
```
