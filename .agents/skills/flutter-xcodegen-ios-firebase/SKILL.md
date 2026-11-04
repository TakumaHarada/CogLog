---
name: flutter-xcodegen-ios-firebase
description: >-
  Flutter iOS の XcodeGen 構成に Firebase（SPM: firebase-ios-sdk）と
  GoogleService-Info.plist 配置・pre-build コピーを組み込む SKILL。
  「Firebase を xcodegen に」「GoogleService-Info を Flavor ごとに」「preBuildInstallGoogleServiceInfoPlist」
  「firebase-ios-sdk を project.yml に」では必ず使う。前提は flutter-xcodegen-ios 適用済み。
  Crashlytics 専用は flutter-xcodegen-ios-firebase-crashlytics、Google Sign-In は
  flutter-xcodegen-ios-google-sign-in に譲る。
---
# Flutter iOS / XcodeGen + Firebase

`flutter-xcodegen-ios` で整えた `ios/` に、Firebase iOS SDK（SPM）と Configuration 別 `GoogleService-Info.plist` を載せる。

## 前提

* `flutter-xcodegen-ios` 済み（`project.yml` / `Configurations/` / `xcodegen/` がある）
* 各 Xcode Configuration 名に対応する Firebase アプリの `GoogleService-Info.plist` をユーザーが用意できること

plist の中身や Firebase project の対応が指示に無い場合は、配置パスだけ用意し、実ファイルはユーザー提供を待つ（推測で中身を捏造しない）。

## 作業手順

1. [references/google-service-info.md](./references/google-service-info.md) を読む
2. [assets/xcodegen/scripts/preBuildInstallGoogleServiceInfoPlist.sh](./assets/xcodegen/scripts/preBuildInstallGoogleServiceInfoPlist.sh) を `ios/xcodegen/scripts/` へコピーし実行権限を付ける
3. 各 Configuration ディレクトリに `GoogleService-Info.plist` を置く  
   例: `Configurations/Debug-development/GoogleService-Info.plist`
4. [assets/project.yml.firebase-fragment.yml](./assets/project.yml.firebase-fragment.yml) に従い `project.yml` を更新する  
   * `packages` に `firebase-ios-sdk` と `googleappmeasurement`  
   * バージョンは確認して埋める（推測しない）  
   * `preBuildScripts` に Install GoogleService-Info を追加  
   * **`CoreGraphics.framework` 依存は残す**（SPM 解決失敗対策）
5. `xcodegen` を再実行する

## 単一 plist の場合

Configuration が複数でも Firebase プロジェクトが1つなら、同じ plist を各 `Configurations/<Configuration>/` にコピーしてよい。スクリプトは常に `${CONFIGURATION}` 配下を見る。

## 関連

* 土台: `flutter-xcodegen-ios`
* Crashlytics: `flutter-xcodegen-ios-firebase-crashlytics`
* Google Sign-In: `flutter-xcodegen-ios-google-sign-in`
