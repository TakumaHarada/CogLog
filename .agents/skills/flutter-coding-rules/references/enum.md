# enum と switch 規約

## 概要

本ドキュメントは、Dart における **enum の利用**（dot-shorthands 記法）と **switch の網羅性**に関する規約を定義する。

* enum や static メンバーを利用する際は、**Dart 3.10 の dot-shorthands 記法**（`.foo`）を可能な限り利用する。
* enum や sealed class を switch で分岐する際は、**`_` や `default` によるデフォルト分岐を禁止**し、すべてのケースを明示的に列挙する。これにより拡張時のコンパイラによる型安全性を確保する。
* ワークスペースの SDK は `>=3.11.0` であり、dot-shorthands および網羅的 switch はいずれも利用可能である。

## dot-shorthands 記法（enum 利用規約）

enum や static メンバーを利用する際は、Dart 3.10 で導入された **dot-shorthands 記法**（`.foo`）を可能な限り利用する。コンテキスト型が明確な場合に `ContextType.foo` の代わりに `.foo` と記述できる。

### dot-shorthands の補足

コンテキスト型は、変数の型、パラメータの型、戻り値の型、nullable 型（`T?`）、`FutureOr<T>` などから推論される。型が明確なときは省略表記によりコードが簡潔になり、型名の繰り返しを避けられる。

主な使用場面：

* enum 値へのアクセス（`EnumType.value` → `.value`）
* static 定数へのアクセス（`Type.constant` → `.constant`）
* static getter へのアクセス（`Type.getter` → `.getter`）
* コンストラクタの呼び出し（`Type()` → `.new()` または `Type.name()` → `.name()`）
* static 関数の呼び出し（`Type.function()` → `.function()`）
* セレクタチェーン（`Type.member.subMember` → `.member.subMember`）

### dot-shorthands の実装例

#### switch 式での enum 使用（ワークスペース実例）

```dart
// screen_feature_home2, home_content.dart
Widget _buildTabContent(HomeScreenTab tab) {
  return switch (tab) {
    .kanjiPractice => const KanjiPracticeOutletProxy(),
    .schoolGrade => const SchoolGradeOutletProxy(),
    .ganbariStamp => const GanbariStampOutletProxy(),
    .kanjiKanamajiri => throw UnimplementedError(),
    .loginHelp => throw UnimplementedError(),
  };
}
```

#### dot-shorthands の使用例

```dart
// enum 値への代入
Color color = .blue;
Endian endian = .little;

// switch 文での使用
switch (color) {
  case .blue:
    print('blue');
  case .red:
    print('red');
  case .green:
    print('green');
}

// switch 式での使用
String colorName = switch (color) {
  .blue => 'blue',
  .red => 'red',
  .green => 'green',
};

// 三項演算子での使用
Endian endian = firstWord == 0xFEFF ? .little : firstWord == 0xFFFE ? .big : .host;
```

#### Flutter Widget での使用

```dart
Column(
  crossAxisAlignment: .start,  // CrossAxisAlignment.start
  mainAxisSize: .min,          // MainAxisSize.min
  children: widgets,
)

Row(
  mainAxisAlignment: .center,  // MainAxisAlignment.center
  children: widgets,
)
```

#### static 定数・getter・コンストラクタ・static 関数

```dart
BigInt b0 = .zero;              // BigInt.zero
Endian littleEndian = .little;  // Endian.little
String s = .fromCharCode(42);   // String.fromCharCode(42)
int value = .parse(input);      // int.parse(input)
```

#### 比較演算子での使用

```dart
if (color == .blue) { }   // Color.blue と比較
if (endian != .little) { } // Endian.little と比較
```

### dot-shorthands のアンチパターン

* コンテキスト型が明確なのに完全修飾名のみを使用する（可能な箇所では `.value` を使う）。
* コンテキスト型が不明確な場合に dot-shorthands を使用する（`var color = .blue;` は型が推論できずエラーになり得る）。
* 式文として `.foo` で始まる式を単体で書く（意図が伝わりにくく、制限にも抵触し得る）。
* 複雑な型や長いセレクタチェーンで可読性が落ちる場合は、無理に省略せず完全修飾名を使う。

### 制限事項と注意点

* **コンテキスト型が必要**: dot-shorthands はコンテキスト型が明確な場合にのみ使用できる。型推論ができない場合は明示的に型を指定する。
* **式文として使用不可**: 式文として `.foo` で始まる式は使用できない。
* **== と != のみ特別扱い**: 比較演算子では `==` と `!=` のみが特別扱いされる。`<`, `>`, `<=`, `>=` などでは使用できない。
* **型引数の推論**: コンストラクタや static 関数で型引数が必要な場合、コンテキスト型から推論される。明示的に型引数を指定する場合は完全修飾名が必要な場合がある。

## switch のコーディング規約（網羅性）

enum や sealed class など、分岐が確定している対象に対して、**`_` や `default` を用いたデフォルト分岐を禁止**する。すべてのケースを明示的に列挙し、拡張時にコンパイラが未処理ケースを検出できるようにする。

### switch 網羅性の補足

enum や sealed class は、すべてのケースを網羅的に処理することでコンパイラが型安全性を保証できる。`_` や `default` を許可すると、新しいケース追加時に未処理のままになりうる。全ケースを列挙することで、拡張時にコンパイルエラーとなり、漏れなく処理を追加できる。

### switch 網羅性の実装例

#### enum の switch 式（全ケース列挙）

```dart
// screen_feature_home2, home_content.dart
Widget _buildTabContent(HomeScreenTab tab) {
  return switch (tab) {
    .kanjiPractice => const KanjiPracticeOutletProxy(),
    .schoolGrade => const SchoolGradeOutletProxy(),
    .ganbariStamp => const GanbariStampOutletProxy(),
    .kanjiKanamajiri => throw UnimplementedError(),
    .loginHelp => throw UnimplementedError(),
  };
}
```

#### enum の switch 文（全ケース列挙）

```dart
String getColorName(Color color) {
  switch (color) {
    case .blue:
      return 'blue';
    case .red:
      return 'red';
    case .green:
      return 'green';
  }
}
```

#### sealed class の switch 式（全サブクラス列挙）

```dart
sealed class Result<T> {}
class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}
class Failure<T> extends Result<T> {
  final String error;
  Failure(this.error);
}

String handleResult(Result<int> result) {
  return switch (result) {
    Success(value: final v) => 'Success: $v',
    Failure(error: final e) => 'Failure: $e',
  };
}
```

### switch 網羅性のアンチパターン

* **enum の switch で `default` を使用する**: すべての enum ケースを明示的に列挙する。
* **enum の switch 式で `_` を使用する**: `_ => 'other'` のようなフォールバックは書かず、全ケースを列挙する。
* **sealed class の switch で `_` を使用する**: 全サブクラスを列挙し、`_` でまとめて処理しない。

```dart
// アンチパターン: default / _ の使用
switch (exampleEnum) {
  case ExampleEnum.foo:
    break;
  default:  // NG
    break;
}

String result = switch (exampleEnum) {
  ExampleEnum.foo => 'foo',
  _ => 'other',  // NG
};
```

## ワークスペースとの関係

* ワークスペースの Dart SDK は **`>=3.11.0 <4.0.0`** である。dot-shorthands（Dart 3.10 導入）および網羅的 switch はいずれも利用可能である。
* 実際の enum 利用例は `screen_feature_home2` の `HomeScreenTab` などで参照できる。

## ナレッジベース

### DO: コンテキスト型が明確なときは dot-shorthands を使う

* enum 値・static メンバーに `.value` 形式を可能な限り使う。

```dart
// screen_feature_home2, home_content.dart
Widget _buildTabContent(HomeScreenTab tab) {
  return switch (tab) {
    .kanjiPractice => const KanjiPracticeOutletProxy(),
    .schoolGrade => const SchoolGradeOutletProxy(),
    .ganbariStamp => const GanbariStampOutletProxy(),
    .kanjiKanamajiri => throw UnimplementedError(),
    .loginHelp => throw UnimplementedError(),
  };
}
```

### DO: switch で全ケースを明示的に列挙する

* enum や sealed class の switch では、`_` や `default` を使わず、すべてのケースを明示的に列挙する。

### DO NOT: switch で `_` や `default` によるデフォルト分岐を使う

* 理由: 新しいケース追加時にコンパイラが未処理を検出できなくなる。

```dart
// アンチパターン: default / _ の使用
switch (exampleEnum) {
  case ExampleEnum.foo:
    break;
  default:  // NG
    break;
}

String result = switch (exampleEnum) {
  ExampleEnum.foo => 'foo',
  _ => 'other',  // NG
};
```

### DO NOT: コンテキスト型がない箇所で dot-shorthands を使う

* 理由: 型が推論できない箇所で `.foo` を使うとエラーになり得る。明示的な型付きで利用する。
