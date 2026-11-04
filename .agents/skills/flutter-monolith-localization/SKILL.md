---
name: flutter-monolith-localization
description: >-
  monolith による Flutter 文字列外部リソース化・L10n（`res/strings.csv` →
  `dart run monolith_runner:localization` → `L10nStringsMixin` / `StringsTestHelper`）用 SKILL。
  文言追加・変更、CSV ヘッダー、生成コマンド、`lib/src/strings.dart`、複数 package の mixin、
  Unit／Widget Preview／Golden での `injectDelegateForTest` では必ず使う。
  「strings.csv に足して」「L10n 生成して」「テストで文言注入」「StringsTestHelper」でもロードする。
  Flutter 標準の gen-l10n だけ・ARB 手編集だけ、Dart コーディング規約のみ、アプリ起動／DTD、
  Go／Firebase 調査のみでは使わない。詳細は references/localization.md。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# monolith / L10n 対応

Flutter アプリで、`monolith` 経由のローカライゼーション（CSV → 生成コード）を扱うときはこの SKILL に従う。
実装の細部・DO/DO NOT は [references/localization.md](./references/localization.md) を読む。
コマンド例は `dart run …` 本体で示す。`mise` / `fvm` 等のラッパーはリポジトリ規約に任せ、本 SKILL には埋め込まない。

## いつ使うか

* `res/strings.csv` への文言追加・変更
* `dart run monolith_runner:localization` によるコード生成
* パッケージ内 `strings` アクセサ（`L10nStringsMixin`）の実装
* Unit Test / Widget Preview / Golden Test への文言注入（`StringsTestHelper`）

## いつ使わないか

* Flutter 標準 `gen-l10n` / ARB 手編集のみ（monolith を使わない場合）
* Dart の一般的なコーディング規約だけ → `flutter-coding-rules`
* アプリ起動・DTD デバッグ → `flutter-app-debug`

## データレイアウト

各 package ごと（必要に応じて）:

```text
path/to/package
├── lib
│   ├── gen
│   │   └── strings.dart          # 自動生成（手編集しない）
│   └── src
│       └── strings.dart          # 手書き: L10nStringsMixin を mixin
├── pubspec.yaml
├── res
│   └── strings.csv               # 真実源
└── test
```

集約言語の正本（ARB / gen-l10n / L10nHelper）は **`app_runner`（`app/runner`）** に出力される。
feature アプリは `package:app_runner/app_runner.dart` 経由で `L10nHelper` を利用する。
`.secrets/monolith.secrets.yaml` に `localization.app.package_name` がある場合は `app_runner` に揃える（secrets が優先）。

## 作業手順

1. `res/strings.csv` を編集する（ヘッダー `id,{言語コード},description`）
2. ルートから生成する: `dart run monolith_runner:localization`
3. パッケージの `lib/src/strings.dart` で生成 mixin を使う（`export` しない、`@internal`）
4. テスト／Preview が必要なら `StringsTestHelper` + `LocalizeStringDelegate.injectDelegateForTest`

## 依存ライブラリ

| パッケージ | 置き場所 |
| --- | --- |
| [monolith](https://pub.dev/packages/monolith) | dart workspace **ルート**の `dev_dependencies` |
| [monolith_localization](https://pub.dev/packages/monolith_localization) | 同上 |
| [monolith_localization_runtime](https://pub.dev/packages/monolith_localization_runtime) | **個別 package** に必要 |

個別 package に monolith / monolith_localization を足す必要はない。

## StringsTestHelper（Test / Preview / Golden）

`monolith.yaml` の `localization.test_helper` は省略可。省略時はヘルパーを生成しない。

```yaml
localization:
  languages:
    - ja
  test_helper:
    package_name: foundation_resources          # required
    test_helper_class_name: StringsTestHelper   # optional
    test_helper_path: lib/gen/strings_test_helper.dart  # optional
```

生成後は言語ごとの getter（例: `StringsTestHelper.ja`）を `injectDelegateForTest` に渡す。
リリースモードでは getter が `UnsupportedError` を投げる。詳細とコード例は references を読む。

## 主な遵守事項

* [ ] リソース定義は `res/strings.csv`。ヘッダー `id,{言語コード},description`
* [ ] CSV 変更後は `dart run monolith_runner:localization` で再生成
* [ ] アクセスは `lib/src/strings.dart` + 生成 `L10nStringsMixin`（`export` しない、`@internal`）
* [ ] 他 package の文言が必要なら、該当 `L10nStringsMixin` を必要な数だけ mixin
* [ ] Test / Preview / Golden では `StringsTestHelper` + `injectDelegateForTest`
* [ ] `StringsTestHelper` をリリースビルドから呼ばない
* [ ] `lib/gen/strings.dart` / `strings_test_helper.dart` を手編集しない
