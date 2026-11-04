# try-catch 規約

## 概要

本ドキュメントは、Dart における **例外処理（try-catch）** の規約を定義する。

* **基本的に `Error` 型の例外を catch しない**。`Error` はプログラムのバグを示すため、通常は上位で捕捉せず修正対象とする。
* **`Error` を catch する場合**、または**型を指定せずにすべての例外を catch する場合**（例外を握りつぶす場合）は、**必ず理由をコメントで追記**する。意図が明確になり、レビュー時に判断しやすくなる。
* **`Exception` 型**（予期される例外）は、適切に型を指定して catch し、処理する。

## Error と Exception の区別

Dart では例外は **`Error`** と **`Exception`** に分類される。

* **`Error`**: プログラムのバグを示す（例: `AssertionError`、`OutOfMemoryError`）。通常は catch せず、コードの修正で対処する。
* **`Exception`**: 予期しうる例外（例: `FormatException`、`TimeoutException`、`SocketException`）。`on ExceptionType catch (e)` で型を指定して catch し、適切に処理する。

`Error` を catch する、または型を指定しない `catch (e)` で握りつぶす場合は、**必ず理由をコメントで明記**する。

### Error と Exception の区別の補足

理由のコメントにより、意図的な例外処理であることが明確になり、コードレビュー時に「なぜ `Error` を catch しているか」「なぜ型指定なしで catch しているか」を判断しやすくなる。例外の隠蔽を避け、デバッグしやすいコードを維持する。

## try-catch の実装例

### Exception 型の例外を catch する

```dart
try {
  final value = int.parse(input);
  return value;
} on FormatException catch (e) {
  // 数値形式が不正な場合の処理
  return 0;
}
```

### 特定の Exception 型を複数 catch する

```dart
try {
  await fetchData();
} on TimeoutException catch (e) {
  showError('接続がタイムアウトしました');
} on SocketException catch (e) {
  showError('ネットワークエラーが発生しました');
}
```

### Error を catch する場合に理由をコメントで追記する

```dart
try {
  // 外部ライブラリが Error を throw する可能性があるため、catch する
  // このライブラリのバグを回避するための暫定対応
  externalLibrary.doSomething();
} on Error catch (e) {
  // 外部ライブラリのバグを回避するため、Error も catch する
  // TODO: ライブラリが修正されたら、この catch を削除する
  logger.warn('外部ライブラリのエラーを回避: $e');
}
```

### 型を指定せずに catch する場合に理由をコメントで追記する

```dart
try {
  await criticalOperation();
} catch (e) {
  // クリティカルな操作が失敗した場合でも、アプリを継続させる必要がある
  // すべての例外を catch してログに記録し、デフォルト値を返す
  logger.error('クリティカルな操作が失敗しました: $e');
  return defaultValue;
}
```

## try-catch のアンチパターン

* **Error を catch しているが理由がコメントで明記されていない**: 意図が伝わらず、レビューで指摘されやすくなる。必ず理由を書く。
* **型を指定せずに例外を握りつぶしているが理由が明記されていない**: 例外が隠蔽され、デバッグが困難になる。握りつぶす場合は理由をコメントする。
* **Exception を catch すべきところで Error を catch している**: 例として `int.parse` は `FormatException`（Exception のサブクラス）を throw する。`on Error` で catch するのではなく、`on FormatException` で catch する。

```dart
// アンチパターン: Error を catch しているが理由が不明確
try {
  someOperation();
} on Error catch (e) {
  return defaultValue;  // 理由のコメントがない
}

// アンチパターン: 型指定なし catch で理由が不明確
try {
  someOperation();
} catch (e) {
  // 理由が書かれていない → 例外が隠蔽され、デバッグが困難になる
}

// アンチパターン: FormatException は Exception 型なので、Error で catch しない
try {
  final value = int.parse(input);
  return value;
} on Error catch (e) {
  return 0;  // on FormatException を使うべき
}
```

## ワークスペースとの関係

* ファイル編集後の確認ポイントとして、例外処理が本規約に沿っているかをプロジェクトの編集後チェックリストで確認する。
* 外部ライブラリや Firebase 等の API が `Error` を throw する場合、暫定対応で `on Error` を使うときは、必ず理由と TODO をコメントに残す。

## ナレッジベース

### DO: 予期される例外は具体的な Exception 型で catch する

* `on FormatException`、`on TimeoutException` など、型を指定して処理する。

```dart
try {
  final value = int.parse(input);
  return value;
} on FormatException catch (e) {
  // 数値形式が不正な場合の処理
  return 0;
}
```

### DO: Error / 型なし catch には理由コメントを書く

* `Error` を catch する場合、または `catch (e)` で握りつぶす場合は、必ず理由をコメントで追記する。

```dart
try {
  await criticalOperation();
} catch (e) {
  // クリティカルな操作が失敗した場合でも、アプリを継続させる必要がある
  // すべての例外を catch してログに記録し、デフォルト値を返す
  logger.error('クリティカルな操作が失敗しました: $e');
  return defaultValue;
}
```

### DO NOT: 理由コメントなしで Error を catch する

* 理由: 意図が不明瞭になり、レビュー・デバッグが困難になる。

```dart
// アンチパターン: Error を catch しているが理由が不明確
try {
  someOperation();
} on Error catch (e) {
  return defaultValue;  // 理由のコメントがない
}
```

### DO NOT: 理由コメントなしで型指定なし catch により例外を握りつぶす

* 理由: 例外が隠蔽され、デバッグが困難になる。

```dart
// アンチパターン: 型指定なし catch で理由が不明確
try {
  someOperation();
} catch (e) {
  // 理由が書かれていない → 例外が隠蔽され、デバッグが困難になる
}
```

### DO NOT: Exception を catch すべき箇所で Error を catch する

* 理由: 適切な例外型で catch する。例として `int.parse` は `FormatException` を throw する。

```dart
// アンチパターン: FormatException は Exception 型なので、Error で catch しない
try {
  final value = int.parse(input);
  return value;
} on Error catch (e) {
  return 0;  // on FormatException を使うべき
}
```

```dart
try {
  final value = int.parse(input);
  return value;
} on FormatException catch (e) {
  // 数値形式が不正な場合の処理
  return 0;
}
```

### DO NOT: 同一型を catch して何もせず rethrow する

* 理由: 制御フローが変わらず冗長。後続の `on OtherException` を書くためだけに挟むなら、先に具体型を catch する
* 理由: 「握りつぶしていない」ことを示す目的でも、空の `rethrow` 節はノイズになる

```dart
// DO NOT: 意味のない rethrow
try {
  return await client.get(path: path);
} on ProfileImageObjectNotFoundException {
  rethrow;
} on FirebaseException catch (e) {
  // ...
}
```

```dart
// DO: 変換が必要な型だけ catch する
try {
  return await client.get(path: path);
} on FirebaseException catch (e, st) {
  if (e.code == "object-not-found") {
    throw ProfileImageObjectNotFoundException(
      path: path,
      cause: e,
      stackTrace: st,
    );
  }
  rethrow;
}
```

独自例外の定義（`message` / `cause` / `stackTrace` / `toString`）は
[exception-definition.md](./exception-definition.md) を正とする。
