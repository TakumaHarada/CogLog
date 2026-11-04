# ViewModel レイヤー / Unit Test

## 概要

本ドキュメントは、**ViewModel** および ViewModel まわりの **Delegate**・**画面固有 Usecase** の Unit Test のやり方をまとめる。

* **ViewModel**: `state`, `event`, `entity` の各 Stream を監視し、状態遷移やイベント発火を検証する。Stream を `listen` してリストに蓄積し、期待される状態・イベントが発生したことを assert するパターンを推奨する。
* **Delegate**: StateToEntityDelegate は入力を組み立てて変換結果の Entity を検証する。アクション用 Delegate は依存を Mock し、`execute()` 前後の状態と副作用を検証する。
* **Usecase（画面固有）**: テスト用の依存注入の後、Usecase を直接生成し、`execute()` の戻り値や Repository の読み直しで検証する。

## テストの基本構成

```dart
// app_packages/screen/feature/home2/test/home_screen_view_model_test.dart
import "package:armyknife_dartx/armyknife_dartx.dart";
import "package:flutter_test/flutter_test.dart";
import "package:riverpod_container_async_test/riverpod_container_async_test.dart";
import "package:screen_feature_home2/src/viewmodel/entity/home_screen_entity.dart";
import "package:screen_feature_home2/src/viewmodel/home_screen_view_model.dart";
import "package:screen_feature_home2/src/viewmodel/state/home_screen_event.dart";
import "package:screen_feature_home2/src/viewmodel/state/home_screen_state.dart";
import "package:testing_core/testing_core.dart";
import "package:testing_injection/testing_injection.dart";

void main() {
  late HomeScreenViewModel viewModel;
  late List<HomeScreenEvent> debugEvents;
  late List<HomeScreenEntity> debugEntities;
  late List<HomeScreenState> debugStates;

  setUp(() async {
    debugEvents = [];
    debugEntities = [];
    debugStates = [];
    await testContext.injectForTesting();
  });

  Future<void> configure() async {
    viewModel = await ref.testReady(HomeScreenViewModel.provider);
    viewModel.event
        .where((e) => e is! HomeScreenEventNothing)
        .listen(debugEvents.add);
    viewModel.entity.stream.listen(debugEntities.add);
    viewModel.state.stream.listen(debugStates.add);
    await nop();
  }

  // テストケース...
}
```

## Stream監視パターン（推奨）

### Stream監視の設定の補足

`configure` メソッドでViewModelの初期化とStreamの監視設定を行う。
`nop()` を使用して、初期状態の反映完了を待機する。

### Stream監視の設定の実装例

```dart
Future<void> configure() async {
  viewModel = await ref.testReady(HomeScreenViewModel.provider);

  // eventストリームを監視（nothingイベントは除外）
  viewModel.event
      .where((e) => e is! HomeScreenEventNothing)
      .listen(debugEvents.add);

  // entityストリームを監視
  viewModel.entity.stream.listen(debugEntities.add);

  // stateストリームを監視
  viewModel.state.stream.listen(debugStates.add);

  // 非同期処理の完了を待つ
  await nop();
}
```

### イベント発火の検証の実装例

アクション実行後に、期待されるイベントが `debugEvents` リストに追加されていることを検証する。

```dart
test("操作によりイベントが発火する", () async {
  await configure();

  // 初期状態ではイベントは発火していない
  expect(debugEvents, isEmpty);

  // アクションを実行
  await viewModel.onSomeAction();

  // 期待するイベントが発火している
  expect(debugEvents, isNotEmpty);
  expect(debugEvents.last, isA<HomeScreenEventNavigateToNextScreen>());
});
```

### Entity変更の検証の実装例

アクション実行後に、`debugEntities` リストの最新状態が期待通りであることを検証する。

```dart
test("タブを選択するとEntityが更新される", () async {
  await configure();

  await viewModel.onTabSelected(newIndex: 1);

  // Entityの最新状態を検証
  expect(debugEntities.last.selectedTabIndex, 1);
});
```

### State遷移の検証の実装例

`debugStates` リストを確認し、状態遷移の過程や最終状態を検証する。

```dart
test("状態遷移が正しく行われる", () async {
  await configure();

  // 初期状態を確認
  expect(debugStates.first, isA<HomeScreenStateInitial>());

  // アクションを実行
  await viewModel.onLoadData();

  // 状態遷移を検証（loading → loaded）
  expect(debugStates, hasLength(greaterThan(1)));
  expect(debugStates.last, isA<HomeScreenStateLoaded>());
});
```

## 直接状態アクセスパターン

シンプルなテストケースでは、Streamを監視せずに現在の状態を直接アクセスすることも可能。
ただし、状態遷移の過程を検証できないため、注意が必要。

```dart
test("初期状態が取得できる", () async {
  await configure();

  // 現在の状態を直接取得
  expect(viewModel.state.state, isA<HomeScreenState>());
  expect(viewModel.state.state.event, isA<HomeScreenEventNothing>());

  // 現在のEntityを直接取得
  final entity = viewModel.entity.state;
  expect(entity, isNotNull);
});
```

## テストグループの構成例

`group` を使用して、初期化時のテストと操作時のテストを構造化する。

```dart
void main() {
  // ... 変数定義 ...

  setUp(() async {
    // ... 初期化 ...
  });

  Future<void> configure() async {
    // ... 設定 ...
  }

  group("初期化", () {
    setUp(() async {
      await configure();
      expect(debugEvents, isEmpty);
    });

    test("初期状態が取得できる", () async {
      // ... 検証 ...
    });
  });

  group("操作", () {
    setUp(() async {
      await configure();
      expect(debugEvents, isEmpty);
    });

    test("タブを選択する", () async {
      // ... 操作と検証 ...
    });
  });
}
```

## Delegate のテスト

ViewModel まわりの **Delegate**（StateToEntityDelegate およびアクション用 Delegate）は、ViewModel から切り出された単一責務のクラスである。単体テストで振る舞いを検証することで、ViewModel テストの負荷を下げたり、変換ロジック・アクションロジックの網羅率を上げたりできる。

### StateToEntityDelegate のテストの補足

StateToEntityDelegate は `ScreenState` を引数に取り `ScreenEntity` を返す。依存は持たず、変換は冪等である。

* **セットアップ**: `setUp` で `delegate = const StateToEntityDelegate();` のようにインスタンス化する。
* **状態の組み立て**: テスト用の `ScreenState` を組み立てるヘルパー（例: `createState({ ... })`）を用意し、検証したいプロパティだけを差し替える。
* **検証**: `delegate.execute(state)` または `delegate.mapStateToEntity(state)`（コードベースによる）を呼び、返却された Entity のプロパティを `expect` する。
* **グループ化**: Entity のセクション単位（ResultSection, InputSection, UserActionSection など）で `group()` を分けると読みやすい。

### StateToEntityDelegate のテストの実装例

```dart
// screen_feature_kanji_kanamajiri, test/viewmodel/delegate/screen_state_to_entity_delegate_test.dart
void main() {
  late ScreenStateToEntityDelegate delegate;

  setUp(() {
    delegate = const ScreenStateToEntityDelegate();
  });

  KanjiKanamajiriScreenState createState({
    String? inputText,
    String? resultText,
  }) {
    return KanjiKanamajiriScreenState(
      context: FutureContext(tag: "test"),
      inputText: inputText ?? "",
      resultText: resultText,
      // ...
    );
  }

  group("ResultSectionEntity", () {
    test("resultText が null の場合、text は空文字で isCopyButtonVisible は false", () {
      final state = createState(resultText: null);
      final entity = delegate.mapStateToEntity(state);  // または delegate.execute(state)
      expect(entity.resultSection.text, "");
      expect(entity.resultSection.isCopyButtonVisible, false);
    });
  });
}
```

### アクション用 Delegate のテストの補足

アクション用 Delegate は、コンストラクタで `MutableStateStream` や外部 Usecase などを受け取り、`execute()` で状態を更新したり副作用を行ったりする。

* **依存のモック**: 外部 Usecase・Repository・Function などは `mocktail` 等で Mock 化し、`when(() => mock.execute(any())).thenAnswer(...)` で振る舞いを定義する。`setUpAll` で `registerFallbackValue` を登録する。
* **StateStream**: `MutableStateStream<ScreenState>` をテスト内で生成し、Delegate に渡す。`tearDown` で `stateStream.close()` を呼ぶ。
* **検証**: アクション前に `stateStream.updateWithLock` で状態をセットし、`await delegate.execute()` の後に `stateStream.state` やモックの `verify` で結果を検証する。
* **グループ化**: 「正常系」「エラーハンドリング」「多重実行防止」「キャンセル処理」などで `group()` を分けるとよい。

### アクション用 Delegate のテストの実装例

```dart
// screen_feature_kanji_kanamajiri, test/viewmodel/delegate/on_tap_convert_button_delegate_test.dart
void main() {
  late OnTapConvertButtonDelegate delegate;
  late MockExtractAllowedKanjiUsecase mockExtractUsecase;
  late MutableStateStream<KanjiKanamajiriScreenState> stateStream;

  setUpAll(() {
    registerFallbackValue(const ExtractAllowedKanjiRequest(...));
  });

  setUp(() {
    mockExtractUsecase = MockExtractAllowedKanjiUsecase();
    stateStream = MutableStateStream(KanjiKanamajiriScreenState(...));
    delegate = OnTapConvertButtonDelegate(
      state: stateStream,
      extractAllowedKanjiUsecase: mockExtractUsecase,
    );
  });

  tearDown(() async {
    await stateStream.close();
  });

  group("正常系", () {
    test("変換が成功し、結果が反映される", () async {
      when(() => mockExtractUsecase.execute(any())).thenAnswer(
        (_) async => ExtractAllowedKanjiResult.success(allowedKanji: {}),
      );
      await stateStream.updateWithLock((oldState, emitter) async {
        return emitter.emit(oldState.copyWith(inputText: "山の上から"));
      });
      await delegate.execute();
      final finalState = stateStream.state;
      expect(finalState.resultText, isNotEmpty);
    });
  });
}
```

## Usecase（画面固有）のテスト

**画面固有の Usecase**（ViewModel 文脈の Usecase）は、`lib/src/viewmodel/usecase/` に配置される。外部レイヤー（Repository など）をコンストラクタで受け取り、`execute()` で読み書きや計算を行う。

* **依存の取得**: テストでは `testContext.injectForTesting()` の後、`ref.testReady(SomeRepository.provider)` でテスト用の Repository を取得する。本番と同様の Fake やテスト用実装が注入される。
* **Usecase の生成**: 取得した Repository をコンストラクタに渡して Usecase を生成する。ViewModel の provider を経由せず、テスト内で直接インスタンス化してよい。
* **検証**: `execute()` の戻り値を検証するか、Repository に書き込んだ後に `ref.testReady` や `repository.get()` で読み直して検証する。非同期の永続化がある場合は `testContext.notifyDB()` 等で反映を待ってから検証する。

```dart
// screen_feature_school_grade, test/school_grade_sort_load_usecase_test.dart
void main() {
  late SchoolGradeSortLoadUsecase usecase;
  late PreferencesRepository preferencesRepository;

  setUp(() async {
    await testContext.injectForTesting();
    preferencesRepository = await ref.testReady(PreferencesRepository.provider);
    usecase = SchoolGradeSortLoadUsecase(
      preferencesRepository: preferencesRepository,
    );
  });

  group("SchoolGradeSortLoadUsecase", () {
    test("Preferencesの読み込み成功ケース（昇順）", () async {
      await preferencesRepository.edit(
        PreferenceEditRequest.putInt(
          key: PreferenceKey.schoolGradeSortType,
          value: SchoolGradeSortType.gradeAscending.prefValue,
        ),
      );
      final result = await usecase.execute();
      expect(result, SchoolGradeSortType.gradeAscending);
    });
  });
}
```

```dart
// screen_feature_school_grade, test/school_grade_sort_save_usecase_test.dart
  test("Preferencesへの保存成功ケース（昇順）", () async {
    await usecase.execute(SchoolGradeSortType.gradeAscending);
    final preference = preferencesRepository.get(
      PreferenceKey.schoolGradeSortType,
      defaultValue: Preference.fromInt(...),
    );
    expect(preference.asInt, SchoolGradeSortType.gradeAscending.prefValue);
  });
```

## テスト用ユーティリティ

### `testContext.injectForTesting()`

テスト環境向けの依存注入を行うユーティリティ。`testing_injection` パッケージで提供される。
Fake実装やMockを注入するために使用する。

### `ref.testReady()`

Providerが準備完了するまで待機し、インスタンスを取得するユーティリティ。`riverpod_container_async_test` パッケージで提供される。
非同期初期化を行うProviderのテストに必須。

### `nop()`

非同期処理の完了を待機するユーティリティ。
Streamの初期化や、非同期処理の完了を待つために使用する。
内部的には `Future.delayed(Duration.zero)` と同等だが、意図を明確にするために使用する。

## ナレッジベース

### DO: Stream監視パターンで state / event / entity を検証する

* `configure()` で ViewModel を `ref.testReady()` 取得し、各 Stream を listen してリストに蓄積する。
* event 監視時は `where((e) => e is! *EventNothing)` でノイズを除外する。
* Stream 監視設定後は `await nop()` で非同期処理の完了を待機する。

```dart
Future<void> configure() async {
  viewModel = await ref.testReady(HomeScreenViewModel.provider);
  viewModel.event
      .where((e) => e is! HomeScreenEventNothing)
      .listen(debugEvents.add);
  viewModel.entity.stream.listen(debugEntities.add);
  viewModel.state.stream.listen(debugStates.add);
  await nop();
}
```

### DO: Delegate と画面固有 Usecase を単体テストする

* StateToEntityDelegate は状態ヘルパーで入力を組み立て、返却 Entity を検証する。
* アクション用 Delegate は依存を Mock し、`MutableStateStream` と `execute()` の前後で状態・verify を検証する。
* 画面固有 Usecase は依存を Mock または `ref.testReady(Repository.provider)` で取得し、直接インスタンス化して検証する。
* Repository の Action（`Update*Delegate` / package internal Usecase）も `_impl/test` で単体テストしてよい。VM 結合だけで担保しない。

### DO: Repository 依存は Mock + overrideWithValue を既定とする

* `injectForTesting()` の後、対象 Repository を Mock で上書きする。
* `watch` 系は `MutableStateStream` / `StreamController` を stub し、テストから emit する。
* Testing\* Repository（`emitProfile` / `updateProfileHandler` 等）は、認証のように振る舞いが厚い場合を除き新規追加しない。

```dart
await testContext.injectForTesting();
final mockRepo = _MockAccountRepository();
when(() => mockRepo.watchProfile()).thenAnswer((_) => profileStream.stream);
refBuilder.override(
  AccountRepository.provider,
  AccountRepository.provider.overrideWithValue(mockRepo),
);
```

### DO: テストグループを機能単位で構造化する

* 「初期化」「操作」などの機能単位で `group()` を分けて整理する。

### DO NOT: テストで ViewModel を直接インスタンス化する

* 理由: Provider による DI・ライフサイクルをバイパスし、本番と異なる経路になる
* 理由: `ref.testReady()` を使用して Provider から取得する

```dart
// 非推奨パターン
// DO NOT: ViewModel の直接 new
final viewModel = HomeScreenViewModel._(...);
```

```dart
// 推奨される書き換えパターン
// DO: Provider 経由で取得する
viewModel = await ref.testReady(HomeScreenViewModel.provider);
```

### DO NOT: event ストリーム監視で nothing イベントを含めたまま検証する

* 理由: nothing がノイズとなり、発火検証が不安定になる
* 理由: `where((e) => e is! *EventNothing)` で除外する
