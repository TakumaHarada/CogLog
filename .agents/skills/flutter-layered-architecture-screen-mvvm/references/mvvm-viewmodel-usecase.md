# ViewModel レイヤー / ViewModel文脈のUsecase

## 概要

ViewModel 文脈の **Usecase** は、**その画面固有のビジネスロジック** を担当するコンポーネントである。Usecase レイヤー（アプリ横断のユースケース）よりも **画面固有の事情を反映したもの** であり、同一画面の ViewModel からだけ利用されることを前提とする。

複雑なビジネスロジックを ViewModel から切り出し、単体テストや Delegate との組み合わせを容易にするために用いる。配置は `lib/src/viewmodel/usecase/` とする。

## Delegate や Usecase レイヤーとの違い

* **ViewModel 文脈の Usecase** は「その画面固有のビジネスロジック」であり、「Usecase レイヤーよりも画面固有の事情を反映したもの」である。アプリ横断の Usecase レイヤーとは役割が異なる。
* **すべて `@internal` が基本** である。パッケージ外に公開しない。
* **Delegate** は「メソッドの外部化」である。一方、**Usecase への切り出し** は次の目的で行う。
  * **ビジネスロジックの切り出し**: 複雑な判断・計算・フローを ViewModel から分離する。
  * **Delegate と組み合わせて Mock を用意することによる Unit Test のカバレッジ向上**: 画面固有 Usecase を差し替えることで、ViewModel や Delegate のテストがしやすくなる。
  * **Delegate 間のロジック共通化**: 複数の Delegate が参照する共通ロジックを Usecase に集約する。
* **1 クラス 1 機能** とする。単一責務を守る。
* **冪等性は問わない**。内部で `StateStream` の操作を行ってもよいし、冪等な結果を返却してもよい。画面固有の都合に合わせて設計する。
* **Internal 専用** であるため、**Provider による DI は不要** である。画面固有 Usecase のインスタンス化は **Delegate を `new` する `onXXXX()` 内** で行う。ただし、**外部レイヤー（Data 層・Usecase 層・Infra 層など）のインターフェースを利用する場合** には、ViewModel の provider で DI（`ref.watch` 等）し、ViewModel のフィールドとして保持する。
* **コンストラクタ注入が必須** である。Delegate が利用する画面固有 Usecase は、Delegate 内で `new` せず、**`onXXXX()` 内で事前にインスタンス化してコンストラクタ引数で渡す**。未使用の Usecase が含まれてもよい（無駄なインスタンス化のコストは受け入れる）。

## 責務と配置

* **責務**: 画面固有のビジネスロジック（複数 Delegate で共有するロジック、テストで切り出したい判断・計算など）を 1 クラスで担当する。
* **配置場所**: `lib/src/viewmodel/usecase/`。ファイル名は `{機能名}_usecase.dart` など、責務が分かる名前にする。
* **可視性**: `@internal` を付与し、同一パッケージ内からのみ利用する。

## 実装のポイント

* **1 クラス 1 機能**: 一つの Usecase クラスは一つの責務のみ持つ。
* **外部レイヤーは ViewModel の provider で DI**: 画面外の Repository・Usecase 層・Infra のインターフェースは、ViewModel の provider で `ref.watch` し、ViewModel のフィールドとして保持する。
* **画面固有 Usecase は `onXXXX()` 内で `new`**: Provider による DI を行わない画面固有 Usecase は、ViewModel の provider では生成しない。Delegate を `new` する **`onXXXX()` 内** でインスタンス化し、Delegate のコンストラクタ引数として渡す。Delegate の `execute` 内で `Usecase(...)` を `new` してはならない。
* **無駄なインスタンス化のコストは受け入れる**: ある `onXXXX()` が一部の Usecase しか使わなくても、Delegate に渡す Usecase は事前にすべて生成してよい。テスト容易性と依存の明示を優先する。
* **冪等性**: 必須としない。StateStream の更新を行っても、純粋に値を返すだけでもよい。
* **public メソッド**: Delegate と同様に `execute` を 1 つ持つ形を推奨するが、StateStream の購読開始など「開始メソッド」が必要な場合は `start` など別名でもよい（1 クラス 1 機能の範囲で）。

## 実装例（ワークスペース）

### 値を返す Usecase（Delegate 経由）の実装例

画面固有 Usecase は `onXXXX()` 内で生成し、Delegate にはコンストラクタ注入する。外部 Repository は ViewModel の provider で DI 済みのフィールドを参照する。

```dart
// screen_feature_school_grade, usecase/school_grade_sort_load_usecase.dart
/// ソート順をPreferencesから読み込むUsecase.
@internal
class SchoolGradeSortLoadUsecase {
  final PreferencesRepository preferencesRepository;

  const SchoolGradeSortLoadUsecase({
    required this.preferencesRepository,
  });

  /// Preferencesからソート順を読み込む.
  Future<SchoolGradeSortType> execute() async {
    // ...
  }
}
```

ViewModel の provider では **外部レイヤーのみ DI** する（画面固有 Usecase は生成しない）:

```dart
// screen_feature_school_grade, school_grade_screen_view_model.dart
static final provider = Provider.autoDispose<SchoolGradeScreenViewModel>(
  (ref) {
    final preferencesRepository = ref.watch(PreferencesRepository.provider);
    final kanjiListBySchoolGradeUsecase = ref.watch(
      KanjiListBySchoolGradeUsecase.provider,
    );
    return SchoolGradeScreenViewModel._(
      state: MutableStateStream(/* ... */),
      kanjiListBySchoolGradeUsecase: kanjiListBySchoolGradeUsecase,
      preferencesRepository: preferencesRepository,
    );
  },
  dependencies: [
    PreferencesRepository.provider,
    KanjiListBySchoolGradeUsecase.provider,
  ],
);
```

Delegate には `onXXXX()` 内で生成した Usecase をコンストラクタ注入する（Delegate 内では `new` しない）:

```dart
// screen_feature_school_grade, delegate/on_initialize_delegate.dart
@internal
class OnInitializeDelegate {
  final MutableStateStream<SchoolGradeScreenState> state;
  final KanjiListBySchoolGradeUsecase kanjiListBySchoolGradeUsecase;
  final SchoolGradeSortLoadUsecase schoolGradeSortLoadUsecase;

  const OnInitializeDelegate({
    required this.state,
    required this.kanjiListBySchoolGradeUsecase,
    required this.schoolGradeSortLoadUsecase,
  });

  Future<void> execute() async {
    await state.updateWithLock((oldState, emitter) async {
      final savedSortType = await schoolGradeSortLoadUsecase.execute();
      // ...
    });
  }
}
```

```dart
// screen_feature_school_grade, school_grade_screen_view_model.action.dart
Future<void> onInitialize() async {
  final schoolGradeSortLoadUsecase = SchoolGradeSortLoadUsecase(
    preferencesRepository: preferencesRepository,
  );
  final delegate = OnInitializeDelegate(
    state: state,
    kanjiListBySchoolGradeUsecase: kanjiListBySchoolGradeUsecase,
    schoolGradeSortLoadUsecase: schoolGradeSortLoadUsecase,
  );
  await delegate.execute();
}
```

同様に、`SchoolGradeSortSaveUsecase` は `onChangeSortType()` 内で生成し、`OnChangeSortTypeDelegate` に注入する。ViewModel は `preferencesRepository` を `ref.watch` で受け取り、画面固有 Usecase のコンストラクタへ渡す。

### StateStream を操作する Usecase の実装例

認証状態や他リポジトリのストリームを購読し、ViewModel の `MutableStateStream` を更新する画面固有 Usecase がある。

**推奨（Unit Test で初期化を明示したい画面）**: `onInitialize()` 内で Usecase を `new` し、`OnInitializeDelegate` 経由で `start()` する。ルート Screen の `useEffect` から `onInitialize()` を呼ぶ。Provider / コンストラクタから開始しない（[mvvm-widget.md](./mvvm-widget.md)、[mvvm-viewmodel-design.md](./mvvm-viewmodel-design.md)）。

```dart
// onInitialize → Delegate → AccountProfileSyncUsecase.start(state)
Future<void> onInitialize() async {
  final profileSyncUsecase = AccountProfileSyncUsecase(...);
  final delegate = OnInitializeDelegate(
    state: state,
    profileSyncUsecase: profileSyncUsecase,
  );
  delegate.execute();
}
```

**既存パターン（コンストラクタ開始）**: 歴史的には ViewModel コンストラクタ内で Usecase を `new` し `start()` する例もある。新規画面やテスタビリティを優先する場合は上記の `onInitialize` を選ぶ。

```dart
// screen_feature_settings2, settings_screen_view_model.dart（既存例）
SettingsScreenViewModel._({
  required this.data,
  required this.authenticationRepository,
  required this.preferencesRepository,
}) {
  // 既存パターン: コンストラクタで購読開始。
  // 新規では onInitialize + useEffect を優先する。
  SettingsSyncUsecase(
    authenticationRepository: authenticationRepository,
  ).start(data);
}
```

Delegate 経由で画面固有 Usecase を使う場合は、パターン1に従い `onXXXX()` 内で `new` する。

### 複数 Delegate で共有する Usecase の実装例

`onClearText` が `onInputText("")` と等価な場合のように、複数のアクションが同一フローを共有する場合は、**Delegate 内で別 Delegate を呼ばず**、共通ロジックを画面固有 Usecase に切り出す。各 Delegate は Usecase をコンストラクタ注入して `execute` する。

```dart
// screen_feature_kanji_practice2, usecase/process_input_text_usecase.dart
@internal
class ProcessInputTextUsecase {
  const ProcessInputTextUsecase({
    required this.state,
    required this.passageParseUsecase,
    required this.optimizePassageUsecase,
  });

  Future<void> execute(String newText) async {
    // インクリメンタルパース本体
  }
}

// screen_feature_kanji_practice2, kanji_practice_screen_view_model.action.dart
Future<void> onInputText(String newText) async {
  final processInputTextUsecase = ProcessInputTextUsecase(/* ... */);
  final delegate = OnInputTextDelegate(
    processInputTextUsecase: processInputTextUsecase,
  );
  await delegate.execute(newText);
}

Future<void> onClearText() async {
  final processInputTextUsecase = ProcessInputTextUsecase(/* ... */);
  final delegate = OnClearTextDelegate(
    processInputTextUsecase: processInputTextUsecase,
  );
  await delegate.execute(); // 内部で usecase.execute("")
}
```

### ディレクトリ構成の実装例

```text
app_packages/screen/feature/school_grade/lib/src/viewmodel/
├── school_grade_screen_view_model.dart
├── school_grade_screen_view_model.action.dart
├── usecase/
│   ├── school_grade_sort_load_usecase.dart   # ソート順の読み込み
│   ├── school_grade_sort_save_usecase.dart   # ソート順の保存
│   └── school_grade_screen_state_to_entity_delegate.dart
├── delegate/
│   └── ...
└── ...
```

```text
app_packages/screen/feature/home2/lib/src/viewmodel/
├── home_screen_view_model.dart
└── usecase/
    └── (画面固有 Usecase が必要な場合)
```

```text
app_packages/screen/feature/settings2/lib/src/viewmodel/
├── settings_screen_view_model.dart
└── usecase/
    └── settings_sync_usecase.dart   # 認証状態の監視・State 更新（既存例はコンストラクタ start。新規は onInitialize 優先）
```

## 関連文書

* ViewModel の基本設計・構成は [mvvm-viewmodel-design.md](mvvm-viewmodel-design.md) を参照する。
* Delegate の設計・配置は Delegate パターン（および [mvvm-viewmodel-entity.md](mvvm-viewmodel-entity.md) の StateToEntityDelegate）を参照する。

## ナレッジベース

### DO: 画面固有のビジネスロジックは Usecase に切り出す

* 複雑な判断・計算・フローを ViewModel から分離し、1 クラス 1 機能とする。
* `@internal` を付与し、パッケージ外に公開しない。

### DO: Delegate 経由の画面固有 Usecase は onXXXX() 内で new する

* ViewModel の provider では生成せず、Delegate には生成済みインスタンスをコンストラクタ注入する。
* 無駄なインスタンス化のコストは受け入れ、依存の明示とテスト容易性を優先する。

```dart
Future<void> onInitialize() async {
  final schoolGradeSortLoadUsecase = SchoolGradeSortLoadUsecase(
    preferencesRepository: preferencesRepository,
  );
  final delegate = OnInitializeDelegate(
    state: state,
    kanjiListBySchoolGradeUsecase: kanjiListBySchoolGradeUsecase,
    schoolGradeSortLoadUsecase: schoolGradeSortLoadUsecase,
  );
  await delegate.execute();
}
```

### DO: 外部レイヤーのインターフェースは ViewModel の provider で DI する

* Repository・Usecase 層・Infra は `ref.watch` し、ViewModel のフィールドとして保持する。
* 画面固有 Usecase のコンストラクタへ渡す。

### DO NOT: Delegate の execute 内で Usecase を new する

* 理由: 依存が隠蔽され、Mock 注入が困難になる
* 理由: `onXXXX()` 内で事前にインスタンス化し、コンストラクタ引数で渡す

```dart
// 非推奨パターン
// DO NOT: execute 内での Usecase new
Future<void> execute() async {
  final usecase = SchoolGradeSortLoadUsecase(...);
}
```

```dart
// 推奨される書き換えパターン
// DO: onXXXX() 内で事前生成しコンストラクタ注入する
final usecase = SchoolGradeSortLoadUsecase(...);
final delegate = OnInitializeDelegate(schoolGradeSortLoadUsecase: usecase);
```

### DO NOT: Delegate in Delegate を行う

* 理由: 共通ロジックが Delegate 層に閉じ、Mock 注入・単体テストが困難になる
* 理由: 共通ロジックを `@internal` 画面固有 Usecase に抽出し、各 Delegate は Usecase をコンストラクタ注入する

### DO NOT: ViewModel の provider で画面固有 Usecase をフィールドとして保持する

* 理由: Delegate 経由で使う場合、未使用の Usecase が ViewModel に残る
* 理由: `onXXXX()` 内で `new` し、Delegate のコンストラクタへ渡す（ライフサイクル購読開始も、新規では `onInitialize` 経由を優先）

### DO NOT: 新規画面でストリーム購読開始をコンストラクタや Provider から行う

* 理由: Unit Test で初期化を明示できず、初期化待ちが不安定になる
* 理由: `onInitialize()` + ルート Screen の `useEffect` に寄せる（[mvvm-widget.md](./mvvm-widget.md)）
