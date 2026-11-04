---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0270/
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
mastg_test_id: MASTG-TEST-0270
masvs_category: MASVS-AUTH
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0270: References to APIs Detecting Biometric Enrollment Changes

## 概要

* 本ドキュメントは OWASP MASTG Test「References to APIs Detecting Biometric Enrollment Changes」（iOS / 認証・認可）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks whether the app fails to protect sensitive operations against unauthorized access following biometric enrollment changes. An attacker who obtains the device passcode could add a new fingerprint or facial representation via system settings and use it to authenticate in the app.
* メタ: type: static, code; profiles: L2; weakness: MASWE-0022; knowledge: MASTG-KNOW-0056
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0270/>
* 関連制御群: `MASVS-AUTH`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to APIs Detecting Biometric Enrollment Changesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to APIs Detecting Biometric Enrollment Changesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to APIs Detecting Biometric Enrollment Changesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if the app uses SecAccessControlCreateWithFlags with any flag except the kSecAccessControlBiometryCurrentSet flag for any sensitive data resource worth protecting.
* 観測期待: The output should contain a list of locations where relevant APIs are used.
```

## ナレッジベース

### DO: 認証・認可の最終判定をサーバ側で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 認証・認可の最終判定をサーバ側で確認する
- ローカル認証成功ブール alone で機微操作を通さない
- 関連弱点 MASWE-0022 の有無をチケットへ併記する
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
- MASTG-TEST-0270 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0270/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
