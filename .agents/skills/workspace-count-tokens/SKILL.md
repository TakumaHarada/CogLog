---
name: workspace-count-tokens
description: >-
  Cursor ワークスペースのデフォルト Context（AGENTS.md・alwaysApply rules・SKILL description）と、
  動的ロード時の SKILL.md / docs・references 最大トークンを概算する。
  「トークン量」「コンテキストサイズ」「デフォルト Context」「SKILL が何トークンか」
  「ルールやスキル一覧のサイズ」を測る・比較するときは必ず使う。概算でよい。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Count Tokens

ファイルベースでトークン量を概算する。課金トークンや Cursor UI 表示との一致は保証しない。
出力は必ず [assets/report.md](./assets/report.md) の見出し・表カラムに従う。

## いつ使うか

* デフォルト Context や SKILL / docs のトークン概算を測る・比較するとき
* 「コンテキストサイズ」「SKILL が何トークンか」を知りたいとき

## いつ使わないか

* 会話全体・ツール結果込みの実リクエスト課金を監査するとき
* 単一ファイルの厳密カウントだけで足りるとき

## 計測対象

| 区分 | デフォルト（常時） | 動的（最大） |
| --- | --- | --- |
| `AGENTS.md` / alwaysApply rules / `.cursorrules` | 本文 | - |
| 非 always の rule | description のみ | - |
| `SKILL.md` | description のみ | 全文（他 SKILL 経由の追加ロードは含めない） |
| `docs/` `doc/` `references/` | 含めない | 全文 |
| User Skills（`--include-user-skills`） | description | 全文 |

含めない: システムプロンプト、ツール/MCP スキーマ、User Rules（Settings）、オープン中ファイル、会話履歴。

## 手順

1. `scripts/count_workspace_tokens.py` を **実行**する（自前集計よりスクリプト優先）
2. 標準出力のレポートを [assets/report.md](./assets/report.md) 構成のままユーザーへ示す（3セクションを混ぜない）
   * 各セクション先頭の統計（`ファイル数合計` / `トークン量合計`）を残す
   * `トークン量合計` は常にキロトークン（例: `0.7K Tokens`、`5.0K Tokens`、小数点以下第1位）
3. 概算である旨と未計測項目を一言添える
4. `tiktoken` が無ければスクリプトの提案どおりインストールを案内する
5. 結果を残すなら `.ai-agent/tmp/` へ（`workspace-agent-temporary`）

```bash
# 推奨依存
python3 -m pip install tiktoken
# または: python3 -m venv /tmp/tokencount && /tmp/tokencount/bin/pip install tiktoken

# SKILL_DIR は本 SKILL.md があるディレクトリ
SCRIPT="$SKILL_DIR/scripts/count_workspace_tokens.py"
python3 "$SCRIPT" --root .
# multi-root は --root を繰り返し。ユーザー SKILL 込みは --include-user-skills。JSON は --json。
```

パス解決は `workspace-resolve-file-path` に従う。トークナイザは `tiktoken` の `o200k_base`、無ければ `chars/4`。

## DO / DO NOT

* DO: デフォルトと動的（SKILL / ドキュメント）を分けて報告する
* DO NOT: UI のコンテキスト％や課金トークンと同一視する
* DO NOT: eval / iteration / skill-snapshot 配下を本番 SKILL として数える
