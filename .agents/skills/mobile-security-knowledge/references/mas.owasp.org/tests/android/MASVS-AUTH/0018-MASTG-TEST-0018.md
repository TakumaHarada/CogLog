---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0018/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - auth
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0018
masvs_category: MASVS-AUTH
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0018: Testing Biometric Authentication

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Biometric Authentication」（Android / 認証・認可）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Note that there are quite some vendor/third party SDKs, which provide biometric support, but which have their own insecurities. Be very cautious when using third party SDKs to handle sensitive authentication logic.
* メタ: profiles: L2; covered_by: MASTG-TEST-0326, MASTG-TEST-0327, MASTG-TEST-0328, MASTG-TEST-0329, MASTG-TEST-0330; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0018/>
* 関連制御群: `MASVS-AUTH`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Biometric Authenticationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Biometric Authenticationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Biometric Authenticationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Note that there are quite some vendor/third party SDKs, which provide biometric support, but which have their own insecurities. Be very cautious when using third party SDKs to handle sensitive authentication ...
* [Dynamic] Please take a look at this detailed blog article about the Android KeyStore and Biometric authentication. This research includes two Frida scripts which can be used to test insecure implementations of biomet...
* [Dynamic] Fingerprint bypass: This Frida script will bypass authentication when the CryptoObject is not used in the authenticate method of the BiometricPrompt class. The authentication implementation relies on the cal...
* [Dynamic] Fingerprint bypass via exception handling: This Frida script will attempt to bypass authentication when the CryptoObject is used, but used in an incorrect way. The detailed explanation can be found in the se...
```

## ナレッジベース

### DO: 認証・認可の最終判定をサーバ側で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 認証・認可の最終判定をサーバ側で確認する
- ローカル認証成功ブール alone で機微操作を通さない
- 後継: MASTG-TEST-0326, MASTG-TEST-0327, MASTG-TEST-0328, MASTG-TEST-0329, MASTG-TEST-0330
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
- MASTG-TEST-0018 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0018/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
