# ビジネスロジック(Usecase)

## 概要

Usecaseは、アプリケーションのビジネスロジックを実装するためのコンポーネントである。ViewModelや他のビジネスロジックから呼び出され、アプリケーション固有の処理を実行する。

* ビジネスロジックのインターフェースは `Usecase` というサフィックスを持つのが基本である
  * `{動詞}{カテゴリ}Usecase` という名称に統一する（動詞が先、カテゴリを示す名詞が次）
  * 一部のビジネスロジックは、特殊化されたサフィックスを持つ場合がある
* **インターフェースと実装の分離**: すべてのUsecaseはインターフェースと実装を別パッケージに分離する
* **ステートレス**: Usecase自体は状態を持たない
* **依存注入**: RiverpodのProviderを使用して依存関係を管理する
* **単一責任**: 1つのUsecaseインターフェースは1つの機能のみを提供する

## 原則

### 1インターフェース１機能

* 1つのUsecaseインターフェースは、1つの機能のみを提供する
* インターフェースは、原則として `execute()` という名称のメソッドを1つだけ持つ
  * **重要**: `execute()` 以外のメソッド名（例: `search()`, `parseCharacter()`）は、亜種であり、設計時に特殊な判断がされたことを意味する。新規に作成する場合は、原則として `execute()` を使用する。
* Java/Kotlin等の言語機能におけるOverloadについては許容する
  * Dart言語ではオーバーロードをサポートしないため、引数をsealed classにすることで対応する

#### 1インターフェース１機能の補足

この原則により、Usecaseの責任範囲が明確になり、テストや保守が容易になる。複数の機能が必要な場合は、複数のUsecaseインターフェースを作成する。

#### 1インターフェース１機能の実装例

良い例：1つの機能のみを提供するUsecase

```dart
/// 漢字を検索するUsecase.
abstract class KanjiSearchUsecase {
  static final provider = Provider<KanjiSearchUsecase>(
    (ref) => throw UnimplementedError(),
  );

  /// 漢字を検索する.
  Future<KanjiSearchResult> execute(KanjiSearchRequest request);

  const KanjiSearchUsecase._();
}
```

`KanjiSearchUsecase` は「漢字を検索する」という1つの機能のみを提供し、メソッド名も `execute` に統一されている。
なお Class 名の `KanjiSearch`（カテゴリ名詞先行）は古い命名である。新規は `{動詞}{カテゴリ}Usecase`（例: `SearchKanjiUsecase`）とする。詳細は「ナレッジベース」を参照する。

#### 引数のsealed class化によるオーバーロード対応

複数の引数パターンを表現する場合は、Requestクラスをsealed classとして定義する：

```dart
@freezed
sealed class ${機能名}Request with _$${機能名}Request {
  const factory ${機能名}Request.byId({
    required String id,
  }) = ${機能名}RequestById;

  const factory ${機能名}Request.byName({
    required String name,
  }) = ${機能名}RequestByName;

  const ${機能名}Request._();
}
```

これにより、Dart言語でオーバーロードをサポートしない制約を回避できる。

### ステートレス原則

* ビジネスロジックは、それ自体が状態を持つことはない
* 状態管理が必要な場合は、RepositoryやDatasourceを使用する

#### ステートレス原則の補足

Usecaseは、実行時に状態を変更したり、内部状態を保持したりしない。すべての処理は、引数と依存関係のみに基づいて実行される。これにより、Usecaseのテストが容易になり、副作用の発生を防ぐことができる。

#### ステートレス原則の実装例

良い例：状態を持たないUsecase

```dart
class ErrorQueryUsecaseImpl implements ErrorQueryUsecase {
  static final provider = Provider<ErrorQueryUsecase>(
    (ref) {
      ref.keepAlive();
      return ErrorQueryUsecaseImpl._();
    },
    dependencies: const [],
  );

  ErrorQueryUsecaseImpl._();
}
```

`ErrorQueryUsecaseImpl` は、フィールドを持たず、メソッドの引数に基づいて処理を実行する。

#### 状態管理が必要な場合

状態管理が必要な場合は、RepositoryやDatasourceを使用する：

```dart
class FirstLoginTutorialUsecaseImpl implements FirstLoginTutorialUsecase {
  final PreferencesRepository preferencesRepository;

  @override
  Future<bool> isTutorialCompleted() async {
    // Repositoryから状態を取得する
    return preferencesRepository.preferencesStream
        .map((e) => e.get(_preferenceKey, defaultValue: _defaultValue))
        .map((e) => e.asBoolean)
        .first;
  }
}
```

Usecase自体は状態を持たず、Repositoryから状態を取得する。

### 実装の、内部的な依存

* ビジネスロジックは、それ以外のビジネスロジックに依存することを許容する
* ただし、循環参照を許容しない
* Usecaseは、Repository、Datasource、他のUsecaseに依存できる

#### 実装の内部的な依存の補足

Usecaseは、他のUsecaseやRepository、Datasourceに依存して、より複雑なビジネスロジックを実装できる。ただし、循環参照を避けるために、依存関係の方向を明確にする必要がある。

#### 実装の内部的な依存の実装例

他のUsecaseに依存する例：

```dart
class PassageParseUsecaseImpl implements PassageParseUsecase {
  static final provider = Provider<PassageParseUsecase>(
    (ref) {
      ref.keepAlive();
      return PassageParseUsecaseImpl._(
        kanjiParseUsecase: ref.watch(JapaneseParseUsecase.provider),
        kanjiSearchUsecase: ref.watch(KanjiSearchUsecase.provider),
      );
    },
    dependencies: [
      JapaneseParseUsecase.provider,
      KanjiSearchUsecase.provider,
    ],
  );
}
```

`PassageParseUsecaseImpl` は、`JapaneseParseUsecase` と `KanjiSearchUsecase` に依存している。

Repositoryに依存する例：

```dart
class KanjiSearchUsecaseImpl implements KanjiSearchUsecase {
  static final provider = Provider<KanjiSearchUsecase>(
    (ref) {
      ref.keepAlive();
      final embeddedLocalDataSource = ref.watch(
        EmbeddedLocalDataSource.provider,
      );
      return KanjiSearchUsecaseImpl._(
        embeddedLocalDataSource: embeddedLocalDataSource,
      );
    },
    dependencies: [
      EmbeddedLocalDataSource.provider,
    ],
  );
}
```

`KanjiSearchUsecaseImpl` は、`EmbeddedLocalDataSource`（Datasource）に依存している。

#### 循環参照の回避

以下のような循環参照は避ける必要がある：

* `UsecaseA` が `UsecaseB` に依存し、`UsecaseB` が `UsecaseA` に依存する

このような場合は、共通の機能を別のUsecaseやRepositoryに分離する必要がある。

### インターフェースと実装の分離

* すべてのビジネスロジックは、インターフェースと実装を分離する
* すべてのビジネスロジックは、インターフェースと実装が異なるpackageに分離される
* インターフェースには `${機能名}Usecase.provider` というstatic final Provider(riverpod)を持つ.
* インターフェースと実装は、RiverpodのProvider ContainerのOverride機能を通じて、依存注入される

#### インターフェースと実装の分離の補足

インターフェースと実装を分離することで、以下の利点がある：

* テスト時のモック実装が容易になる
* 実装の変更がインターフェースに影響を与えない
* 依存関係の方向が明確になる

#### パッケージ構成

Usecaseは、以下のパッケージ構成で実装される：

```text
app_packages/usecase/
├── ${機能名}/              # インターフェースパッケージ
│   └── lib/src/
│       └── ${機能名}_usecase.dart
├── ${機能名}_impl/         # 実装パッケージ
│   └── lib/src/
│       └── ${機能名}_usecase/${機能名}_usecase_impl.dart
└── injection/              # 依存注入パッケージ
    └── lib/src/
        └── usecase_injection.dart
```

パッケージ命名規則：

* インターフェースパッケージ: `usecase_${機能名}`
* 実装パッケージ: `usecase_${機能名}_impl`
* テストパッケージ（オプション）: `usecase_${機能名}_test`

ライブラリファイル名の命名規則：

* インターフェースパッケージのライブラリファイル: `lib/usecase_${機能名}.dart`
* 実装パッケージのライブラリファイル: `lib/usecase_${機能名}_impl.dart`
* インポート: `import "package:usecase_${機能名}/usecase_${機能名}.dart";`

実装例：

```text
app_packages/usecase/
├── school/                 # usecase_school
│   └── lib/
│       ├── usecase_school.dart  # パッケージ名と同一
│       └── src/kanji_search/
│           ├── kanji_search_usecase.dart
│           ├── kanji_search_request.dart
│           └── kanji_search_result.dart
├── school_impl/            # usecase_school_impl
│   └── lib/
│       ├── usecase_school_impl.dart  # パッケージ名と同一
│       └── src/kanji_search_usecase/
│           └── kanji_search_usecase_impl.dart
└── injection/
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

#### インターフェースの定義

インターフェースは、以下のパターンで定義する：

```dart
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:usecase_${機能名}/src/${機能名}/${機能名}_request.dart";
import "package:usecase_${機能名}/src/${機能名}/${機能名}_result.dart";

/// ${機能の説明}.
abstract class ${機能名}Usecase {
  static final provider = Provider<${機能名}Usecase>(
    (ref) => throw UnimplementedError("$${機能名}Usecase is not implemented"),
  );

  /// ${メソッドの説明}.
  Future<${機能名}Result> execute(${機能名}Request request);

  const ${機能名}Usecase._();
}
```

インターフェース定義のポイント：

1. **abstract class**: インターフェースは `abstract class` で定義する
2. **プライベートコンストラクタ**: `const ${機能名}Usecase._();` を定義し、外部からの直接インスタンス化を防ぐ
3. **Provider定義**: `static final provider` でRiverpodのProviderを定義する
4. **UnimplementedError**: インターフェース側のProviderは `UnimplementedError` を投げる
5. **ドキュメントコメント**: すべての公開メソッドにはドキュメントコメントを記述する

実装例：

```dart
/// 漢字を検索するUsecase.
abstract class KanjiSearchUsecase {
  static final provider = Provider<KanjiSearchUsecase>(
    (ref) => throw UnimplementedError(),
  );

  /// 漢字を検索する.
  Future<KanjiSearchResult> execute(KanjiSearchRequest request);

  const KanjiSearchUsecase._();
}
```

#### 実装クラスの定義

実装クラスは、以下のパターンで定義する：

```dart
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:usecase_${機能名}/${機能名}.dart";

/// [${機能名}Usecase]の実装.
class ${機能名}UsecaseImpl implements ${機能名}Usecase {
  static final provider = Provider<${機能名}Usecase>(
    (ref) {
      ref.keepAlive();
      final dependency1 = ref.watch(Dependency1.provider);
      final dependency2 = ref.watch(Dependency2.provider);
      return ${機能名}UsecaseImpl._(
        dependency1: dependency1,
        dependency2: dependency2,
      );
    },
    dependencies: [
      Dependency1.provider,
      Dependency2.provider,
    ],
  );

  final Dependency1 dependency1;
  final Dependency2 dependency2;

  const ${機能名}UsecaseImpl._({
    required this.dependency1,
    required this.dependency2,
  });

  @override
  Future<${機能名}Result> execute(${機能名}Request request) async {
    // 実装
  }
}
```

実装クラス定義のポイント：

1. **implements**: インターフェースを `implements` で実装する
2. **Provider定義**: 実装側のProviderは、実際のインスタンスを返す
3. **ref.keepAlive()**: 必要に応じて `ref.keepAlive()` を呼び出し、インスタンスを保持する
4. **ref.watch()**: 依存関係は `ref.watch()` で取得する
5. **dependencies**: Providerの `dependencies` パラメータに依存関係を明示する
6. **プライベートコンストラクタ**: `const ${機能名}UsecaseImpl._();` で定義する
7. **finalフィールド**: 依存関係は `final` フィールドとして保持する

実装例：

```dart
class KanjiSearchUsecaseImpl implements KanjiSearchUsecase {
  static final provider = Provider<KanjiSearchUsecase>(
    (ref) {
      ref.keepAlive();
      final embeddedLocalDataSource = ref.watch(
        EmbeddedLocalDataSource.provider,
      );
      return KanjiSearchUsecaseImpl._(
        embeddedLocalDataSource: embeddedLocalDataSource,
      );
    },
    dependencies: [
      EmbeddedLocalDataSource.provider,
    ],
  );
}
```

#### 依存注入

Usecaseの依存注入は、`UsecaseInjection` クラスで一元管理する：

```dart
import "package:foundation_dependency_injection/dependency_injection.dart";
import "package:usecase_${機能名}/${機能名}.dart";
import "package:usecase_${機能名}_impl/${機能名}_impl.dart";

/// ビジネスロジックの依存性注入を行う.
final class UsecaseInjection {
  const UsecaseInjection._();

  static Future<void> inject(DependencyBuilder builder) async {
    await _inject${機能名}(builder);
    // 他の機能の注入...
  }

  static Future<void> _inject${機能名}(DependencyBuilder builder) async {
    builder.inject(
      ${機能名}Usecase.provider,
      ${機能名}UsecaseImpl.provider,
    );
  }
}
```

`DependencyBuilder.inject()` メソッドを使用して、インターフェースと実装を結びつける：

```dart
builder.inject(
  ${機能名}Usecase.provider,        // インターフェース側のProvider
  ${機能名}UsecaseImpl.provider,    // 実装側のProvider
);
```

実装例：

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

## Request/Result パターン

Usecaseのメソッドは、引数に `*Request` クラス、戻り値に `*Result` クラスを使用する。
これらは `freezed` を使用した data class として定義し、必要に応じて `abstract` または `sealed` を使用して柔軟に表現する。

### Request クラス

Requestクラスは、Freezedを使用して定義する。複数の入力パターンがある場合は `sealed` を使用する。

```dart
import "package:freezed_annotation/freezed_annotation.dart";
import "package:future_context2/future_context2.dart";

part "${機能名}_request.freezed.dart";

/// ${機能名}のリクエスト.
@freezed
sealed class ${機能名}Request with _$${機能名}Request {
  const factory ${機能名}Request({
    /// キャンセルコンテキスト.
    FutureContext? context,

    /// ${パラメータの説明}.
    required ${型} ${パラメータ名},
  }) = _${機能名}Request;

  // 複数の入力パターンがある場合の例
  // const factory ${機能名}Request.bySomething({ ... }) = ${機能名}RequestBySomething;

  const ${機能名}Request._();
}
```

実装例：

```dart
@freezed
sealed class KanjiSearchRequest with _$KanjiSearchRequest {
  const factory KanjiSearchRequest({
    /// キャンセルコンテキスト.
    FutureContext? context,

    /// 検索する漢字.
    required Kanji kanji,
  }) = _KanjiSearchRequest;

  const KanjiSearchRequest._();
}
```

### Result クラス

Resultクラスは、sealed classまたはFreezedを使用して定義する。

#### sealed freezed class を使用する場合（複数の結果パターンがある場合）

成功・失敗や、複数の状態を戻り値として表現したい場合に推奨される。

```dart
import "package:freezed_annotation/freezed_annotation.dart";

part "${機能名}_result.freezed.dart";

/// ${機能名}の結果.
@freezed
sealed class ${機能名}Result with _$${機能名}Result {
  /// 成功
  const factory ${機能名}Result.success({
    required ${型} ${パラメータ名},
  }) = ${機能名}ResultSuccess;

  /// 失敗
  const factory ${機能名}Result.failure({
    required String message,
  }) = ${機能名}ResultFailure;

  const ${機能名}Result._();
}
```

実装例：

```dart
@freezed
sealed class KanjiSearchResult with _$KanjiSearchResult {
  /// データが見つかった
  const factory KanjiSearchResult.found({
    /// 対象漢字
    required Kanji kanji,

    /// 習う学年
    required SchoolGrade? learningGrade,

    /// 漢検の級
    required KankenGrade? kankenGrade,
  }) = KanjiSearchResultFound;

  /// データが見つからなかった
  const factory KanjiSearchResult.notFound() = KanjiSearchResultNotFound;

  const KanjiSearchResult._();
}
```

#### abstract freezed class を使用する場合（単一の結果型）

結果のパターンが1つしかない場合に適している。

```dart
import "package:freezed_annotation/freezed_annotation.dart";

part "${機能名}_result.freezed.dart";

/// ${機能名}の結果.
@freezed
abstract class ${機能名}Result with _$${機能名}Result {
  const factory ${機能名}Result({
    required ${型} ${パラメータ名},
  }) = _${機能名}Result;

  const ${機能名}Result._();
}
```

## Provider の実装

### インターフェース側のProvider

インターフェース側のProviderは、実装が注入されるまで `UnimplementedError` を投げる：

```dart
static final provider = Provider<${機能名}Usecase>(
  (ref) => throw UnimplementedError("$${機能名}Usecase is not implemented"),
);
```

### 実装側のProvider

実装側のProviderは、以下の要素を含む：

1. **ref.keepAlive()**: 必要に応じて呼び出し、インスタンスを保持する
2. **ref.watch()**: 依存関係を取得する
3. **dependencies**: 依存関係を明示する
4. **ref.onDisposeAsync()**: クリーンアップが必要な場合に使用する

```dart
static final provider = Provider<${機能名}Usecase>(
  (ref) {
    ref.keepAlive();
    final dependency1 = ref.watch(Dependency1.provider);
    final dependency2 = ref.watch(Dependency2.provider);
    final instance = ${機能名}UsecaseImpl._(
      dependency1: dependency1,
      dependency2: dependency2,
    );
    ref.onDisposeAsync(() async {
      // クリーンアップ処理
    });
    return instance;
  },
  dependencies: [
    Dependency1.provider,
    Dependency2.provider,
  ],
);
```

### ライフサイクル管理

実装クラスでリソース管理が必要な場合は、以下のパターンを使用する：

```dart
static final provider = Provider<${機能名}Usecase>(
  (ref) {
    ref.keepAlive();
    final instance = ${機能名}UsecaseImpl._();
    ref.onDisposeAsync(() async {
      await instance.close();
    });
    return instance;
  },
);
```

## Usecase実装例

### 基本的なUsecase（依存関係なし）

```dart
/// エラー内容を調査し、ハンドリングを確定させる.
abstract class ErrorQueryUsecase {
  static final provider = Provider<ErrorQueryUsecase>(
    (ref) => throw UnimplementedError("$ErrorQueryUsecase is not implemented"),
  );

  /// エラー内容を調査し、ハンドリングを確定させる.
  ErrorDetail execute(ErrorQueryRequest request);
}
```

```dart
class ErrorQueryUsecaseImpl implements ErrorQueryUsecase {
  static final provider = Provider<ErrorQueryUsecase>(
    (ref) {
      ref.keepAlive();
      return ErrorQueryUsecaseImpl._();
    },
    dependencies: const [],
  );

  ErrorQueryUsecaseImpl._();
}
```

### 複数の依存関係を持つUsecase

```dart
class StartupUsecaseImpl implements StartupUsecase {
  static final provider = Provider<StartupUsecaseImpl>(
    (ref) {
      final appDatabase = ref.watch(AppDatabase.provider);
      final preferencesRepository = ref.watch(PreferencesRepository.provider);
      final authenticationRepository = ref.watch(
        AuthenticationRepository.provider,
      );
      // 漢字DBの初期化タスクを確実に登録するため、EmbeddedLocalDataSourceを読み込む
      final embeddedLocalDataSource = ref.watch(
        EmbeddedLocalDataSource.provider,
      );
      ref.keepAlive();
      return StartupUsecaseImpl._(
        diCompletion: () => ref.waitInitializeTasks(),
        embeddedLocalDataSource: embeddedLocalDataSource,
        appDatabase: appDatabase,
        preferencesRepository: preferencesRepository,
        authenticationRepository: authenticationRepository,
      );
    },
    dependencies: [
      AppDatabase.provider,
      PreferencesRepository.provider,
      AuthenticationRepository.provider,
      EmbeddedLocalDataSource.provider,
      FirstLoginTutorialUsecase.provider,
    ],
  );
}
```

### 同期処理のUsecase

```dart
/// 日本語を解析するためのユースケース
abstract class JapaneseParseUsecase {
  static final provider = Provider<JapaneseParseUsecase>(
    (ref) =>
        throw UnimplementedError("$JapaneseParseUsecase is not implemented"),
  );

  /// 漢字を解析する
  ///
  /// 入力された [text] を解析し、漢字を抽出する.
  Iterable<JapaneseCharacter> execute(JapaneseParseRequest request);
}
```

## Datasource/Repository との関係

### Datasource

Datasourceは、Read Onlyのデータアクセスを提供する：

* データの読み取りのみを行う
* データの変更は行わない
* 例: `EmbeddedLocalDataSource`、`authenticationRepository`

### Repository

Repositoryは、Read/Write両方のデータアクセスを提供する：

* データの読み取りと書き込みを行う
* 状態管理を行う場合がある
* 例: `PreferencesRepository`、`AuthenticationRepository`

### Usecaseからの依存

Usecaseは、DatasourceやRepositoryに依存してデータアクセスを行う：

```dart
class KanjiSearchUsecaseImpl implements KanjiSearchUsecase {
  final EmbeddedLocalDataSource embeddedLocalDataSource;

  @override
  Future<KanjiSearchResult> execute(KanjiSearchRequest request) async {
    final kanjiEntries = await embeddedLocalDataSource.getAllKanjiEntries();
    // ...
  }
}
```

```dart
class FirstLoginTutorialUsecaseImpl implements FirstLoginTutorialUsecase {
  final PreferencesRepository preferencesRepository;

  @override
  Future<bool> isTutorialCompleted() async {
    return preferencesRepository.preferencesStream
        .map((e) => e.get(_preferenceKey, defaultValue: _defaultValue))
        .map((e) => e.asBoolean)
        .first;
  }

  @override
  Future<void> execute(TutorialDoneRequest request) {
    return preferencesRepository.edit(
      const PreferenceEditRequest.putBool(
        key: _preferenceKey,
        value: true,
      ),
    );
  }
}
```

## Fake Usecaseの実装

テスト環境では、外部サービス（Firebase Crashlytics等）への依存を軽量化するため、Fake実装を提供する。

### Fake Usecaseの補足

Fake Usecaseを実装することで、以下の利点がある：

* テストコストの削減（外部サービスへの依存を排除）
* テストの高速化（ネットワーク通信等の遅延を回避）
* テスト環境の制御性向上（Fake実装で振る舞いを制御）

Fake実装は、本番実装と同じパッケージ（`usecase_${機能名}_impl`）に配置する。これにより、インターフェースとFake実装の依存関係が明確になる。

### 命名規則

* Fake実装クラス: `${機能名}UsecaseFake`（例：`CrashReportSendUsecaseFake`）
* ファイル名: `${機能名}_usecase_fake.dart`

### Fake実装のパターン

Fake実装は、以下のパターンで定義する：

```dart
import "package:armyknife_logger/armyknife_logger.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:usecase_${機能名}/usecase_${機能名}.dart";

// リリースモードではログを出力しない.
final _log = Logger.drop(
  Logger.of(${機能名}UsecaseFake),
  drop: kReleaseMode,
);

/// [${機能名}Usecase]のフェイク実装.
class ${機能名}UsecaseFake implements ${機能名}Usecase {
  static final provider = Provider<${機能名}Usecase>(
    (ref) {
      ref.keepAlive();
      return const ${機能名}UsecaseFake._();
    },
    dependencies: const [],
  );

  const ${機能名}UsecaseFake._();

  @override
  Future<${機能名}Result> execute(${機能名}Request request) async {
    _log.d("Fake ${機能名}Usecase.execute() - no-op");
    // 最小限の実装（no-op、デフォルト値の返却等）
    return const ${機能名}Result.success();
  }
}
```

#### ポイント

1. **implements**: インターフェースを `implements` で実装する
2. **Provider定義**: Fake実装側のProviderは、Fakeインスタンスを返す
3. **ref.keepAlive()**: 必要に応じて `ref.keepAlive()` を呼び出す
4. **dependencies**: 依存関係は空配列（`const []`）とすることが多い
5. **const コンストラクタ**: `const ${機能名}UsecaseFake._();` で定義する
6. **最小限の実装**: ログ出力やno-op実装とする

### Fake実装の実装例

外部サービスへの依存を持つUsecaseのFake実装：

```dart
// usecase_error_impl, crash_report_send_usecase_fake.dart
import "package:armyknife_logger/armyknife_logger.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:usecase_error/usecase_error.dart";

// リリースモードではログを出力しない.
final _log = Logger.drop(
  Logger.of(CrashReportSendUsecaseFake),
  drop: kReleaseMode,
);

/// [CrashReportSendUsecase]のフェイク実装.
class CrashReportSendUsecaseFake implements CrashReportSendUsecase {
  static final provider = Provider<CrashReportSendUsecase>(
    (ref) {
      ref.keepAlive();
      return const CrashReportSendUsecaseFake._();
    },
    dependencies: const [],
  );

  const CrashReportSendUsecaseFake._();

  @override
  Future<void> execute(CrashReportSendRequest request) async {
    _log.d("Fake CrashReportSendUsecase.execute() - no-op");
  }
}
```

`CrashReportSendUsecaseFake` は、Firebase Crashlyticsへの依存を持たず、ログ出力のみを行う。これにより、テスト環境でFirebaseの初期化が不要になる。

### Fake実装の配置

Fake実装は、本番実装と同じパッケージに配置する：

```text
app_packages/usecase/
└── error/                          # usecase_error（インターフェース）
    ├── lib/src/crash_report_send/
    │   └── crash_report_send_usecase.dart
    └── _impl/                      # usecase_error_impl（実装）
        └── lib/src/crash_report_send_usecase/
            ├── crash_report_send_usecase_impl.dart  # 本番実装
            └── crash_report_send_usecase_fake.dart  # Fake実装
```

### Fake実装のエクスポート

Fake実装は、実装パッケージのエクスポートファイルに含める：

```dart
// usecase_error_impl, error_impl.dart
library;

export "src/crash_report_send_usecase/crash_report_send_usecase_fake.dart";
export "src/crash_report_send_usecase/crash_report_send_usecase_impl.dart";
export "src/crash_report_usecase/crash_report_usecase_impl.dart";
export "src/error_query_usecase/error_query_usecase_impl.dart";
```

### Fake実装のテストでの使用

Fake実装は、テスト用Injectionで注入する：

```dart
// usecase_injection/_testing, testing_usecase_injection.dart
/// テスト環境向けのUsecase依存注入.
final class TestingUsecaseInjection {
  const TestingUsecaseInjection._();

  /// Usecase依存注入.
  static Future<void> inject(DependencyBuilder builder) async {
    builder.inject(
      CrashReportSendUsecase.provider,
      CrashReportSendUsecaseFake.provider,  // Fake実装を注入
    );
  }
}
```

詳細は `dependency-injection.md` の「テスト用と本番用のInjectionの分離」を参照。

### Fake vs Mock の使い分け

* **Fake**: 軽量な実装、外部サービスへの依存回避、no-op実装
* **Mock**: 呼び出しの検証、特定の振る舞いのテスト、テストフレームワークによる生成

Fake実装は、外部サービスへの依存を軽量化するために使用する。一方、Mockは、特定の呼び出しを検証するために使用する。

#### 使い分けの例

* **Fakeを使用する場合**:
  * Firebase Crashlyticsへの送信をテスト環境で無効化する
  * 外部APIへのリクエストをテスト環境で無効化する
  * ログ出力のみを行う軽量な実装

* **Mockを使用する場合**:
  * Usecaseが特定のRepositoryメソッドを呼び出したことを検証する
  * Usecaseが特定の引数で他のUsecaseを呼び出したことを検証する
  * テストフレームワーク（Mockito等）によるMock生成

## テスト

Usecaseのテストは、以下のパターンで実装する：

### テストパッケージの使い分け

Usecaseのテストは, テストの目的に応じて適切なパッケージに配置する。

1. **インターフェースの動作テスト（ブラックボックステスト）**
   * **配置先**: `usecase_${機能名}_test` パッケージ
   * **目的**: 外部仕様（インターフェース）が正しく動作することを確認する。
   * **内容**: `Usecase.provider` を通じてインスタンスを取得し, 公開メソッド（`execute`）の入出力を検証する。実装の詳細（どのクラスが使われているか等）には依存しない。

2. **特定の実装に係る内部動作テスト（ホワイトボックステスト）**
   * **配置先**: `usecase_${機能名}_impl` パッケージ内の `test/` ディレクトリ
   * **目的**: 実装クラス内部のロジックや, プライベートな動作を検証する必要がある場合。
   * **内容**: `UsecaseImpl` クラスを直接インスタンス化したり, 実装固有の依存関係をモックしてテストする。

#### インターフェース動作テストの実装例（ブラックボックス）

インターフェースパッケージの外部から, 仕様に基づいたテストを行う。

```dart
// usecase_school_test, kanji_search_usecase_test.dart
void main() {
  late KanjiSearchUsecase usecase;

  setUp(() async {
    await testContext.injectForTesting();
    // インターフェースのProviderを使用して取得する
    usecase = await ref.testReady(KanjiSearchUsecase.provider);
  });

  test("漢字検索の仕様確認", () async {
    final result = await usecase.execute(
      const KanjiSearchRequest(kanji: Kanji("漢")),
    );
    // 戻り値の型（Result）に基づいた検証を行う
    expect(result, isA<KanjiSearchResultFound>());
  });
}
```

#### 実装内部動作テストの実装例（ホワイトボックス）

実装パッケージ内で, 実装クラス固有のロジックをテストする。

```dart
// usecase_school_impl, kanji_search_usecase_impl_test.dart
void main() {
  test("実装固有のロジック検証", () async {
    // 実装クラスを直接扱う必要がある場合や, 
    // 内部のプライベートメソッドに近い挙動を検証する場合にのみ impl 側で記述する
    final impl = KanjiSearchUsecaseImpl._(
      embeddedLocalDataSource: mockDataSource,
    );
    
    // ... 内部ロジックの検証 ...
  });
}
```

### テストのセットアップ

#### 統合ヘルパーを使用する場合（推奨）

統合ヘルパー（`testContext.injectForTesting()`）を使用することで、テスト用の依存注入を一括で行える：

```dart
import "package:flutter_test/flutter_test.dart";
import "package:riverpod_container_async_test/riverpod_container_async_test.dart";
import "package:testing_core/testing_core.dart";
import "package:testing_injection/testing_injection.dart";
import "package:usecase_${機能名}/${機能名}.dart";

void main() {
  late ${機能名}Usecase usecase;

  setUp(() async {
    await testContext.injectForTesting();  // 統合ヘルパーで一括注入

    usecase = await ref.testReady(${機能名}Usecase.provider);
  });

  group("${機能名}Usecase", () {
    test("インスタンス取得", () async {
      expect(usecase, isA<${機能名}Usecase>());
    });

    test("${機能のテスト}", () async {
      final result = await usecase.execute(
        ${機能名}Request(/* ... */),
      );
      expect(result, /* ... */);
    });
  });
}
```

#### 個別にInjectionを呼び出す場合

特定のInjectionをカスタマイズしたい場合は、個別に呼び出す：

```dart
import "package:data_injection/injection.dart";
import "package:flutter_test/flutter_test.dart";
import "package:infra_injection/_testing/injection_testing.dart";
import "package:riverpod_container_async_test/riverpod_container_async_test.dart";
import "package:testing_core/testing_core.dart";
import "package:usecase_injection/injection.dart";
import "package:usecase_injection/_testing/usecase_injection_testing.dart";
import "package:usecase_${機能名}/${機能名}.dart";

void main() {
  late ${機能名}Usecase usecase;

  setUp(() async {
    await TestingInfraInjection.inject(refBuilder);
    await DataInjection.inject(refBuilder);
    await UsecaseInjection.inject(refBuilder);
    await TestingUsecaseInjection.inject(refBuilder);

    usecase = await ref.testReady(${機能名}Usecase.provider);
  });

  group("${機能名}Usecase", () {
    test("インスタンス取得", () async {
      expect(usecase, isA<${機能名}Usecase>());
    });

    test("${機能のテスト}", () async {
      final result = await usecase.execute(
        ${機能名}Request(/* ... */),
      );
      expect(result, /* ... */);
    });
  });
}
```

### 統合ヘルパーと個別呼び出しの使い分け

* **統合ヘルパー（推奨）**: 標準的なテストで使用する。`testContext.injectForTesting()` で一括注入
* **個別呼び出し**: 特定のInjectionをカスタマイズしたい場合に使用する

統合ヘルパーの実装は `testing_injection` パッケージの `testing_injection_functions.dart` を参照。

### テストの実装例

統合ヘルパーを使用した実装例：

```dart
// usecase_system_test, startup_usecase_test.dart
import "package:data_repository_preferences/data_repository_preferences.dart";
import "package:domain_preferences/domain_preferences.dart";
import "package:flutter_test/flutter_test.dart";
import "package:riverpod_container_async_test/riverpod_container_async_test.dart";
import "package:testing_core/testing_core.dart";
import "package:testing_injection/testing_injection.dart";
import "package:usecase_system/usecase_system.dart";

void main() {
  late StartupUsecase startupUsecase;
  late PreferencesRepository preferencesRepository;

  setUp(() async {
    await testContext.injectForTesting();  // 統合ヘルパーで一括注入

    startupUsecase = await ref.testReady(StartupUsecase.provider);
    preferencesRepository = await ref.testReady(PreferencesRepository.provider);
  });

  Future<void> configure() async {
    startupUsecase = await ref.testReady(StartupUsecase.provider);
  }

  void verifyMigratedSettings() {
    final schemaVersion = preferencesRepository.require(
      PreferenceKey.settingsVersion,
    );
    expect(schemaVersion.asInt, PreferenceSettingsVersion.v1.value);
  }

  group("StartupUsecase", () {
    test("インスタンス取得", () async {
      await configure();
      expect(startupUsecase, isA<StartupUsecase>());
    });

    test("実行し、エラーが発生しない", () async {
      await configure();
      final result = await startupUsecase.execute(const StartupRequest());
      expect(result.isMigratedSettings, isTrue);

      // マイグレーションが完了している
      verifyMigratedSettings();
    });

    test("２回目以降はマイグレーションが行われない", () async {
      await configure();

      {
        final result = await startupUsecase.execute(const StartupRequest());
        expect(result.isMigratedSettings, isTrue);
      }
      {
        final result = await startupUsecase.execute(const StartupRequest());
        expect(result.isMigratedSettings, isFalse);
      }
    });
  });
}
```

## Usecase命名規則

### *Usecase

* ビジネスロジックは、基本的に `*Usecase` というインターフェース名とする

#### *Usecaseの補足

Usecaseインターフェースは、機能名に `Usecase` サフィックスを付けて命名する。実装クラスは、インターフェース名に `Impl` サフィックスを付けて命名する。

#### *Usecaseの実装例

* `KanjiSearchUsecase` / `KanjiSearchUsecaseImpl`
* `StartupUsecase` / `StartupUsecaseImpl`
* `JapaneseParseUsecase` / `JapaneseParseUsecaseImpl`

### *Datasource / Repository

* データ保持・取得に関わるビジネスロジックは、 `Datasource` `Repository` のいずれかのサフィックスが付与される
* DatasourceはRead Onlyである場合に使用される
* RepositoryはRead/Write両方である場合に使用される

#### *Datasource / Repositoryの補足

データアクセス層のインターフェースは、読み取り専用の場合は `Datasource`、読み書き両方の場合は `Repository` というサフィックスを使用する。

#### *Datasource / Repositoryの実装例

Datasourceの例：

* `EmbeddedLocalDataSource` - 組み込みデータの読み取りのみ
* `authenticationRepository` - 認証情報の読み取りのみ

Repositoryの例：

* `PreferencesRepository` - 設定値の読み書き
* `AuthenticationRepository` - 認証情報の読み書き

## ナレッジベース

### DO: Usecase Class名は `{動詞}{カテゴリ}Usecase` に統一する

* 先頭に機能を示す動詞（`Search`、`Get`、`Query`、`Parse` 等）を置く
* 続けてカテゴリを示す名詞（対象ドメイン・リソース等）を置く
* 末尾は `Usecase` とする。実装クラスは `{動詞}{カテゴリ}UsecaseImpl` とする
* 例: `SearchKanjiUsecase`、`ParsePassageUsecase`、`QueryErrorUsecase`

```dart
/// 漢字を検索するUsecase.
abstract class SearchKanjiUsecase {
  Future<SearchKanjiResult> execute(SearchKanjiRequest request);
  const SearchKanjiUsecase._();
}

class SearchKanjiUsecaseImpl implements SearchKanjiUsecase {
  const SearchKanjiUsecaseImpl._({
    required this.embeddedLocalDataSource,
  });
}
```

### DO: 1 Usecase は 1 機能としメソッド名は execute() に統一する

* 新規作成時は原則として `execute()` を使用する
* 複数機能が必要な場合は複数の Usecase インターフェースに分割する

```dart
abstract class KanjiSearchUsecase {
  Future<KanjiSearchResult> execute(KanjiSearchRequest request);
  const KanjiSearchUsecase._();
}
```

### DO: インターフェースと実装を別パッケージに分離する

* インターフェース側 Provider は `UnimplementedError` を投げる
* 実装の結びつけは `UsecaseInjection` で行う

```dart
builder.inject(
  KanjiSearchUsecase.provider,
  KanjiSearchUsecaseImpl.provider,
);
```

### DO: Usecase 自体はステートレスにし状態は Repository / Datasource に委ねる

* Usecase はフィールドとして状態を保持しない
* 状態が必要な場合は Repository から取得・更新する

```dart
class FirstLoginTutorialUsecaseImpl implements FirstLoginTutorialUsecase {
  final PreferencesRepository preferencesRepository;
  // 状態は Repository 経由で取得する
}
```

### DO: Request/Result を freezed の data class で定義する

* 引数は `*Request`、戻り値は `*Result` とする
* 複数パターンがある場合は `sealed`、単一の場合は `abstract` を用いる

```dart
@freezed
sealed class KanjiSearchRequest with _$KanjiSearchRequest {
  const factory KanjiSearchRequest({
    FutureContext? context,
    required Kanji kanji,
  }) = _KanjiSearchRequest;

  const KanjiSearchRequest._();
}
```

### DO: Provider の dependencies に依存関係を明示する

* 依存は `ref.watch()` で取得する
* `dependencies` パラメータに監視対象の Provider を列挙する

```dart
static final provider = Provider<KanjiSearchUsecase>(
  (ref) {
    ref.keepAlive();
    final embeddedLocalDataSource = ref.watch(
      EmbeddedLocalDataSource.provider,
    );
    return KanjiSearchUsecaseImpl._(
      embeddedLocalDataSource: embeddedLocalDataSource,
    );
  },
  dependencies: [
    EmbeddedLocalDataSource.provider,
  ],
);
```

### DO: 必要に応じて ref.keepAlive() でインスタンスを保持する

* ライフサイクルを Provider 管理下に置き、不要な再生成を防ぐ
* クリーンアップが必要な場合は `ref.onDisposeAsync()` と併用する

```dart
static final provider = Provider<ErrorQueryUsecase>(
  (ref) {
    ref.keepAlive();
    return ErrorQueryUsecaseImpl._();
  },
  dependencies: const [],
);
```

### DO: インターフェースと実装でプライベートコンストラクタを定義する

* 外部からの直接生成を防ぎ、Provider 経由の取得を強制する

```dart
abstract class KanjiSearchUsecase {
  const KanjiSearchUsecase._();
}

class KanjiSearchUsecaseImpl implements KanjiSearchUsecase {
  const KanjiSearchUsecaseImpl._({
    required this.embeddedLocalDataSource,
  });
}
```

### DO: 公開メソッドにドキュメントコメントを記述する

* インターフェースの公開 API には `///` コメントを付ける

```dart
/// 漢字を検索するUsecase.
abstract class KanjiSearchUsecase {
  /// 漢字を検索する.
  Future<KanjiSearchResult> execute(KanjiSearchRequest request);
}
```

### DO NOT: Usecase 自体に状態を保持する

* 理由: 副作用とテスト困難の原因になる
* 理由: ステートレス原則に反する

```dart
// DO NOT: Usecase 内に mutable な状態フィールドを持つ
class ExampleUsecaseImpl implements ExampleUsecase {
  String _cache = "";
}
```

```dart
// DO: 状態は Repository に委譲する
class ExampleUsecaseImpl implements ExampleUsecase {
  final PreferencesRepository preferencesRepository;
}
```

### DO NOT: カテゴリ名詞を先頭にした Usecase Class名を使う

* 理由: 動詞先行（`{動詞}{カテゴリ}Usecase`）に統一し、機能の読み取りを揃えるため

```dart
// 非推奨パターン（古い実装）
// DO NOT: カテゴリ名詞が先、動詞が後
abstract class KanjiSearchUsecase {}
abstract class PassageParseUsecase {}
abstract class ErrorQueryUsecase {}
```

```dart
// 推奨される書き換えパターン
// DO: 動詞が先、カテゴリ名詞が次
abstract class SearchKanjiUsecase {}
abstract class ParsePassageUsecase {}
abstract class QueryErrorUsecase {}
```

### DO NOT: インターフェースと実装を同一パッケージに混在させる

* 理由: テスト時の差し替えが困難になる
* 理由: インターフェースパッケージから実装詳細が漏れる

```text
# DO NOT
app_packages/usecase/school/lib/src/
├── kanji_search_usecase.dart
└── kanji_search_usecase_impl.dart
```

```text
# DO
app_packages/usecase/school/
├── lib/src/.../kanji_search_usecase.dart
└── _impl/lib/src/.../kanji_search_usecase_impl.dart
```

### DO NOT: Usecase 間で循環参照する

* 理由: 依存の向きが不明確になり保守性が低下する
* 理由: 共通機能の切り出し機会を失う

```dart
// DO NOT: A → B かつ B → A
// UsecaseA が UsecaseB に依存し、UsecaseB が UsecaseA に依存する
```

```dart
// DO: 共通処理を別 Usecase または Repository に分離し一方向依存にする
```

### DO NOT: Usecase を直接インスタンス化する

* 理由: 依存注入と差し替えが破綻する
* Provider を通じて取得する

```dart
// DO NOT
final usecase = KanjiSearchUsecaseImpl._(...);

// DO
final usecase = ref.watch(KanjiSearchUsecase.provider);
```

### DO NOT: 必要以上の依存関係を持つ

* 理由: 結合度が上がり変更影響が広がる
* 最小限の依存のみを持つ

## package internal Usecase（Repository / 画面 _impl 内）

公開 Usecase 層（`app_packages/usecase/*` の IF/Impl）とは別に、**実装パッケージ内部**に
`@internal` Usecase を置いてよい。目的は Delegate 間の共通処理の切り出しである。

* 配置例: `data_repository_*_impl/lib/src/**/usecase/`、`screen_feature_*/lib/src/viewmodel/usecase/`
* IF/Impl 分離・Riverpod Provider は **必須としない**（パッケージ外に出さない）
* Delegate in Delegate の代替として使う（正本: `delegate-pattern.md` / `mvvm-viewmodel-design-action.md`）
* 命名は `{動詞}{カテゴリ}Usecase`（例: `FetchProfileImageUsecase`）

```dart
@internal
class FetchProfileImageUsecase {
  const FetchProfileImageUsecase({required this.storage, required this.uid});
  Future<ProfileImageImplState> execute() async { /* ... */ }
}
```
