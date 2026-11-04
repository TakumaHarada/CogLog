---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0394/
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
mastg_test_id: MASTG-TEST-0394
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0394: Missing Input Validation in Custom URL Scheme Handlers

## 概要

* 本ドキュメントは OWASP MASTG Test「Missing Input Validation in Custom URL Scheme Handlers」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Apps register custom URL schemes by declaring an in the AndroidManifest.xml with an , the android.intent.category.BROWSABLE category, and a element whose android:scheme is a custom (non-http/https) value. The handling activity then reads the incoming URI — typically via getIntent() and Intent.getData() (or onNewIntent()) — and extracts parameters with methods such as Uri.getQueryParameter(), Uri.getPathSegments(), or Uri.getLastPathSegment().
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0029; knowledge: MASTG-KNOW-0019
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0394/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Missing Input Validation in Custom URL Scheme Handlersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Missing Input Validation in Custom URL Scheme Handlersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Missing Input Validation in Custom URL Scheme Handlersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if a custom URL scheme handler uses URL parameter values without performing adequate validation before acting on them.
* To complement this static analysis, you can use MASTG-TECH-0173 to observe at runtime which handler method receives the deep link and which parameters it reads.
* Further Validation Required:
* Inspect each reported handler using MASTG-TECH-0023, looking for cases such as:
* Missing type conversion: a numeric parameter is used as a raw string without converting it (e.g., not calling toLong() or toInt()).
* Missing bounds or range checks: the value is used without verifying it falls within an expected range.
* 観測期待: The output should contain the custom URL scheme declarations in the manifest and the handler code locations where the incoming URI is read and its parameters are extracted.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0029 の有無をチケットへ併記する
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
- MASTG-TEST-0394 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0394/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
