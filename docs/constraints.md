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

クライアント設定は手元に置き、Git では追跡しない。

- Android は `app/android/app/google-services.json`。プラグイン `com.google.gms.google-services` を `app/android/settings.gradle.kts` で宣言し、`app/android/app/build.gradle.kts` で適用する。対象の `applicationId` は `io.github.madahataraku.coglog`。
- iOS は `app/ios/Runner/GoogleService-Info.plist` を Runner ターゲットのリソースに含める。対象の Bundle Identifier は `io.github.madahataraku.coglog`。

`google-services.json` と `GoogleService-Info.plist` は `.gitignore` に入る。リポジトリへ追加しない。

`development`、`production`、`test` は dart-define のフレーバーであり、ネイティブの applicationId と Bundle Identifier は共通である。Firebase アプリは Android と iOS で 1 つずつなので、手元に置く設定ファイルも 1 組である。

XcodeGen へ移すときは、上記の iOS の条件が揃ってから行う。そのとき plist は `app/ios/Configurations/<CONFIGURATION>/GoogleService-Info.plist` へ移し、ビルド前にアプリバンドルへコピーする。このパスも Git では追跡しない。

## App Distribution

`.github/workflows/app-distribution.yml` は、`main` への push と手動の `workflow_dispatch` で Android の release APK を Firebase App Distribution へ出す。

push のフレーバーは `development`。手動起動では `development` または `production` を選ぶ。`test` は配布しない。dart-define は、リポジトリルートの `dart run monolith_runner:define` が書く `secrets/dart-define/<flavor>.json` を使う。`secrets/monolith.yaml` が無い include は読み飛ばす。

Android のクライアント設定は、Actions 上で次の参照から配置する。

```bash
op read --force --out-file app/android/app/google-services.json \
  "op://AppDevelopment/CogLog_develop/google-services.json"
```

iOS のファイル参照は `op://AppDevelopment/CogLog_develop/GoogleService-Info.plist`。IPA の配布は Team ID、証明書、Provisioning Profile が揃ってからワークフローへ足す。

Actions に置く secret は次のとおり。

- `OP_SERVICE_ACCOUNT_TOKEN`。vault `AppDevelopment` を読める 1Password サービスアカウント。
- `GCP_WORKLOAD_IDENTITY_PROVIDER`。このリポジトリ向けの Workload Identity Federation プロバイダ資源名。
- `GCP_SERVICE_ACCOUNT`。サービスアカウントのメールアドレス。Google Cloud のプロジェクト IAM で、このメンバーに `roles/firebaseappdistro.admin` を付ける。

同じサービスアカウントには、リポジトリ `madahataraku/CogLog` の `main` からだけなれるようにする。管理場所は Google Cloud コンソールの **IAM と管理 → サービス アカウント → 対象アカウント → 権限** である。そこへ次の principal に `roles/iam.workloadIdentityUser` を付ける。

```text
principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github/attribute.repository/madahataraku/CogLog
```

テスターグループはリポジトリ変数 `FIREBASE_APP_DISTRIBUTION_GROUPS` にカンマ区切りで置く。手動起動の `groups` 入力があるときはそれを使う。

配布の前に、リポジトリルートで `flutter analyze` を実行し、`test/` がある各パッケージでテストを実行する。`sdk: flutter` を持つパッケージは `flutter test`、それ以外は `dart test` である。

versionName は `pubspec.yaml` のままにする。versionCode は GitHub Actions の run number にする。release 署名は同じ upload keystore を使い、配布済みの APK を上書き更新できるようにする。debug 署名は release に使わない。

keystore とパスワードは、アイテム `CogLog_develop` に置く。Actions は次の参照を読み、標準出力へパスワードを出さずに `app/android/key.properties` を書く。

- `op://AppDevelopment/CogLog_develop/upload-keystore.jks`
- `op://AppDevelopment/CogLog_develop/storePassword`
- `op://AppDevelopment/CogLog_develop/keyPassword`
- `op://AppDevelopment/CogLog_develop/keyAlias`

`storeFile` は `app/android/app` から `../../../secrets/android/upload-keystore.jks` を指す。keystore、`key.properties`、パスワードは Git に入れない。

keystore がまだ無いときは、リポジトリの外で一度だけ作り、同じアイテムへファイル添付する。`keyAlias` に入れる別名は、このコマンドの `-alias` と揃える。

```bash
keytool -genkeypair -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

`storePassword` と `keyPassword` は、そのときに入力したパスワードである。同じファイルを後から作り直すと、すでに配布した APK を上書き更新できなくなる。
