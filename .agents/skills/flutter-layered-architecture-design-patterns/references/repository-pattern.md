# Data層 / Repository パターン

## 概要

Repository は、Data 層においてデータの永続化・取得・監視を抽象化するコンポーネントである。Usecase や ViewModel から呼び出され、Datasource や外部 API の差異を隠蔽する。

* データ入出力を隠蔽・抽象化するインターフェースは、`Repository` というサフィックスを持つのが基本である
* `${機能グループ名}Repository` という名称が基本である
* **インターフェースと実装の分離**: Usecase と同様に、インターフェースと実装を別パッケージに分離する
* **複数機能の許容**: 1 つの Repository インターフェースは、同一機能グループに属する複数のデータ操作を提供してよい
* **状態の保持と監視**: 内部状態を持ち、`watch()` 系メソッドや `Stream` で状態を監視することを許可する
* **Request/Result パターン**: データ操作の入出力は Request/Result の data class で表現する
* **入出力の抽象化**: Read/Write 両方、Write-Only、Read-Only のいずれであっても、データ入出力の窓口として隠蔽・抽象化する

## 原則

### インターフェースと実装の分離

* すべての Repository は、インターフェースと実装を分離する
* インターフェースと実装は異なる package に配置する
* インターフェースには `${Repository名}.provider` という static final Provider（Riverpod）を持つ
* 依存注入は Riverpod の Override により行う

#### インターフェースと実装の分離の補足

Usecase パターンと同様に、インターフェースと実装を分離することでテスト時の差し替えが容易になり、実装の変更が呼び出し側に波及しにくくなる。Data 層の注入は `DataInjection` で一元管理する。

#### インターフェースと実装の分離の実装例

良い例：インターフェース（パッケージ `data_repository_preferences`）

```dart
// data_repository_preferences, preferences_repository.dart
abstract class PreferencesRepository {
  static final provider = Provider<PreferencesRepository>(
    (ref) =>
        throw UnimplementedError("$PreferencesRepository is not implemented"),
  );

  const PreferencesRepository();

  Preferences get preferences;
  Stream<Preferences> get preferencesStream;
  Future<void> edit(PreferenceEditRequest request);
  Preference get(PreferenceKey key, {required Preference defaultValue});
  Preference require(PreferenceKey key);
}
```

良い例：実装（パッケージ `data_repository_preferences_impl`）

```dart
// data_repository_preferences_impl, preferences_repository_impl.dart
class PreferencesRepositoryImpl implements PreferencesRepository {
  static final provider = Provider<PreferencesRepositoryImpl>(
    (ref) {
      final appDatabase = ref.watch(db.AppDatabase.provider);
      // ... 依存の組み立て
      final result = PreferencesRepositoryImpl._(
        stateStream: MutableStateStream(initial),
        databaseSyncDelegate: databaseSyncDelegate,
        databasePutDelegate: databasePutDelegate,
      );
      ref.keepAlive();
      ref.registerInitializeTasks(result.awaitInitialized());
      ref.onDisposeAsync(() async => await result.close());
      return result;
    },
    dependencies: [db.AppDatabase.provider],
  );

  final MutableStateStream<PreferencesRepositoryState> stateStream;
  final DatabaseSyncDelegate databaseSyncDelegate;
  final DatabaseEditDelegate databasePutDelegate;

  PreferencesRepositoryImpl._({...});
}
```

### 1 クラスに複数機能を許可する

* 1 つの Repository インターフェースは、同一の機能グループに属する複数のデータ操作メソッドを持ってよい
* Usecase の「1 インターフェース 1 機能」とは異なり、Repository は集約されたデータ窓口として複数メソッドを提供する

#### 1 クラスに複数機能を許可する補足

認証まわり（初期化・サインイン・サインアウト・EULA 取得・同意バージョン監視など）を 1 つの `AuthenticationRepository` にまとめるように、ドメイン的にまとまるデータ操作は 1 つの Repository に集約する。これにより、呼び出し側は「認証に関するデータ」を 1 つのインターフェースで扱える。

#### 1 クラスに複数機能を許可する実装例

良い例：認証に関する複数操作を 1 つの Repository で提供する

```dart
// data_repository_authentication, authentication_repository.dart
abstract class AuthenticationRepository {
  static final provider = Provider<AuthenticationRepository>(
    (ref) => throw UnimplementedError(
      "$AuthenticationRepository is not implemented",
    ),
  );

  AuthenticationState get authentication;
  Stream<AuthenticationState> get authenticationStream;
  Future<GetEndUserLicenseAgreementResult> getEndUserLicenseAgreement(
    GetEndUserLicenseAgreementRequest request,
  );
  Future<InitializeResult> initialize(InitializeRequest request);
  Future<SaveEulaAgreementVersionResult> saveEulaAgreementVersion(
    SaveEulaAgreementVersionRequest request,
  );
  Future<AuthenticationResult> signIn(AuthenticationRequest request);
  Future<void> signOut();
  Stream<EndUserLicenseAgreementVersion> watchEulaAgreementVersion(
    WatchEulaAgreementVersionRequest request,
  );
}
```

### 状態の保持と watch 系メソッドの許可

* Repository の実装は内部状態を持ってよい
* 状態の変化を `Stream` や getter（例: `preferencesStream`, `authenticationStream`）で公開し、呼び出し側が監視することを許可する
* 初期化完了の遅延や、非同期で更新される値をストリームで通知する設計は推奨される

#### 状態の保持と watch 系メソッドの許可の補足

Datasource や外部 API の変更をアプリ内で一元的に反映するため、Repository が状態を保持し、`watch()` や `*Stream` で購読可能にすることがある。Usecase は原則としてステートレスであるが、Repository は「データの窓口」として状態を保持する責務を持つ。

#### 状態の保持と watch 系メソッドの許可の実装例

良い例：状態ストリームと getter で現在値・監視を提供する

```dart
// data_repository_preferences_impl, preferences_repository_impl.dart
@override
Preferences get preferences => stateStream.state.preferences;

@override
Stream<Preferences> get preferencesStream => stateStream.stream
    .where((e) => e.initialized)
    .map((e) => e.preferences)
    .distinct();
```

良い例：watch 系メソッドで監視 API を提供する

```dart
// data_repository_ai_quota, ai_quota_repository.dart
Stream<WatchAiQuotaResult> watchAiQuota(WatchAiQuotaRequest request);
```

### データ操作の Request/Result パターン

* データの書き込み・読み込み・監視など、データ操作のメソッドには Request と Result の data class を用いる
* 引数は `*Request`、戻り値は `*Result` または `Stream<*Result>` とする
* Freezed を用いた data class として定義し、必要に応じて sealed class で複数パターンを表現する

#### データ操作の Request/Result パターンの補足

Usecase と同様に、引数・戻り値の型を明示することで契約が明確になり、テストや将来の変更がしやすくなる。Write のみの操作では `Future<void>` と Request の組み合わせ、Read のみでは Request/Result または getter/Stream を使う。

#### データ操作の Request/Result パターンの実装例

良い例：編集リクエストを sealed class で表現する

```dart
// data_repository_preferences, preference_edit_request.dart
@freezed
sealed class PreferenceEditRequest with _$PreferenceEditRequest {
  const factory PreferenceEditRequest.multiple({
    required Set<PreferenceEditRequest> requests,
  }) = PreferenceEditRequestMultiple;
  const factory PreferenceEditRequest.putBool({
    required PreferenceKey key,
    required bool value,
  }) = PreferenceEditRequestPutBool;
  const factory PreferenceEditRequest.putString({
    required PreferenceKey key,
    required String value,
  }) = PreferenceEditRequestPutStringValue;
  const factory PreferenceEditRequest.remove({
    required PreferenceKey key,
  }) = PreferenceEditRequestRemove;
  const PreferenceEditRequest._();
}
```

良い例：Read 専用の Request/Result

```dart
// data_repository_japanese, japanese_character_repository.dart
Future<GetKanjiEntriesResult> getKanjiEntries(GetKanjiEntriesRequest request);
```

### Read/Write・Write-Only・Read-Only のいずれも抽象化の対象

* Repository は「データ入出力の窓口」である
* Read/Write 両方を行うインターフェース、Write-Only、Read-Only のいずれであっても、データの永続化・取得・監視を隠蔽する役割として Repository を定義してよい
* 呼び出し側は Datasource がローカル DB かリモートか等を意識しない

#### Read/Write・Write-Only・Read-Only のいずれも抽象化の対象の補足

「Repository = Read + Write」に限定せず、例えば「AI 利用チケットの監視のみ」を提供する `AiQuotaRepository` のように Read-Only のストリーム API だけを持つ Repository も許容する。重要なのは「データの入出力を 1 つのインターフェースで抽象化する」ことである。

#### Read/Write・Write-Only・Read-Only の実装例

良い例：Read-Only の監視のみを提供する Repository

```dart
// data_repository_ai_quota, ai_quota_repository.dart
abstract class AiQuotaRepository {
  static final provider = Provider<AiQuotaRepository>(
    (ref) => throw UnimplementedError(),
  );

  Stream<WatchAiQuotaResult> watchAiQuota(WatchAiQuotaRequest request);

  const AiQuotaRepository._();
}
```

良い例：Read-Only の取得のみを提供する Repository

```dart
// data_repository_japanese, japanese_character_repository.dart
abstract interface class JapaneseCharacterRepository {
  static final provider = Provider<JapaneseCharacterRepository>(
    (ref) => throw UnimplementedError(
      "$JapaneseCharacterRepository is not implemented",
    ),
  );

  Future<GetKanjiEntriesResult> getKanjiEntries(GetKanjiEntriesRequest request);
}
```

## テスタビリティ

### Unit Test での差し替え方針（優先順位）

1. **Mock（mocktail 等）+ `overrideWithValue` / コンストラクタ注入**（既定）
   * ViewModel / Screen Delegate / 画面固有 Usecase のシナリオ制御に使う
   * `watch` は `MutableStateStream` / `StreamController` を `when(() => mock.watch...).thenAnswer` で返す
2. **package internal Fake**（`_impl/test` の Fake Storage 等）
   * Repository Impl の Unit Test でインフラ境界だけ差し替える
3. **`_testing` の Testing\* 実装**（例外的）
   * 認証フロー・EULA・埋め込みデータなど、**振る舞いが厚く Mock だとテストが読めなくなる**場合のみ
   * 「emit 用ヘルパー」や「呼び出し回数カウンタ」だけの Testing\* は作らない

### Fake 実装と Mock 実装

* 単体テストや統合テストでは、Repository を Fake または Mock で差し替える
* Fake は「実際の永続化は行わないが、振る舞いを再現する実装」
* Mock は呼び出し検証・戻り値のシナリオ制御に使う

#### Fake 実装と Mock 実装の補足

Firebase / DB に依存しないことが目的なら、必ずしも `_testing` パッケージは不要である。
画面・VM テストは **Mock + DI override** を優先する（`account_screen_view_model_test` の方針）。

認証のようにセッション状態・EULA・複数 API が絡む場合は、`TestingAuthenticationRepository` のような Testing\* を `_testing` に置いてよい。

#### Mock + override の実装例（推奨・画面 / VM）

```dart
class _MockAccountRepository extends Mock implements AccountRepository {}

setUp(() async {
  await testContext.injectForTesting();
  final mockRepo = _MockAccountRepository();
  final profileStream = MutableStateStream<WatchProfileResult>(
    const WatchProfileResult.empty(),
  );
  when(() => mockRepo.watchProfile()).thenAnswer((_) => profileStream.stream);
  when(() => mockRepo.updateProfile(any())).thenAnswer((invocation) async {
    final request = invocation.positionalArguments.first as UpdateProfileRequest;
    return UpdateProfileResult.success(nickname: request.nickname);
  });
  refBuilder.override(
    AccountRepository.provider,
    AccountRepository.provider.overrideWithValue(mockRepo),
  );
});
```

#### Testing\* 実装の実装例（例外・厚い振る舞い）

```dart
// data_repository_authentication_testing, testing_authentication_repository.dart
class TestingAuthenticationRepository implements AuthenticationRepository {
  // signIn / EULA / stateStream など本番相当のシナリオを再現する
}
```

### テスト時の DI

* `injectForTesting()` の後、必要な Repository だけ Mock で `overrideWithValue` する
* `injectForTesting` に Testing\* を結線しない選択肢を認める（未結線なら各テストが必ず override する）
* 環境フラグで本番/Testing を切り替える設計は、厚い Fake が必要な Repository に限る

### Fake と実利用の責務分離

* 1 つの Impl クラスが「Fake と本番の両方」を兼ねることは推奨しない
* テスト用の振る舞いと本番用の振る舞いは、別の実装クラス（または Mock）に分離する

#### Fake と実利用の責務分離の補足

「if (isTest) then ... else ...」を 1 つの Impl 内に書くと、本番コードが読みにくくなる。
差し替えは DI（Mock override または Testing\* Provider）で行う。

## パッケージ構成

Repository は、以下のようなパッケージ構成で実装する。

```text
app_packages/data/repository/
├── ${機能名}/                    # インターフェースパッケージ
│   └── lib/src/
│       ├── ${機能名}_repository.dart
│       └── （Request/Result 等）
├── ${機能名}_impl/               # 実装パッケージ
│   └── lib/src/
│       └── ${実装名}/
│           ├── ${実装名}_impl.dart
│           ├── delegate/
│           └── usecase/          # package internal Usecase（任意）
├── ${機能名}_testing/            # 厚い Fake が必要なときのみ（任意）
│   └── lib/src/
│       └── testing_${機能名}_repository.dart
└── （injection は data/injection に集約）
```

パッケージ命名規則（本ワークスペースの例）。

* インターフェース: `data_repository_${機能名}`（例: `data_repository_preferences`, `data_repository_authentication`）
* 実装: `data_repository_${機能名}_impl`
* テスト用実装: `data_repository_${機能名}_testing`（**必須ではない**。Mock で足りるなら作らない）

## インターフェースの定義

* インターフェースは `abstract class` または `abstract interface class` で定義する
* `static final provider = Provider<${Repository名}>((ref) => throw UnimplementedError(...));` を持つ
* プライベートコンストラクタ `const ${Repository名}._();` または `const ${Repository名}();` で外部からの直接インスタンス化を防ぐ
* 公開メソッド・getter にはドキュメントコメントを付ける

```dart
abstract class ${機能グループ名}Repository {
  static final provider = Provider<${機能グループ名}Repository>(
    (ref) => throw UnimplementedError(
      "$${機能グループ名}Repository is not implemented",
    ),
  );

  const ${機能グループ名}Repository();

  // 状態・監視
  ${StateType} get ${stateName};
  Stream<${StateType}> get ${stateName}Stream;

  // データ操作（Request/Result）
  Future<${ResultType}> ${operationName}(${RequestType} request);
}
```

## 実装クラスの定義

* 実装は `implements ${Repository名}` でインターフェースを実装する
* 実装側の Provider で `ref.keepAlive()`、`ref.watch()` による依存取得、`dependencies` の明示、必要に応じて `ref.onDisposeAsync()` を行う
* 内部で Delegate や StateStream を使い、責務を分割してよい

```dart
class ${実装名}Impl implements ${Repository名} {
  static final provider = Provider<${実装名}Impl>(
    (ref) {
      final dependency = ref.watch(SomeDependency.provider);
      final result = ${実装名}Impl._(dependency: dependency);
      ref.keepAlive();
      ref.onDisposeAsync(result.close);
      return result;
    },
    dependencies: [SomeDependency.provider],
  );

  final SomeDependency dependency;
  @internal
  final MutableStateStream<...> stateStream;

  ${実装名}Impl._({required this.dependency, ...});

  @override
  Future<...> someOperation(SomeRequest request) {
    return someDelegate.execute(request);
  }
}
```

## 依存注入

* Data 層の Repository の依存注入は `DataInjection` で行う
* `DependencyBuilder.inject(インターフェースの Provider, 実装の Provider)` で、インターフェースに実装を結びつける
* テスト時のみ使う実装は、`isFlutterTesting` 等で分岐して注入してよい

```dart
// data_injection, data_injection.dart
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
```

## Request/Result の定義

* Repository のデータ操作でも、Usecase と同様に Freezed を用いた Request/Result を推奨する
* 複数パターンがある場合は sealed class、単一の場合は abstract class または factory 1 つの freezed class でよい
* 戻り値が不要な操作（例: 一部の Write）では `Future<void>` と Request の組み合わせでもよい

## ナレッジベース

### DO: インターフェースと実装を別パッケージに分離する

* インターフェースに `static final provider` を持ち、実装は `_impl` 側で結びつける
* 依存注入は `DataInjection` で一元管理する

```dart
// data_repository_preferences, preferences_repository.dart
abstract class PreferencesRepository {
  static final provider = Provider<PreferencesRepository>(
    (ref) =>
        throw UnimplementedError("$PreferencesRepository is not implemented"),
  );
}
```

### DO: 機能グループごとに 1 Repository を集約する

* 認証・設定などドメイン的にまとまるデータ操作を 1 インターフェースにまとめる
* Usecase の「1 インターフェース 1 機能」とは異なり、複数メソッドを許容する

```dart
// data_repository_authentication, authentication_repository.dart
Future<AuthenticationResult> signIn(AuthenticationRequest request);
Future<void> signOut();
```

### DO: 状態は StateStream で保持し getter と Stream で公開する

* 初期化完了を待ってからストリームを流すなど、公開条件は実装側で制御する
* 呼び出し側は getter（現在値）と Stream（変化）の両方を利用できる

```dart
// data_repository_preferences_impl, preferences_repository_impl.dart
@override
Preferences get preferences => stateStream.state.preferences;

@override
Stream<Preferences> get preferencesStream => stateStream.stream
    .where((e) => e.initialized)
    .map((e) => e.preferences)
    .distinct();
```

### DO: 肥大化する場合は Delegate に処理を委譲する

* 操作ごとに Delegate を切り出し、Repository Impl は組み立てと委譲に専念する
* 複数 Delegate で共有する処理は `_impl` の `usecase/` に package internal Usecase を置く（Delegate in Delegate 禁止。詳細は `delegate-pattern.md`）

```dart
// data_repository_preferences_impl, preferences_repository_impl.dart
final DatabaseSyncDelegate databaseSyncDelegate;
final DatabaseEditDelegate databasePutDelegate;
```

### DO: 内部状態型と公開 Result を分離する

* StateStream が保持する内部型（例: `ProfileImageImplState`）と、公開 API の Result（例: `WatchProfileImageResult`）を混在させない
* 公開 `watch*` は map/distinct で Result に変換する（変換は公開 watch Delegate に統合してよい）

### DO: Unit Test の差し替えは Mock を既定とし、Testing\* は厚い振る舞いに限る

* ViewModel / Screen テスト: Mock + `overrideWithValue`（またはコンストラクタ注入）
* `_testing` の Testing\* は認証などシナリオが厚い場合のみ
* emit ヘルパーや callCount だけの Testing\* は作らない

```dart
refBuilder.override(
  AccountRepository.provider,
  AccountRepository.provider.overrideWithValue(mockRepo),
);
```

### DO NOT: シナリオ制御のためだけに `_testing` Testing\* Repository を増やす

* 理由: Mock と MutableStateStream で足りるのにパッケージと DI が増える
* 理由: テストが Testing\* の独自 API（`emitProfile` 等）にロックされる

### DO NOT: 1 つの Impl で本番と Fake を兼務する

* 理由: 条件分岐が増え、本番コードが読みにくくなる
* 理由: テスト専用の分岐が本番実装に混入する

```dart
// DO NOT: 同一 Impl 内で本番とテストを分岐する
if (isTest) {
  // Fake 相当の処理
} else {
  // 本番処理
}
```

```dart
// DO: Mock override、または本番 Impl と Testing\* を別クラスにし DI で切り替える
```

### DO NOT: Repository インターフェースを省略し実装クラスのみ公開する

* 理由: テスト時の差し替えが困難になる
* 理由: 別実装の追加がしづらくなる

```dart
// DO NOT: 実装クラスを直接公開し、呼び出し側が Impl に依存する
class PreferencesRepositoryImpl {
  static final provider = Provider<PreferencesRepositoryImpl>(...);
}
```

```dart
// DO: インターフェースを公開し、Impl は Injection で結びつける
abstract class PreferencesRepository {
  static final provider = Provider<PreferencesRepository>(...);
}
```

### DO NOT: Datasource の型をそのまま戻り値にする

* 理由: 呼び出し側がインフラ詳細に依存する
* 理由: Repository 専用の Request/Result による抽象化が崩れる

```dart
// DO NOT: インフラ型をそのまま返す
Future<FirestoreDocument> getDocument(...);
```

```dart
// DO: Repository 専用の Result で返す
Future<GetKanjiEntriesResult> getKanjiEntries(GetKanjiEntriesRequest request);
```

### DO NOT: Repository 同士で循環参照する

* 理由: 依存の向きが不明確になり保守性が低下する
* 共通データは別 Repository や Datasource に切り出し、一方向依存を保つ
