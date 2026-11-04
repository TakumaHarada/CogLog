---
name: flutter-xcodegen-ios-firebase-crashlytics
description: >-
  Flutter iOS XcodeGen 構成に Firebase Crashlytics（SPM product と dSYM アップロード Build Phase）を
  組み込む SKILL。「Crashlytics を xcodegen に」「Crashlytics Upload Symbols」「FirebaseCrashlytics product」
  では必ず使う。前提は flutter-xcodegen-ios-firebase（GoogleService-Info と firebase-ios-sdk）済み。
  Dart シンボルの別アップロード手順や Android 側は対象外。
---
# Flutter iOS / XcodeGen + Firebase Crashlytics

`flutter-xcodegen-ios-firebase` 済みの `project.yml` に、Crashlytics のリンクとシンボルアップロード Phase を足す。

## 前提

* `firebase-ios-sdk` が `packages` にある
* 各 Configuration に `GoogleService-Info.plist` があり、pre-build でバンドルへ入る
* Upload Phase の input にバンドル内 plist と dSYM が含まれる（テンプレどおり）

## 作業手順

1. [assets/project.yml.crashlytics-fragment.yml](./assets/project.yml.crashlytics-fragment.yml) を読む
2. [assets/xcodegen/scripts/preBuildFirebaseCrashlyticsRun.sh](./assets/xcodegen/scripts/preBuildFirebaseCrashlyticsRun.sh) を `ios/xcodegen/scripts/` へ配置し、実行ビットを付ける
3. `targets.Runner.dependencies` に `FirebaseCrashlytics` product を追加する
4. `postBuildScripts` に Crashlytics Upload Phase を追加する（Thin Binary の後でよい）。`script` はインラインではなく `${PROJECT_DIR}/xcodegen/scripts/preBuildFirebaseCrashlyticsRun.sh` を指す
5. `xcodegen` を再実行する

## 注意

* `basedOnDependencyAnalysis: false` を付け、入力ファイル一覧をテンプレから落とさない
* GoogleService-Info がバンドルに無いとアップロードが失敗しやすい → firebase SKILL 側を先に直す
* Crashlytics `run` の配置先はビルド経路で異なる
  * `flutter build` / `flutter ipa`: `build/ios/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run`
  * Xcode IDE: DerivedData 配下の `SourcePackages/checkouts/.../Crashlytics/run`
  * `${BUILD_DIR%/Build/*}/SourcePackages/...` のみだと Flutter CLI アーカイブで `No such file or directory` になり得る。同梱スクリプトは両方を探索する

## 関連

* `flutter-xcodegen-ios-firebase`
* `flutter-xcodegen-ios`
