---
name: workspace-agent-temporary
description: >-
  一時ファイルが必要な作業で、配置先（`@this/.ai-agent/` 配下のどれか）を提案する SKILL。
  一時スクリプト（*.sh/*.py/*.ts）、テンポラリ出力、計画ドキュメント、調査下書きを
  「どこに書くか」決めるときは必ず従う。実パスは常に `@this/.ai-agent`
  （workspace-resolve-root-directory）。特定サブディレクトリ優先の Git ルート走査はしない。
  「plan/memory/tmp の使い分け」「このメモは tmp？ memory？」「@this の .ai-agent」
  でもロードする。ひな形導入は workspace-layout、Memory 本文は workspace-agent-memory-save。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Agent Temporary

一時成果物が必要な作業では、置き場を先に決めてから書く。
ルート直下や `docs/`・プロダクションコードへ散らすと、後続 Agent が発見できず ignore 漏れも増える。

**全体の箱（推奨レイアウト・`.ai-agent/` ひな形）** は `workspace-layout` が担う。
本 SKILL は、その箱の中で **いまの作業ファイルをどこに置くか** を提案する。
ベースは常に **`@this/.ai-agent`**（開いている／表記元が属するワークスペース folder 直下）である。

## いつ使うか

* 一時スクリプト・ログ・抽出結果・下書き Markdown を書くとき
* 実行計画（要件・詳細設計・実装手順）を `.md` で残すとき
* 「このファイルは tmp / plan / memory のどれ？」と迷ったとき
* Multi-Root で「どのルートの `.ai-agent` に書くか」を決めるとき

## いつ使わないか

* リポジトリ全体の推奨構成・不足ディレクトリの導入 → `workspace-layout`
* Memory の見出し構成・テンプレート本文 → `workspace-agent-memory-save`
* `@this` 自体の解決アルゴリズムだけ → `workspace-resolve-root-directory`

## 前提: `.ai-agent/` の実パス（常に `@this/.ai-agent`）

* ディレクトリ名は **`.ai-agent/`（単数形）** のみ
* **配置ベースは常に `@this/.ai-agent`**。Git ルート相対で特定サブディレクトリ（例: `headquarters/.ai-agent`）を優先したり、別 Multi-Root folder の `.ai-agent` へ勝手に寄せたりしない
* `@this` の解決は `workspace-resolve-root-directory` に従う（Multi-Root なら表記元／作業対象が属する workspace folder、単一ルートなら開いているワークスペース）
* 無ければ `workspace-layout` に従い、**同じ `@this/.ai-agent` へ**ひな形を導入する（本 SKILL はひな形アセットを持たない）

```bash
# SCOPE = @this（workspace-resolve-root-directory で絶対パス化）
SCOPE="$(...)"  # 例: Multi-Root の name=app → folders[].path が指すディレクトリ
AI_AGENT_DIR="${SCOPE}/.ai-agent"
```

例（架空の Multi-Root / `example-monorepo.code-workspace`）:

| 作業の属する folder（`folders[].name`） | `@this/.ai-agent` |
| --- | --- |
| `docs` | `docs-workspace/.ai-agent` |
| `app` | `../repo/example_app/.ai-agent` |
| `example_backend` | `../repo/example_backend/.ai-agent` |
| `skills` | `../repo/example-skills/.ai-agent` |

## 配置先の提案（サブディレクトリ）

いずれも **`@this/.ai-agent/` 配下**（上で決めた `AI_AGENT_DIR`）である。

| パス（`@this` 相対） | この作業向けの用途 |
| --- | --- |
| `.ai-agent/tmp/` | タスク用の使い捨てファイル（`*.sh` `*.py` `*.ts` `*.md` `*.txt` など） |
| `.ai-agent/plan/` | 実行中・レビュー中の計画ファイル（`*.md`） |
| `.ai-agent/plan/done/` | 完了した計画の保管先 |
| `.ai-agent/memory/` | 会話コンテキスト・調査結果の Memory（書き方は `workspace-agent-memory-save`） |
| `.ai-agent/memory/done/` | 用済み Memory の保管先 |

### `.ai-agent/tmp/`

* プロダクションコードや `docs/` に置かず、ここに書く
* 機密・大きなバイナリもここに閉じ込める（ルート `.gitignore` で除外される想定）

### `.ai-agent/plan/`

* 計画は `*.md` のみ
* 完了後は `plan/done/` へ移してよい

### `.ai-agent/memory/`

* 「再利用したい結論・判断材料」があるとき。フォーマットは `workspace-agent-memory-save`
* 使い捨て下書きだけなら `tmp/` で足りる

## 作業手順

1. `@this` を `workspace-resolve-root-directory` で決め、`AI_AGENT_DIR = @this/.ai-agent` とする
2. 書く成果物の種類（使い捨て / 進行中計画 / 再利用 Memory）を判別する
3. 上表で配置先を決める。`AI_AGENT_DIR` が無ければ先に `workspace-layout` で **同じパスへ**導入する
4. ファイルを作成し、採用した絶対パス（または `@this/.ai-agent/...`）を報告する

## ナレッジベース

### DO: 一時ファイルのベースは常に `@this/.ai-agent`

* いま属しているワークスペース folder に閉じる。別 folder の `.ai-agent` へ横断しない

### DO NOT: Git ルート走査で別 folder の `.ai-agent` を優先する

* それは旧ルール。Multi-Root では作業中の folder と違うルートへ書く誤りにつながる

### DO NOT: `.ai-agents` やリポジトリ直下へ散らす

* 単数形 `.ai-agent` とサブディレクトリ規約を守る
