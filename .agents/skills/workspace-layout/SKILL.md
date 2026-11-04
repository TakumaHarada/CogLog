---
name: workspace-layout
description: >-
  AI Agent 協業向けの推奨ワークスペース・レイアウト（ルート構成）を伝える SKILL。
  リポジトリ整備・新規プロジェクト・「どこにディレクトリを置く？」「レイアウトの推奨は？」
  「AGENTS.md / docs / .ai-agent が無い」「不足ディレクトリを揃えたい」では必ず使う。
  `.ai-agent/` ひな形の導入先は `@this/.ai-agent`（特定サブディレクトリ優先の Git ルート走査はしない）。
  一時ファイルを今すぐ書く置き場の提案だけなら workspace-agent-temporary、
  Memory 本文の書き方は workspace-agent-memory-save を使う。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Layout

Agent と人間が同じ地図を共有できるよう、ワークスペース（`@this/`）の **推奨レイアウト** を定義する。
散在した規約・ドキュメント・一時領域は発見コストと ignore 漏れを増やすため、ここに揃える。

一時成果物を **いまのタスクでどこに書くか** は `workspace-agent-temporary` の責務である。
本 SKILL は「全体の箱」と、**必要になったタイミング**での不足パス提案を担う。

## いつ使うか

* ワークスペース全体の推奨構成を説明する・提案するとき
* ドキュメント作成・Agent 作業などで、推奨パスが未整備だと分かったとき
* 「このファイル／ディレクトリはルートのどこ？」と配置を決めるとき

## いつ使わないか

* 使い捨てスクリプト・計画・調査メモの **置き場選びだけ** → `workspace-agent-temporary`
* Memory 本文のフォーマット → `workspace-agent-memory-save`
* 文書内パスや `{assets}/` の実体解決だけ → `workspace-resolve-file-path` / `workspace-resolve-agent-assets`

## アセットディレクトリ

ひな形の探索先（`{assets}/...` を解決するとき `workspace-resolve-agent-assets` に従う）:

* `./assets/`
* `apm_modules/**/workspace-layout/assets/`

## 推奨レイアウト

`@this/` 直下を基準とする。
本 SKILL は APM 配布を前提とするため、`apm.yml` / `apm_modules/` は構成上そろっている想定である。

```text
@this/
├── AGENTS.md                      # Agent 向けプロジェクト規約（常時 Context）
├── README.md
├── apm.yml                        # APM 依存定義
├── .ai-agent/                     # Agent 作業領域（gitignore・単数形のみ）
│   ├── .gitignore
│   ├── tmp/                       # 使い捨てスクリプト・ログ・下書き
│   ├── plan/                      # 実行中・レビュー中の計画 (*.md)
│   │   └── done/                  # 完了した計画
│   └── memory/                    # 調査結果・引き継ぎ Memory (*.md)
│       └── done/                  # 用済み Memory
├── docs/                          # 技術ドキュメント正本（markdown-*）
└── apm_modules/                   # APM 依存の展開先・Agent アセット探索先
```

### 各要素の役割

| パス | 必須度 | 役割 |
| --- | --- | --- |
| `AGENTS.md` | 推奨 | Agent 向け規約の置き場（常時 Context）。**本 SKILL はパス案内のみ** |
| `README.md` | 推奨 | 人間向け概要の置き場。**本 SKILL はパス案内のみ** |
| `apm.yml` | 前提 | APM 依存定義（本パッケージ配布の前提） |
| `.ai-agent/` | 必要時 | コミットしない作業領域。**単数形のみ** |
| `docs/` | 必要時 | 技術ドキュメント正本 |
| `apm_modules/` | 前提 | APM install の展開先（通常は gitignore） |

### `AGENTS.md` / `README.md`

* 置く場所は `@this/` 直下（上表）である
* **中身・見出し・テンプレートは本 SKILL の対象外**である
* 無いまま規約や README が必要になったら、`@this/` への作成を提案する（本文はユーザー方針や他ドキュメントに任せる）

### `.ai-agent/` の場所

* ディレクトリ名は **`.ai-agent/`（単数形）** のみ
* **一時ファイル・計画・Memory の運用ベース**は `@this/.ai-agent`（`workspace-agent-temporary` / `workspace-resolve-root-directory`）。Git ルート相対で特定サブディレクトリの `.ai-agent` を優先する旧候補順は使わない
* ひな形を導入するときも、導入先は **いまの `@this/.ai-agent`** とする（別 Multi-Root folder へ勝手に作らない）
* 配下の使い分け（`tmp` / `plan` / `memory`）の運用は `workspace-agent-temporary` に委譲する
* Memory の書き方は `workspace-agent-memory-save` に委譲する

## 不足時の扱い（Just-in-time）

先回りで全ディレクトリを埋めない。**そのパスを必要とした作業のタイミング**で、作成または移行を提案する。

1. いま書こうとしている成果物（技術文書・一時ファイル・規約など）を特定する
2. 推奨レイアウト上の配置先を決める
3. 配置先が無ければ、その場で作成・移行を提案する（同意が取れる運用なら作成してよい）
4. `.ai-agent/` が必要になったときだけ `{assets}/.ai-agent/` を **`@this/.ai-agent`** へコピーする
5. `docs/` が必要になったときだけ導入する（ひな形は `{assets}/docs/`）
6. `AGENTS.md` / `README.md` はパス案内に留め、本文は書かない（他 SKILL・ユーザー方針へ）
7. `apm.yml` / `apm_modules/` は APM 前提として地図に含める。欠落に気づいたら「APM ワークスペースとして揃える」旨を短く触れる

```bash
# SCOPE = @this（workspace-resolve-root-directory で絶対パス化）
SCOPE="$(...)"  # いまのワークスペース folder
AI_AGENT_DIR="${SCOPE}/.ai-agent"
# 無ければ {assets}/.ai-agent/ を AI_AGENT_DIR へコピー（workspace-resolve-agent-assets）
```

## 他 SKILL との境界

| SKILL | 責務 |
| --- | --- |
| **本 SKILL** | ルート全体の推奨地図・必要時の不足パス提案・`@this/.ai-agent` へのひな形導入 |
| `workspace-agent-temporary` | 一時ファイルが必要な作業での配置先提案（常に `@this/.ai-agent`） |
| `workspace-resolve-root-directory` | `@this` 等のルート解決 |
| `workspace-agent-memory-save` | Memory の保存フォーマット |
| `markdown-search` / `markdown-documentation` | `docs/` 等の探索・文書作成 |
| `workspace-resolve-file-path` | 文書内の通常パス / Markdown リンク解決 |

## ナレッジベース

### DO: 必要になったパスだけを提案・導入する

* ドキュメント作成なら `docs/`、Agent 一時作業なら `.ai-agent/`、というようにトリガーと導入を結びつける

### DO: `AGENTS.md` / `README.md` は `@this/` 配置のみ案内する

* 本文テンプレートまで抱え込むと、プロジェクト固有の規約と衝突しやすい

### DO: `.ai-agent` は単数形・ignore 済みひな形を `@this` へ置く

* `{assets}/.ai-agent/` をコピーすれば `tmp` / `plan` / `memory` と `.gitignore` が揃う
* 導入先は常に `@this/.ai-agent`（`workspace-resolve-root-directory`）

### DO NOT: 本 SKILL で一時ファイルの中身や Memory 本文ルールまで抱え込む

* それは temporary / memory-save の範囲である

### DO NOT: 未使用の推奨パスを先回りで全部作る

* Just-in-time を崩すとノイズな空ディレクトリが増える
