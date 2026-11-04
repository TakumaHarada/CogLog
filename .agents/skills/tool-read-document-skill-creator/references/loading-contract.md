# 索引 SKILL のロード契約

生成するドキュメント読み込み SKILL（索引 SKILL）が守るべき契約の要約である。
実行時のスクリプト・終端ルール・出力の正本は常に `markdown-search`（およびその `references/context-loading.md`）とする。

**生成 SKILL 本文には Stage 手順や出力の目安を再掲しない。** Context 節約のため `markdown-search` への誘導に留める。
本ファイルは作成者向けの契約メモであり、生成物へコピーしない。

## なぜ Stage 1 を必須にするか（作成者向け）

全文を先に Context へ載せると、トークンを浪費し、関連節の判断も鈍る。
索引 SKILL の役割は「読むべき候補を示す」ことであり、「全部を記憶させる」ことではない。
実行時は `markdown-search` に従い、**最初の一手は見出し TOC（Stage 1）** とする。

## 3 段階（正本は markdown-search）

| Stage | やること | いつ |
| --- | --- | --- |
| 1 | 見出し + 行範囲 TOC。本文は読まない | **必須・最初** |
| 2 | 選んだ `start-end` / 見出しだけ読む | TOC で関連が取れたとき |
| 3 | 文書全体 | Stage 2 でも前提・横断が足りず、理由を説明できるときだけ |

## トリガーとプロンプト制約

* トリガー文は **`description` に集約**する（参照ドキュメントの主題から作る）
* ユーザーや親が文書・節を制約したら、索引の全件消化より制約を優先する
* 制約が無いときは対象一覧を候補集合とし、それでも `markdown-search` の Stage 1 から入る

## 生成本文に書いてよいこと / 書いてはいけないこと

### 書いてよい

* 対象 path（解決可能な表記）のみの一覧
  * リンク / クォート相対 → `workspace-resolve-file-path`
  * `@` / `repo:` → `workspace-resolve-root-directory`
* 「いつ読むか」を `description` に集約したトリガー
* 「読み方は `markdown-search`」「path 解決は `workspace-resolve-*`」という誘導

### 書いてはいけない

* Stage 1→2→3 の手順や出力の目安の再掲（正本は `markdown-search`）
* 対象ドキュメントの内容要約・再掲（正本との齟齬の元）
* ドキュメント個別の「いつ読むか」注記（トリガーは `description` のみ）
* `md_section.py` や path 解決アルゴリズムの再定義
* 「適用したらまず全文 Read」を既定手順にする
* 実在確認していない path や、解決 SKILL で解けない曖昧表記を一覧に入れる
* slash-command 用の非対話エラー契約や Mermaid 必須を混ぜる
