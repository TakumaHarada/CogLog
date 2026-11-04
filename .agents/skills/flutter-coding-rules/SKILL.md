---
name: flutter-coding-rules
description: >-
  Flutter / Dart のコーディング規約（言語・ファイル・コメント・定番パターン）を適用する SKILL。 `*.dart`
  の実装・修正・リファクタ、ドキュメントコメント、enum、try-catch、`@internal` 等の可視性、
  dart_file_layout、Delegate、データオブジェクト（extension type / freezed / DTO）、 `dart fix --apply`
  → analyze → format の警告修正では必ずロードし、該当 `references/` だけ追加で読む。 「値オブジェクト作って」「コメント規約どおり」「型付き
  catch に」「ファイル分割して」でも使う。 画面 MVVM・Repository/Usecase の設計詳細は flutter-layered-architecture-*
  を併用。 アプリ起動・DTD デバッグは flutter-app-debug、Maestro UI、Markdown 整形のみ、要件／設計ドキュメントのみ、
  Go／Firebase 調査のみでは使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter & Dart コーディング規約

`*.dart` を書く・直すときは、この SKILL の規約と、文脈に合う参照ドキュメントに従う。
レイヤー設計そのものは `flutter-layered-architecture-*` 側が主で、本 SKILL は言語・ファイル・コメント・定番パターンの土台である。

## いつ使うか

* Dart の新規実装・修正・レビュー指摘の反映
* データオブジェクト / Delegate / enum / 例外の定義・catch / 可視性 / ファイルレイアウト / コメント

## 作業手順

1. 変更対象の種類を特定する（DTO、Delegate、enum、コメントのみ、など）
2. 下表から必要な `references/`（と snippets）をロードする
3. 規約に沿って実装する
4. Analyzer / Formatter で検証する
5. 解析エラーの直し方に迷ったら [fix-error](./references/fix-error.md) を読む

## 文脈に応じたドキュメントのロード

| 参照 | 使うとき |
| --- | --- |
| [クラス作成テンプレート](./assets/architecture_data_object.code-snippets) | データオブジェクト等のひな形が欲しいとき |
| [data_object](./references/data_object.md) | DTO / data class / 構造体的な型 |
| [delegate-pattern](./references/delegate-pattern.md) | Delegate による責務分離 |
| [code_comment](./references/code_comment.md) | ドキュメントコメント・Example |
| [code_internal](./references/code_internal.md) | `@internal` / `@visibleForTesting` / `@protected` 等 |
| [dart_file_layout](./references/dart_file_layout.md) | ファイル名・1クラス1ファイル・library・配置 |
| [enum](./references/enum.md) | enum・dot-shorthands・switch 網羅 |
| [try-catch](./references/try-catch.md) | 例外処理・Error/Exception の catch |
| [exception-definition](./references/exception-definition.md) | 独自 Exception / Error の定義（message / cause / stackTrace / toString） |
| [fix-error](./references/fix-error.md) | Analyzer / よくある修正の手順 |

必要な参照だけ読む。全部を一度にロードしない。

## 他 SKILL との境界

* 画面の MVVM: `flutter-layered-architecture-screen-mvvm`
* Usecase / Repository 設計: `flutter-layered-architecture-design-patterns`
* アプリ起動・DTD デバッグ: `flutter-app-debug`

## ナレッジベース

### DO: プロジェクト規定のコマンド prefix を付ける

* `mise` / `fvm` 等がある場合はそのルールに従う（例: `flutter ...`）
