# 開発上の制約

レイヤーは `docs/architecture.md`、Dart の書き方は `docs/coding.md`、文言は `docs/localization.md`、UI は `docs/ui.md` に従う。ここにはそれらをまたぐ制約を書く。

## Workspace

- 依存の実効バージョンはルート `pubspec.yaml` の `dependency_overrides` に書く。
- 子パッケージの外部依存は `any` にする。
- `flutter pub get` と Monolith のコマンドはリポジトリルートで実行する。
- `flutter run` と `dart run forui` は `app/` で実行する。

## フレーバー

`monolith.yaml` の `define.flavors` は `development`、`production`、`test`。値はすべて文字列にする。`test` はテストが読むフレーバーで、中身は development に揃える。

```bash
dart run monolith_runner:define
```

出力先 `secrets/dart-define/` は git に入れない。`foundation_metadata` のテストは `secrets/dart-define/test.json` がある状態で実行する。

開発ビルド:

```bash
cd app
flutter run --dart-define-from-file=../secrets/dart-define/development.json
```

## 秘密情報

- `secrets/` はコミットしない。
- 秘密の注入元は `monolith.yaml` の `includes` にある `secrets/monolith.yaml`。
- 1Password を使うときは `op inject --force --in-file monolith.yaml --out-file secrets/monolith.yaml` のあと、`dart run monolith_runner:install` を実行する。

## 生成ファイル

Monolith が書く次のファイルは手で編集しない。

- `app_packages/foundation/metadata/lib/gen/defines.dart`
- 各パッケージの `lib/gen/strings.dart`
- `app_packages/foundation/resources/lib/gen/strings_test_helper.dart`
- `app/runner/lib/l10n/`

入力側（`monolith.yaml` と `res/strings.csv`）を変えて、対応するコマンドを再実行する。

## iOS

`dart run monolith_runner:xcodegen` は、各構成の Bundle Identifier、Provisioning Profile、Team ID が揃ってから実行する。これらの値が指示に無いときは、値を作らずに不足項目を残す。

## Firebase

クライアント設定はリポジトリに置く。これは Firebase のクライアント向け API キーであり、`secrets/` には置かない。サービスアカウント秘密鍵は置かない。

- Android は `app/android/app/google-services.json`。プラグイン `com.google.gms.google-services` を `app/android/settings.gradle.kts` で宣言し、`app/android/app/build.gradle.kts` で適用する。対象の `applicationId` は `io.github.madahataraku.coglog`。
- iOS は `app/ios/Runner/GoogleService-Info.plist` を Runner ターゲットのリソースに含める。対象の Bundle Identifier は `io.github.madahataraku.coglog`。

`development`、`production`、`test` は dart-define のフレーバーであり、ネイティブの applicationId と Bundle Identifier は共通である。Firebase アプリは Android と iOS で 1 つずつなので、設定ファイルも 1 組である。

XcodeGen へ移すときは、上記の iOS の条件が揃ってから行う。そのとき plist は `app/ios/Configurations/<CONFIGURATION>/GoogleService-Info.plist` へ移し、ビルド前にアプリバンドルへコピーする。

## Firebase App Distribution

`.github/workflows/firebase-app-distribution.yml` が Android の release APK と iOS の Ad Hoc IPA を Firebase App Distribution へ出す。

起動は次の 2 つ。

- `main` への push。マージで `main` が進んだときを含む。フレーバーは `development`。
- `workflow_dispatch`。任意のタイミングで実行し、フレーバーは `development` または `production`。

配布するフレーバーは `development` と `production` である。`test` はテストが読むフレーバーのままにする。ネイティブの applicationId と Bundle Identifier はフレーバーで分かれない。配布先の Firebase アプリ ID は、コミット済みの `app/android/app/google-services.json` と `app/ios/Runner/GoogleService-Info.plist` から読む。

ビルド前にリポジトリルートで `flutter pub get` と `dart run monolith_runner:define` を実行し、`app/` のビルドへ `--dart-define-from-file=../secrets/dart-define/<flavor>.json` を渡す。

Android の release は `app/android/app/build.gradle.kts` の debug 署名を使う。

iOS の署名材料は GitHub Actions の secret に置く。ワークフローは Provisioning Profile から Team ID とプロファイル名を読む。Bundle Identifier は `io.github.madahataraku.coglog`。Ad Hoc プロファイルに登録した端末が iOS ビルドをインストールできる。

| secret | 内容 |
| --- | --- |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | プロジェクト `coglog-47b99` のサービスアカウント JSON。ロールは Firebase App Distribution 管理者 |
| `IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64` | Apple Distribution 証明書の PKCS#12 を Base64 にしたもの |
| `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | その PKCS#12 のパスワード |
| `IOS_PROVISIONING_PROFILE_BASE64` | Bundle Identifier `io.github.madahataraku.coglog` の Ad Hoc Provisioning Profile を Base64 にしたもの |

テスターグループの初期値は `testers`。手動実行の入力、またはリポジトリ変数 `FIREBASE_DISTRIBUTION_GROUPS` で置き換える。
