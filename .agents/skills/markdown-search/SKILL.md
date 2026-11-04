---
name: markdown-search
description: >-
  ワークスペース内の Markdown を、見出し TOC（行範囲付き）→ 範囲ロード → 必要時のみ全文、
  の 3 段階で検索・把握する SKILL。Context を最小化しつつ DO / DO NOT や関連 docs を拾う。
  「docs を調べて」「見出しだけ先に」「この節だけ読んで」「関連ドキュメントを把握してから実装／レビュー」、
  コーディング・設計・レビュー前のナレッジ収集時は積極的に使う。
  文書の新規作成は markdown-documentation、lint 修正は markdown-fix、
  Memory 保存は workspace-agent-memory-save。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# ドキュメント検索（Context 最適化）

実装・設計・レビューの前に、既存ドキュメントから必要最小限だけを Context に載せる SKILL である。
全文をいきなり読まず、**見出し一覧（行範囲）→ 指定範囲 →（必要なら）全文** の順で深さを上げる。

段階の意図は [references/context-loading.md](./references/context-loading.md) を参照する。

## いつ使うか

* コーディング・詳細設計・レビュー前のナレッジ収集
* 「どこに書いてあるか」を探すとき
* `### DO:` / `### DO NOT:` を横断したいとき
* 大きな `*.md` を読む前に構造だけ把握したいとき

## 優先して見る配置

リポジトリルート（`.git` があるディレクトリ）からの相対パス:

* `AGENTS.md` やRule/Instructionによって指定されたプロジェクト固有ディレクトリ
* `docs/`: 標準ドキュメントディレクトリ
* `README.md`: 標準README
* `.cursor/skills/`
* `.agents/skills/`
* `apm_modules/`
* `.ai-agent/memory/`（場所は `workspace-layout` / 用途は `workspace-agent-temporary`）

## 同梱スクリプト

行範囲付き TOC と範囲抽出は、この SKILL の `scripts/md_section.py` を使う（Python 3 / 標準ライブラリのみ）。
`SKILL_DIR` は本 `SKILL.md` があるディレクトリ（`.cursor/skills/`・`.agents/skills/`・`packages/.../.apm/skills/` いずれでも可）。

```bash
SCRIPT="$SKILL_DIR/scripts/md_section.py"

# Stage 1: 見出し + 行範囲（子見出しを含む終端）
# 内容 SHA-256 が同一のファイルは、先に現れた 1 件だけ対象にする（コピー二重ロード防止）
python3 "$SCRIPT" toc path/to/file.md
python3 "$SCRIPT" toc --max-level 2 path/to/dir
python3 "$SCRIPT" toc --grep 'DO NOT' path/to/file.md

# 内容重複を落とした path 一覧だけ欲しいとき
python3 "$SCRIPT" unique path/to/directory
python3 "$SCRIPT" unique -v path/a.md path/b.md   # 除外した path を stderr に出す

# Stage 2: 指定範囲だけ出力
python3 "$SCRIPT" print path/to/file.md 629 637
python3 "$SCRIPT" print path/to/file.md --at 675
python3 "$SCRIPT" print path/to/file.md --title '循環参照'
```

`path:start-end` が既に分かっているときは `sed -n 'start,endp' file` でもよい。

コードフェンス内の `#` は見出し扱いにしない。終端は同レベル以上の次見出しの直前（末尾空行は trim）。
`toc` / `unique` は既定で内容ハッシュ重複を除外する。意図的に全コピーを見たいときだけ `toc --keep-duplicates` を使う。

## 把握手順（3 段階）

### Stage 1 — 見出し一覧と行範囲を取る

* 対象 path（ファイルまたは少数の候補）を決め、TOC を取る
* 複数ファイル横断の当たり付けは `--max-level 2` から始め、必要ならレベルを下げる
* 出力の `path:start-end` と見出しテキストだけで関連性を判断する（この時点で本文を読まない）
* HQ / APM で同内容が複数 path にコピーされていることがある。**内容ハッシュが一致するファイルは先頭 1 件だけ**を候補にし、以降の Stage でも同じ本文を二重ロードしない

DO / DO NOT を探すときも、まず TOC か見出し grep で当たりを付ける。
横断検索の前に `unique` で重複を落とし、一致する内容は最初の 1 ファイルだけを対象にする:

```bash
# 内容ハッシュが同一なら先頭 1 ファイルだけ残してから見出し検索
python3 "$SCRIPT" unique path/to/directory \
  | while IFS= read -r f; do rg -n '^### DO( NOT)?:' "$f"; done
# または（toc も同一内容は先頭ファイルのみ出力）
python3 "$SCRIPT" toc --grep '### DO' path/to/directory
```

### Stage 2 — 指定範囲だけロードする

* Stage 1 で選んだ `start-end`（または `--at` / `--title`）だけを読む
* 親子まとめて必要なときは親見出しの範囲を 1 回で取る（例: `## ナレッジベース` 全体）
* 無関係な節は読まない

### Stage 3 — 文書全体をロードする

* Stage 2 だけでは前提・用語・横断関係が足りないと判断したときだけ全文を読む
* 「念のため全文」は避ける。不足理由が説明できるときだけ Stage 3 に進む

### SKILL ドキュメントの追加ロード

`.cursor/skills/{SKILL名}/SKILL.md` および配下 `*.md` がヒットしたら、関連 SKILL を必要に応じてロードする（同様に Stage 1→2）。

## ナレッジベース（DO / DO NOT）

* コーディング・設計時: `### DO:` を探し従う
* レビュー時: `### DO NOT:` を探し指摘に使う
* 条文本文は Stage 2 で当該見出し範囲だけ読む

## 出力の目安

* ヒットした `path:start-end` と見出し一覧
* 採用すべき `DO` / 避けるべき `DO NOT` の要約（必要なら引用）
* 次に読む範囲（または全文が必要な理由）の提案
* どの Stage まで進んだかを明示する（Context 最適化の証跡）
