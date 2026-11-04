# Flutter-Layered-Architecture / ディレクトリ構成

## 概要

`Flutter-Layered-Architecture` では、アプリを構築するディレクトリ構成のルールを定めている。

* レイヤーごとに `app_packages/` 配下へパッケージを配置する
* 機能単位でパッケージを細分化し、単一の巨大パッケージを避ける
* 実装・テスト用パッケージはインターフェース直下の入れ子ディレクトリ（`_impl` 等）に配置する

## 基本的なレイアウト

```text
workspace              # ルートディレクトリ
├── app                # アプリ用レイヤー
├── app_packages       # アーキテクチャレイヤーごとのpackage
│   ├── data 
│   ├── domain
│   ├── foundation
│   ├── infra
│   ├── screen
│   ├── testing
│   ├── usecase
│   └── view
├── app_packages_fork  # アプリ用のForkしたライブラリ格納ディレクトリ
├── docs               # ドキュメントディレクトリ
├── templates          # 各種テンプレートファイル
└── tool               # grinderスクリプト
```

## パッケージの細分化

各レイヤー配下では、**機能単位でパッケージを適切に細分化する**。単一の巨大パッケージにせず、責務ごとにサブディレクトリ（＝パッケージ）を切る。

### 細分化の原則

* **data**: `repository/${機能名}`、`database`、`injection` 等に分離する
* **domain**: ドメイン概念ごとに `account`、`japanese`、`school` 等のパッケージに分離する。他レイヤーに依存しない
* **foundation**: `dependency_injection`、`metadata`、`resources` 等の基盤機能ごとに分離する
* **infra**: 関心ごとに `asset`、`firebase`、`functions`、`google`、`storage`、`injection` 等に分離する。環境別実装は入れ子の `_mobile`、`_testing` 等で持つ
* **screen**: `navigation`（画面遷移のインターフェース）、`feature/${画面名}`（各画面）、`injection` に分離する
* **usecase**: ビジネス機能ごとに `school`、`japanese`、`error` 等のパッケージに分離する。各パッケージはインターフェースのみを持ち、実装は `_impl` に委ねる
* **view**: デザインシステム等は `designkit` 等に分離する
* **testing**: 横断的なテスト支援は `testing/core`、`testing/injection` 等に分離する

### レイヤー別の細分化例（app_packages 配下）

```text
app_packages/
├── data/
│   ├── database/           # データベース抽象
│   ├── repository/         # Repository 群（preferences, japanese, authentication, ai_quota 等）
│   └── injection/
├── domain/
│   ├── account/
│   ├── ai_quota/
│   ├── japanese/
│   ├── kanji_practice/
│   ├── preferences/
│   ├── school/
│   └── end_user_license_agreement/
├── foundation/
│   ├── dependency_injection/
│   ├── metadata/
│   └── resources/
├── infra/
│   ├── asset/
│   ├── firebase/
│   ├── functions/
│   ├── google/
│   ├── storage/
│   └── injection/
├── screen/
│   ├── navigation/         # ナビゲーションインターフェース
│   ├── feature/            # 各画面
│   └── injection/
├── testing/
│   ├── core/
│   └── injection/
├── usecase/
│   ├── error/
│   ├── japanese/
│   ├── kanji_practice/
│   ├── school/
│   ├── system/
│   ├── tutorial/
│   └── injection/
└── view/
    └── designkit/
```

## インターフェースパッケージ内の入れ子実装

インターフェースを定義するパッケージの**直下**に、実装やテスト用のパッケージを**入れ子ディレクトリ**として配置する。ディレクトリ名はアンダースコア prefix とする（`pub` で private 扱いされないが、構成上の「内部実装」であることを示す）。

### 入れ子ディレクトリの種類

| サブディレクトリ | 用途 | パッケージ名例 |
| -- | -- | -- |
| `_impl` | 本番用実装 | `usecase_school_impl`、`data_repository_preferences_impl` |
| `_testing` | テスト用注入・Fake 実装の提供 | `usecase_injection_testing`、`infra_storage_testing` |
| `_test` | テスト用のスタブ／Fake 専用パッケージ（単体テストから参照） | `usecase_school_test`、`data_repository_authentication_test` |
| `_mobile` | 実機向け実装（infra の環境別実装） | `infra_storage_mobile`、`infra_injection_mobile` |
| `_go_router` | 画面遷移の特定実装（screen_navigation の実装） | `screen_navigation_go_router` |

※ `_fake` は、Fake クラスを `_impl` パッケージ内の `lib/src/` 配下に置くパターンもあり、その場合は入れ子パッケージを切らない。テスト専用のスタブを別パッケージにまとめる場合は `_test` を用いる。

### 入れ子構成の例（usecase）

```text
app_packages/usecase/school/
├── pubspec.yaml              # name: usecase_school（インターフェース）
├── lib/
│   └── ...
├── _impl/                    # usecase_school_impl
│   ├── pubspec.yaml
│   └── lib/...
└── _test/                    # usecase_school_test（Fake/スタブ）
    ├── pubspec.yaml
    └── lib/...
```

### 入れ子構成の例（data repository）

```text
app_packages/data/repository/authentication/
├── pubspec.yaml              # data_repository_authentication（インターフェース）
├── lib/...
├── _impl/                    # data_repository_authentication_impl
├── _test/                    # テスト用スタブパッケージ
└── _testing/                 # テスト用注入で使う Fake 提供（必要な場合）
```

### 入れ子構成の例（infra・環境別）

```text
app_packages/infra/storage/
├── pubspec.yaml              # infra_storage（インターフェース）
├── lib/...
├── _mobile/                  # 実機向け実装
├── _testing/                 # テスト用 Fake 実装
└── ...
```

### 入れ子構成の例（screen navigation）

```text
app_packages/screen/navigation/
├── pubspec.yaml              # screen_navigation（インターフェース）
├── lib/...
└── _go_router/               # screen_navigation_go_router（実装）
    ├── pubspec.yaml
    └── lib/...
```

### ルールのまとめ

* インターフェースは「そのパッケージのルート」に置き、実装類は `_impl` / `_testing` / `_test` / `_mobile` / `_go_router` 等の**入れ子パッケージ**に配置する
* 本番コードはインターフェースパッケージと `_impl`（または `_mobile`、`_go_router`）にのみ依存し、`_test`・`_testing` には依存しない
* テスト時のみ、`_test` や `_testing` を参照し、Fake やテスト用 Injection を利用する

詳細は [architecture-design.md](./architecture-design.md) の「testing レイヤー」「ディレクトリ配置」および [dependency-injection.md](./dependency-injection.md) の「package分離」を参照すること。

## ナレッジベース

### DO: 機能単位でパッケージを細分化する

* 単一の巨大パッケージにせず、責務ごとにサブディレクトリ（＝パッケージ）を切る
* レイヤー配下は `repository/${機能名}`、`school`、`feature/${画面名}` 等に分離する

```text
app_packages/usecase/
├── school/
├── japanese/
└── injection/
```

### DO: 実装はインターフェース直下の入れ子パッケージに置く

* `_impl` / `_testing` / `_test` / `_mobile` / `_go_router` 等のアンダースコア prefix ディレクトリを用いる
* インターフェースはパッケージルートに置く

```text
app_packages/usecase/school/
├── pubspec.yaml              # インターフェース
├── _impl/                    # 本番実装
└── _test/                    # テスト用スタブ
```

### DO: 本番コードは `_test`・`_testing` に依存しない

* 本番はインターフェースと `_impl`（または `_mobile`、`_go_router`）のみに依存する
* テスト時のみ `_test` / `_testing` を参照する

### DO NOT: インターフェースと実装を同一パッケージに混在させる

* 理由: テスト時の差し替えが困難になる
* 理由: 依存の向きが曖昧になり、実装詳細が呼び出し側へ漏れる

```text
# DO NOT: 同一パッケージ内に interface と impl を同居させる
app_packages/usecase/school/lib/src/
├── kanji_search_usecase.dart
└── kanji_search_usecase_impl.dart
```

```text
# DO: 入れ子の _impl パッケージへ実装を分離する
app_packages/usecase/school/
├── lib/src/kanji_search_usecase.dart
└── _impl/lib/src/.../kanji_search_usecase_impl.dart
```

### DO NOT: 本番パッケージから `_testing` を依存に含める

* 理由: テスト用 Fake が本番バイナリへ混入する
* 理由: 本番とテストの境界が崩れる

```yaml
# DO NOT: 本番用 pubspec.yaml に _testing を書く
dependencies:
  usecase_injection_testing: ...
```

```yaml
# DO: テスト用依存はテスト側（または _test / テストパッケージ）に限定する
dev_dependencies:
  usecase_injection_testing: ...
```
