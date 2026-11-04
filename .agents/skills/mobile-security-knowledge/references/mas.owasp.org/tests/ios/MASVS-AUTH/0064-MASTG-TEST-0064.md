---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0064/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - auth
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0064
masvs_category: MASVS-AUTH
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0064: Testing Biometric Authentication

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Biometric Authentication」（iOS / 認証・認可）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: The usage of frameworks in an app can be detected by analyzing the app binary's list of shared dynamic libraries. This can be done by using MASTG-TOOL-0060:
* メタ: profiles: L2; covered_by: MASTG-TEST-0266, MASTG-TEST-0267, MASTG-TEST-0268, MASTG-TEST-0269, MASTG-TEST-0270, MASTG-TEST-0271; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0064/>
* 関連制御群: `MASVS-AUTH`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Biometric Authenticationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Biometric Authenticationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Biometric Authenticationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] It is important to remember that the LocalAuthentication framework is an event-based procedure and as such, should not be the sole method of authentication. Though this type of authentication is effective on ...
* [Static] Verify that sensitive processes, such as re-authenticating a user performing a payment transaction, are protected using the keychain services method.
* [Static] Verify that access control flags are set for the keychain item which ensure that the data of the keychain item can only be unlocked by means of authenticating the user. This can be done with one of the follow...
* [Static] kSecAccessControlBiometryCurrentSet (before iOS 11.3 kSecAccessControlTouchIDCurrentSet). This will make sure that a user needs to authenticate with biometrics (e.g. Face ID or Touch ID) before accessing the ...
* [Static] kSecAccessControlBiometryAny (before iOS 11.3 kSecAccessControlTouchIDAny). This will make sure that a user needs to authenticate with biometrics (e.g. Face ID or Touch ID) before accessing the data in the Ke...
* [Dynamic] Objection Biometrics Bypass can be used to bypass LocalAuthentication. Objection uses Frida to instrument the evaluatePolicy function so that it returns True even if authentication was not successfully perfo...
* [Dynamic] ...itudehacks.DVIAswiftv2.develop on (iPhone: 13.2.3) [usb] # ios ui biometrics_bypass
* [Dynamic] (agent) Registering job 3mhtws9x47q. Type: ios-biometrics-disable
```

## ナレッジベース

### DO: 認証・認可の最終判定をサーバ側で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 認証・認可の最終判定をサーバ側で確認する
- ローカル認証成功ブール alone で機微操作を通さない
- 後継: MASTG-TEST-0266, MASTG-TEST-0267, MASTG-TEST-0268, MASTG-TEST-0269, MASTG-TEST-0270, MASTG-TEST-0271
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: クライアント申告のロールを信頼する

* 理由: MASVS-AUTH の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- クライアント申告のロールを信頼する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0064 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0064/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
