# Delegate パターン

## 概要

Delegate パターンは、親クラス（ViewModel、Repository、Usecase など）から **メソッド単体を独立したクラスとして分割** することで、コードの見通しを良くする設計パターンである。本アプリでは、「クラスが肥大化したとき、メソッドを Delegate クラスとして切り出す」という方針を一貫して採用している。

本パターンの本質的な目的は以下の2点である。

* **見通しの良さ**: 親クラスから個々の処理を Delegate として切り出すことで、親クラスはメソッドの呼び出し（オーケストレーション）のみに専念でき、全体の流れが一目で把握できる
* **単一責務の分離**: 1つの Delegate は1つの処理だけを担当する。これにより、各クラスの責務が明確になり、変更時の影響範囲が限定される

上記の目的を達成するための副次的な利点として、以下がある。

* **テスト容易性**: Delegate は独立してユニットテスト可能であり、親クラス全体のモックなしにテストできる
* **レイヤー横断**: Screen、Data、Usecase の各レイヤーで一貫したパターンとして採用される

## Delegate の基本構造

Delegate は **単一の機能のみを提供するクラス** であり、public メソッドとして `execute` を1つだけ持つ。

### コンストラクタの設計

Delegate のコンストラクタは、**呼び出し元クラスのプロパティのサブセット** を受け取る。親クラスが保持する依存のうち、その Delegate が必要とするものだけをコンストラクタ引数とする。

### execute メソッドの設計

`execute` メソッドの引数は、**呼び出し元のメソッド引数と同等** とする。親クラスのメソッドが受け取る引数を、そのまま `execute` に渡す形となる。戻り値型も呼び出し元の属性を引き継ぐ。`Future`、同期型、`Stream` など、呼び出し元のメソッドに応じた型とする。

### ステートレス原則

Delegate クラスは **ステートレス（Stateless）であることを必須** とする。

* Delegate は `execute` の呼び出しをまたいで **内部状態を保持・変更しない**
* フィールドは `final` のみとし、コンストラクタで注入された依存（StateStream、Usecase、Repository 等）への参照を保持するにとどめる
* `execute` 実行中に得た値をインスタンスフィールドへ書き戻さない
* 可能な限り `const` コンストラクタを用いる

#### ステートレス原則の補足

ここでいう「ステートレス」とは、Flutter の `StatefulWidget` とは無関係である。Delegate が `MutableStateStream` 等の **外部状態** を操作することは許容するが、**Delegate インスタンス自身が呼び出し間で変化する状態を持つこと** は禁止する。

ステートレスを守ることで、以下が成立する。

* **テスト容易性**: 依存を Mock 注入し、`execute` 単位で副作用を検証できる
* **再入性の確保**: 同一 Delegate を複数回呼び出しても、前回の実行結果が次回に漏れない
* **ライフサイクルの単純化**: 呼び出しごとに生成・使い捨てしても安全である

状態の保持・更新は、Delegate が依存として受け取る `MutableStateStream` や Repository に委ねる。Delegate 自身が「記憶」しない。

#### ステートレス原則の実装例

```dart
// 良い例: フィールドは final の依存参照のみ
@internal
class OnInputTextChangedDelegate {
  @internal
  final MutableStateStream<KanjiKanamajiriScreenState> state;

  const OnInputTextChangedDelegate({required this.state});

  Future<void> execute(String text) async {
    await state.updateWithLock((oldState, emitter) async {
      return emitter.emit(oldState.copyWith(inputText: text));
    });
  }
}
```

```dart
// 悪い例: execute 間で変化する mutable フィールドを持つ
@internal
class BadDelegate {
  int callCount = 0; // NG: Delegate 自身が状態を保持している

  Future<void> execute() async {
    callCount++; // NG: 呼び出しをまたいで内部状態が変化する
  }
}
```

### Delegate の基本構造のテンプレート

```dart
/// ${処理の説明}Delegate.
@internal
class ${処理名}Delegate {
  /// 呼び出し元クラスのプロパティのサブセット.
  @internal
  final ${依存型} ${依存名};

  const ${処理名}Delegate({
    required this.${依存名},
  });

  /// ${処理の説明}を実行する.
  ${呼び出し元と同等の戻り値型} execute(${呼び出し元と同等の引数}) {
    // 処理ロジック
  }
}
```

### Delegateの基本構造の実装例

呼び出し元（ViewModel）が保持する依存のサブセットを Delegate のコンストラクタに渡し、呼び出し元のメソッド引数はそのまま `execute` に渡す。

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen_view_model.action.dart
// ViewModel は extractAllowedKanjiUsecase, translateKanjiKanamajiriFunction, errorQueryUsecase, state を保持
// Delegate のコンストラクタにはこれらのサブセットを渡す
Future<void> onTapConvertButton() async {
  final delegate = OnTapConvertButtonDelegate(
    state: state,
    extractAllowedKanjiUsecase: extractAllowedKanjiUsecase,
    translateKanjiKanamajiriFunction: translateKanjiKanamajiriFunction,
    errorQueryUsecase: errorQueryUsecase,
  );
  await delegate.execute();
}
```

```dart
// data_repository_authentication_impl, firebase_account_repository_impl.dart
// Repository は stateStream, firebaseAuth, googleSignIn 等を保持
// signIn メソッドの引数 request は execute にそのまま渡す
@override
Future<AuthenticationResult> signIn(AuthenticationRequest request) async {
  final signInDelegate = SignInDelegate(
    stateStream: stateStream,
    auth: firebaseAuth,
    googleSignIn: googleSignIn,
    crashlytics: crashlytics,
    onDeviceLoginFunction: onDeviceLoginFunction,
    applicationMetadata: applicationMetadata,
    preferencesRepository: preferencesRepository,
  );
  return signInDelegate.execute(
    request: request,
    eulaVersion: eulaVersion.version,
  );
}
```

## Delegate の適用範囲

Delegate の適用範囲は特定の種類に限定されない。親クラスのメソッドが複雑になった場合、そのメソッドを Delegate として切り出すことが推奨される。以下は、本アプリで頻出する代表的な種類である。

| 種類 | 配置例 |
| -- | -- |
| ユーザー操作やイベントに対する処理 | `OnTapConvertButtonDelegate`、`SignInDelegate` |
| データアクセスや永続化 | `SignInDelegate`、`DatabaseSyncDelegate` |
| 画面遷移の判定ロジック | `RoutingRedirectDelegate` |
| アプリ起動時の初期化シーケンス | `StartUpDelegate` |

## 配置規則

### ディレクトリ配置

Delegate は、親クラスと同じパッケージ内の `delegate/` サブディレクトリに配置する。

```text
${親クラスを格納するパッケージ}/
├── ${親クラス名}.dart
└── delegate/
    ├── ${処理名}_delegate.dart
    └── ${別処理名}_delegate.dart
```

### 配置規則の補足

親クラスと同じパッケージ内の `delegate/` に置くことで、関連する処理を発見しやすくし、パッケージ外への露出を避けやすくする。

### 配置規則の実装例

```text
app_packages/screen/feature/kanji_kanamajiri/lib/src/viewmodel/
├── kanji_kanamajiri_screen_view_model.dart
├── kanji_kanamajiri_screen_view_model.action.dart
├── usecase/
│   └── screen_state_to_entity_delegate.dart
└── delegate/
    ├── on_initialize_delegate.dart
    ├── on_input_text_changed_delegate.dart
    ├── on_selected_grade_changed_delegate.dart
    └── on_tap_convert_button_delegate.dart
```

```text
app_packages/data/repository/authentication/_impl/lib/src/firebase_account_repository/
├── firebase_account_repository_impl.dart
└── delegate/
    ├── initialize_delegate.dart
    ├── sign_in_delegate.dart
    ├── sign_out_delegate.dart
    └── save_eula_agreement_version_delegate.dart
```

## インスタンス化のパターン

Delegate のインスタンス化には、依存関係とライフサイクルに応じて2つのパターンがある。

### パターン1: 呼び出しごとに生成

親クラスのメソッド内で、呼び出しのたびに Delegate を生成する。依存関係がその都度変わる場合や、親クラスが多くの依存を保持したくない場合に適する。

**ViewModel のアクション Delegate（`OnXxxxxDelegate`）は、常にこのパターンを採用する。** ViewModel フィールドとして保持せず、`onXXXX()` 内で都度生成・使い捨てとする。これは Delegate のステートレス原則を守るためである。

#### 呼び出しごとに生成の補足

Repository の各メソッドが異なる Delegate を必要とする場合、メソッド内で必要な依存を渡して Delegate を生成する。親クラスのフィールド数を抑えられる。

#### 呼び出しごとに生成の実装例

```dart
// data_repository_authentication_impl, firebase_account_repository_impl.dart
@override
Future<AuthenticationResult> signIn(
  AuthenticationRequest request,
) async {
  final signInDelegate = SignInDelegate(
    stateStream: stateStream,
    auth: firebaseAuth,
    googleSignIn: googleSignIn,
    crashlytics: crashlytics,
    onDeviceLoginFunction: onDeviceLoginFunction,
    applicationMetadata: applicationMetadata,
    preferencesRepository: preferencesRepository,
  );
  return signInDelegate.execute(
    request: request,
    eulaVersion: eulaVersion.version,
  );
}
```

### パターン2: フィールドとして保持

親クラスのコンストラクタで Delegate を生成し、フィールドとして保持する。同一 Delegate を複数回使用する場合に適する。

#### フィールドとして保持の補足

PreferencesRepository のように、初期化時に DatabaseSyncDelegate を起動し、edit 時に DatabaseEditDelegate を使用する場合、両方をフィールドとして保持する。

#### フィールドとして保持の実装例

```dart
// data_repository_preferences_impl, preferences_repository_impl.dart
final databaseSyncDelegate = DatabaseSyncDelegate(
  database: appDatabase,
  preferencesFactory: const db.PreferencesFactory(),
);

final databasePutDelegate = DatabaseEditDelegate(
  database: appDatabase,
);

final result = PreferencesRepositoryImpl._(
  stateStream: MutableStateStream(initial),
  databaseSyncDelegate: databaseSyncDelegate,
  databasePutDelegate: databasePutDelegate,
);
// ...
PreferencesRepositoryImpl._({
  required this.stateStream,
  required this.databaseSyncDelegate,
  required this.databasePutDelegate,
}) {
  databaseSyncDelegate.execute(stateStream);
}
```

## 命名規則

Delegate クラス名は、`${処理内容}Delegate` の形式とする。処理内容は動詞句または名詞句で、責務が明確になるようにする。

### 命名規則の補足

処理内容から責務が読み取れる名前にすることで、親クラスのオーケストレーションが追いやすくなる。

| パターン | 例 |
| -- | -- |
| ユーザーアクション | `OnTapConvertButtonDelegate`、`OnInitializeDelegate` |
| 処理 | `SignInDelegate`、`DatabaseSyncDelegate`、`RoutingRedirectDelegate` |

## 可視性

Delegate はパッケージ内部でのみ使用するため、`@internal` アノテーションを付与する。テストで必要となるプロパティには `@visibleForTesting` を付与する。

### 可視性の補足

Delegate は実装詳細であり、パッケージ外に公開すると依存境界が崩れる。`@internal` により API 境界を明示する。

## ナレッジベース

### DO: 1 Delegate = 1 `execute` メソッドとする

* Delegate は単一の機能のみを提供し、public メソッドは `execute` の1つだけとする。

### DO: コンストラクタは呼び出し元のプロパティのサブセットとする

* 親クラスが保持する依存のうち、その Delegate が必要とするもののみをコンストラクタ引数にする。

### DO: `delegate/` ディレクトリに配置する

* 親クラスと同じパッケージ内の `delegate/` に配置し、発見しやすくする。

### DO: ステートレスを守る

* フィールドは `final` の依存参照のみとし、`execute` をまたいで変化する mutable フィールドを持たない。

```dart
// 良い例: フィールドは final の依存参照のみ
@internal
class OnInputTextChangedDelegate {
  @internal
  final MutableStateStream<KanjiKanamajiriScreenState> state;

  const OnInputTextChangedDelegate({required this.state});

  Future<void> execute(String text) async {
    await state.updateWithLock((oldState, emitter) async {
      return emitter.emit(oldState.copyWith(inputText: text));
    });
  }
}
```

### DO NOT: 親クラスに複雑な処理を直書きする

* 理由: クラスが肥大化し、テストが困難になる。

### DO NOT: 1つの Delegate に複数の public メソッドを持たせる

* 理由: Delegate は `execute` のみを公開し、複数の機能を1つの Delegate に詰め込まない。

### DO NOT: Delegate をパッケージ外に公開する

* 理由: Delegate は実装詳細であり、`@internal` でパッケージ外への露出を防ぐ。

### DO NOT: Delegate をステートフルにする

* 理由: `execute` 間で変化する mutable フィールドを持たせない。カウンタ、キャッシュ、前回結果の保持などは Delegate 内に置かず、StateStream や Repository へ委ねる。

```dart
// 悪い例: execute 間で変化する mutable フィールドを持つ
@internal
class BadDelegate {
  int callCount = 0; // NG: Delegate 自身が状態を保持している

  Future<void> execute() async {
    callCount++; // NG: 呼び出しをまたいで内部状態が変化する
  }
}
```

### DO: Delegate 間の共通処理は package internal Usecase に切り出す

* 複数 Delegate が同じ処理（例: Storage 1 回 get、JWT パース）を共有するとき、**Delegate から Delegate を呼ばない**
* `_impl` 配下の `usecase/` に `@internal` Usecase を置き、各 Delegate がコンストラクタまたは都度生成で利用する
* 画面層の同様ルールは `flutter-layered-architecture-screen-mvvm` の `mvvm-viewmodel-design-action.md` を正とする
* 公開 Usecase 層（`app_packages/usecase/*` の IF/Impl）とは別物である。パッケージ内の実装詳細として閉じる

```dart
// DO: package internal Usecase
@internal
class FetchProfileImageUsecase {
  const FetchProfileImageUsecase({required this.storage, required this.uid});
  Future<ProfileImageImplState> execute() async { /* ... */ }
}

// WatchProfileImageStateDelegate / UpdateProfileImageDelegate の双方から利用
```

### DO: Repository / 親の公開メソッドは Delegate に委譲する

* Impl の public メソッド本体に put・再取得・map・distinct を直書きしない
* 変換だけの薄い Delegate が隣接する場合は、公開 `watch*` Delegate へ統合してよい（Map 専用クラスの乱立を避ける）

### DO NOT: Delegate in Delegate にする

* 理由: 共通ロジックが Delegate 層に閉じ、単体テストと Mock 注入が困難になる
* 対応: package internal Usecase に抽出し、各 Delegate は Usecase を呼ぶ

```dart
// DO NOT
return Stream.fromFuture(
  WatchProfileImageDelegate(storage: storage, uid: uid).execute(),
);
```

```dart
// DO
return Stream.fromFuture(
  FetchProfileImageUsecase(storage: storage, uid: uid).execute(),
);
```

### DO NOT: listen とほぼ同時に同じ現在値を先出し sync する

* 理由: `StateStream.stream.listen` が直後に現在値相当を届ける場合、初期 `updateWithLock` はタイミング差がほぼなく冗長
* 先出し sync が必要なのは、listen が現在値を流さない、または sync 無しだと直後の同期 API が壊れることが実証できるときに限る
