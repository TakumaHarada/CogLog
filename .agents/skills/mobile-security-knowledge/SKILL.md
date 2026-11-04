---
name: mobile-security-knowledge
description: >-
  モバイル／バックエンド／GCP／Firebase のセキュリティナレッジを、同梱 references から
  markdown-search の段階ロードで引き、要件の DO 提案とレビューの DO NOT 監査に使う。
  `/plan.init`・Plan モード初期化・実装計画、`/coding.requirement`・要件定義・計画ファイル
  （`.ai-agent/plan`）の要件／技術要件／セキュリティ要件／暗黙的な要件の整理、
  `/coding.design`・詳細設計・ジュニア実装粒度への落とし込み、
  `/coding.loop`・`/loop /coding.loop`・DO NOT 監査クリア・Coding-Commands の自律ループ、
  および `engineer-software-requirement` / `engineer-software-design` と併用する作業では
  必ずロードする（これらのコマンドが SKILL 名を直書きしていなくても、同時利用が前提）。
  コードレビュー、セキュリティレビュー、PR 指摘、AndroidManifest・ATS・IAM・App Check・
  Security Rules・OWASP MAS／MASTG の確認、機密・暗号化・権限・認証・不正対策・クラウド基盤の
  話が出たときも使う。ユーザーが「セキュリティ」と言わなくてもロードする。
  ナレッジ本文は SKILL に持たず references を正本とする。
---

# Mobile Security Knowledge

公式・OWASP 等を蒸留したセキュリティナレッジを、**必要な文書だけ** Context に載せて使う SKILL である。
条文の正本は同梱 `references/` であり、本 Body にはセキュリティ知識そのものを書かない。
文書の書式は `markdown-documentation` に従っている（`## 概要` / 原則+補足+実装例 / `### DO:` / `### DO NOT:` / `## 参考リンク`）。

## いつ使うか

* `/plan.init` / Plan モードで実装計画・関連 SKILL 適用を行うとき
* `/coding.requirement` で要件・技術要件・セキュリティ要件・暗黙要件を計画へ落とすとき
* `/coding.design` で詳細設計し、DO／推奨に沿った実装方針を書くとき
* `/coding.loop`（`/loop /coding.loop`）で DO NOT 監査を含む設計→実装ループを回すとき
* コードレビュー・セキュリティレビューで、禁止事項（DO NOT）を洗い出すとき
* 上記以外でも、認証・権限・暗号・クラウド／Firebase／モバイル基盤の話が出たとき

Coding-Commands（`plan.init` / `coding.requirement` / `coding.design` / `coding.loop`）側は本 SKILL への直リンクを持たない。
**同時利用が前提**のため、それらのフローに入ったら本 SKILL を自らロードし、探査手順を適用する。

## Coding-Commands / Plan 併用時の振る舞い

直リンクが無くても、次の合図があれば本 SKILL をロード済みとして扱う。

| 合図 | 本 SKILL での主作業 |
| --- | --- |
| `/plan.init` / Plan モード | 主題に触れる領域の `references/` を Stage 1 で当たり、関連 DO を計画提案に織り込む |
| `/coding.requirement` | `### DO:` を「セキュリティ要件」または「技術要件」（および暗黙的な要件）へ参照付きで提案する |
| `/coding.design` | 詳細設計が DO に沿い、関連 `### DO NOT:` を設計に残さない |
| `/coding.loop` / DO NOT 監査 | ループのゲートとして関連 DO NOT を照合し、**残 0 件**になるまで指摘・差し戻しする |

`engineer-software-requirement` / `engineer-software-design` が「関連 SKILL・ドキュメントの DO / DO NOT を使え」と指示している場合も、その正本探索先として本 SKILL の `references/` を使う。

## 前提

* ナレッジの正本は同梱 `references/`（サイト／標準ごとのディレクトリ）
* 探索手順の正本は `markdown-search`（Stage 1 → 2 → 3）
* 文書を新規に書く・直す作業は `markdown-documentation`（本 SKILL の主用途ではない）

## ディレクトリ案内（絞り込み用）

文脈が明確なら Stage 1 の対象を次に絞る。不明なら `references/` 全体から始める。

| 文脈 | 優先ディレクトリ |
| --- | --- |
| Android 実装・マニフェスト・権限・不正対策 | `references/developer.android.com/`（併せて `references/mas.owasp.org/`） |
| iOS / Apple 開発者向けセキュリティ | `references/developer.apple.com/`（併せて `references/mas.owasp.org/`） |
| OWASP MAS / MASVS / MASTG / Best Practices / Tests（Android・iOS の知識・テスト・Best Practices を含む） | `references/mas.owasp.org/` |
| Google Cloud IAM・秘密・Cloud Run 等 | `references/cloud.google.com/` |
| Firebase App Check・Rules・Checklist・環境分離 | `references/firebase.google.com/` |

各ディレクトリの `0000-index.md`（あれば）は入口である。Stage 1 で索引の見出しを先に取ると迷いが減る。
Android / iOS の話題でも公式プラットフォーム文書（`developer.android.com` / `developer.apple.com`）だけに絞らず、`mas.owasp.org` の該当章も Stage 1 の候補に含める。

## 手順（探査）

`SKILL_DIR` は本 `SKILL.md` のディレクトリ。`markdown-search` の `md_section.py` を使う（`markdown-search` の SKILL に従い `SCRIPT` を解決する）。

### 1. Stage 1 — 見出し TOC で候補を付ける

* 対象: `references/` または上表で絞ったディレクトリ
* `--max-level 2` から始め、必要ならレベルを下げる
* この時点では本文を読まない。`path:start-end` と見出しだけで関連性を判断する
* 内容ハッシュが同一のコピーが複数ある場合は、`markdown-search` の重複除外に従い先頭 1 件だけを候補にする

```bash
python3 "$SCRIPT" toc --max-level 2 "$SKILL_DIR/references"
python3 "$SCRIPT" toc --max-level 2 "$SKILL_DIR/references/developer.android.com"
python3 "$SCRIPT" toc --grep '### DO NOT' "$SKILL_DIR/references/firebase.google.com"
```

### 2. 候補の `## 概要` だけ追加ロードする

* Stage 1 で関連しそうな文書について、`## 概要` の行範囲だけを Stage 2 で読む
* 概要で「この変更／レビューに要るか」を判断する。不要なら以降を読まない

```bash
python3 "$SCRIPT" print path/to/doc.md --title '概要'
```

### 3. Stage 2 → Stage 3（必要な節だけ深掘り）

* 要件定義: `### DO:` および親の `## ナレッジベース` 範囲を優先して読む
* レビュー: `### DO NOT:` および関連する原則・実装例の範囲を優先して読む
* なお不足し、前提や横断関係が必要なときだけ Stage 3（全文）。「念のため全文」は避ける

### 4. まだ足りないとき — `## 参考リンク` から辿る

* 同梱蒸留で不足する場合のみ、当該文書の `## 参考リンク` を Stage 2 で読み、公式 URL や隣接ドキュメントへ進む
* 参考リンク先を読むときも、可能な限り Stage 1 → 2 を崩さない

## 使い分け（DO 提案 / DO NOT 監査）

### 要件定義 — DO に従い要件へ提案する

関連する `### DO:` を、計画・要件文書の **セキュリティ要件** または **技術要件** への追加提案として書く。
必ず同梱ドキュメントへの参照パスを併記する（条文の再発明をしない）。

```markdown
## 技術要件

* ビルド完了後の AndroidManifest を確認し、security 関連属性が適切であること
  * `references/developer.android.com/0002-security-tips.md`
```

提案単位の目安:

* 1 つの DO（または密接な DO 群）→ 1 箇条
* 参照は本 SKILL からの相対 path（`references/...`）を残す
* 行範囲が分かるときは `references/.../file.md:start-end` または `path:start-end` を併記してよい

### レビュー — DO NOT を 1 件も残さない

* 差分・設計に対し、関連文書の `### DO NOT:` を照合する
* 該当する DO NOT が残っている場合は、指摘として必須にする（任意コメントに下げない）
* 指摘には、違反内容と参照ドキュメント path（`references/...`、可能なら `path:start-end`）を付ける

## 出力の目安

* 使った探索範囲（ディレクトリ）と、進んだ Stage（1 / 概要 / 2 / 3 / 参考リンク）
* 採用した文書 path 一覧
* 要件時: 追加提案する DO 箇条 + 参照 path
* レビュー時: 残すべきでない DO NOT の指摘一覧（0 件ならその旨）

## 関連 SKILL

* `markdown-search` — TOC / 範囲ロードの手順とスクリプト
* `markdown-documentation` — references 文書の構造（読むときの見出し期待）
