# ViewModel レイヤー / ライフサイクル紐づきリソース

## 概要

画面の生存期間に紐づくリソース（キャンセル用コンテキスト、購読ハンドル、一時ファイル等）は **ScreenState のプロパティとして保持**する。
ViewModel のフィールドや、State ストリームの外に置くと、dispose・再入・Unit Test での追跡が困難になる。

本ドキュメントは次の DO NOT の詳細である。

* **DO NOT: ViewModel のライフサイクルに紐づくリソースが State の外に定義されている**

可変な画面フラグ（`isInitialized` 等）については [mvvm-viewmodel-design.md](./mvvm-viewmodel-design.md) / [mvvm-viewmodel-state.md](./mvvm-viewmodel-state.md) の「可変値は State に載せる」を参照する。本ドキュメントは **リソース（解放が必要なオブジェクト）** に焦点を当てる。

## 対象になるもの / ならないもの

### 対象（State に載せる）

* 画面 dispose 時に必ず解放・キャンセルすべきもの
* Delegate / Usecase が「現在の画面インスタンス」に紐づいて参照するもの
* 例: キャンセル用コンテキスト、画面スコープのトークン、画面単位の作業ディレクトリ など

### 対象外（ViewModel の `final` 依存としてよい）

* Repository / Usecase など、DI されたインターフェース参照（動的に差し替えないもの）
* `MutableStateStream` 本体、`StateToEntityDelegate` など ViewModel 骨格の依存

## DO NOT: ViewModel のライフサイクルに紐づくリソースが State の外に定義されている

* 理由: ViewModel の単独フィールドに置くと、State 遷移（loading ↔ loaded）や Delegate から「いまのリソース」を一貫して参照できない
* 理由: Provider dispose 時の解放順・二重 close・テストでの明示キャンセルが属人化しやすい
* 理由: 「可変値は State」と同じく、画面の単一の状態ストリーム原則が崩れる
* 対応: ScreenState（sealed なら各 variant）にリソースを `required` で載せ、初期 State 構築時に生成し、`ref.onDisposeAsync` 等で State 上のリソースを解放してから StateStream を閉じる

```dart
// 非推奨パターン
// DO NOT: ライフサイクル紐づきリソースを ViewModel の単独フィールドに置く
@internal
final class AccountScreenViewModel {
  @visibleForTesting
  final FutureContext screenContext; // NG: State の外

  Future<void> _close() async {
    await screenContext.close();
    await state.close();
  }
}
```

```dart
// 推奨される書き換えパターン
// DO: ScreenState に載せ、dispose は State 経由で解放する
@freezed
sealed class AccountScreenState with _$AccountScreenState {
  const factory AccountScreenState.loading({
    required bool isInitialized,
    required AccountScreenEvent event,
    /// 画面ライフサイクルに紐づくキャンセル用コンテキスト（例）。
    required FutureContext context,
  }) = AccountScreenStateLoading;

  const factory AccountScreenState.loaded({
    // ... 表示・入力に必要なプロパティ
    required FutureContext context,
  }) = AccountScreenStateLoaded;

  const AccountScreenState._();
}

// Provider: 初期 State 構築時に生成する
final context = FutureContext(tag: "$AccountScreenViewModel");
final stateStream = MutableStateStream(
  AccountScreenState.loading(
    isInitialized: false,
    event: const AccountScreenEvent.nothing(),
    context: context,
  ),
);

// dispose: State 上のリソース → StateStream の順
Future<void> _close() async {
  await state.state.context.close();
  await state.close();
}
```

### Example: FutureContext（キャンセル基盤がある場合）

プロジェクトが `FutureContext`（または同等のキャンセル用コンテキスト）を導入している場合の典型例である。**未導入のプロジェクトでは別種のライフサイクル紐づきリソースに読み替える**。

* sealed State の **すべての variant** に同じリソースを載せる（loading → loaded 遷移で引き継ぐ）
* Action / Delegate は ViewModel フィールドではなく `oldState.context`（または第1ロックで取り出した値）を使う
* Unit Test では `viewModel.state.state.context.close()` のように State 経由でキャンセルを再現する

参考となる既存パターン: `SchoolGradeScreenState` / `KanjiKanamajiriScreenState`（いずれも State に `FutureContext context`）。

### State 遷移時の引き継ぎ

```dart
// loading → loaded で新しいインスタンスを組み立てるとき
AccountScreenState.loaded(
  // ...
  context: oldState.context, // 同じライフサイクルリソースを引き継ぐ
);

// loaded → loaded の copyWith では通常触らない（保持される）
```

## 関連文書

* ViewModel 基本・可変値: [mvvm-viewmodel-design.md](./mvvm-viewmodel-design.md)
* ScreenState 設計: [mvvm-viewmodel-state.md](./mvvm-viewmodel-state.md)
* Widget / dispose: [mvvm-widget.md](./mvvm-widget.md)
