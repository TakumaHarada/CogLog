# アーキテクチャ方針

Dart workspace のモノリスを、上位が下位にだけ依存するレイヤーへ分ける。パッケージが未作成でも、新しい機能はこの表の責務に置く。

## レイヤー

| レイヤー | パッケージ名 | レベル | 役割 |
| --- | --- | --- | --- |
| app | `app`、`app_runner` | 7 | 起動、DI の統合、ローカライゼーションのホスト |
| screen | `screen_*` | 6 | 画面。MVVM。画面遷移のインターフェース |
| view | `view_*` | 5 | 複数画面で使う Widget |
| usecase | `usecase_*` | 4 | ビジネスロジック |
| data | `data_*` | 4 | データの読み書き。Repository |
| infra | `infra_*` | 3 | OS 差、実機とテストの差、外部サービス |
| domain | `domain_*` | 2 | 他レイヤーに依存しないドメイン |
| foundation | `foundation_*` | 1 | DI、メタデータ、共通リソースなどの基盤 |
| testing | `testing_*` | 範囲外 | テスト支援。本番バイナリには入れない |

レベルが小さいほど基盤である。usecase と data は同じレベルで、公開されたインターフェース同士の依存はできる。クラスの循環参照は作らない。

## 依存

- 上位レイヤーだけが下位レイヤーに依存する。
- domain と foundation は screen、view、usecase、data、infra を知らない。
- 本番パッケージは `_test` と `_testing` に依存しない。

## 処理の置き場所

アプリの処理は Usecase に置く。

- 共通の読み書きは data の Repository に抽象化する。
- 冪等な変換や分類、API や Repository を含む処理は共通 Usecase に置く。
- 画面の状態更新、再読み込み、画面固有のエラー処理は、その画面の Usecase に置く。
- ViewModel は Usecase を呼ぶ。Widget から Repository や infra を直接呼ばない。

## 画面

- 画面は View、ViewModel、State に分ける。
- 画面遷移のインターフェースは `screen_navigation` に置く。
- 遷移の実装は `screen_navigation` 直下の `_go_router` に置き、`go_router` を使う。
- 画面パッケージから `Navigator` を直接呼ばない。

## DI

- 結合は Riverpod で行う。
- 公開パッケージには `abstract interface class` と、未実装を示す `Provider` を置く。
- 実装クラスは別パッケージに置く。本番実装は `_impl`、実機差は `_mobile`、画面遷移は `_go_router`。
- テスト用の差し替えは `_testing` または `_test` に置き、app の合成箇所で上書きする。
- 各レイヤーの注入点は、そのレイヤーの `injection` パッケージにまとめる。

## パッケージの切り方

1 つの巨大パッケージにまとめない。機能ごとに分ける。

- data: `repository/<機能>`、`database`、`injection`
- domain: 概念ごと。他レイヤーへ依存しない
- usecase: 機能ごと。パッケージ本体はインターフェース、実装は `_impl`
- screen: `navigation`、`feature/<画面>`、`injection`
- view: `designkit` など、再利用する UI ごと
- infra: 関心ごと。環境差は入れ子パッケージ
- foundation: `metadata`、`resources`、`dependency_injection` など基盤ごと
- testing: `core`、`injection` など横断的なテスト支援
