---
name: flutter-layered-architecture-screen-navigation
description: >-
  Flutter Layered Architecture の画面遷移設計用 SKILL。screen 同士を疎結合に保ち、
  `screen_navigation`（IF・Request/Result）と `screen_navigation_impl`（go_router 等）
  に分離し、`{画面名}Factory` / `Launcher` / `Finisher` / `Proxy` で遷移する。
  「画面遷移を足す」「Launcher の IF」「遷移引数・戻り値」「go_router をどこに置くか」
  「画面 package 同士の循環を避けたい」では必ず使う。詳細は references/navigation.md。
  Screen 内 MVVM（ViewModel/Entity）は flutter-layered-architecture-screen-mvvm、
  レイヤー地図は design、所在調査は code-search、Dart 規約のみは coding-rules では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter-Layered-Architecture / ナビゲーション

Screen 層の画面間を **疎結合**にする。ルーティング実装（推奨: `go_router`）は impl に閉じ込め、各画面は Factory / Launcher 等の IF 経由で遷移する。

詳細は [references/navigation.md](./references/navigation.md)（必要なら [example/go_router_extensions.md](./references/example/go_router_extensions.md)）。

## いつ使うか

* 新規画面の遷移入口（Launcher）・終了（Finisher）・Widget 生成（Factory）を設計するとき
* 遷移の Request / Result をどこに置くか決めるとき
* 画面 package 同士の循環参照を避けたいとき
* ルーティングライブラリの置き場所（impl のみ）を揃えるとき

## いつ使わないか

* 画面内部の MVVM（ViewModel / Entity / `onXXXX`）→ `flutter-layered-architecture-screen-mvvm`
* レイヤー責務の地図だけ → `flutter-layered-architecture-design`
* 既存コードの所在調査 → `flutter-layered-architecture-code-search`
* Dart 言語規約だけ → `flutter-coding-rules`

## 作業手順

1. 遷移に必要な型を切り出す（Request / Result、必要なら Input）
2. IF を `screen_navigation` 側に置く（Factory / Launcher / Finisher 等）
3. 各画面 package は **Factory 実装**を提供し、DI で結線する（他 screen を import しない）
4. `go_router` 等の具体実装は **`screen_navigation_impl` のみ**
5. 細部・既存パターンは `references/navigation.md` を読む

## 原則（要約）

* **画面 package 同士を直接参照しない**。遷移契約は `screen_navigation` に集約する
* `go_router`（や Navigator 直叩き）への依存は **impl に閉じる**。他 package はルーティング詳細を知らない
* 典型 IF:
  * `{画面名}Factory` … Widget 構築（実装は各 screen package）
  * `{画面名}Launcher` … 遷移の実行（実装は navigation_impl）
  * `{画面名}Finisher` … 終了と結果返却（必要な画面）
  * `{画面名}Proxy` … ルート定義と Factory の接続（impl）
  * `AppRouterFactory` … アプリ全体ルーティング（impl に隠蔽）
* DI で結線し、ライブラリ差し替えやテスト差し替えを可能にする

## パッケージの役割

| パッケージ | 役割 |
| --- | --- |
| `screen_navigation` | 遷移 IF と Request/Result。ルーティングライブラリ非依存 |
| `screen_navigation_impl` | go_router 等の実装、Proxy、Launcher 実装、DI |
| 各 `screen_*` | 画面本体 + Factory 実装。他画面や go_router に依存しない |

名前はリポジトリにより多少違うが、**IF 層 / 実装層 / 画面層**の分離を優先して読み替える。

## 追加ドキュメント

| 参照 | 使うとき |
| --- | --- |
| [navigation.md](./references/navigation.md) | IF 一覧・パッケージ構成・実装手順 |
| [example/go_router_extensions.md](./references/example/go_router_extensions.md) | go_router 拡張の具体例 |

## ナレッジベース

### DO: 遷移契約を navigation IF に寄せ、画面同士を切る

* Request/Result を screen A が screen B の型にべったり依存させない

### DO: ルーティング実装は impl に閉じる

* 画面や usecase から `GoRouter` / `context.go` を直接呼ばない（Launcher 経由）

### DO NOT: 画面 package 間で相互 import して遷移する

* 循環と結合度の温床になる

### DO NOT: MVVM の State/Entity 設計を本 SKILL だけで済ませようとする

* 画面の中身は `screen-mvvm` へ
