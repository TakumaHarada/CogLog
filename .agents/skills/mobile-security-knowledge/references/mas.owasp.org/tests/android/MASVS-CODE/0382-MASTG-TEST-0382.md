---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0382/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0382
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0382: Runtime Use of Enforced Updating APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Enforced Updating APIs」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: At runtime, Android apps implementing enforced updating typically either invoke the Google Play In-App Updates API (for example, AppUpdateManager) or perform a custom version check, for example by retrieving BuildConfig.VERSION_NAME, BuildConfig.VERSION_CODE, or PackageManager.getPackageInfo values and sending them to a backend that returns a minimum version policy. If the app does not perform this check before access to protected functionalit...
* メタ: type: dynamic, network, hooks, manual; profiles: L2; weakness: MASWE-0043; knowledge: MASTG-KNOW-0023
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0382/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Enforced Updating APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Enforced Updating APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Enforced Updating APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0010 to capture the app traffic.
* Use MASTG-TECH-0043 to hook the relevant API calls.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if the app does not perform a runtime update check, or if the update is not enforced at runtime.
* Further Validation Required:
* Using the backtraces from the hook output, inspect the code locations using MASTG-TECH-0023:
* Determine whether the update check executes before access to protected functionality or backend services and cannot be bypassed.
* For Google Play In-App Updates, determine whether the app handles cancellation or denial of an immediate update flow, checks update state when returning to the foreground, and restarts the immediate update flow when U...
* For mandatory updates, determine whether the app continues blocking access after the update flow is cancelled, interrupted, backgrounded, or left incomplete.
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0043 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ビルド設定を見ずにコードレビューだけで完了する

* 理由: MASVS-CODE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ビルド設定を見ずにコードレビューだけで完了する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0382 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0382/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
