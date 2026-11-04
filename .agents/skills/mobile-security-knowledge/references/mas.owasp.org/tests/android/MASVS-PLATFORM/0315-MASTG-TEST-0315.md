---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0315/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0315
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0315: Sensitive Data Exposed via Notifications

## 概要

* 本ドキュメントは OWASP MASTG Test「Sensitive Data Exposed via Notifications」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test verifies that the app correctly handles notifications, ensuring that sensitive information, such as personally identifiable information (PII), one-time passwords (OTPs), or other sensitive data, like health or financial details, is not exposed.
* メタ: type: static, code; profiles: L2; weakness: MASWE-0037; knowledge: MASTG-KNOW-0054
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0315/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Sensitive Data Exposed via Notificationsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Sensitive Data Exposed via Notificationsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Sensitive Data Exposed via Notificationsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0150 to obtain the minSdkVersion from the AndroidManifest.xml file.
* Use MASTG-TECH-0126 to obtain the relevant permissions.
合否（Evaluation）の要点:
* The test case fails if the app exposes any sensitive data in any notifications and either:
* minSdkVersion is 33 or higher and the POST_NOTIFICATIONS permission is declared in the manifest file, or
* minSdkVersion is 32 or lower, regardless of whether the POST_NOTIFICATIONS permission is declared.
* Why minSdkVersion and not targetSdkVersion?: Using minSdkVersion ensures the test accounts for the least secure environment in which the app can operate, which is what determines the real exposure risk.
* targetSdkVersion only influences how the app behaves on newer Android versions and how the system enforces newer platform restrictions. It does not change the behavior of older Android versions. As a result, an app wi...
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0037 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 未使用入口をテスト対象外のまま放置する

* 理由: MASVS-PLATFORM の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 未使用入口をテスト対象外のまま放置する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0315 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0315/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
