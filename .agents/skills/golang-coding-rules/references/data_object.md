# データオブジェクト

## 概要

本ドキュメントは、Golang におけるデータオブジェクト設計の基本ルールを定義する。

* ドメイン上の意味を持つ値は、`string` や `int` などのプレーン型で直接扱わないことを優先する。
* `type` による独自型定義を用いて型安全性を高める。
* 不正値を防ぐため、必要に応じてコンストラクタ相当の生成関数で検証する。
* ドメイン独自型は `String()` を実装し、返却文字列の方針を明確にする。

## 独自型定義の推奨

プレーン型は意味の異なる値同士を取り違えやすく、引数順ミスや代入ミスの原因になる。
ドメインごとに独自型を作成し、型の境界を明確にする。

### 独自型定義の補足

* ドメイン上の意味を持つ値は、`string` や `int` などのプレーン型で直接扱わないことを優先する。
* `type` による独自型定義を用いて型安全性を高める。
* 不正値を防ぐため、必要に応じてコンストラクタ相当の生成関数で検証する。
* Goの一般的な用語としては、`type` による `defined type`（独自型定義）または `type alias`（別名型）を使い分ける。
* 既存コードがプレーン型中心の場合は、新規追加箇所から段階的に独自型へ移行する。

### 独自型定義の推奨ルール

1. **意味のある値は独自型にする**
   `Email`, `UserID`, `OrderID`, `PhoneNumber` などを `type` で定義する。
2. **ドメイン層の構造体フィールドには独自型を優先する**
   一方で、外部 API / DB / シリアライズ境界のDTOではプレーン型を許容し、変換箇所を明示する。
3. **生成関数で妥当性を担保する**
   形式チェックが必要な値は `NewEmail(...)` のような関数で検証する。
4. **必要に応じてメソッドで振る舞いを閉じ込める**
   文字列整形や比較ロジックを型に寄せ、呼び出し側の重複実装を避ける。
5. **`String()` を必ず実装し、返却する文字列を規定する**
   ドメイン独自型は `fmt.Stringer`（`String() string`）を実装する。`fmt` での出力、ログ、デバッガ、文字列連結などで暗黙に呼ばれるため、未実装のままではベース型のデフォルト表現に依存しうる。
   実装では「この型が人間可読／運用用途でどの文字列を返すか」を型の責務として決め、`String()` が常にその意図どおりの文字列だけを返すこと（マスキングが必要なら `String()` 側で行う、といった方針も含む）をコードレビューで確認できるようにする。

### 独自型定義の実装例

#### NG: プレーン型のまま扱う

```go
type User struct {
  Email string // NG: 意味が弱く、他の string と取り違えやすい
}

func SendWelcomeMail(email string) error { // NG
  // ...
  return nil
}
```

#### OK: 独自型で意味を限定する

```go
import "errors"

type Email string

func NewEmail(value string) (Email, error) {
  if value == "" {
    return "", errors.New("email は空文字を許容しない")
  }
  return Email(value), nil
}

// String はログ等で用いる表示用文字列を返す（本例では検証済みのメールアドレスをそのまま返す）。
func (e Email) String() string {
  return string(e)
}

type User struct {
  Email Email // OK: 型で意味が限定される
}

func SendWelcomeMail(email Email) error { // OK
  // ...
  return nil
}
```

## ナレッジベース

### DO: 意味のある値は独自型にする

* `Email`, `UserID`, `OrderID`, `PhoneNumber` などを `type` で定義する。

```go
type Email string

func NewEmail(value string) (Email, error) {
  if value == "" {
    return "", errors.New("email は空文字を許容しない")
  }
  return Email(value), nil
}
```

### DO: 生成関数で妥当性を担保する

* 形式チェックが必要な値は `NewEmail(...)` のような関数で検証する。

### DO: ドメイン独自型に `String()` を実装する

* 返却する文字列の方針を型の責務として決め、ログ・デバッガでの表現を一貫させる。

```go
func (e Email) String() string {
  return string(e)
}
```

### DO NOT: プレーン型を過剰に利用する

* 理由: `email string` のように型を絞らず、誤代入・誤引数を招く
* 理由: 意味の異なる値同士の取り違えや引数順ミスの原因になる

```go
// 非推奨パターン
// DO NOT: プレーン型のまま扱う
type User struct {
  Email string
}

func SendWelcomeMail(email string) error {
  // ...
  return nil
}
```

```go
// 推奨される書き換えパターン
// DO: 独自型で意味を限定する
type User struct {
  Email Email
}

func SendWelcomeMail(email Email) error {
  // ...
  return nil
}
```

### DO NOT: 独自型だけ定義して検証しない

* 理由: `type Email string` のみだと、妥当性チェックが呼び出し側に分散する
* 理由: 不正値がドメイン内へ流入しやすくなる

```go
// 非推奨パターン
// DO NOT: 検証なしの独自型のみ
type Email string
```

```go
// 推奨される書き換えパターン
// DO: 生成関数で妥当性を担保する
func NewEmail(value string) (Email, error) {
  if value == "" {
    return "", errors.New("email は空文字を許容しない")
  }
  return Email(value), nil
}
```

### DO NOT: 境界で独自型を崩してプレーン型に戻す

* 理由: 関数引数や戻り値で `string` に戻すと型安全性を失う
* 理由: 外部 API / DB / シリアライズ境界以外では独自型を維持する

```go
// 非推奨パターン
// DO NOT: ドメイン境界内で string に戻す
func SendWelcomeMail(email string) error {
  // ...
  return nil
}
```

```go
// 推奨される書き換えパターン
// DO: ドメイン境界内は独自型を維持する
func SendWelcomeMail(email Email) error {
  // ...
  return nil
}
```

### DO NOT: String() を欠く、または返却内容が方針と一致しない

* 理由: 独自型を定義しても `String()` 未実装だと、意図しない表現や機密情報の扱いが各所に散らばる
* 理由: ログ・デバッガでの表現を型の責務として一貫させる

```go
// 非推奨パターン
// DO NOT: String() 未実装の独自型
type Email string
```

```go
// 推奨される書き換えパターン
// DO: String() を実装し返却方針を決める
func (e Email) String() string {
  return string(e)
}
```
