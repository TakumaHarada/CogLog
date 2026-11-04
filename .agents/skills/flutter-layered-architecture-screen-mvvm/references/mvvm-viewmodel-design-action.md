# ViewModel レイヤー / アクションメソッドと Delegate 分離

## 概要

本ドキュメントは、Widget から呼び出す **ViewModel アクション** の設計方針を定義する。
アクションは拡張メソッド `onXXXX()` として公開し、処理本体は **Delegate クラス** に分離する。ViewModel 本体は provider・状態・Entity・イベントの公開に専念し、アクションは `part` ファイルと `delegate/` 配下に整理する。

Delegate の基本構造（`execute` メソッド、コンストラクタ設計、命名）は **Delegate パターン** に従う。本ドキュメントは ViewModel アクションに特化した **必須ルール** を定める。

## 必須ルール

以下は ViewModel アクション実装における **必須** 事項である。例外は認めない。

| # | ルール | 理由 |
| - | -- | -- |
| 1 | Widget から呼び出すアクションは、すべて `onXXXX()` の **拡張メソッド** とする | View 層からの入口を命名で統一し、ViewModel 本体を肥大化させない |
| 2 | すべてのアクションは `{画面名}_screen_view_model.action.dart` に **part で分離** する | ViewModel 本体とアクションの責務をファイル単位で分離する |
| 3 | すべてのアクションは **Delegate パターン** に従い、`OnXxxxxDelegate` クラスとして分離する | 単一責務・テスト容易性・見通しの良さ |
| 4 | Delegate が必要とする State・Usecase・Repository 等は、**コンストラクタ引数** で受け取る | Unit Test で Mock 注入を容易にする |
| 4a | 画面固有 Usecase は **Delegate 内で `new` しない**。**`onXXXX()` 内**（Delegate を `new` するタイミング）で事前生成し、コンストラクタ注入する | 依存の明示とテスト容易性（無駄なインスタンス化のコストは受け入れる） |
| 5 | Delegate は **`execute` メソッドを 1 つ** 持ち、引数は対応する `onXXXX()` と **同一** とする | 呼び出し元メソッドと Delegate の対応を明確にする |
| 6 | Delegate は `onXXXX()` 内で **都度生成し、使い捨てる** | Delegate がフィールドを保持して Stateful になることを防ぐ |

### onXXXX() 拡張メソッドの補足

* アクションは ViewModel クラス本体に直接書かず、`part` ファイル内の **extension** に定義する。
* extension 名は `{画面名}ScreenViewModelActions` とする（例: `KanjiKanamajiriScreenViewModelActions`）。
* メソッド名は `on` + 動詞句（PascalCase）とする。例: `onInitialize`, `onInputTextChanged`, `onTapConvertButton`, `onChangeSortType`。
* 初期化処理も `initialize()` ではなく **`onInitialize()`** とする。

### onXXXX() 拡張メソッドの実装例

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen_view_model.action.dart
part of "kanji_kanamajiri_screen_view_model.dart";

@internal
extension KanjiKanamajiriScreenViewModelActions
    on KanjiKanamajiriScreenViewModel {
  Future<void> onInitialize() async { /* ... */ }
  Future<void> onInputTextChanged(String text) async { /* ... */ }
  Future<void> onTapConvertButton(FutureContext cancelContext) async { /* ... */ }
}
```

View 層からの呼び出し例:

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen.dart
useEffect(() {
  viewModel.onInitialize();
  return null;
}, [viewModel]);
```

### part ファイルへの分離の補足

* ViewModel 本体（`{画面名}_screen_view_model.dart`）に `part "{画面名}_screen_view_model.action.dart";` を宣言する。
* アクションファイル先頭は `part of "{画面名}_screen_view_model.dart";` とする。
* アクションファイル内では ViewModel の `@visibleForTesting` フィールド（`state`, Usecase 等）にアクセスできる。

### part ファイルへの分離の実装例

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen_view_model.dart
part "kanji_kanamajiri_screen_view_model.action.dart";
```

### Delegate 分離と使い捨てインスタンスの補足

各 `onXXXX()` は **オーケストレーションのみ** を担当する。処理本体は対応する `OnXxxxxDelegate` に委譲する。

* Delegate クラスは `lib/src/viewmodel/delegate/on_{動詞句}_delegate.dart` に配置する。
* クラス名は `On` + 動詞句（PascalCase）+ `Delegate` とする。例: `OnTapConvertButtonDelegate`, `OnInitializeDelegate`。
* `onXXXX()` 内で `final delegate = OnXxxxxDelegate(...)` として生成し、`delegate.execute(...)` を呼ぶ。**ViewModel のフィールドとして Delegate を保持しない。**

### Delegate 分離と使い捨てインスタンスの実装例

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen_view_model.action.dart
Future<void> onTapConvertButton(FutureContext cancelContext) async {
  final delegate = OnTapConvertButtonDelegate(
    state: state,
    extractAllowedKanjiUsecase: extractAllowedKanjiUsecase,
    translateKanjiKanamajiriUsecase: translateKanjiKanamajiriUsecase,
    queryErrorUsecase: queryErrorUsecase,
  );
  await delegate.execute(cancelContext: cancelContext);
}
```

## 処理フロー

```text
View (Widget)
  │  viewModel.onXXXX(args)
  ▼
Extension ({Screen}ViewModelActions)     ← part .action.dart
  │  final delegate = OnXxxxxDelegate(dependencies...)
  │  await delegate.execute(args)
  ▼
OnXxxxxDelegate                          ← delegate/on_xxxx_delegate.dart
  │  execute(args) { ビジネスロジック }
  ▼
StateStream / Usecase / Repository
```

## ファイルレイアウト

```text
lib/src/viewmodel/
├── {画面名}_screen_view_model.dart           # 本体（provider, state, entity, event, part 宣言）
├── {画面名}_screen_view_model.action.dart    # アクション拡張メソッド（part）【必須】
└── delegate/
    ├── on_initialize_delegate.dart           # OnInitializeDelegate
    ├── on_input_text_changed_delegate.dart   # OnInputTextChangedDelegate
    └── on_tap_convert_button_delegate.dart   # OnTapConvertButtonDelegate
```

**StateToEntityDelegate**（`entity` 変換用）と **アクション Delegate**（`onXXXX` 用）は責務が異なる。前者は State→Entity 変換の設計に従い ViewModel フィールドとして保持してよい。後者は本ドキュメントのルール 6 に従い、**都度生成・使い捨て** とする。

## Delegate クラスの実装

### Delegate クラスの基本構造の実装例

```dart
// screen_feature_kanji_kanamajiri, delegate/on_input_text_changed_delegate.dart
@internal
class OnInputTextChangedDelegate {
  @internal
  final MutableStateStream<KanjiKanamajiriScreenState> state;

  const OnInputTextChangedDelegate({
    required this.state,
  });

  Future<void> execute(String text) async {
    await state.updateWithLock((oldState, emitter) async {
      // 処理ロジック
    });
  }
}
```

### 依存が多いアクションの実装例

ViewModel が `ref.watch` で保持する外部依存は、`onXXXX()` から Delegate のコンストラクタへ渡す。

```dart
// screen_feature_kanji_kanamajiri, delegate/on_tap_convert_button_delegate.dart
@internal
class OnTapConvertButtonDelegate {
  @internal
  final MutableStateStream<KanjiKanamajiriScreenState> state;
  @internal
  final ExtractAllowedKanjiUsecase extractAllowedKanjiUsecase;
  @internal
  final TranslateKanjiKanamajiriUsecase translateKanjiKanamajiriUsecase;
  @internal
  final QueryErrorUsecase queryErrorUsecase;

  const OnTapConvertButtonDelegate({
    required this.state,
    required this.extractAllowedKanjiUsecase,
    required this.translateKanjiKanamajiriUsecase,
    required this.queryErrorUsecase,
  });

  Future<bool> execute({required FutureContext cancelContext}) async {
    // 変換処理
  }
}
```

* コンストラクタ引数は、その Delegate が **実際に使用する** 依存のサブセットとする。画面固有 Usecase も含め、すべて **`onXXXX()` 内で事前にインスタンス化したもの** を渡す。
* Delegate の `execute` 内で `Usecase(...)` を `new` してはならない（ViewModel 文脈の Usecase 設計に従う）。

### execute の戻り値の補足

* 原則として `onXXXX()` と `execute` の戻り値型は同一とする。
* `Future<void>` が一般的だが、処理の成否を呼び出し元に返す必要がある場合は `Future<bool>` 等もよい（例: `OnTapConvertButtonDelegate.execute`）。

## Unit Test

アクション Delegate は ViewModel 全体を経由せず、**Delegate 単体** でテストする。

```dart
// screen_feature_kanji_kanamajiri, test/viewmodel/delegate/on_input_text_changed_delegate_test.dart
late OnInputTextChangedDelegate delegate;
late MutableStateStream<KanjiKanamajiriScreenState> stateStream;

setUp(() {
  stateStream = MutableStateStream(/* 初期 State */);
  delegate = OnInputTextChangedDelegate(state: stateStream);
});

test("入力テキストが更新される", () async {
  await delegate.execute("テスト文章");
  expect(stateStream.state.inputText, "テスト文章");
});
```

* Usecase を Mock する場合は、コンストラクタに Mock インスタンスを渡す。
* テスト配置は `test/viewmodel/delegate/{delegate名}_test.dart` を推奨する。
* 詳細は ViewModel レイヤーの Unit Test 設計に従う。

## ナレッジベース

### DO: Widget 呼び出し口を onXXXX() 拡張メソッドに統一する

* すべてのアクションは `{画面名}_screen_view_model.action.dart` の extension に定義する。
* `onXXXX()` は Delegate の生成と `execute` 呼び出しのみに留める。

### DO: Delegate は都度生成する

* `OnXxxxxDelegate` は `onXXXX()` 内で生成・使い捨てる。
* DelegateがStatefulになることを抑止する。
* ViewModel のフィールドとして Delegate を保持しない。

```dart
Future<void> onTapConvertButton(FutureContext cancelContext) async {
  final delegate = OnTapConvertButtonDelegate(
    state: state,
    extractAllowedKanjiUsecase: extractAllowedKanjiUsecase,
    translateKanjiKanamajiriUsecase: translateKanjiKanamajiriUsecase,
    queryErrorUsecase: queryErrorUsecase,
  );
  await delegate.execute(cancelContext: cancelContext);
}
```

### DO: Delegateの依存はコンストラクタ注入する

* State・Usecase・Repository など、Delegate が必要とする依存はコンストラクタ引数で受け取る。
* Delegate / Usecase のテスタビリティ向上を担う。必要に応じて Mock を注入しやすくする。
* `execute` 内で依存を `new` しない。

```dart
// screen_feature_kanji_kanamajiri, delegate/on_tap_convert_button_delegate.dart
const OnTapConvertButtonDelegate({
  required this.extractAllowedKanjiUsecase,
  required this.translateKanjiKanamajiriUsecase,
  required this.queryErrorUsecase,
  required this.state,
});
```

### DO: internal Usecaseの依存はコンストラクタ注入する

* 画面固有の `@internal` Usecase が必要とする依存も、コンストラクタ引数で受け取る。
* Delegate / Usecase のテスタビリティ向上を担う。必要に応じて Mock を注入しやすくする。
* Usecase 内部で外部依存を直接解決せず、呼び出し元（`onXXXX()`）またはテストから注入する。

```dart
// screen_feature_kanji_practice2, usecase/process_input_text_usecase.dart
const ProcessInputTextUsecase({
  required this.state,
  required this.passageParseUsecase,
  required this.optimizePassageUsecase,
  required this.cancelParseUsecase,
  required this.applyInputTextStateUsecase,
});
```

```dart
// screen_feature_school_grade, usecase/school_grade_sort_load_usecase.dart
const SchoolGradeSortLoadUsecase({
  required this.preferencesRepository,
});
```

### DO: Delegate 間の共通処理は画面固有 internal Usecase に切り出す

* 複数 Delegate で共有するロジックは `@internal` の画面固有 Usecase とする。
* `onXXXX()` 内で Usecase を生成し、各 Delegate のコンストラクタへ注入する。

```dart
// screen_feature_example, usecase/validate_input_usecase.dart
@internal
class ValidateInputUsecase {
  const ValidateInputUsecase();

  Future<bool> execute(String text) async {
    // 複数 Delegate で共有する検証ロジック
  }
}

// screen_feature_example, example_screen_view_model.action.dart
Future<void> onInputTextChanged(String text) async {
  final validateInputUsecase = const ValidateInputUsecase();
  final delegate = OnInputTextChangedDelegate(
    state: state,
    validateInputUsecase: validateInputUsecase,
  );
  await delegate.execute(text);
}

Future<void> onTapSubmitButton() async {
  final validateInputUsecase = const ValidateInputUsecase();
  final delegate = OnTapSubmitButtonDelegate(
    state: state,
    validateInputUsecase: validateInputUsecase,
  );
  await delegate.execute();
}
```

### DO NOT: Delegate を ViewModel のフィールドとして保持する

* 理由: Delegate が状態を持ち、テスト・再利用が困難になる
* 理由: Stateful な Delegate は単一責務と使い捨て原則に反する

```dart
// 非推奨パターン
// DO NOT: ViewModel フィールドとしての Delegate 保持
final OnTapConvertButtonDelegate tapConvertButtonDelegate;
```

```dart
// 推奨される書き換えパターン
// DO: onXXXX() 内で都度生成する
Future<void> onTapConvertButton(...) async {
  final delegate = OnTapConvertButtonDelegate(...);
  await delegate.execute(...);
}
```

### DO NOT: Delegate の execute 内で Usecase を new する

* 理由: 依存が隠蔽され、Mock 注入が困難になる
* 理由: 画面固有 Usecase は `onXXXX()` 内で事前生成し、コンストラクタ注入する

```dart
// 非推奨パターン
// DO NOT: execute 内での Usecase new
Future<void> execute() async {
  final usecase = SomeUsecase(...);
}
```

```dart
// 推奨される書き換えパターン
// DO: onXXXX() 内で事前生成しコンストラクタ注入する
final usecase = SomeUsecase(...);
final delegate = OnXxxxxDelegate(usecase: usecase);
await delegate.execute();
```

### DO NOT: Delegate in Delegate およびコールバックによる共通化を行う

* 理由: 共通ロジックが Delegate 層に閉じ、Mock 注入・単体テストが困難になる
* 理由: コールバック（関数型引数・クロージャ）はテスタビリティが低い
* 対応: `@internal` 画面固有 Usecase に抽出し、各 Delegate は Usecase をコンストラクタ注入する

### DO NOT: ViewModel の Action を Delegate 分割せずに直接実装する

* 理由: `onXXXX()` に処理本体を直書きすると ViewModel / action.dart が肥大化する
* 理由: 処理中の一時フラグや購読管理を ViewModel の mutable フィールドに逃がしやすくなる
* 対応: オーケストレーション（Usecase `new` → Delegate `new` → `execute`）のみを `onXXXX()` に残し、本体は `OnXxxxxDelegate.execute` に置く

```dart
// 非推奨パターン
// DO NOT: action.dart に処理本体を直書きする
Future<void> onSave() async {
  await state.updateWithLock((old, emitter) async {
    // バリデーション・API・イベント発火をすべてここに書く
  });
}
```

```dart
// 推奨される書き換えパターン
// DO: Delegate に委譲する
Future<void> onSave() async {
  final delegate = OnSaveDelegate(
    state: state,
    accountRepository: accountRepository,
  );
  await delegate.execute();
}
```

### DO NOT: updateWithLock 内で長時間の I/O・RPC を行う

* 理由: ロック中は他の `updateWithLock`（入力変更等）が待ち、UX とキャンセル挿入が壊れる
* 対応: (1) 短ロックで状態遷移 (2) ロック外で通信 (3) 短ロックで結果反映

```dart
// DO NOT: 通信を updateWithLock 内に置く
await state.updateWithLock((old, emitter) async {
  await emitter.emit(old.copyWith(isSaving: true));
  final result = await repository.update(...); // NG
  await emitter.emit(...);
});
```

```dart
// DO: 通信はロック外
await state.updateWithLock((old, emitter) async {
  await emitter.emit(old.copyWith(isSaving: true));
});
final result = await repository.update(...);
await state.updateWithLock((old, emitter) async {
  await emitter.emit(old.copyWith(isSaving: false));
});
```
