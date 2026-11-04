---
name: workspace-resolve-agent-assets
description: >-
  ドキュメント内の `{assets}/...` メタ変数を実ファイルパスへ解決する SKILL。
  本文 `## アセットディレクトリ`（`## assets` / `### assets` も可）と互換の
  `metadata.assets` から候補を集め、文書相対とスコープルート相対の両方で探す。
  スコープは暗黙の `@this`（インストール先ワークスペース）か、明示の
  `@app/` / `repo:backend/` 等（workspace-resolve-root-directory で解決）。
  候補に `*` / `**` があれば glob 展開する。
  「`{assets}/template.md`」「@app/{assets}/...」「アセットを解決してからロード」
  「apm_modules の glob でアセットを探して」では必ず使う。
  通常の path/to/file・Markdown リンクは workspace-resolve-file-path、
  `.ai-agent/` の置き場は workspace-layout / workspace-agent-temporary、
  URL メタデータ取得は本 SKILL では扱わない（混同しない）。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Resolve Agent Assets

APM などでインストール先が変わっても参照を保てるよう、アセットは **メタ変数** `{assets}/` で書く。
本 SKILL はその表記を、文書に書かれた候補ディレクトリから実パスへ落とす。
探索の **スコープルート** は、暗黙ではインストール先ワークスペース（`@this`）、明示では `@app/` 等で切り替える（解決は `workspace-resolve-root-directory` に従う）。
`apm install`・fork・`_local` 展開などで `apm_modules/` 配下が揺れる場合は、候補にワイルドカードを書いて複数レイアウトを一度に拾う。

## いつ使うか

* コマンド / SKILL 本文や関連ファイルに `{assets}/template.md` のように書かれているとき
* `@app/{assets}/...` / `repo:backend/{assets}/...` / `@this/{assets}/...` のようにルート付きでアセットを指すとき
* パッケージソースと `apm_modules/` 展開先の両方に同じアセットがあり得るとき
* 「アセットを解決してから読んで」「`{assets}/` の実体はどこ？」と聞かれたとき

## いつ使わないか

* クォート相対 `path/to/file`、Markdown リンク `[text](rel)` → `workspace-resolve-file-path`
* `{assets}/` を含まない純粋な `@` / `repo:` パスだけ → `workspace-resolve-root-directory`
* `.ai-agent/` の導入・置き場 → `workspace-layout` / `workspace-agent-temporary`
* GitHub Issue URL から ID/タイトルを取る（本 SKILL の範囲外）
* キーワードで文書を探すだけ → `markdown-search`

## 作業手順

1. 参照文字列に `@` / `repo:` があれば剥がし、**スコープルート**を決める（下記）
2. `{assets}/` 以降をサフィックスとする
3. 基準ファイルから候補ディレクトリ一覧を集める（候補行自体に `@` / `repo:` があれば、行ごとにスコープを上書きしてよい）
4. 各候補について、リテラルならそのまま・ワイルドカードなら展開し、**文書相対**と **スコープルート相対**（必要ならその Git ルート相対）で存在確認する
5. ヒットを明示し、1 件なら採用、0 件なら推測読みしない

## スコープルート（`@` / `repo:` / 暗黙の `@this`）

アセット探索の「ルート相対」ベースを決める。詳細アルゴリズムは `workspace-resolve-root-directory` に従う。

| 指定 | 意味 |
| --- | --- |
| **無し**（通常の `{assets}/...`） | 暗黙の `@this` — 基準ファイルが属する **インストール先ワークスペース folder** |
| `@this/...` | 同上を明示 |
| `@{name}/...`（例: `@app/`） | その Multi-Root folder（または単一ルート互換）をスコープにする。プロジェクト専用 SKILL から他ルートのアセットを指すときに使う |
| `repo:{name}/...` / `repo:this/...` | 対応する **Git リポジトリルート**をスコープにする |

参照例:

* `{assets}/template.md` → スコープ = `@this`、サフィックス = `template.md`
* `@app/{assets}/example-skill/assets` → スコープ = `@app`、サフィックス = `example-skill/assets`
* `repo:backend/{assets}/template.md` → スコープ = `repo:backend`、サフィックス = `template.md`

`@example` / `repo:example` の文脈読み替えも root-directory の変数規則に従う。

スコープが決まらない（name 不一致・文脈不足）ときはアセット探索に進まず、root-directory と同様に候補 name を報告する。

## 入力の読み方

1. **参照文字列**: 任意の `@` / `repo:` プレフィックスを除き、`{assets}/` 以降をサフィックスとする
2. **候補ディレクトリ**: 同じファイルから、次の順で集める（重複は先勝ちで 1 回にまとめる）
   1. 本文の `## アセットディレクトリ`（または同等見出し `## assets` / `### assets`）直下の箇条書き
   2. frontmatter の `metadata.assets`（旧形式・互換用）
   * プレーン文字列: ディレクトリパス（または glob）。先頭が `@` / `repo:` ならその行のスコープを差し替える
   * Markdown リンク `[label](path)`: `path` を使う
   * インラインコード `` `path` ``: 中身を使う
3. **基準ファイル**: `{assets}/` が書かれているファイル自身（`SKILL.md` / `.prompt.md` / `.cursor/commands/*.md` など）

候補ディレクトリを読んだら、必ず **サフィックスを結合**する（ディレクトリ一覧だけでは実ファイルにならない）。
例: 候補 `../assets/` + 参照 `{assets}/coding/design.md` → `../assets/coding/design.md`。

`## アセットディレクトリ` が無く `metadata.assets` だけの文書、またはその逆でも解決してよい。両方ある場合は本文セクションを先に試し、続けて metadata を試す。

## ワイルドカード（glob）

候補文字列に `*` または `**` が含まれる場合は、**ディレクトリの glob** として展開してからサフィックスを結合する。

| 記号 | 意味 |
| --- | --- |
| `*` | 1 パスセグメント内の任意文字列（`/` は跨がない） |
| `**` | 0 個以上のディレクトリ階層 |

例:

* `apm_modules/**/coding-xm3/.apm/assets/` → `_local/coding-xm3` でも `eaglesakura/.../packages/coding-xm3` でも拾う
* `apm_modules/*/agentic-workspace/.apm/assets/` → `apm_modules` 直下の 1 階層だけの別名に対応

展開ルール:

1. 文書相対ベース `dirname(基準ファイル)` と、**スコープルート**ベース（下記の解決手順）の両方で glob する
2. 各ベース内のマッチは **辞書順（パス文字列の昇順）** に並べ、決定的にする
3. 列挙順は「候補行の出現順 → 文書相対の展開結果 → スコープ側の展開結果」。重複パスは先勝ちで 1 回にまとめる
4. 展開結果が 0 件の候補行は miss として記録し、次の候補行へ進む（推測で別パスを足さない）

リテラル候補（ワイルドカード無し）は従来どおり、展開せず 1 パスとして扱う。

## 解決手順

`SCOPE_ROOT` = 上記スコープルート（絶対パス）。`@` / `folder:` スコープのとき、`REPO_OF_SCOPE = git -C SCOPE_ROOT rev-parse --show-toplevel`（失敗したらスキップ）。

各候補（リテラル、または glob 展開後の各ディレクトリ）について、次の基準で候補ファイルを作る。

1. **文書相対**: `dirname(基準ファイル) / assets候補 / サフィックス`
2. **スコープルート相対**: `SCOPE_ROOT / assets候補 / サフィックス`
3. **スコープの Git ルート相対**（`SCOPE_ROOT` と異なるときのみ）: `REPO_OF_SCOPE / assets候補 / サフィックス`  
   ※ `repo:` スコープでは 2 と 3 が同値になりうる

存在するファイル（またはディレクトリ）を **ヒット**として列挙する。重複パスは 1 回にまとめる。

* ヒットが 1 件 → それを実体として使う
* ヒットが複数 → すべて示し、利用側が選べるようにする。非対話で 1 つに決める必要がある場合は、**列挙順の先勝ち**（文書相対 → スコープルート → Git ルート、同一基準内では辞書順）
* ヒットが 0 件 → 試した候補パス一覧とルールを報告し、推測読みはしない

## 実例（自 package 内の架空コマンド）

本文（要約）:

```markdown
## アセットディレクトリ

* `../assets/example.command/`
* `apm_modules/**/agentic-workspace/.apm/assets/example.command/`
```

互換の frontmatter がある場合（任意）:

```yaml
metadata:
  assets:
    - "[example.command/](../assets/example.command/)"
    - apm_modules/**/agentic-workspace/.apm/assets/example.command/
```

本文参照: `{assets}/template.md`

基準ファイルがパッケージソースの `.apm/prompts/example.command.prompt.md` のとき、主な候補は次になる。

```text
# 文書相対 × 1件目（リテラル）
.apm/prompts/../assets/example.command/template.md
  → .apm/assets/example.command/template.md

# スコープルート相対 × 2件目（glob。install / fork 先が揺れても拾う）
# 暗黙 @this（または明示 @/repo:）の SCOPE_ROOT / REPO_OF_SCOPE 基準
apm_modules/_local/agentic-workspace/.apm/assets/example.command/template.md
apm_modules/**/agentic-workspace/.apm/assets/example.command/template.md
```

```bash
# SCOPE_ROOT は workspace-resolve-root-directory で決める
# 例: 暗黙 @this / 明示 @app / repo:backend
SCOPE_ROOT="..."  # 絶対パス
REPO_OF_SCOPE="$(git -C "$SCOPE_ROOT" rev-parse --show-toplevel 2>/dev/null || true)"
SOURCE_MD="path/to/example.command.prompt.md"
SUFFIX="template.md"
shopt -s globstar nullglob

bases=( "$(dirname "$SOURCE_MD")" "$SCOPE_ROOT" )
if [ -n "$REPO_OF_SCOPE" ] && [ "$REPO_OF_SCOPE" != "$SCOPE_ROOT" ]; then
  bases+=( "$REPO_OF_SCOPE" )
fi

for DIR in \
  "../assets/example.command" \
  "apm_modules/**/agentic-workspace/.apm/assets/example.command"
do
  expanded=()
  if [[ "$DIR" == *[\*\?]* ]]; then
    for base in "${bases[@]}"; do
      matches=( "$base"/$DIR )
      for base_match in "${matches[@]}"; do
        [ -e "$base_match" ] || continue
        expanded+=( "$base_match" )
      done
    done
  else
    for base in "${bases[@]}"; do
      expanded+=( "${base}/${DIR}" )
    done
  fi

  for CAND_DIR in "${expanded[@]}"; do
    CAND="${CAND_DIR%/}/${SUFFIX}"
    if [ -e "$CAND" ]; then
      echo "HIT: $CAND"
    else
      echo "miss: $CAND"
    fi
  done
done
```

### 実例（明示スコープ `@app`）

参照: `@app/{assets}/example-skill/assets`

1. `workspace-resolve-root-directory` で `@app` → `SCOPE_ROOT`（例: `.../repo/pocket_kosodate`）
2. サフィックス = `example-skill/assets`
3. 候補が無い／`.` 相当なら `SCOPE_ROOT/example-skill/assets` を試す
4. 無ければ miss を報告（推測で別 folder を探さない）

プロジェクト専用 SKILL が「アプリ側のアセット」を指すときは、参照または候補に `@app/` を付ける。

## 書き手向けメモ

* 本文・関連ファイルにはインストール先の絶対的な 1 パスだけを書かず、`{assets}/...` を使う
* インストール先 WS 内のアセットは暗黙の `@this` で足りる。他ルートを指すときだけ `@{name}/` を付ける
* 探索先は本文の `## アセットディレクトリ` に **ソース相対**（開発時）と **install 後ルート相対**（利用者ワークスペース）を並べる
* install 後パスは固定の `apm_modules/eaglesakura/.../packages/<pkg>/` より、**ワイルドカード推奨**（fork・`_local`・ネスト深さの揺れに耐える）
  * 推奨例: `apm_modules/**/<package-name>/.apm/assets/`
* 新規・改訂では `metadata.assets` に寄せず、本文セクションを正とする（APM が frontmatter の `metadata` を落とすターゲットでも本文が残る）
* 旧文書の `metadata.assets` だけでも本 SKILL は解決できる
* slash-command 本体の書き方は、各プロジェクトの command 作成用 SKILL / テンプレートに従う

## ナレッジベース

### DO: `{assets}/` は先に候補ディレクトリ一覧を読む

* 通常の相対パス解決やリテラルな `{assets}` フォルダ探索に落とさない

### DO: スコープは暗黙 `@this`、明示は `@` / `repo:`

* インストール先ワークスペースをルート相対の基準にする（cwd の偶然の Git ルートに依存しない）
* 他プロジェクトのアセットは `@app/` 等で明示する
* プレフィックスの解決は `workspace-resolve-root-directory` に委譲する

### DO: 全候補を試し、ヒットを明示する

* install 前後で生きるパスが違うため、1 候補だけで決め打ちしない
* 本文 `## アセットディレクトリ` を先に、無ければ／続けて `metadata.assets` を読む
* ワイルドカード候補は展開してからサフィックス結合する

### DO: install 後パスはワイルドカードで書く

* `apm_modules/**/<pkg>/...` なら `_local` と vendor ネストの両方を同じ行でカバーできる

### DO NOT: `{assets}/` をリテラルなディレクトリ名だと思い込む

* `{assets}` はメタ変数であり、ディスク上のフォルダ名ではない

### DO NOT: 解決失敗時に推測読みする

* 候補とルールを報告し、存在しないパスを開かない
* glob が 0 件でも、勝手に別パッケージ名へ読み替えない
* `@app` が miss でも別 `folders[].name` へ勝手に読み替えない
