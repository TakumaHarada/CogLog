---
name: workspace-resolve-root-directory
description: >-
  VS Code / Cursor の Workspace で `@{name}/path`（優先）・互換の `folder:{name}/path`・
  `repo:{name}/path` を実ファイルパスへ解決する SKILL。`@HQ` と `folder:HQ` は同一の
  folder ルート。Multi-Root では `{name}` は folders[].name、`@` / `folder:` は
  folders[].path、`repo:` は同 folder 起点の Git ルート（ズレうる）。
  ルートが 1 つだけのときは互換のため `{name}` を無視し、開いているワークスペース
  ディレクトリを起点にする。予約名 `@this` / `folder:this` / `repo:this`、指定なしは
  暗黙の `folder:this/`（`@this/` と同義）。変数名 `example`（`@example` /
  `folder:example` / `repo:example`）はプロンプト文脈に応じて実 folders[].name へ
  読み替える。「@backend/...」「folder:backend/...」「repo:example/README.md」
  「@this」「文脈で example を解決」「単一ルートで @」「マルチルートの名前でパス解決」
  では必ず使う。通常の path/to/file・Markdown リンクは workspace-resolve-file-path、
  `.ai-agent/` の置き場は workspace-layout / workspace-agent-temporary、
  `{assets}/...` は workspace-resolve-agent-assets を使う。
  URL メタデータ取得は本 SKILL では扱わない（混同しない）。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Workspace / Resolve Root Directory

VS Code / Cursor の Workspace では、ルートに表示名が付くことがある。
参照は次の **系統**で書く。ドキュメント・プロンプトでは **`@{name}` を優先**し、
`folder:{name}` は同じ意味の互換記法としてどちらもパースする（Cursor の `@` 参照と揃える）。

| 記法 | ルートの意味（Multi-Root） | ルートの意味（単一ルート） |
| --- | --- | --- |
| `@{name}/...`（**優先**） | `folders[].name` → `folders[].path`（エディタ上のルート） | `{name}` を**無視**し、開いているワークスペースディレクトリ |
| `folder:{name}/...`（互換） | **上と同一**（`@{name}/...` と同じ `FOLDER_ROOT`） | **上と同一** |
| `repo:{name}/...` | その folder 起点の **Git リポジトリルート** | `{name}` を**無視**し、開いているワークスペース起点の **Git ルート** |
| `@example/...` / `folder:example/...` / `repo:example/...` | **変数**。文脈から実 `folders[].name` へ読み替えてから上記どおり解決 | `{name}` 無視（単一ルート互換。読み替え不要） |
| `@this/...` / `folder:this/...` / 指定なし | 表記元が属する workspace folder（最長一致） | 開いているワークスペースディレクトリ |
| `repo:this/...` | 表記元が属する **Git リポジトリルート** | 同左 |

**等価の例:** `folder:HQ` と `@HQ` は同じディレクトリ（`name == "HQ"` の `folders[].path`）を指す。
`repo:HQ` は Git ルート側であり、`@HQ` / `folder:HQ` とは一致しないことがある。

Multi-Root では通常の `{name}` は **ディレクトリ名ではなく** `folders[].name` を使う（パス断片の推測はしない）。
例外として予約変数 `example` だけは、プロンプト／タスク文脈に応じて実 name へ読み替えてよい（下記 **特殊ルール / `example`**）。
`folders[].path` がリポジトリのサブディレクトリを指すと、`@` / `folder:` と `repo:` は一致しない。
例: `name=docs` の `path` が `docs-workspace/` でも、Git ルートが親の `example-monorepo/` なら、`@docs/README.md`（=`folder:docs/README.md`）と `repo:docs/README.md` は別ファイルになる。

## いつ使うか

* 表記が `@{name}/...`・`folder:{name}/...`・`repo:{name}/...` のとき（Multi-Root / 単一ルートどちらでも）
* `@example/...` / `folder:example/...` / `repo:example/...` を文脈の対象ルートへ読み替えるとき
* ルート名の指定が無く、workspace folder 相対として解く必要があるとき（暗黙の `@this/` = `folder:this/`）
* 「`@docs/...` / `folder:docs/...` / `repo:docs/...` / `@this` の実体は？」「folders 名で解決して」と聞かれたとき

## いつ使わないか

* クォート相対 `path/to/file`（Git リポジトリルート相対が意図）・Markdown リンク → `workspace-resolve-file-path`
* `.ai-agent/` の導入・置き場 → `workspace-layout` / `workspace-agent-temporary`
* `{assets}/...` または `@`/`folder:`/`repo:` 付き `{assets}/...` → `workspace-resolve-agent-assets`（スコープは本 SKILL の規則で決める）
* URL → タスクID / タイトル（本 SKILL の範囲外）
* チャット上のメンション（例: ユーザー `@eaglesakura`）や、workspace folder 名ではない単なる `@` 記号 → 本 SKILL のパス解決対象外

## 作業手順

1. プレフィックスを判別する（`@` / `folder:` / `repo:` / **指定なし**）
2. **`@`** は **`folder:` と同一意味**として扱う（以降の手順では folder ルート解決に進む）。どちらで書かれても同じ結果にする
3. **指定なし**（`@` も `folder:` も `repo:` も無いが、本 SKILL の文脈でルート相対に解く必要がある）→ 暗黙的に `@this/{relative-path}`（=`folder:this/{relative-path}`）として扱う
4. `{name}` が `this` のとき → **特殊ルール / `this`**
5. `{name}` が `example`（または文書上の `{example}`）のとき → **特殊ルール / `example`** で実 name へ読み替えてから続行
6. ワークスペースのルート数を判別する（単一ルート / Multi-Root）
7. **単一ルート**なら **互換ルール / 単一ルート** へ進む（`{name}` は見ない。`this` / `example` も同じ結果になる）
8. **Multi-Root** かつ通常の `{name}` なら `*.code-workspace` を特定し、`folders[]` から `name == {name}` を 1 件選ぶ
9. `FOLDER_ROOT` を求め、プレフィックスに応じてベースを決める
   * `@` / `folder:` → `BASE = FOLDER_ROOT`
   * `repo:` → `BASE = git -C FOLDER_ROOT rev-parse --show-toplevel`（失敗したら推測せず報告）
10. `TARGET = normalize(BASE / {relative-path})` を存在確認してから読む・書く
11. name 不一致（Multi-Root 時・`example` 読み替え不能を含む）・Git ルート取得失敗・ファイル無しは推測解決しない。候補とルールを報告する

## 入力の読み方

```text
@{name}/{relative-path}            # 優先記法（folder ルート）
folder:{name}/{relative-path}      # 互換（上と同一）
repo:{name}/{relative-path}
{relative-path}                    # 指定なし → 暗黙の @this/{relative-path}
```

| 部分 | 意味 |
| --- | --- |
| `{name}` | Multi-Root では通常 `folders[].name`。単一ルートでは**無視**。予約語 `this` / 変数 `example` は下記 |
| `{relative-path}` | 選んだベース（folder ルートまたは Git ルート）からの相対パス。ルート自体だけ指すときは省略可（例: `@HQ` = `folder:HQ`） |

例（Multi-Root）:

* `@backend/README.md`（=`folder:backend/README.md`）→ `name == "backend"` の path 配下の `README.md`
* `@HQ` と `folder:HQ` → 同じ `FOLDER_ROOT`（相対パスなし）
* `@example/README.md`（文脈が「backend 側」）→ 読み替え後 `@backend/README.md` と同じ
* `repo:example/README.md`（文脈が「app 側」）→ 読み替え後 `repo:app/README.md` と同じ
* `@this/README.md`（=`folder:this/README.md`）→ 表記元文書が属する workspace folder 直下の `README.md`
* `README.md`（指定なし・本 SKILL 文脈）→ 暗黙の `@this/README.md`

例（単一ルート）:

* `repo:example/README.md` → 開いている場所起点の Git ルートの `README.md`（`example` は無視）
* `@example/README.md`（=`folder:example/README.md`）→ 開いているワークスペースディレクトリ直下の `README.md`

Cursor / VS Code の `@docs/README.md` は Multi-Root では **folder ルート**側（`@docs/...` = `folder:docs/...`）に相当する。Git ルートが欲しいときは `repo:` を使う。

## 互換ルール / 単一ルート

ルートディレクトリが **1 つ**のとき（通常のディレクトリをワークスペースとして開いた場合、または実質ルートが 1 つだけの場合）は、ドキュメント互換のため `{name}` を照合しない。

1. `WORKSPACE_FOLDER` = いま開いているワークスペースのルートディレクトリ
2. `{name}` は読み捨てる（存在しない name でもエラーにしない。`this` も同様に `WORKSPACE_FOLDER` 起点）
3. ベースを決める
   * `@{name}/{relative-path}` / `folder:{name}/{relative-path}` および暗黙の `@this/` → `BASE = WORKSPACE_FOLDER`
   * `repo:{name}/{relative-path}` → `BASE = git -C WORKSPACE_FOLDER rev-parse --show-toplevel`
4. `TARGET = normalize(BASE / {relative-path})` を存在確認する

```bash
# 単一ルートの概念例（{name} は無視）
WORKSPACE_FOLDER="/path/to/opened-folder"          # 例: リポジトリの docs/ を単体で開いている
# @example/README.md や folder:example/README.md、暗黙の @this/README.md
TARGET="$WORKSPACE_FOLDER/README.md"
# repo:example/README.md
REPO_ROOT="$(git -C "$WORKSPACE_FOLDER" rev-parse --show-toplevel)"
TARGET="$REPO_ROOT/README.md"
```

意図: Multi-Root 向けに書かれた `@foo/...` / `folder:foo/...` / `repo:foo/...` を、単一ルート環境でも同じ記法のまま読めるようにする。

## 特殊ルール / `this`（`@this` / `folder:this` / `repo:this`）

`this` は **予約名**であり、`folders[].name` に `"this"` が登録されていることは想定しない（あっても照合しない）。
`@this` と `folder:this` は同一（folder ルート）。`repo:this` だけが Git ルート。

### 共通: 基準ファイル

表記が書かれている側の SKILL / コマンド / 文書を `SOURCE` とする（絶対パスに正規化）。

### `@this/{relative-path}` / `folder:this/{relative-path}`

表記元が属する **workspace folder**（エディタ上のルート）をベースにする。Git ルートではない。

1. **単一ルート**: `FOLDER_ROOT = WORKSPACE_FOLDER`
2. **Multi-Root**: 各 `folders[].path` を絶対パス化し、`SOURCE` を **最長一致のプレフィックス**として含む folder を選ぶ。どれにも含まれなければ推測せず報告する
3. `TARGET = normalize(FOLDER_ROOT / {relative-path})`

```bash
# Multi-Root: SOURCE が .../docs-workspace/guides/a.md で、docs の path が docs-workspace のとき
FOLDER_ROOT=".../docs-workspace"
TARGET="$FOLDER_ROOT/README.md"
```

### `repo:this/{relative-path}`

表記元が属する **Git リポジトリルート**をベースにする。

```bash
ROOT="$(git -C "$(dirname "$SOURCE")" rev-parse --show-toplevel)"
TARGET="$ROOT/{relative-path}"
```

### 暗黙の `@this/`（指定なし）

`@` / `folder:` / `repo:` もルート `{name}` も無い相対パスを、**本 SKILL の文脈で**ルート相対として解く必要があるときは、暗黙的に `@this/{relative-path}`（=`folder:this/{relative-path}`）と同じにする。

* 意図を Git リポジトリルート相対に固定したいクォート `path/to/file` は、従来どおり `workspace-resolve-file-path`（暗黙の `@this/` にしない）
* Markdown リンクはリンク元相対のまま `workspace-resolve-file-path`

確実性: Multi-Root で「どの name か」が書かれていない参照を、ディレクトリ名推測で当てに行かず、**いまの文書が属する folder** に固定できる。

## 特殊ルール / `example`（読み替え変数）

`example` は **変数名**である。ドキュメントやプロンプトで「どれか 1 つのルート」を示すプレースホルダとして使い、実行時に実 `folders[].name` へ読み替える。

対象表記:

* `@example/...` / `folder:example/...` / `repo:example/...`
* 文書上の `@{example}/...` / `folder:{example}/...` / `repo:{example}/...`（中括弧はプレースホルダ表記。中身は変数 `example`）

### 読み替え手順（Multi-Root）

1. `folders[]` に `name == "example"` が **実際に存在する** → 通常の name として厳密一致で解決する（変数扱いにしない）
2. 存在しない → プロンプト／タスク文脈から、指しているルートを 1 件に決める
   * 根拠の例: 「backend」「app」「HQ」、`@backend`、対象リポジトリ名と `folders[].name` / `path` の対応が文脈上明らか
   * 決めた name が `folders[].name` に含まれることを確認する
3. 読み替え後の name で、通常の `@` / `folder:` / `repo:` 解決を続行する（`@` と `folder:` は同じ folder ルート）
4. 文脈が無い・複数候補で一意に決まらない・候補外 → **読み替えない**。`folders[].name` 一覧と文脈不足を報告する（勝手に選ばない）

```text
# 文脈: 「バックエンド側の README」
@example/README.md       →  @backend/README.md
folder:example/README.md →  @backend/README.md（同じ）
repo:example/README.md   →  repo:backend/README.md
```

### 単一ルート

`example` も他の `{name}` と同様 **無視**する（開いているワークスペース起点）。文脈読み替えは不要。

### `example` 以外は読み替えない

`foo` / `myapp` / ディレクトリ basename などを文脈だけで別 name にマップしない。変数として許すのは **`example` のみ**。

## `.code-workspace` の特定（Multi-Root 時）

次の順で、最初に使えるものを採用する。

1. ユーザーがパスや `@...code-workspace` で明示したファイル
2. いま開いている Multi-Root Workspace の定義ファイル（分かれば）
3. 作業ツリーから `*.code-workspace` を探索（複数ある場合はユーザーに確認するか、明示されたものを優先）

見つからない場合は解決を中断し、workspace ファイルの場所を尋ねる。
単一ルートでディレクトリのみ開いているときは code-workspace は不要（前節の互換ルール）。

## 解決アルゴリズム（Multi-Root）

`*.code-workspace` は JSON（末尾カンマを許すエディタ拡張があるため、パース失敗時は末尾カンマ除去も試してよい）。

```json
{
  "folders": [
    { "path": ".", "name": "docs" },
    { "path": "../repo/example_backend", "name": "example_backend" }
  ]
}
```

### 共通: folder エントリの解決

`this` 系・変数 `example` の読み替え後・単一ルート互換以外:

1. `WORKSPACE_FILE` / `WORKSPACE_DIR = dirname(WORKSPACE_FILE)`
2. `folders` から `name == {name}` を 1 件選ぶ（複数一致は定義ミス。止める）
3. `FOLDER_ROOT = normalize(WORKSPACE_DIR / folders[].path)`  
   ※ `path` は **常に `WORKSPACE_DIR` からの相対**（絶対パスが書いてある場合のみそのまま）

### `@{name}/...` / `folder:{name}/...`

どちらも同じ。

```text
BASE = FOLDER_ROOT
TARGET = normalize(BASE / {relative-path})
```

```bash
WORKSPACE_DIR="$(dirname "$WORKSPACE_FILE")"
# name=docs → path=. のとき（@docs/README.md も folder:docs/README.md も同じ）
FOLDER_ROOT="$(cd "$WORKSPACE_DIR/." && pwd)"
TARGET="$FOLDER_ROOT/README.md"
```

### `repo:{name}/...`（`this` 以外）

```text
BASE = git rev-parse --show-toplevel（作業ディレクトリ = FOLDER_ROOT）
TARGET = normalize(BASE / {relative-path})
```

```bash
FOLDER_ROOT="$(cd "$WORKSPACE_DIR/." && pwd)"   # 例: .../docs-workspace
REPO_ROOT="$(git -C "$FOLDER_ROOT" rev-parse --show-toplevel)"  # 例: .../example-monorepo
TARGET="$REPO_ROOT/README.md"
```

`FOLDER_ROOT` と `REPO_ROOT` が同じことも、親ディレクトリへ上がることもある。どちらも正しい結果であり、推測で打ち消さない。

## 出力

* **主結果**: 実ファイル（またはディレクトリ）の絶対パス
* 必要なら併記: 単一 / Multi-Root、プレフィックス（`@` / `folder:` / `repo:`、または暗黙の `@this`）、`@` を `folder:` 相当として解いた旨、`example` を読み替えた場合は **変換前→変換後の name**、`FOLDER_ROOT` / `WORKSPACE_FOLDER`、`repo:` なら `REPO_ROOT`
* 失敗時（Multi-Root の name 不一致・`example` の文脈不足など）: 不一致の `{name}`、`folders[].name` 一覧、使った文脈根拠（あれば）、`WORKSPACE_FILE`、Git エラーを示し、推測読みしない
* 単一ルートでは `{name}` 不一致を失敗理由にしない

## ナレッジベース

### DO: 先に単一ルートか Multi-Root かを判別する

* 単一なら `{name}` を無視し、開いているワークスペースディレクトリを起点にする（互換）

### DO: `@{name}` を優先し、`folder:{name}` も同じ意味でパースする

* Cursor 互換のためドキュメント・新規記載は `@` を優先する
* 既存の `folder:` 表記は壊さず、同じ `FOLDER_ROOT` に落とす（例: `@HQ` ≡ `folder:HQ`）

### DO: ルート名の指定が無いときは暗黙の `@this/`（=`folder:this/`）

* ディレクトリ名推測で Multi-Root のどれかに当てない。表記元が属する folder に固定する
* Git ルート相対が意図のクォート path は `workspace-resolve-file-path` のまま

### DO: `@example` / `folder:example` / `repo:example` は文脈で実 name へ読み替える

* 変数専用。読み替え後は通常の `folders[].name` 照合に戻る
* 一意に決まらなければ失敗報告（候補一覧を出す）

### DO: code-workspace 上の位置は `@` / `folder:`、Git ルートは `repo:`

* path と repo root のズレを吸収するため、用途でプレフィックスを分ける
* 単一ルートでも同じ（folder = 開いているディレクトリ、repo = その Git ルート）

### DO: Multi-Root では通常の `{name}` は `folders[].name`（`this` / 変数 `example` 以外）

* ディスク上のディレクトリ名（例: `example_backend_checkout`）と `name`（例: `backend`）は一致しないことがある

### DO: `folders[].path` は code-workspace ファイル基準の相対パス

* カレントや「なんとなくの Git ルート」基準にしない

### DO: `@this` / `folder:this` は workspace folder、`repo:this` は Git ルート

* 両者を混同しない（ズレうる）

### DO: 解決後に存在確認してから読む

### DO NOT: 単一ルートで `{name}` 不一致をエラーにする

* 互換のため無視する

### DO NOT: `@` / `folder:` と `repo:` を同じパスだと決めつける

* サブディレクトリが folder（または単一でサブディレクトリを開いている）とき、`repo:` は親リポジトリのパスになりうる

### DO NOT: `example` 以外の name を文脈だけで読み替える

* `@foo/...` / `folder:foo/...` を黙って `backend` にマップしない
* ディレクトリ basename だけの推測も禁止（従来どおり）

### DO NOT: 文脈が曖昧なまま `example` をどれかへ当てる

* 複数候補・根拠不足なら報告して止める

### DO NOT: クォート Git ルート相対を勝手に `@this` / `folder:this` へ読み替える

* → `workspace-resolve-file-path`

## 関連

* 通常パス / リンク: `workspace-resolve-file-path`
* `.ai-agent/` 置き場: `workspace-layout` / `workspace-agent-temporary`
* `{assets}/...`: `workspace-resolve-agent-assets`
* URL → タスクID / タイトル（本 SKILL の範囲外）
