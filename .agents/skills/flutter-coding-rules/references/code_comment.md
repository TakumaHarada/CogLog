# コードコメント規約

## 概要

本ドキュメントは、プロジェクト内の Dart コードに付与する**ドキュメントコメント**の規約を定義する。

* すべてのクラス名・プロパティ名・関数名・変数等のアクセス可能シンボルには、下記の要素を満たしたコメントブロックを記載する
  * **技術文書として自然な日本語コメント**を付与する。
  * **利用時の Example**
  * コメントでは**意図・前提・副作用・注意点**に焦点を当て、自明な記述は避ける。
* ワークスペースの静的解析では `comment_references` が有効であり、ドキュメント内の参照（`[symbol]` 等）が正しく解決される必要がある。
* コメント付与対象を Private/Internal/Public等で区別しない。全てのシンボル対してコメントは必要である。

## 必須付与対象

以下のクラス・プロパティ・関数・メソッドには、必ず日本語のドキュメントコメントを付与する。

* **クラス**: 役割の説明、必要に応じて NOTE や Example
* **プロパティ**: 意味・制約・注意点
* **関数・メソッド**: 役割、パラメータ・戻り値の説明、Example（利用例）
* **コンストラクタ**: パラメータの制約（例: 「1文字である必要がある」）

## コードコメントの補足

ドキュメントコメントは、API の意図と使用方法を明確にするために必要である。日本語で記述することで、チーム内での理解が容易になる。

* **自明なコメントは避ける**（例:「値を取得する」は getter 名から自明）。
* **意図・前提条件**を簡潔に記述する。
* **副作用・注意点**がある場合は必ず明記する。
* **パラメータ・戻り値**は `[param]` 形式でドキュメント内から参照できる。
* **AI Agent がインターフェースを提案するとき**は、コメントに**利用時の Example コード**を必ず含める。

## 主語の省略

宣言名（型・関数・メソッド・フィールド）はコード上で既に明示されている。コメントで `PreferenceKey は` のように主語として繰り返すと冗長になる。**役割・制約・意図を、主語なしで述べる。**

### 主語の省略の補足

宣言名を主語に繰り返すと、コメントが名前の言い換えに留まり、意図・制約・副作用が伝わらない。主語なしで役割を述べることで、ドキュメントとして情報量が増える。

### 主語の省略の実装例

```dart
/// ✅️ DO
/// Preferences に与える単一キーを表す。
class PreferenceKey {}

// ⚠️ DO NOT
// PreferenceKey は Preferences に与える単一キーを表す。
class PreferenceKey {}
```

## コードコメントの実装例

### クラス・型の説明

* コンストラクタパラメータ等、内容の重複を許容する（コンストラクタコメントと、引数のコメント両方に記載する）

```dart
// domain_japanese, japanese_character.dart
/// ひらがな1文字を示す.
class Hiragana implements JapaneseCharacter {
  @override
  final String character;

   // domain_japanese, japanese_character.dart
   /// 漢字を作成する.
   ///
   /// [character] は漢字1文字である必要がある.
   ///
   /// Example:
   /// ```dart
   /// final kanji = Kanji(example);
   /// ```
  const Hiragana({
   /// 対象文字。漢字1文字である必要がある。
   required this.character,
  })
    : assert(character.length == 1, "ひらがなは1文字である必要があります");
}
```

### NOTE と前提・注意点

```dart
// domain_preferences, preference_key.dart
/// Preferencesに与える単一キー.
///
/// NOTE.
/// DBからの復元やUnit Test等で使いやすいようにコンストラクタを一部開放しているが、
/// 基本的には管理されたキー一覧を使うことを想定している.
extension type const PreferenceKey(String _value) {
}
```

### 呼び出し可能シンボル（メソッド、関数等）

* 関数等のコメントと引数コメント、といった内容の重複を許容する（両方に記載する）

```dart
// infra_firebase, firebase_analytics_proxy.dart
/// Firebase Analyticsにイベントを記録する.
///
/// [name] イベント名
/// [parameters] イベントパラメータ
///
/// Firebase非対応プラットフォームやテスト環境では、何も実行しない.
///
/// Example:
/// ```dart
/// // 画面遷移イベント（GoRouterのpathをそのまま使用）
/// await proxy.logEvent(name: "/home");
///
/// // タブ移動イベント
/// await proxy.logEvent(
///   name: "tab_selected",
///   parameters: {"tab_name": "HomeScreenTab.home"},
/// );
/// ```
Future<void> logEvent({
  /// イベント名
  required String name,
  /// イベントパラメータ
  Map<String, Object>? parameters,
});
```

## コードコメントのアンチパターン

以下のようなコメントや欠如は避ける。

### Privateなシンボルにコメントがない

```dart
// ⚠️ DO NOT
// アンチパターン: PrivateなシンボルのコメントやExample等が省略されている


class _ExampleClass {
  String getData() {
    return "";
  }
}
```

### 自明なコメント

```dart
// ⚠️ DO NOT
/// 値を取得する.
/// 10文字以内の任意の値が設定されている.
///
/// example: "ABC", "ほげ"
String get value => _value;

// ⚠️ DO NOT
/// 値を取得する
String get value => _value;
```

### インターフェース・メソッドに Example がない

* メソッドやインターフェースに、利用例（Example）が一切ない。
* API の意図や使用方法が不明確になる。
* AI Agent がインターフェースを提案する場合は、Example の記載が必須である。

## ワークスペースとの関係

* **analysis_options.yaml**: `comment_references` が有効。ドキュメント内の `[symbol]` 等は実在するシンボルを参照している必要がある。
* **type_annotate_public_apis**: 公開 API に型注釈を要求するルールと合わせ、ドキュメントコメントで「何をする API か」を補足する。
* **ファイル編集後の確認**: Analyzer 実行時の確認ポイントの一つに「ドキュメントコメントが不足していないか」が含まれる。プロジェクトの編集後チェックリストを参照する。

## Unit Test

### Unit Testコメントの補足

`*_test.dart` のようなテストコードでは、テストの意図と失敗時の可読性を高めるため、以下を必須ルールとする。

1. **テスト内容を関数コメントに記載する**
   すべてのテスト関数 `test()` のコメントに「どの条件を検証するテストか」を日本語で記述する。
   期待値・前提条件・優先順位のどれを確認しているかを簡潔に書く。
2. **`expect` のreason引数を入力し、日本語で記載する**
   失敗時に CI ログだけで意味が通るよう、期待値と実測値を日本語で示す。
   例: `t.Fatalf("ProjectIdが不一致: expected=%q actual=%q", expected, actual)`

### Unit Testコメントの実装例

```dart
// ✅️ DO
group("Flavor系のテスト", (){
   // テスト対象:
   // {テスト対象としているモジュール等}
   //
   // テスト内容:
   // {XXXがYYYのとき、ZZZとなる。等の想定結果}
   test("Flavor.current", () {
      expect(
      Flavor.current,
      isA<FlavorDevelopment>(),
      reason: "Flavor.currentとFlavorDevelopmentが一致すること",
      );
   });

   // テスト対象:
   // {テスト対象としているモジュール等}
   //
   // テスト内容:
   // {XXXがYYYのとき、ZZZとなる。等の想定結果}
   test("XXXXのテスト", () {
      // テスト内容..
   });
});
```

## ナレッジベース

### DO: 日本語のドキュメントコメントを必ず付与する

* 型・プロパティ・関数に、意図・前提・副作用・注意点を簡潔に書く。

### DO: パラメータは `[param]` で参照する

* 「[character] は漢字1文字である必要がある」のように、Dart の doc 参照を使う。

### DO: NOTE で設計上の前提を書く

* テスト用の開放や、想定利用者（「管理されたキー一覧を使うことを想定」）を明示する。

```dart
// domain_preferences, preference_key.dart
/// Preferencesに与える単一キー.
///
/// NOTE.
/// DBからの復元やUnit Test等で使いやすいようにコンストラクタを一部開放しているが、
/// 基本的には管理されたキー一覧を使うことを想定している.
extension type const PreferenceKey(String _value) {
}
```

### DO: インターフェース・メソッドには Example を書く

* 特に AI Agent がインターフェースを提案する場合は、利用例を必ず含める。

### DO NOT: コメントを欠如させる

* 理由: クラス・メソッド・プロパティ・関数にコメントがないと、意図・前提・副作用が伝わらない。

```dart
// ⚠️ DO NOT
// アンチパターン: PrivateなシンボルのコメントやExample等が省略されている


class _ExampleClass {
  String getData() {
    return "";
  }
}
```

### DO NOT: 自明な説明だけを書く

* 理由: 名前から分かることだけを繰り返すと、ドキュメントとして情報が増えない。

```dart
// ⚠️ DO NOT
/// 値を取得する
String get value => _value;
```

```dart
/// ✅️ DO
/// Preferences に与える単一キーを表す。
class PreferenceKey {}
```

### DO NOT: 自動生成コードへコメントを更新する

* 理由: 自動生成コードは更新しても再生成で崩れるため、コメント更新は不要である。
* 例: `*.freezed.dart` `*.gen.dart` `*.g.dart` 等
