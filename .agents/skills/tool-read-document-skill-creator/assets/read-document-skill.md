---
name: {skill-name}
description: >-
  {いつこの SKILL（＝対象ドキュメント群）を読むかのトリガーをここに集約する。
  参照ドキュメント群の主題・判断場面・キーワードを具体的に。
  「〜を調べて」「〜の方針を確認」「〜ドキュメントを読んでから実装／設計／レビュー」
  でも必ず使う、と少し押し気味に書く。全文直読みではなく段階ロードする旨も触れる。
  各ドキュメントの内容要約は書かない（正本との齟齬を防ぐ）。}
metadata:
  author: "{Optional, ユーザー指定時のみ}"
---

# {領域} / {ドキュメント群の入口}

<!--
* H1 は SKILL 名ではなく、何を読むための索引かが一目でわかるタイトルにする
* 形式の目安: `{領域} / {主題}`
  例: `アーキテクチャ / バックエンド全体像`
  例: `HQ Spec / 生成AI 課金の法的制約`
* 文書内容の要約は H1 にも本文にも書かない
-->

この SKILL は、列挙したドキュメントを **いつ正本から読むか** を決める索引である。
判断材料は必ず正本（対象ドキュメント）から取る。本 SKILL 本文に内容要約を置かない。
読み方・深さ・出力の取り方は `markdown-search` に従う（本 SKILL で再掲しない）。

「いつ読むか」は frontmatter の `description` に集約する。本文でトリガーを重複定義しない。

## 使わないか

* {隣接するが別 SKILL / 別文書群の方が適切な場面}
* （「いつ使うか」は `description` を正とする）

## 対象ドキュメント

<!--
* path のみ列挙する。内容要約・「いつ読むか」の注記は付けない
  （「いつ」は description、「何が書いてあるか」は正本を markdown-search で読む）
* path は次のいずれかで書き、実行時に対応 SKILL で実体へ解決する（推測読みしない）
  * Markdown リンク `[label](relative/path.md)` → この SKILL.md からの相対。`workspace-resolve-file-path`
  * クォート `path/to/file.md` → Git リポジトリルート相対。`workspace-resolve-file-path`
  * `@{name}/...` / `repo:{name}/...`（`this` / `example` 可）→ `workspace-resolve-root-directory`
* 実在しないパスを推測で書かない。解決失敗時は候補とルールを報告する
-->

* [{表示名}](../relative/doc.md)
* `docs/architecture/another.md`
* `repo:example/docs/architecture/overview.md`

## 読み方

* 適用時は対象 path を解決したうえで、**必ず `markdown-search` を使う**（Stage・スクリプト・出力の正本）
* プロンプト制約がある場合は、索引全体ではなく制約に合う文書・節から進める
* path 解決: `workspace-resolve-file-path` / `workspace-resolve-root-directory`

## 境界

* **対象**: 上表ドキュメントを正本として読むこと
* **対象外**: {この SKILL が引き受けない隣接領域。委譲先 SKILL があれば名を書く}
* **対象外**: 対象ドキュメントの内容を本 SKILL 本文へ要約・再掲すること
* **対象外**: `markdown-search` の手順・出力形式の再定義
* 文書の新規作成・lint 修正は `markdown-documentation` / `markdown-fix` に委譲する

## 関連

* 段階ロード・把握手順・出力の正本: `markdown-search`
* パス解決: `workspace-resolve-file-path` / `workspace-resolve-root-directory`
* {隣接 SKILL があれば列挙}
