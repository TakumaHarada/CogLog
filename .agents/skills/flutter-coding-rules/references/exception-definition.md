# Exception / Error 定義規約

## 概要

本ドキュメントは、**独自の `Exception` / `Error` を定義するとき**の規約である。
catch 側の書き方は [try-catch.md](./try-catch.md) を正とする。

* 独自例外は **デバッグ・ログ・上位への伝播** に耐えるフィールドを標準で持つ
* 最低限: `message` / `cause` / `stackTrace` / `toString()`
* PII（uid・メール・ニックネーム・Storage パスに uid が含まれる場合など）は `toString()` に出さない

## 標準フィールド

| フィールド | 型 | 役割 |
| --- | --- | --- |
| `message` | `String` | 人間可読な説明（固定文言でも可） |
| `cause` | `Exception?` または `Object?` | ラップした根本原因 |
| `stackTrace` | `StackTrace?` | 捕捉時のスタック |

既存例: `GoogleSignInException`、`BadEulaVersionException`、`AuthOperationLockedException`。

### テンプレート

```dart
@internal
final class ExampleDomainException implements Exception {
  final String message;
  final Exception? cause;
  final StackTrace? stackTrace;

  const ExampleDomainException({
    this.cause,
    this.stackTrace,
  }) : message = "example domain failed";

  @override
  String toString() {
    final causeText = cause != null ? ", cause: $cause" : "";
    return "ExampleDomainException: $message$causeText";
  }
}
```

パスや uid などログに出したくない識別子を保持する場合は、**フィールドとしては持ってよいが `toString()` には含めない**。

```dart
final class ProfileImageObjectNotFoundException implements Exception {
  final String message;
  final Exception? cause;
  final StackTrace? stackTrace;
  /// デバッグ用。toString には出さない。
  final String path;

  const ProfileImageObjectNotFoundException({
    required this.path,
    this.cause,
    this.stackTrace,
  }) : message = "profile image object not found";

  @override
  String toString() {
    final causeText = cause != null ? ", cause: $cause" : "";
    return "ProfileImageObjectNotFoundException: $message$causeText";
  }
}
```

## ナレッジベース

### DO: 独自 Exception / Error に message・cause・stackTrace・toString を揃える

* 既存の認証・API 例外と同型にする
* `toString()` は型名と `message`（必要なら `cause`）を返す

### DO: 外部例外をラップするとき cause と stackTrace を渡す

```dart
} on FirebaseException catch (e, st) {
  throw ProfileImageObjectNotFoundException(
    path: path,
    cause: e,
    stackTrace: st,
  );
}
```

### DO NOT: フィールド無しの Exception を追加する

* 理由: ログ・クラッシュレポートで原因が追えない
* 理由: 上位が `cause` を辿れない

```dart
// DO NOT
final class BadException implements Exception {
  const BadException();
}
```

### DO NOT: toString に PII や機微パスを出す

* 理由: ログ・Crashlytics へ漏洩する
* uid・メール・ニックネーム・ユーザー特定可能な Storage パスは出さない
