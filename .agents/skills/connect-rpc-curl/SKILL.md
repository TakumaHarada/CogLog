---
name: connect-rpc-curl
description: >-
  Connect RPC（Unary）の HTTP サービスを `buf curl` で呼び出す SKILL。
  `*.proto` の rpc / message から JSON リクエストを組み立て、`--protocol connect`
  でコールするときに使う。
  「Connect RPC を叩く」「buf curl」「proto から curl」「RPC をローカル検証」
  「Authorization 付きで Connect を呼ぶ」では必ず使う。
  gRPC 生プロトコル専用クライアントや、Stream RPC の検証手順では使わない。
---

# Connect RPC / curl

Connect RPC の Unary HTTP サービスを、`buf curl` + JSON で呼び出す。
`*.proto` の定義をそのまま JSON に写すのが基本で、フレームワーク固有の変換レイヤは不要。

## いつ使うか

* Connect RPC（Unary）のエンドポイントを手元から検証したいとき
* proto の `message` からリクエスト JSON を組み立てたいとき
* `buf curl --protocol connect` のコマンドを組み立てたいとき

## いつ使わないか

* Stream RPC の検証（本 SKILL の範囲外）
* Connect 以外のプロトコル専用クライアントだけで足りるとき

## 作業手順

1. **プロジェクト正本を解決する**（ワークスペースのファイルレイアウト指示など）
   * 探すもの: スキーマ（`buf.yaml`）の場所、接続先ホスト（`BASE_URL`）、Path 接頭辞（`PATH_PREFIX`）
   * レイアウトに記載があれば、それを本 SKILL の入力として使う（推測で上書きしない）
   * `@` / `repo:` などのパス表記は、ワークスペースのパス解決規則で実パスへ落とす
   * 記載が無い項目だけ、ユーザー指定や下記のプレースホルダ例にフォールバックする
2. 対象の `service` / `rpc` / リクエスト `message` を `*.proto` から特定する
3. リクエスト `message` のフィールド名をそのままキーにした JSON を作る
4. 解決したスキーマディレクトリを `--schema` に渡す（またはそのディレクトリで実行する）
5. URL を組み立てる: `{BASE_URL}/{PATH_PREFIX}{package}.{Service}/{Rpc}`
6. 必要ヘッダ（`Authorization` など）を付けて `buf curl` を実行する

本 SKILL のコマンド例のパス・ホストはプレースホルダである。レイアウト指示がある環境では、手順 1 の結果で置き換える。

## リクエストの基本

* Connect Unary は HTTP + JSON でコールできる
* `-H 'Key: Value'` で任意ヘッダを付与できる
* proto のフィールド名をそのまま JSON プロパティにする（camelCase / snake_case は proto 定義に従う）

```proto
package example.v1;
service ExampleService {
  rpc Echo(EchoRequest) returns (EchoResponse);
}

message EchoRequest {
  optional string message = 1;
}
```

```bash
buf curl \
  --protocol connect \
  --schema path/to/schema/dir/ \
  -H 'Authorization: Bearer YOUR_TOKEN_HERE' \
  --data '{"message":"hello"}' \
  "${BASE_URL}/${PATH_PREFIX}example.v1.ExampleService/Echo"
```

`PATH_PREFIX` はサーバー側のマウントパス（例: `api/v1/`）。無い場合は省略する。

```bash
# ローカル例（プレースホルダ）
buf curl \
  --protocol connect \
  --schema path/to/schema/dir/ \
  -H 'Authorization: Bearer YOUR_TOKEN_HERE' \
  --data '{"message":"hello"}' \
  "http://127.0.0.1:8080/api/v1/example.v1.ExampleService/Echo"
```

## スキーマ（`--schema`）

* `buf.yaml` があるディレクトリがモジュールルートになる
* レイアウト指示に `buf.yaml`（またはそのディレクトリ）の正本があれば、それを使う
* そのディレクトリへ `cd` してから実行するか、`--schema` にそのパスを渡す
* スキーマを渡さないと、リモートリフレクションや別経路に依存するため、手元検証では明示を推奨する

## 有用なオプション

### `--verbose`

通信内容の詳細を確認するときに使う。

```bash
buf curl \
  --protocol connect \
  --verbose \
  --schema path/to/schema/dir/ \
  --data '{"message":"hello"}' \
  "http://127.0.0.1:8080/api/v1/example.v1.ExampleService/Echo"
```

### `--help`

インストール済み `buf` のオプション一覧を確認する。

```bash
buf curl --help
```

## ナレッジベース

### DO: proto のフィールド名を JSON キーにそのまま使う

* 独自のリネームやラッパオブジェクトを挟まない（Connect の JSON マッピングに合わせる）

### DO: ファイルレイアウト指示があれば、そこからホスト・接頭辞・スキーマを解決する

* レイアウトに書かれた正本があるのに、SKILL 例のプレースホルダや推測パスで上書きしない
* `@` / `repo:` 表記はパス解決してから `--schema` や URL に使う

### DO: スキーマディレクトリを明示する

* `--schema` か作業ディレクトリで `buf.yaml` 起点を固定すると、再現性が高い

### DO: URL は `{package}.{Service}/{Rpc}` を末尾に置く

* `PATH_PREFIX` はサーバー実装依存。レイアウト正本があればそれに従う

### DO NOT: Stream RPC を本手順で無理に叩く

* Unary 向けの手順であり、Stream は別手段が必要
