---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0052/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0052
masvs_category: MASVS-STORAGE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0052: Testing Local Data Storage

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Local Data Storage」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: This test case focuses on identifying potentially sensitive data stored by an application and verifying if it is securely stored. The following checks should be performed:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0299, MASTG-TEST-0300, MASTG-TEST-0301, MASTG-TEST-0302, MASTG-TEST-0303; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0052/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Local Data Storageのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Local Data Storageのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Local Data Storageのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] When you have access to the source code of an iOS app, identify sensitive data that's saved and processed throughout the app. This includes passwords, secret keys, and personally identifiable information (PII...
* [Static] Make sure that sensitive data is never stored without appropriate protection. For example, authentication tokens should not be saved in NSUserDefaults without additional encryption. Also avoid storing encrypt...
* [Static] Sensitive data should be stored by using the Keychain API (that stores them inside the Secure Enclave), or stored encrypted using envelope encryption. Envelope encryption, or key wrapping, is a cryptographic ...
* [Static] The encryption must be implemented so that the secret key is stored in the Keychain with secure settings, ideally kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly. This ensures the usage of hardware-backed sto...
* [Static] Generic examples of using the KeyChain to store, update, and delete data can be found in the official Apple documentation. The official Apple documentation also includes an example of using Touch ID and passc...
* [Dynamic] One way to determine whether sensitive information (like credentials and keys) is stored insecurely without leveraging native iOS functions is to analyze the app's data directory. Triggering all app function...
* [Dynamic] The following steps can be used to determine how the application stores data locally on a jailbroken iOS device:
* [Dynamic] Trigger the functionality that stores potentially sensitive data.
合否（Evaluation）の要点:
* This test case focuses on identifying potentially sensitive data stored by an application and verifying if it is securely stored. The following checks should be performed:
* Be sure to trigger all possible functionality in the application (e.g. by clicking everywhere possible) in order to ensure data generation.
* Check all application generated and modified files and ensure that the storage method is sufficiently secure.
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0299, MASTG-TEST-0300, MASTG-TEST-0301, MASTG-TEST-0302, MASTG-TEST-0303
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 内部ストレージだから安全と一律 pass にする

* 理由: MASVS-STORAGE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 内部ストレージだから安全と一律 pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0052 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0052/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
