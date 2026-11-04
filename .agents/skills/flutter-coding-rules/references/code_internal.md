# internal 属性規約

## 概要

本ドキュメントは、Dart コードにおける**可視性の明示**と **`@internal` を中心とした注釈**の規約を定義する。

* `public` 以外の型・クラス・メンバーには、**`@internal` アノテーションもしくは `private` 属性**を付与する。
* テストのために公開する必要がある場合は、**`@visibleForTesting`** を付与する。
* 継承階層での保護が必要な場合は、**`@protected`** を付与する。
* 可視性を明確にすることで、パッケージの API 境界を守り、意図しない外部からのアクセスを防ぐ。

## 付与ルール

* **パッケージ内部でのみ使用する型・クラス・メンバー**: `@internal` または `private`（識別子の先頭 `_`）
* **テスト用にのみ公開する型・メンバー**: `@visibleForTesting`
* **継承クラスからのみアクセスを許すメンバー**: `@protected`

## internal 属性の補足

* 可視性を明確にすることで、**パッケージの API 境界**が明確になり、意図しない外部からのアクセスを防ぐことができる。
* `@internal` アノテーションは **`package:meta/meta.dart`** からインポートする。
* 各アノテーションの用途は以下の通りである：
  * **`@internal`**: パッケージ内部でのみ使用する型やメンバーに付与する。
  * **`@visibleForTesting`**: テストのために公開する必要がある型やメンバーに付与する。
  * **`@protected`**: 継承階層での保護が必要なメンバーに付与する。
* Delegate やデータオブジェクトなど、実装詳細としてパッケージ外に露出させたくないものは [delegate-pattern.md](delegate-pattern.md)・[data_object.md](data_object.md) も参照する。

## internal 属性の実装例

### パッケージ内部でのみ使用するクラス・トップレベル

```dart
// screen_feature_home2, strings.dart
/// 文字列リソースへのアクセスを提供するインスタンス
@internal
final strings = _Strings();
```

```dart
// screen_feature_home2, strings.dart
/// パッケージ内部でのみ使用する文字列リソースへのアクセサ
final class _Strings with L10nStringsMixin {}
```

### テスト用に公開するメソッド

```dart
// domain_preferences, preference_key.dart
/// テスト用のキーを生成する
@visibleForTesting
factory PreferenceKey.test(String value) => PreferenceKey(value);
```

### 継承階層での保護

```dart
class ProtectedClassExample {
  @protected
  void onExample() {}
}
```

## internal 属性のアンチパターン

以下のように、可視性が不明確な実装は避ける。

```dart
// アンチパターン: 外部から使用すべきでないクラスにアノテーションがない
class InternalOnlyClassName {}
```

## ワークスペースとの関係

* ファイル編集後の確認ポイントとして、`@internal` および `@visibleForTesting` が適切に使用されているかをプロジェクトの編集後チェックリストで確認する。
* [delegate-pattern.md](delegate-pattern.md) では、Delegate はパッケージ内部でのみ使用するため `@internal` を付与する方針が述べられている。
* [data_object.md](data_object.md) では、パッケージ内部専用のデータオブジェクトに `@internal` を付与するパターンが示されている。

## ナレッジベース

### DO: public 以外の型・メンバーに `@internal` または `private` を付与する

* 可視性を明確化し、パッケージの公開 API と内部実装を分ける。

```dart
// screen_feature_home2, strings.dart
/// 文字列リソースへのアクセスを提供するインスタンス
@internal
final strings = _Strings();
```

### DO: テスト用公開には `@visibleForTesting` を使用する

* テストのために公開する型やメンバーに付与する。

```dart
// domain_preferences, preference_key.dart
/// テスト用のキーを生成する
@visibleForTesting
factory PreferenceKey.test(String value) => PreferenceKey(value);
```

### DO NOT: 外部利用を想定しない public にアノテーションを付けないままにする

* 理由: パッケージの API 境界が不明確になり、意図しない依存が発生する。

```dart
// アンチパターン: 外部から使用すべきでないクラスにアノテーションがない
class InternalOnlyClassName {}
```

```dart
// screen_feature_home2, strings.dart
/// 文字列リソースへのアクセスを提供するインスタンス
@internal
final strings = _Strings();
```
