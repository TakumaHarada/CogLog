---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0356/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0356
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0356: Runtime Verification of Unauthorized Database Access through Content Providers

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Verification of Unauthorized Database Access through Content Providers」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If an app exports a content provider without requiring permissions, any app on the device can directly query its underlying database using ContentResolver or using the adb shell content command. Even when a permission is declared, a misconfigured protection level (for example, android:protectionLevel="normal") allows any requesting app to obtain it automatically, effectively bypassing the restriction. This test verifies at runtime whether the ...
* メタ: type: dynamic, filesystem, manual; profiles: L1, L2; weakness: MASWE-0018; knowledge: MASTG-KNOW-0020, MASTG-KNOW-0117
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0356/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Verification of Unauthorized Database Access through Content Providersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Verification of Unauthorized Database Access through Content Providersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Verification of Unauthorized Database Access through Content Providersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
* Use MASTG-TECH-0148 to query the app's exported content providers.
合否（Evaluation）の要点:
* The test case fails if sensitive data can be accessed through content providers.
* Further Validation Required:
* Inspect the content of each row returned by the query to determine whether the data is sensitive:
* Determine whether the records contain sensitive information (e.g., personal data, credentials, tokens, or health data).
* Determine whether the accessible data represents a security risk given the app's data classification.
* 観測期待: The output should contain the content of the database that is available through the content provider.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0018 の有無をチケットへ併記する
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
- MASTG-TEST-0356 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0356/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
