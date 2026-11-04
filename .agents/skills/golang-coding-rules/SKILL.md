---
name: golang-coding-rules
description: >-
  Go（`*.go`）のコーディング規約 SKILL。import 別名・errors.As、データオブジェクト（独自型 /
  NewXxx / Stringer）、ドキュメントコメント（日本語・主語省略・Example・NOTE）を適用する。
  「Go を書く」「コメント規約どおり」「独自型にして」「errors.As」「DTO / 構造体の型」
  「*.go の実装・修正」では必ずロードし、該当 `references/` だけ読む。 fmt/lint/test
  の実行手順は golang-analyze、ConnectRPC/Repository/Usecase 設計は
  golang.architecture.* を使う。Dart / Flutter の言語規約には使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Golang / コーディング規約

`*.go` を書く・直すときは、この SKILL の規約と、文脈に合う参照ドキュメントに従う。
品質コマンド（fmt / lint / test）の回し方は `golang-analyze`、レイヤー設計は `golang.architecture.*` が主で、本 SKILL は言語・型・コメントの土台である。

## いつ使うか

* Go の新規実装・修正・レビュー指摘の反映
* import 別名、error 判定、データオブジェクト（独自型）、ドキュメントコメント

## いつ使わないか

* `go fmt` / `golangci-lint` / `go test` の実行手順だけ → `golang-analyze`
* ConnectRPC / Repository / Usecase 等のアーキテクチャ設計 → 該当 `golang.architecture.*`
* Dart / Flutter の言語規約（他言語向けの規約 SKILL がある場合はそちら）

## 作業手順

1. 変更対象の種類を特定する（一般・データオブジェクト・コメントのみ、など）
2. 下表から必要な `references/` **だけ**ロードする（全部を一度に読まない）
3. 規約に沿って実装する
4. 区切りがついたら `golang-analyze` で fmt / lint / test を回す

## 文脈に応じたドキュメントのロード

| 参照 | 使うとき |
| --- | --- |
| [general.md](./references/general.md) | import 別名、入れ子 error（`errors.As`）など一般規約 |
| [data_object.md](./references/data_object.md) | DTO / 構造体 / 独自型（`type`）・生成関数・`String()` |
| [code_comment.md](./references/code_comment.md) | public への日本語ドキュメントコメント・Example・`NOTE:` |

必要な参照だけ読む。全部を一度にロードしない。

## 原則（要約）

* **import 別名**は既定名で通じるときは付けない。`/v1` 等は一段上げて小文字連結。衝突時は下位レイヤを無別名、上位にパス連結別名。**Linter（goimports / golangci-lint）と食い違うときは Linter 最優先**（詳細は `references/general.md`）
* 入れ子 error の型確認は **`errors.As`**（文字列比較や不安定な型アサーションだけに頼らない）
* ドメイン上の意味ある値はプレーン `string`/`int` 直扱いを避け、**独自型 + 必要なら `NewXxx` + `String()`**
* public な型・関数・フィールド等には **日本語ドキュメントコメント**（主語の省略、意図・副作用、必要なら Example / `NOTE:`）

## ナレッジベース

### DO: まず対象種別を決め、対応する reference だけ読む

* general / data_object / code_comment を同時に全部読まないと進まない、という進め方を避ける

### DO: 型とコメントで意図をコードに残し、曖昧なプレーン型を減らす

* 取り違えとレビューコストを下げるため

### DO NOT: 品質コマンド手順やアーキテクチャ詳細を本 SKILL だけで済ませようとする

* 実行は `golang-analyze`、設計は `golang.architecture.*` へ

### DO NOT: 入れ子 error を文字列マッチだけで判定する

* ラップ構造の変化に弱く、壊れやすい
