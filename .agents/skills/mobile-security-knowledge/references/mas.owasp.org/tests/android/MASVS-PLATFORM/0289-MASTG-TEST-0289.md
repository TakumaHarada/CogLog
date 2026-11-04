---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0289/
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
mastg_test_id: MASTG-TEST-0289
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0289: Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgrounding

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgrounding」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test verifies that the app hides sensitive content from the screen when it moves to the background. This is important because Android captures a task screenshot of the app UI when it moves to the background. This screenshot is used for the Recents screen and transitions, and can expose sensitive content if the app does not protect it.
* メタ: type: dynamic, filesystem, manual; profiles: L2; weakness: MASWE-0038; knowledge: MASTG-KNOW-0053
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0289/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgroundingのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgroundingのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgroundingのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Exercise your app until you get to each of the screens identified as sensitive. While on each of those screens, move the app to the background (for example by pressing Home or opening the Recents screen and exiting it...
* Use MASTG-TECH-0002 to copy the screenshots taken by the system to your laptop for further analysis. The system stores the screenshots in their containers /data/system_ce/0/snapshots or /data/system.
合否（Evaluation）の要点:
* The test case fails if any screenshot displays sensitive data that should have been protected.
* Further Validation Required:
* Inspect each screenshot visually, looking for sensitive information such as passwords, tokens, personally identifiable information, or other sensitive content that should not be exposed when the app is in the background.
* 観測期待: The output should include a collection of screenshots cached when the app entered the background state.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0038 の有無をチケットへ併記する
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
- MASTG-TEST-0289 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0289/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
