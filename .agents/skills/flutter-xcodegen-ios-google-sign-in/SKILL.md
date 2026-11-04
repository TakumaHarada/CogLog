---
name: flutter-xcodegen-ios-google-sign-in
description: >-
  Flutter iOS XcodeGen 構成に Google Sign-In 用の GID_CLIENT_ID / REVERSED_CLIENT_ID（xcconfig）と
  Info.plist（GIDClientID・URL Scheme）を組み込む SKILL。「Google Sign-In を xcodegen に」
  「REVERSED_CLIENT_ID」「GIDClientID を xcconfig」では必ず使う。前提は flutter-xcodegen-ios。
  Firebase Auth 全体や Android 側、Firebase SPM 本体は flutter-xcodegen-ios-firebase に譲る。
---
# Flutter iOS / XcodeGen + Google Sign-In

Configuration ごとの OAuth クライアント値を xcconfig に置き、`project.yml` の Info.plist 生成で参照する。

## 必須入力

各 Configuration（または Flavor × BuildType）について:

* `GID_CLIENT_ID`（例: `123-abc.apps.googleusercontent.com`）
* `REVERSED_CLIENT_ID`（例: `com.googleusercontent.apps.123-abc`）

無ければ推測せずエラーで止める。

## 作業手順

1. 各 `Configurations/<Configuration>/flavor.xcconfig` に  
   [assets/flavor.xcconfig.google-sign-in-fragment.xcconfig](./assets/flavor.xcconfig.google-sign-in-fragment.xcconfig) のキーを追加し実値を埋める
2. `project.yml` の `targets.Runner.info.properties` に  
   [assets/project.yml.google-sign-in-fragment.yml](./assets/project.yml.google-sign-in-fragment.yml) どおり追加する  
   * `GIDClientID: $(GID_CLIENT_ID)`  
   * `CFBundleURLTypes` → `CFBundleURLSchemes: [$(REVERSED_CLIENT_ID)]`
3. `xcodegen` を再実行する

## 関連

* 土台: `flutter-xcodegen-ios`
* Firebase 併用時: `flutter-xcodegen-ios-firebase`（plist 配置は別問題）
