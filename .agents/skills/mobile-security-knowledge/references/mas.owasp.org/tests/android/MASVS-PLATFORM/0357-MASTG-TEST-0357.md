---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0357/
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
mastg_test_id: MASTG-TEST-0357
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0357: References to Oversharing of File-Based Content Providers

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Oversharing of File-Based Content Providers」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If the app exports an Android content provider without enforcing access restrictions, external callers may open private files through content:// URIs. This test checks whether exported providers expose sensitive stored data to callers that don't hold the required permissions.
* メタ: type: static, config, code, manual; profiles: L1, L2; weakness: MASWE-0018; knowledge: MASTG-KNOW-0020, MASTG-KNOW-0117
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0357/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Oversharing of File-Based Content Providersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Oversharing of File-Based Content Providersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Oversharing of File-Based Content Providersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0159 to identify exported file-based content providers and inspect their path configurations.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if the app exports a FileProvider and if the provider's path configuration allows access outside the intended shared directory (for example, via , path="/", path=".", or path="").
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0023 to determine whether the exposure is security-relevant:
* Determine whether FileProvider.getUriForFile() is called with attacker-controlled input (for example, values derived from URI query parameters or user input).
* Determine whether the provider enforces appropriate access control, by using in the Android Manifest android:permission and an adequate protection level like dangerous or signature.
* 観測期待: The output should contain a list of exported file-based content providers with their path configurations, and a list of code locations where provider-backed file access occurs.
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
- MASTG-TEST-0357 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0357/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
