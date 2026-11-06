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

ネイティブのアプリ ID（Android `applicationId` / iOS Bundle Identifier）はフレーバーだけで切り替える。buildType（debug / release）では変えない。

| flavor | applicationId / Bundle Identifier |
| --- | --- |
| development | `io.github.madahataraku.coglog.debug` |
| test | `io.github.madahataraku.coglog.debug` |
| production | `io.github.madahataraku.coglog` |

開発ビルド:

```bash
cd app
flutter run --flavor development \
  --dart-define-from-file=../secrets/dart-define/development.json
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

Bundle Identifier は上記フレーバー対応表に従う。`dart run monolith_runner:xcodegen` は、各構成の Bundle Identifier、Provisioning Profile、Team ID が揃ってから実行する。Provisioning Profile と Team ID は未指定のため、いまは xcodegen を実行しない。指示に無い署名の値は作らない。

## Firebase

クライアント設定は手元に置き、Git では追跡しない。フレーバーごとにファイルを分ける（1 ファイルに両アプリ ID を入れない）。

- Android は `app/android/app/src/<flavor>/google-services.json`。プラグイン `com.google.gms.google-services` を `app/android/settings.gradle.kts` で宣言し、`app/android/app/build.gradle.kts` で適用する。各ファイルの `package_name` は、そのフレーバーの `applicationId` と一致させる。
- iOS の保管先は `app/ios/Configurations/<CONFIGURATION>/GoogleService-Info.plist`（例: `Debug-development`）。同一フレーバーの Debug / Profile / Release は同じ内容を置く。ビルド前に選んだ構成の plist を `app/ios/Runner/GoogleService-Info.plist` へコピーし、Runner ターゲットのリソースとして含める。

```bash
# flavor=development・Debug の例
cp app/ios/Configurations/Debug-development/GoogleService-Info.plist \
  app/ios/Runner/GoogleService-Info.plist
```

`google-services.json` と `GoogleService-Info.plist` は `.gitignore` に入る。リポジトリへ追加しない。

Firebase コンソールでは、Android / iOS それぞれに development（`.debug`）用と production 用のアプリを持つ。1Password の `CogLog_develop` に置く development / test 向け添付は、package name / Bundle ID が `io.github.madahataraku.coglog.debug` であることを期待する。production 向けはアイテム `CogLog_production` を使う。

XcodeGen へ移すときは、署名条件が揃ってから行う。そのときも plist の保管は `app/ios/Configurations/<CONFIGURATION>/GoogleService-Info.plist` とし、ビルド前にアプリバンドルへコピーする。

## App Distribution

`.github/workflows/app-distribution.yml` は、`main` への push と、`main` を選んだ手動の `workflow_dispatch` で Android の release APK を Firebase App Distribution へ出す。ジョブは `github.ref == refs/heads/main` のときだけ動き、Environment `app-distribution` を使う。

push のフレーバーは `development`。手動起動では `development` または `production` を選ぶ。`test` は配布しない。dart-define は、リポジトリルートの `dart run monolith_runner:define` が書く `secrets/dart-define/<flavor>.json` を使う。`secrets/monolith.yaml` が無い include は読み飛ばす。

Android のクライアント設定は、Actions 上でフレーバー別パスへ配置する。`development` は `CogLog_develop`、`production` は `CogLog_production` を読む。

```bash
# development の例
mkdir -p app/android/app/src/development
op read --force --out-file app/android/app/src/development/google-services.json \
  "op://AppDevelopment/CogLog_develop/google-services.json"
```

```bash
# production の例
mkdir -p app/android/app/src/production
op read --force --out-file app/android/app/src/production/google-services.json \
  "op://AppDevelopment/CogLog_production/google-services.json"
```

配置後、ファイル内の `package_name` がそのフレーバーの `applicationId` と一致することを検証する。APK は `flutter build apk --release --flavor <flavor>` で出し、成果物は `app-<flavor>-release.apk` である。Firebase App Distribution のアプリ ID も、同じフレーバーの `package_name` から解決する。

iOS の development / test 向け参照は `op://AppDevelopment/CogLog_develop/GoogleService-Info.plist`、production 向けは `op://AppDevelopment/CogLog_production/GoogleService-Info.plist`。IPA の配布は Team ID、証明書、Provisioning Profile が揃ってからワークフローへ足す。

配布用 secret は、GitHub の Environment `app-distribution` に置く。リポジトリ secret には置かない。Environment の Deployment branches は Selected branches で `main` だけを許可する。設定場所は **Settings → Environments → app-distribution** である。

- `OP_SERVICE_ACCOUNT_TOKEN`。vault `AppDevelopment` を読める 1Password サービスアカウント。
- `GCP_WORKLOAD_IDENTITY_PROVIDER`。このリポジトリ向けの Workload Identity Federation プロバイダ資源名。
- `GCP_SERVICE_ACCOUNT`。サービスアカウントのメールアドレス。Google Cloud のプロジェクト IAM で、このメンバーに `roles/firebaseappdistro.admin` を付ける。

同じサービスアカウントには、リポジトリ `madahataraku/CogLog` の `main` からだけなれるようにする。Workload Identity プロバイダの属性マッピングは次にする。`attribute.repository` が無いと、IAM の principal はトークンと一致しない。

```text
google.subject=assertion.sub
attribute.repository=assertion.repository
```

属性条件は次にする。この条件が、`main` 以外の ref を拒否する。

```text
assertion.repository=='madahataraku/CogLog' && assertion.ref=='refs/heads/main'
```

IAM の principal はリポジトリ単位である。管理場所は Google Cloud コンソールの **IAM と管理 → サービス アカウント → 対象アカウント → 権限** である。そこへ次の principal に `roles/iam.workloadIdentityUser` を付ける。

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
