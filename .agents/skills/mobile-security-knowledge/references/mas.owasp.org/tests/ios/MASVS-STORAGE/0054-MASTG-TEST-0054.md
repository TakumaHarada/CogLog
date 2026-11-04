---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0054/
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
mastg_test_id: MASTG-TEST-0054
masvs_category: MASVS-STORAGE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0054: Determining Whether Sensitive Data Is Shared with Third Parties

## 概要

* 本ドキュメントは OWASP MASTG Test「Determining Whether Sensitive Data Is Shared with Third Parties」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Sensitive information might be leaked to third parties by several means. On iOS typically via third-party services embedded in the app.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0206, MASTG-TEST-0281; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0054/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Determining Whether Sensitive Data Is Shared with Third Partiesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Determining Whether Sensitive Data Is Shared with Third Partiesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Determining Whether Sensitive Data Is Shared with Third Partiesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] To determine whether API calls and functions provided by the third-party library are used according to best practices, review their source code, requested permissions and check for any known vulnerabilities.
* [Static] All data that's sent to third-party services should be anonymized to prevent exposure of PII (Personal Identifiable Information) that would allow the third party to identify the user account. No other data (s...
* [Dynamic] Check all requests to external services for embedded sensitive information.
* [Dynamic] To intercept traffic between the client and server, you can perform dynamic analysis by launching a Machine-in-the-Middle (MITM) attack (MASTG-TECH-0062), for example using MASTG-TOOL-0077 or MASTG-TOOL-0079...
合否（Evaluation）の要点:
* The downside is that developers don't usually know the details of the code executed via third-party libraries. Consequently, no more information than is necessary should be sent to a service, and no sensitive informat...
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0206, MASTG-TEST-0281
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
- MASTG-TEST-0054 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0054/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
