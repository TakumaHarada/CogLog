---
name: flutter-layered-architecture-screen-mvvm
description: >-
  Flutter Layered Architecture の Screen 層 MVVM（View / ViewModel / ScreenState /
  ScreenEntity / ScreenEvent）設計・実装用 SKILL。1画面1ViewModel、Riverpod Provider
  （@riverpod なし）、`onXXXX()` + Delegate、State→Entity、`{画面名}Screen` /
  `ScreenImpl` 分割では必ず使う。「画面を作る」「ViewModel 追加」「onInitialize」
  「Entity 設計」「ViewModel テスト」でもロードし、該当 `references/` だけ読む。
  画面間遷移・Factory/Launcher は flutter-layered-architecture-screen-navigation、
  Usecase/Repository 定番は design-patterns、レイヤー地図は design、所在調査は
  code-search、Dart 規約のみは flutter-coding-rules では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter / Screen 層 MVVM

Screen 層の画面を **Model–View–ViewModel** で組む。状態は ViewModel、表示は Entity、操作は `onXXXX()`、見た目は Widget。
詳細は文脈に応じて `references/` だけ追加ロードする（本 SKILL は地図と原則）。

## いつ使うか

* 新規／改修で Screen の ViewModel・State・Entity・Event・Widget を設計するとき
* アクション（`onXXXX` / Delegate）や ViewModel Unit Test を書くとき
* Riverpod での ViewModel DI・ライフサイクル（autoDispose）を揃えるとき

## いつ使わないか

* 画面遷移・`*Factory` / `*Launcher` / `go_router` 隠蔽 → `flutter-layered-architecture-screen-navigation`
* Usecase / Repository の Request&Result 定番だけ → `flutter-layered-architecture-design-patterns`
* どのレイヤーに置くかだけ → `flutter-layered-architecture-design`
* 既存コードの所在調査 → `flutter-layered-architecture-code-search`
* 言語規約だけ → `flutter-coding-rules`

## 作業手順

1. 対象が ViewModel / State・Entity・Event / Action / View(Widget) / Test のどれかを決める
2. 下の原則で骨格を決める
3. 詳細は対応する `references/` **だけ**読む（全部を一度に読まない）
4. 画面遷移が必要なら `screen-navigation` に委ねる（本 SKILL ではルーター直叩きしない）

## 原則（要約）

* **1 画面 = 1 ViewModel**（タブ親子など、スコープが互いに素なら柔軟に）
* ViewModel は `@internal`、**private コンストラクタ**、`static final provider = Provider.autoDispose<...>`（**`@riverpod` は使わない**）
* Riverpod は **DI とライフサイクル**に限る。全フィールド `final`。可変状態は `MutableStateStream<ScreenState>` のみ
* 表示は `StateStream<ScreenEntity> entity`（State→Entity は Delegate）。ワンショットは `Stream<ScreenEvent> event`
* Widget からの操作はすべて **`onXXXX()` 拡張**（`onInitialize` 含む）。本体は `.action.dart` の part + **使い捨て `OnXxxxxDelegate`（`execute`）**
* ルート Widget は `{画面名}Screen`（public）で VM watch／初期化／event 購読。見た目は `{画面名}ScreenImpl`。配下は **Entity のみ watch**、操作時は `ref.read`

## 主なライブラリ

| 用途 | パッケージ |
| --- | --- |
| 状態・DI | `flutter_riverpod` / `hooks_riverpod` / `flutter_hooks` |
| State ストリーム | `state_stream` / `state_stream_riverpod` |
| 深い比較 watch | `flutter_riverpod_watch_plus`（`watchBy`） |
| 不変データ | `freezed`（State / Entity / Event） |
| VM テスト | `riverpod_container_async_test` 等 |

## 追加ドキュメント（progressive disclosure）

| 参照 | 使うとき |
| --- | --- |
| [mvvm-viewmodel-design.md](./references/mvvm-viewmodel-design.md) | VM 基本・provider・ファイルレイアウト |
| [mvvm-viewmodel-design-action.md](./references/mvvm-viewmodel-design-action.md) | `onXXXX` / Delegate / `.action.dart` |
| [mvvm-viewmodel-state.md](./references/mvvm-viewmodel-state.md) | ScreenState |
| [mvvm-viewmodel-lifecycle-resource.md](./references/mvvm-viewmodel-lifecycle-resource.md) | 画面ライフサイクル紐づきリソース（State 外禁止） |
| [mvvm-viewmodel-entity.md](./references/mvvm-viewmodel-entity.md) | ScreenEntity / StateToEntity |
| [mvvm-viewmodel-event.md](./references/mvvm-viewmodel-event.md) | ScreenEvent |
| [mvvm-viewmodel-usecase.md](./references/mvvm-viewmodel-usecase.md) | 画面固有 Usecase |
| [mvvm-view-design.md](./references/mvvm-view-design.md) | View と Riverpod 利用 |
| [mvvm-widget.md](./references/mvvm-widget.md) | Screen / ScreenImpl |
| [mvvm-viewmodel-test.md](./references/mvvm-viewmodel-test.md) | ViewModel Unit Test |

ディレクトリ例に特定アプリ名が出ても、**命名と責務**を優先して読み替える。

## ナレッジベース

### DO: まず VM 骨格、次に必要な reference だけ

* State / Action / Widget を同時に全部読まないと進まない、という進め方を避ける

### DO: 表示は Entity、操作は onXXXX、可変は ScreenState ストリーム

* View が State や Repository を直接いじるとテストと責務が崩れる

### DO NOT: 画面 package から go_router / Navigator を直叩きする

* 遷移は `screen-navigation` の Factory / Launcher 側へ

### DO NOT: 新規で `@riverpod` 生成や ViewModel の mutable フィールドを増やす

* provider 手書き + 状態は `state` ストリームに閉じる

### DO NOT: ViewModel の Action を Delegate 分割せずに直接実装する

* ViewModel 肥大化と Stateful プロパティを防ぐ。詳細は [mvvm-viewmodel-design-action.md](./references/mvvm-viewmodel-design-action.md)

### DO NOT: ViewModel に可変値を保存する

* 可変値は ScreenState（`MutableStateStream`）に保持する。詳細は [mvvm-viewmodel-design.md](./references/mvvm-viewmodel-design.md)

### DO NOT: ViewModel のライフサイクルに紐づくリソースが State の外に定義されている

* キャンセル用コンテキスト等、画面 dispose で解放すべきものは ScreenState に載せる。詳細は [mvvm-viewmodel-lifecycle-resource.md](./references/mvvm-viewmodel-lifecycle-resource.md)

### DO NOT: ViewModel の非同期初期化をコンストラクタや Provider から呼ぶ

* `onInitialize()` 等の Action とし、ルート Screen の `useEffect` から呼ぶ。詳細は [mvvm-widget.md](./references/mvvm-widget.md)

### DO NOT: StatefulWidget を作成する

* Widget は Stateless（`HookConsumerWidget` / `ConsumerWidget` / `HookWidget` 等）。状態は Hooks または ViewModel の State に寄せる。詳細は [mvvm-widget.md](./references/mvvm-widget.md)

### DO NOT: updateWithLock 内で長時間の I/O・RPC を行う

* 状態遷移のみ短ロックし、通信はロック外。詳細は [mvvm-viewmodel-design-action.md](./references/mvvm-viewmodel-design-action.md)
