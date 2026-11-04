# Golang / 一般コーディング規約

## 概要

本ドキュメントは、Golang における一般的なコーディング規約のうち、import 文の別名指定と入れ子 error の確認方法を定義する。

* import 別名は、既定の識別子で意味が通じるときは付けない。
* 末尾だけでは意味が通じない（`/v1` 等）とき、または同一識別子が衝突するときにだけ別名を付ける。
* **本規約と Linter（`goimports` / `golangci-lint` 等）が衝突する場合は、Linter を最優先する。**
* 入れ子の error を確認する場合は `errors.As` を使用する。

## import文

import 文の package 別名は、次の順で判断する。

0. **Linter（`goimports` / `golangci-lint` 等）の要求を最優先する。** 本節の命名方針と食い違う場合は Linter に合わせる。
1. **標準の import 識別子だけで意味が通じる場合、別名を付けない。**
2. **末尾が `/v1` 等、それ単体では意味が通じない場合は、パス上の段階を 1 つ上げて小文字連結した別名を付ける。** ただし path 末尾と package 名が異なるときなど、Linter が package 名別名を要求するならそれに従う。
3. **同じ識別子が重複した場合は、どちらか片方（判断可能であればレイヤーレベルが低く独立性が高い方）を無別名のまま残し、上位側にパスを小文字連結した別名を付ける。**

根拠: [Go Code Review Comments — Imports](https://go.dev/wiki/CodeReviewComments#imports)（衝突時のみ別名、より局所・プロジェクト固有側を改名する考え方と整合）。

### import文の補足

* 既定名（ディレクトリ末尾）が読めるなら別名はノイズになる。必要最小限だけ付ける。
* `/v1` / `/v2` のような API バージョン suffix は識別子として弱い。方針上は親ディレクトリ名を含めた連結を推奨するが、**実 package 名が親側（例: `secretmanager`）であり Linter がそれを要求するなら package 名別名を採用する。**
* 衝突時は下位レイヤ・横断基盤・標準に近い側を無別名とし、上流・機能寄りの側を別名にする。別名はレイヤ名と package 名など、パス上の意味ある要素を小文字連結する（例: `usecaselogger` / `domainlogger`）。
* 規約どおりに書いた結果が Linter に弾かれたら、規約の理想形より Linter の結果を残す（手動で「規約どおり」に戻さない）。

### import文の実装例

path 末尾が `/apiv1` でも package 名が `secretmanager` の場合（Linter / goimports に合わせる）:

```go
import (
 secretmanager "cloud.google.com/go/secretmanager/apiv1"
)
```

衝突時（下位を無別名、上位に別名）:

```go
import (
 "domain/logger"
 usecaselogger "usecase/logger"
)
```

```go
import (
 "logger"
 domainlogger "domain/logger"
 usecaselogger "usecase/logger"
)
```

## error型のチェック(unwrap)

入れ子のerror型を確認する場合（内包するエラーを確認する場合）は、`errors.As` を使用する。

### error型のチェックの補足

`errors.As` により、ラップされた error の具象型を安全に取り出せる。型アサーションの繰り返しや文字列比較による判定を避ける。

### error型のチェックの実装例

```go
 var connectErr *connect.Error
 if !errors.As(err, &connectErr) {
  t.Fatalf("*connect.Error であるべき: 実際=%T", err)
 }
```

## ナレッジベース

### DO: 既定の import 識別子で通じるときは別名を付けない

* 衝突もバージョン suffix もない通常の import は、ディレクトリ末尾の package 名のまま使う。

### DO: import 別名で Linter と規約が食い違うときは Linter を最優先する

* `goimports` / `golangci-lint` 等が要求する別名・無別名を採用する。規約の理想形へ手動で戻さない。

### DO: `/v1` 等は親を含めた別名を推奨するが、Linter が package 名別名を要求するなら従う

```go
import (
 secretmanager "cloud.google.com/go/secretmanager/apiv1"
)
```

### DO: 衝突時は下位・独立性の高い側を無別名にし、上位にパス連結別名を付ける

```go
import (
 "domain/logger"
 usecaselogger "usecase/logger"
)
```

### DO: 入れ子 error の確認に `errors.As` を使う

* 内包するエラーの具象型を安全に取り出す。

```go
 var connectErr *connect.Error
 if !errors.As(err, &connectErr) {
  t.Fatalf("*connect.Error であるべき: 実際=%T", err)
 }
```

### DO NOT: 意味が通じる既定名にまで別名を付ける

* 理由: 呼び出し側の識別子が増え、どの package 由来かがかえって読み取りにくくなる。

### DO NOT: `/v1` だけを別名にする（例: `apiv1`）

* 理由: 単体では意味が弱く、他 API の `apiv1` と区別できない。Linter が別の別名を要求する場合は Linter に従う。

### DO NOT: Linter が要求する別名を、規約の理想形を理由に上書きする

* 理由: フォーマット・静的解析の再現性が崩れ、CI と手元差分が食い違う。

### DO NOT: 衝突時に下位レイヤ側だけを改名して上位を無別名のままにする

* 理由: 独立性が高い・再利用される側の識別子を安定させ、上流側の別名で区別する。

### DO NOT: 入れ子 error を文字列比較や不安定な型アサーションだけで判定する

* 理由: ラップ構造の変化に弱く、誤判定や壊れやすいテストになる。

## 参考リンク

* Go Code Review Comments — Imports: <https://go.dev/wiki/CodeReviewComments#imports>
