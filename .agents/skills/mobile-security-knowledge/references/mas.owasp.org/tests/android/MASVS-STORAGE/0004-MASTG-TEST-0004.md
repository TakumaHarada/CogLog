---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0004/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0004
masvs_category: MASVS-STORAGE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0004: Determining Whether Sensitive Data Is Shared with Third Parties via Embedded Services

## 概要

* 本ドキュメントは OWASP MASTG Test「Determining Whether Sensitive Data Is Shared with Third Parties via Embedded Services」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To determine whether API calls and functions provided by the third-party library are used according to best practices, review their source code, requested permissions, and check for any known vulnerabilities.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0318, MASTG-TEST-0319; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0004/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Determining Whether Sensitive Data Is Shared with Third Parties via Embedded Servicesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Determining Whether Sensitive Data Is Shared with Third Parties via Embedded Servicesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Determining Whether Sensitive Data Is Shared with Third Parties via Embedded Servicesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] To determine whether API calls and functions provided by the third-party library are used according to best practices, review their source code, requested permissions, and check for any known vulnerabilities.
* [Static] All data that's sent to third-party services should be anonymized to prevent exposure of PII (Personal Identifiable Information) that would allow the third party to identify the user account. No other data (s...
* [Dynamic] Check all requests to external services for embedded sensitive information.
* [Dynamic] To intercept traffic between the client and server, you can perform dynamic analysis by launching a Machine-in-the-Middle (MITM) attack with MASTG-TOOL-0077 or MASTG-TOOL-0079. Once you route the traffic thr...
合否（Evaluation）の要点:
* To determine whether API calls and functions provided by the third-party library are used according to best practices, review their source code, requested permissions, and check for any known vulnerabilities.
* All data that's sent to third-party services should be anonymized to prevent exposure of PII (Personal Identifiable Information) that would allow the third party to identify the user account. No other data (such as ID...
* Check all requests to external services for embedded sensitive information.
* To intercept traffic between the client and server, you can perform dynamic analysis by launching a Machine-in-the-Middle (MITM) attack with MASTG-TOOL-0077 or MASTG-TOOL-0079. Once you route the traffic through the i...
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0318, MASTG-TEST-0319
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
- MASTG-TEST-0004 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0004/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
