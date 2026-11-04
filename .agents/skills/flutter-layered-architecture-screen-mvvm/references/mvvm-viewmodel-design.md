# ViewModel レイヤー / 基本設計

## 概要

本ドキュメントは、ViewModel レイヤーの**基本設計事項**を定義する。
1 画面 1 ViewModel のスコープ、Riverpod の役割、状態・Entity・イベントの公開方法、ライフサイクル、ファイルレイアウトを定め、実装の一貫性を保つために参照する。
責務（状態管理・ビジネスロジック統合・UI状態提供・イベント通知）と構成（ViewModel, ScreenState, ScreenEntity, ScreenEvent, StateToEntityDelegate, Usecase/Delegate）は本ドキュメントの基本設計・ファイルレイアウトおよび [mvvm-viewmodel-state.md](./mvvm-viewmodel-state.md)・[mvvm-viewmodel-entity.md](./mvvm-viewmodel-entity.md)・[mvvm-viewmodel-event.md](./mvvm-viewmodel-event.md)・[mvvm-viewmodel-usecase.md](./mvvm-viewmodel-usecase.md)・[mvvm-viewmodel-design-action.md](./mvvm-viewmodel-design-action.md) を参照する。

## 基本設計

* **1画面 = 1ViewModel**: 1 画面につき 1 つの専用設計された ViewModel を持つことを基本とする。適切にスコープを切り出し、互いに素であるならば柔軟に対応する（タブの親子構造など）。
* **internal 属性**: ViewModel クラスは `@internal` を付与し、パッケージ外から直接参照されないようにする。
* **Riverpod の役割**: Riverpod への依存は、**DI によるインターフェースの解決**と**ライフサイクル解決**に限る。`@riverpod` は用いず、`static final provider = Provider.autoDispose<...>(...)` を ViewModel に定義する。
* **ViewModel.provider**: 各 ViewModel は `ViewModel.provider`（`Provider.autoDispose<ViewModel>`）を持ち、画面破棄時にインスタンスが破棄される。
* **private コンストラクタ**: ViewModel は private コンストラクタ（`ViewModel._(...)`）を持ち、インスタンスは Provider のコールバック内からのみ作成する。
* **単一ステート**: 単一ステートの原則に従い、`MutableStateStream<ScreenState> state` で状態を管理する。詳細は [mvvm-viewmodel-state.md](./mvvm-viewmodel-state.md) に従う。
* **全属性 final の原則**: ViewModel が保持する **すべてのフィールドは `final`** とする。画面状態の変化は `MutableStateStream<ScreenState> state` 経由でのみ行い、ViewModel インスタンス自身が State 以外の Stateful な要素（`execute` をまたいで変化する mutable フィールド、カウンタ、キャッシュ、前回結果の保持など）を持たないようにする。
* **表示状態の公開**: 表示状態は `StateStream<ScreenEntity> get entity` で公開する。State→Entity 変換は StateToEntityDelegate に委譲する。詳細は [mvvm-viewmodel-entity.md](./mvvm-viewmodel-entity.md) に従う。
* **イベントの公開**: イベントを持つ必要がある場合は `Stream<ScreenEvent> get event` で公開する。詳細は [mvvm-viewmodel-event.md](./mvvm-viewmodel-event.md) に従う。
* **リソース解放**: `_close()` メソッドを実装し、Provider の解放コールバック（`ref.onDisposeAsync(result._close)`）で実行する。主に `MutableStateStream` の `close()` を呼ぶ。
* **アクションの分離**: Widget から呼び出す操作は `onXXXX()` 拡張メソッドとし、`part` ファイルおよび `OnXxxxxDelegate` に分離する。詳細は [mvvm-viewmodel-design-action.md](./mvvm-viewmodel-design-action.md) に従う。

## DI

* **Riverpod による DI を推奨する**: 外部レイヤー（Repository・Usecase・Infra など）のインターフェースは `ref.watch(...)` で取得し、ViewModel のコンストラクタに渡す。`dependencies` に依存 Provider を明記する。
* **StateToEntityDelegate** など Entity 変換用 Delegate は、ViewModel のコンストラクタで生成しフィールドとして保持してよい（[mvvm-viewmodel-entity.md](./mvvm-viewmodel-entity.md) 参照）。
* **アクション用 Delegate**（`OnXxxxxDelegate`）は ViewModel のフィールドに保持せず、`onXXXX()` 内で都度生成する。必要な依存（State, Usecase, Repository 等）は ViewModel が `ref.watch` で解決し、事前にインスタンス化したうえで Delegate のコンストラクタ引数として渡す（[mvvm-viewmodel-design-action.md](./mvvm-viewmodel-design-action.md) 参照）。
* 画面固有の Usecase（Delegate 経由で使うもの）は `onXXXX()` 内で `new` し、Delegate にコンストラクタ注入する。ViewModel の provider では生成しない（[mvvm-viewmodel-usecase.md](./mvvm-viewmodel-usecase.md) 参照）。

## ファイルレイアウト

### ファイルレイアウトの補足

ViewModel および関連型は、画面パッケージの `lib/src/viewmodel/` 以下に配置する。
本体は `{画面名}_screen_view_model.dart` に置き、アクションは `{画面名}_screen_view_model.action.dart` に **part で分離** する。state / entity / delegate / usecase はサブディレクトリで整理する。

### 標準ディレクトリ構成

```text
lib/src/viewmodel/
├── {画面名}_screen_view_model.dart           # ViewModel 本体（provider, state, entity, event, _close）
├── {画面名}_screen_view_model.action.dart    # アクション処理（part）
├── delegate/                                 # StateToEntityDelegate およびアクション用 Delegate（推奨配置）
│   ├── {画面名}_screen_state_to_entity_delegate.dart
│   └── {アクション名}_delegate.dart
├── entity/
│   └── {画面名}_screen_entity.dart
├── state/
│   ├── {画面名}_screen_state.dart
│   └── {画面名}_screen_event.dart            # イベントがある場合
├── usecase/                                  # 画面固有 Usecase（Optional）
│   └── {ユースケース名}_usecase.dart
└── model/                                    # 画面固有の型（Optional）
    └── {型名}.dart
```

ViewModel 本体の part 分割は **`{画面名}_screen_view_model.action.dart` のみ** を推奨する。provider・entity・event・`_close` 等は ViewModel 本体に置く。上記以外の part 分割・フィールド命名・配置は非推奨とする（詳細は「ナレッジベース」参照）。

### ファイルレイアウトの実装例

```text
app_packages/screen/feature/{画面名}/lib/src/viewmodel/
├── {画面名}_screen_view_model.dart
├── {画面名}_screen_view_model.action.dart
├── delegate/
│   ├── {画面名}_screen_state_to_entity_delegate.dart
│   └── on_{動詞句}_delegate.dart
├── entity/
├── state/
└── usecase/
```

### ViewModel 本体の実装例

```dart
/// 学年ごとの習う漢字画面のViewModel.
@internal
final class SchoolGradeScreenViewModel {
  static final provider = Provider.autoDispose<SchoolGradeScreenViewModel>(
    (ref) {
      final kanjiListBySchoolGradeUsecase = ref.watch(
        KanjiListBySchoolGradeUsecase.provider,
      );
      const schoolGradeSectionSortDelegate =
          SchoolGradeScreenStateToEntityDelegate();
      final result = SchoolGradeScreenViewModel._(
        state: MutableStateStream(
          SchoolGradeScreenState.loading(
            context: FutureContext(tag: "$SchoolGradeScreenViewModel.initial"),
          ),
        ),
        kanjiListBySchoolGradeUsecase: kanjiListBySchoolGradeUsecase,
        schoolGradeScreenStateToEntityDelegate: schoolGradeSectionSortDelegate,
      );
      ref.onDisposeAsync(result._close);
      return result;
    },
    dependencies: [KanjiListBySchoolGradeUsecase.provider],
  );

  @visibleForTesting
  final MutableStateStream<SchoolGradeScreenState> state;

  @visibleForTesting
  final KanjiListBySchoolGradeUsecase kanjiListBySchoolGradeUsecase;

  @visibleForTesting
  final SchoolGradeScreenStateToEntityDelegate
      schoolGradeScreenStateToEntityDelegate;

  const SchoolGradeScreenViewModel._({
    required this.state,
    required this.kanjiListBySchoolGradeUsecase,
    required this.schoolGradeScreenStateToEntityDelegate,
  });

  /// StateToEntityDelegate の public メソッドは execute（Delegate パターンに従う）.
  StateStream<SchoolGradeScreenEntity> get entity =>
      state.map(schoolGradeScreenStateToEntityDelegate.execute);

  Future<void> _close() async => state.close();
}
```

## 関連文書

* [mvvm-viewmodel-design-action.md](./mvvm-viewmodel-design-action.md): アクションメソッド（`onXXXX()`）と Delegate 分離の必須ルール
* [mvvm-viewmodel-state.md](./mvvm-viewmodel-state.md): ScreenState の型・単一ステート・初期状態
* [mvvm-viewmodel-entity.md](./mvvm-viewmodel-entity.md): ScreenEntity と StateToEntityDelegate
* [mvvm-viewmodel-event.md](./mvvm-viewmodel-event.md): ScreenEvent と event ストリーム
* [mvvm-viewmodel-usecase.md](./mvvm-viewmodel-usecase.md): 画面固有 Usecase

## ナレッジベース

### DO: 1 画面 1 ViewModel とし、フィールドはすべて final にする

* 画面ごとに専用 ViewModel を持ち、スコープが重ならないようにする。
* 状態変化は `MutableStateStream<ScreenState> state` に集約し、ViewModel 自身を Stateful にしない。

### DO: Provider.autoDispose と ref.onDisposeAsync でライフサイクルを管理する

* `@riverpod` は用いず、`static final provider = Provider.autoDispose<...>(...)` を定義する。
* 外部依存は `ref.watch` で取得し、`dependencies` に列挙する。
* `_close()` を `ref.onDisposeAsync(result._close)` で登録する。

```dart
static final provider = Provider.autoDispose<SchoolGradeScreenViewModel>(
  (ref) {
    final result = SchoolGradeScreenViewModel._(...);
    ref.onDisposeAsync(result._close);
    return result;
  },
  dependencies: [KanjiListBySchoolGradeUsecase.provider],
);
```

### DO: ViewModel の part 分割は action.dart のみとする

* provider・entity・event・`_close` は ViewModel 本体に置く。
* アクションは `{画面名}_screen_view_model.action.dart` に part で分離する。

### DO NOT: Provider を介さずに ViewModel を new する

* 理由: ライフサイクルと DI が Provider 外に漏れ、テスト・解放が困難になる
* 理由: `@internal` と private コンストラクタで、インスタンス生成経路を Provider に限定する

```dart
// 非推奨パターン
// DO NOT: Provider 外での ViewModel 生成
final vm = SchoolGradeScreenViewModel._(...);
```

```dart
// 推奨される書き換えパターン
// DO: Provider コールバック内でのみ生成する
static final provider = Provider.autoDispose<SchoolGradeScreenViewModel>(
  (ref) => SchoolGradeScreenViewModel._(...),
);
```

### DO: 推奨するプロパティ名 state, entity, eventを使用する

* 状態ストリームは `MutableStateStream<ScreenState> state` とする。
* 表示状態は `StateStream<ScreenEntity> get entity` で公開する。
* イベントは `Stream<ScreenEvent> get event` で公開する（必要な場合）。
* `data` 等の別名は使わず、設計文書・テストの参照を統一する。

```dart
// screen_feature_school_grade, school_grade_screen_view_model.dart（抜粋）
@visibleForTesting
final MutableStateStream<SchoolGradeScreenState> state;

StateStream<SchoolGradeScreenEntity> get entity =>
    state.map(schoolGradeScreenStateToEntityDelegate.execute);
```

```dart
// イベントがある場合の公開例
Stream<SettingsScreenEvent> get event =>
    state.stream.map((e) => e.event).distinct();
```

### DO NOT: ViewModel を factory / ui に part 分割する

* 理由: part 分割が散漫になり、責務境界が不明確になる
* 理由: `{viewmodel}.action.dart` 以外の part 分割は非推奨である

### DO NOT: ViewModel に可変値を保存する

* 理由: ViewModel インスタンスが Stateful になり、ライフサイクル・テスト・二重呼び出しの追跡が困難になる
* 理由: 画面の可変状態は `MutableStateStream<ScreenState>`（ScreenState）に閉じる。初期化済みフラグ等も State のプロパティとする
* 例外: フィールドはすべて `final` の依存参照（Repository、StateStream、StateToEntityDelegate 等）に限る
* 関連: 解放が必要なライフサイクル紐づきリソースは別 DO NOT — [mvvm-viewmodel-lifecycle-resource.md](./mvvm-viewmodel-lifecycle-resource.md)

```dart
// 非推奨パターン
// DO NOT: ViewModel に mutable フィールドを持つ
bool _initialized = false;
int _retryCount = 0;
```

```dart
// 推奨される書き換えパターン
// DO: 可変値は ScreenState に載せる
const factory AccountScreenState.loading({
  required bool isInitialized,
  required AccountScreenEvent event,
}) = AccountScreenStateLoading;
```

### DO NOT: ViewModel の非同期初期化処理をコンストラクタや Provider からコールする

* 理由: ViewModel は Widget ライフサイクルに紐づく。Provider 生成時に非同期初期化を始めると、Unit Test で「初期化待ち」や明示的な開始がしづらい
* 理由: 二重生成・再入時の購読開始タイミングが不明瞭になる
* 対応: 初期化は `onInitialize()` 等の Action とし、ルート Screen の `useEffect` から呼ぶ（[mvvm-widget.md](./mvvm-widget.md)）
* 例外の扱い: ストリーム購読開始をコンストラクタに置く既存パターンは [mvvm-viewmodel-usecase.md](./mvvm-viewmodel-usecase.md) を参照するが、**Unit Test で初期化を明示したい画面では `onInitialize` を優先**する

```dart
// 非推奨パターン
// DO NOT: provider / コンストラクタから非同期初期化や watch 開始を呼ぶ
static final provider = Provider.autoDispose<AccountScreenViewModel>(
  (ref) {
    final vm = AccountScreenViewModel._(...);
    vm.onInitialize(); // NG
    return vm;
  },
);
```

```dart
// 推奨される書き換えパターン
// DO: Screen の useEffect から onInitialize を呼ぶ
useEffect(() {
  viewModel.onInitialize();
  return null;
}, [viewModel]);
```
