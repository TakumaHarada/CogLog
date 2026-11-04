# コードコメント規約

## 概要

本ドキュメントは、プロジェクト内の Golang コードに付与する**ドキュメントコメント**の規約を定義する。

* すべての構造体・インターフェース・プロパティ・関数・定数等、外部から参照される箇所には、**必ず日本語のドキュメントコメント**を付与する。
* クラスインターフェース・構造体・メソッド・関数には、**利用時の Example を記載する**。
* コメントでは**意図・前提・副作用・注意点**に焦点を当て、自明な記述は避ける。
* **型名・関数名・フィールド名を主語にした繰り返しは書かない**（主語の省略）。宣言直下のコメントは、識別子の説明から始める。
* コードや設計の**なぜそうしたか**（判断理由・トレードオフ・将来の読者への注釈）が、名前や通常の説明だけでは伝わらない場合は、**`NOTE:`** として残す（Dart のドキュメントコメントにおける `NOTE.` と同じ役割）。

## 主語の省略

宣言名（型・関数・メソッド・フィールド）はコード上で既に明示されている。コメントで `PreferenceKey は` のように主語として繰り返すと冗長になる。**役割・制約・意図を、主語なしで述べる。**

### 主語の省略の補足

宣言名を主語に繰り返すと、コメントが名前の言い換えに留まり、意図・制約・副作用が伝わらない。主語なしで役割を述べることで、ドキュメントとして情報量が増える。

### 主語の省略の実装例

```go
// ✅️ DO
// Preferences に与える単一キーを表す。
type PreferenceKey string

// ⚠️ DO NOT
// PreferenceKey は Preferences に与える単一キーを表す。
type PreferenceKey string
```

```go
// ✅️ DO
// 外部IDからユーザーを取得する。
func FetchUser(ctx context.Context, externalID string) (*User, error)

// ⚠️ DO NOT
// FetchUser は外部IDからユーザーを取得する。
func FetchUser(ctx context.Context, externalID string) (*User, error)
```

## NOTEブロック

Dart のコードコメント規約と同様、**「何をしているか」はコードと通常のドキュメントで示し、「なぜそうしているか」「どんな前提・例外があるか」**を `NOTE:` で補う。

### NOTEブロックの補足

* **付与する場面の例**
  * 代替案を却下した理由、パフォーマンス・互換性・セキュリティ上の意図
  * 一見冗長・非直感に見える実装の正当化（外部 API の制約、レガシーとの整合など）
  * テストや特定呼び出し元向けに公開しているが、通常は別 API を使うべき、といった利用上の前提
  * 将来変更や削除時に踏みたい地雷（「ここを直すと X が壊れる」）
* **書き方**
  * 行頭を `// NOTE:` とする（複数行は続けて `//` で書く）。
  * 型・関数・ブロック内の非自明な箇所のいずれにも置ける。ブロック直前に置くと、そのブロック全体の文脈が伝わりやすい。
* **避けること**
  * コードを日本語で言い換えるだけの NOTE（自明な「なぜ」にならない）。
  * `NOTE:` がなければ誤用やバグの原因になる、というレベルでないのに乱発すること。

### NOTEブロックの実装例

```go
// domain_preferences, preference_key.go
// Preferences に与える単一キーを表す。
//
// NOTE:
// DBからの復元やUnit Testで使いやすいように NewPreferenceKey を公開しているが、
// 基本的には管理されたキー一覧を使う想定である。
type PreferenceKey string
```

```go
func normalizePhone(raw string) string {
  // NOTE: 国番号付きとローカル表記の両方を受け入れるため、
  // 正規化は E.164 ではなくアプリ内の表示用フォーマットに揃える。
  digits := onlyDigits(raw)
  // ...
  return digits
}
```

## Unit Test

### Unit Testコメントの補足

`environment_variables_test.go` のようなテストコードでは、テストの意図と失敗時の可読性を高めるため、以下を必須ルールとする。

1. **テスト内容を関数コメントに記載する**
   `TestXxx` の直前に「どの条件を検証するテストか」を日本語で記述する。
   期待値・前提条件・優先順位のどれを確認しているかを簡潔に書く。
2. **`t.Fatalf` のメッセージは日本語で記載する**
   失敗時に CI ログだけで意味が通るよう、期待値と実測値を日本語で示す。
   例: `t.Fatalf("ProjectIdが不一致: expected=%q actual=%q", expected, actual)`
3. **処理には適切にコメントを付与する**
   テストの主要ステップ（準備・実行・検証）ごとに、非自明な意図を日本語で補足する。
   ただし、1行ごとの自明な説明は避け、読み手が流れを追うための最小限に留める。

### Unit Testコメントの実装例

#### Test関数のコメントテンプレート

```go
// テスト対象:
// {テスト対象としているモジュール等}
//
// テスト内容:
// {XXXがYYYのとき、ZZZとなる。等の想定結果}
func TestXXXXXXXX_YYYYYY(t *testing.T) {
  // テスト本体
}
```

#### Unit Test コメントの実例

```go
// テスト対象:
// configureWorkingDirectory
//
// テスト内容:
// `go.work` と `container` が存在しないディレクトリのとき、探索失敗として panic し、
// panic メッセージに `foundation_container` を含む。
func TestConfigureWorkingDirectory_panicsInEmptyDir(t *testing.T) {
 t.Chdir(t.TempDir())
 var recovered any
 func() {
  defer func() { recovered = recover() }()
  configureWorkingDirectory()
 }()
 if recovered == nil {
  t.Fatal("expected panic, got success")
 }
 s, ok := recovered.(string)
 if !ok || !strings.Contains(s, "foundation_container") {
  t.Fatalf("unexpected panic value: %v (want string with foundation_container)", recovered)
 }
}
```

### Unit Testコメントのアンチパターン

```go
func TestExample(t *testing.T) {
  actual := compute()
  if actual != "expected" {
    t.Fatalf("unexpected value: %q", actual)
  }
}
```

* テスト対象や期待値の意図がコメントから読み取れない。
* `t.Fatalf` が英語固定で、CI ログの読み手に前提が伝わりづらい。
* 準備・実行・検証の意図を補助するコメントがない。

## 関数・メソッド

### 関数・メソッドコメントの補足

* [主語の省略](#主語の省略) に従い、関数名・メソッド名を主語にしない。
* **役割、パラメータ・戻り値、副作用・注意点を日本語で記述する。**
* **パラメータは `[param]` 形式で参照する。**
* **非自明な判断理由は `NOTE:` で補足する。**

### 関数・メソッドコメントの実装例

```go
// domain_japanese, japanese_character.go
// 漢字1文字の値を生成する。
// [character] は漢字1文字である必要がある。
func NewKanji(character string) (Kanji, error) {
  if utf8.RuneCountInString(character) != 1 {
    return Kanji{}, errors.New("漢字は1文字である必要があります")
  }

  return Kanji{
    Character: character,
  }, nil
}
```

```go
// 外部IDからユーザーを取得する。
func FetchUser(ctx context.Context, externalID string) (*User, error) {
  // NOTE: レート制限のため、ここでは常にキャッシュを先に参照する。
  // キャッシュミス時のみ下流APIへ行き、バーストを避ける。
  if u, ok := userCache.Get(externalID); ok {
    return u, nil
  }
  // ...
  return nil, nil
}
```

### 関数・メソッドコメントのアンチパターン

```go
// DO NOT: 関数名を主語にし、名前の言い換えだけを書いている
// GetValue は値を取得する。
func (s *ExampleService) GetValue() string {
  return s.value
}
```

* 宣言名を主語にした冗長な繰り返し（[主語の省略](#主語の省略) に違反）。
* 名前から明らかな説明のみで、意図や制約がない。
* パラメータ・戻り値の前提や副作用が必要なのに明示していない。
* `NOTE:` が必要な判断理由をコード側に埋もれさせている。

## 構造体 / インターフェース

### 構造体・インターフェースコメントの補足

* [主語の省略](#主語の省略) に従い、型名・フィールド名を主語にしない。
* **構造体・インターフェースの役割を日本語で明示する。**
* **`type ApiKey string` のような独自型定義にも、用途・制約・意図をコメントする。**
* **すべてのフィールド/メソッドの意味・制約をコメントする。**
* **インターフェースには Example を併記し、利用方法を検証可能にする。**

### 構造体・インターフェースコメントの実装例

```go
// domain_japanese, japanese_character.go
// ひらがな1文字を示す。
type Hiragana struct {
  // ひらがな1文字を保持する。
  Character string
}
```

```go
// API 認証に利用するキー文字列を表す。
// 外部入力をそのまま string で扱わないためのドメイン型である。
type ApiKey string
```

```go
// infra_firebase, firebase_analytics_proxy.go
// Firebase Analytics にイベントを記録する。
type AnalyticsProxy interface {
  // イベントを記録する。
  //
  // [name] はイベント名である。
  // [parameters] はイベントパラメータである。
  //
  // Firebase 非対応プラットフォームやテスト環境では何も実行しない。
  LogEvent(ctx context.Context, name string, parameters map[string]any) error
}

// LogEvent の利用例を示す。
func ExampleAnalyticsProxy_LogEvent() {
  ctx := context.Background()

  var proxy AnalyticsProxy = newNoopAnalyticsProxy()

  // 画面遷移イベント（Path をそのまま使用）
  _ = proxy.LogEvent(ctx, "/home", nil)

  // タブ移動イベント
  _ = proxy.LogEvent(ctx, "tab_selected", map[string]any{
    "tab_name": "HomeScreenTab.home",
  })
}
```

### 構造体・インターフェースコメントのアンチパターン

```go
type ApiKey string
```

```go
// アンチパターン: 構造体とメソッドにコメントがない
type ExampleService struct{}

// アンチパターン: 主語の繰り返しと、情報が一切増えていない言い換え
// GetData は Data を Get する。
func (s *ExampleService) GetData() string {
  return ""
}
```

* 型の責務が読み取れない。
* `type ApiKey string` のような独自型で、導入理由や利用境界が不明である。
* メソッドの利用文脈・前提条件が不明確。
* インターフェース定義時に Example がないため、実利用が推測依存になる。

## ワークスペースとの関係

* **`golangci-lint` / `go vet`**: エクスポート対象にコメントが不足していないか、命名と整合しているかを確認する。
* **`go test`**: `ExampleXxx` の Example 関数が実行可能な状態かを確認する。
* **ファイル編集後の確認**: Lint/Format 実行時の確認ポイントの一つに「ドキュメントコメントが不足していないか」を含める。プロジェクトの編集後チェックリストを参照する。

## ナレッジベース

### DO: 日本語のドキュメントコメントを必ず付与する

* 構造体・インターフェース・関数・フィールドに、意図・前提・副作用・注意点を簡潔に書く。

### DO: 主語を省略し、役割・制約から記述する

* 型名・関数名を主語にした繰り返しを書かない。

```go
// ✅️ DO
// Preferences に与える単一キーを表す。
type PreferenceKey string
```

### DO: 非自明な判断理由は `NOTE:` で残す

* 「なぜそうしているか」「どんな前提・例外があるか」を明示する。

```go
// NOTE:
// DBからの復元やUnit Testで使いやすいように NewPreferenceKey を公開しているが、
// 基本的には管理されたキー一覧を使う想定である。
```

### DO: テスト関数には対象と内容を日本語で書く

* `TestXxx` 直前のコメントと `t.Fatalf` メッセージを日本語にし、CI ログだけで意味が通るようにする。

### DO NOT: コメントを欠如させる

* 理由: 型の責務・利用境界・前提条件が読み取れない。

```go
type ApiKey string
```

### DO NOT: 宣言名を主語にした自明な言い換えだけを書く

* 理由: 名前から明らかな説明のみでは、意図や制約が増えない。

```go
// DO NOT: 関数名を主語にし、名前の言い換えだけを書いている
// GetValue は値を取得する。
func (s *ExampleService) GetValue() string {
  return s.value
}
```

```go
// ✅️ DO
// 外部IDからユーザーを取得する。
func FetchUser(ctx context.Context, externalID string) (*User, error)
```
