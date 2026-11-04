---
name: markdown-documentation
description: >-
  技術ドキュメント（docs 配下などの *.md）を作成・更新する SKILL。
  「ドキュメントを書いて」「アーキテクチャ説明を更新」「ナレッジベース付きの md を整えて」、
  技術文書の差分提案時は必ずロードする。
  計画ファイル（要件・詳細設計）が主目的なら、要件／詳細設計向けの専用 SKILL を使う。
  書式の自動修正だけなら markdown-fix、既存 docs の検索だけなら markdown-search を使う。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# ドキュメンテーション / 技術文書の記載

技術ドキュメントの読み手は後続の実装・レビュー Agent である。
文体・必須セクション・実在コード引用を揃えることで、検索（`markdown-search`）とレビューが安定する。

## いつ使うか / 使わないか

* 使う: `docs/` 等の技術文書、アーキテクチャ・規約・ナレッジの作成更新
* 使わない: `.ai-agent/plan/` の要件・詳細設計（engineer.*）、単なる lint 修正（`markdown-fix`）、探索のみ（`markdown-search`）

ひな形は [assets/template.md](./assets/template.md) を起点にする。

## 基本方針

* 「である」調で簡潔に書く
* 本文は `DO` / `推奨` を示し、`DO NOT` はナレッジベース（や example）に寄せる
* 実装例は実在コードを優先し、架空コードで埋めない

## 必須構造

1. **概要**（冒頭）— 目的・役割・特徴・関連コンポーネント
2. **原則・規則**（必要な数だけ）— 各原則に次を付ける
   * `${原則名}の補足`（意図・利点・注意・例外）
   * `${原則名}の実装例`（良い例必須、悪い例は必要時）
3. **ナレッジベース**（末尾付近、参考リンクの直前）— `### DO:` / `### DO NOT:`
4. **参考リンク**（Web を参照した場合）— URL は `<https://...>` 形式

見出しは文書内で一意にする（「補足」「実装例」の重複を避ける）。階層は最大 4、飛ばさない。

## 作業手順

1. 既存コードと類似ドキュメントを調査する（必要なら先に `markdown-search`）
2. テンプレートに沿いドラフトを書く
3. コード引用・パスは [references/code-blocks.md](./references/code-blocks.md) に従う
4. 作図・パス表記は [references/diagrams-and-paths.md](./references/diagrams-and-paths.md) に従う
5. 必須セクションと見出し一意性を確認する
6. [references/lint-and-validation.md](./references/lint-and-validation.md) を確認し、仕上げに `markdown-fix` を実行する

## アプリ基盤の書き方

* 量産不要な基盤は「実装済み・詳細は参照先」と短く書く
* 実装者が使う情報に焦点を当て、基盤内部の長文実装例は避ける

## 詳細リファレンス

| ファイル | 内容 |
| --- | --- |
| [references/code-blocks.md](./references/code-blocks.md) | コード引用・テンプレート・ディレクトリツリー |
| [references/lint-and-validation.md](./references/lint-and-validation.md) | リンターと整合性チェック |
| [references/diagrams-and-paths.md](./references/diagrams-and-paths.md) | Mermaid・相対パス |
