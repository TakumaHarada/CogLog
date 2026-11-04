---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0090/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0090
masvs_category: MASVS-RESILIENCE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0090: Device Binding

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Device Binding」（iOS / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: The purpose of device binding is to impede an attacker who tries to copy an app and its state from device A to device B and continue the execution of the app on device B. After device A has been determined trusted, it may have more privileges than device B. This situation shouldn't change when an app is copied from device A to device B.
* 要旨: Since iOS 7.0, hardware identifiers (such as MAC addresses) are off-limits but there are other methods for implementing device binding in iOS:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0090/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Device Bindingの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Device Bindingの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Device Bindingの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* identifierForVendor: You can use [[UIDevice currentDevice] identifierForVendor] (in Objective-C), UIDevice.current.identifierForVendor?.uuidString (in Swift3), or UIDevice.currentDevice().identifie...
* Using the Keychain: You can store something in the Keychain to identify the application's instance. To make sure that this data is not backed up, use kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly...
* Using Google Instance ID: see the implementation for iOS here.
```

## ナレッジベース

### DO: 耐タンパは追加層としサーバ認可の代替にしない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 耐タンパは追加層としサーバ認可の代替にしない
- 脅威モデルで要否と深度を文書化する
- 検知結果はサーバ側判断と組み合わせる
- identifierForVendor: You can use [[UIDevice currentDevice] identifierForVendor] (in Objective-C), UIDevice.current.identifierForVendor?.uuidString (in Swift3), or UIDevice.currentDevice().identifierForVendor?.UUIDString (in Swift2). The value of identifierForVendor may not be the same if you reinstall the app after other apps from the same vendor are installed and it may change when you update your app bundle's name. Therefore it is best to combine it with something in the Keychain.
- Using the Keychain: You can store something in the Keychain to identify the application's instance. To make sure that this data is not backed up, use kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly (if you want to secure the data and properly enforce a passcode or Touch ID requirement), kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, or kSecAttrAccessibleWhenUnlockedThisDeviceOnly.
- Using Google Instance ID: see the implementation for iOS here.
```

### DO NOT: 難読化だけで平文保存や cleartext を許容する

* 理由: MASVS-RESILIENCE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 難読化だけで平文保存や cleartext を許容する
- クライアント検知成功 alone で権限を付与する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0090 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0090/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
