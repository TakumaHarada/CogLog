---
name: workspace-agent-memory-save
description: >-
  調査結果や会話サマリを `.ai-agent/memory/` に不揮発化する SKILL。
  「メモリに残して」「調査内容を保存して」「別チャットへ引き継げるようにまとめて」「今の文脈をファイルにして」と依頼されたとき、
  また調査タスクの結論を後続で再利用するときに必ず使う。
  置き場の選び方は `workspace-agent-temporary`（常に `@this/.ai-agent`）、
  `.ai-agent/` ひな形は `workspace-layout`。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Agent Memory Save

長い調査や複数ターンの結論は、チャット履歴だけに置くと失われやすい。
後続チャット・別 Agent・人間が `##` 見出し単位で拾える形で `.ai-agent/memory/` に残す。
ベースは **`@this/.ai-agent/memory/`**（`workspace-agent-temporary`）。

## いつ使うか / いつ保存するか

* ユーザーが調査を依頼し、結果をまとめた直後
* 「保存」「memory」「引き継ぎ」「メモ化」などを求められたとき
* 同じテーマを別チャットで続ける可能性が高いとき

一時スクリプトや生ログだけなら `workspace-agent-temporary` の提案どおり `.ai-agent/tmp/` で足りる。
**再利用したい結論・判断材料・引用**があるときが Memory の対象である。

## 出力先

* パス: `@this/.ai-agent/memory/{文脈を示す短い名前}.md`
* `.ai-agent/` の存在・ひな形は `workspace-layout`、用途別の配置判断は `workspace-agent-temporary`（常に `@this/.ai-agent`、単数形）
* 同テーマの Memory が既にある場合は **新規作成せず更新**する
* 用済みになったら `.ai-agent/memory/done/` へ移してよい

### ファイル名

* 内容が推測できる短い kebab-case（例: `app-dependency-update-precheck-2026-05-09.md`）
* 空白や曖昧な `memo.md` / `notes.md` は避ける

## ドキュメントの書き方

* [テンプレート](./assets/template.md) に従う
* 先頭の `#` は会話内容の一言まとめ
* 本体は `##`（レベル2）でトピック分割する
  * 後続ロードは `##` 単位で概要把握される想定のため、1 見出しに論点が混ざらないようにする
* 箇条書き・表を中心に、結論が先に読めるように書く
* 根拠となるコードやコマンドは引用・実行内容として残す（パスや条件が再現できる粒度）

## 手順

1. `workspace-layout` / `workspace-agent-temporary` に従い `@this/.ai-agent/memory/` の実パスを決める
2. 既存 Memory の有無を確認し、あれば更新・なければ新規作成する
3. テンプレートに沿って見出しを切り、調査結果または引き継ぎサマリを書く
4. 保存先パスをユーザー（または親 Agent）に報告する
