---
name: markdown-fix
description: >-
  Markdown（*.md）の書式統一と markdownlint 対応を行う SKILL。
  「md を整形して」「lint を直して」「ドキュメントのフォーマットを揃えて」、
  技術文書や計画 md を書き終えた直後の仕上げ、ディレクトリ配下の一括整形時は必ず使う。
  文書の構成・ナレッジ内容そのものを書く作業は markdown-documentation、探索だけなら markdown-search。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Markdown / Fix Lint, Fix Format

書式が揃っていると `markdown-search` の見出し抽出やレビュー差分が安定する。
内容の設計は別 SKILL に任せ、ここでは lint / format に集中する。

## いつ使うか

* `*.md` 作成・更新の直後
* 「整形」「lint」「フォーマット」依頼
* ディレクトリ配下の Markdown をまとめて直すとき

## 入力

* 対象ファイル、またはディレクトリ（配下のすべての `*.md`）

```bash
find "path/to/directory/" -name "*.md"
```

## 手順

基本ツールは `npx markdownlint-cli2`。
コマンド実行時は、プロジェクト規定のツールチェイン（あれば）に従う。

### ステップ1. 自動修正

```bash
npx markdownlint-cli2 --fix path/to/markdown_file.md
```

複数ファイル・ディレクトリも同様にパスを渡す。

### ステップ2. 残件の手修正

* `--fix` で消えない警告はメッセージを読み、個別に直す
* 技術文書の見出しルール（重複見出し・言語タグ等）は `markdown-documentation` の lint リファレンスを参照してよい

### ステップ3. 再実行

* 手修正後にもう一度ステップ1を実行し、警告ゼロを目指す
