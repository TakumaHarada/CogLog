---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0392/
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
mastg_test_id: MASTG-TEST-0392
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0392: References to Enforced Updating APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Enforced Updating APIs」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Android apps may fail to enforce updates when critical security patches or minimum version requirements are needed. For Google Play-distributed apps, enforced updating can be implemented using the Google Play In-App Updates API (for example, AppUpdateManagerFactory.create, AppUpdateManager#getAppUpdateInfo, UpdateAvailability.UPDATE_AVAILABLE, UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS, AppUpdateType.IMMEDIATE, AppUpdateOptions,...
* メタ: type: static, code, manual; profiles: L2; weakness: MASWE-0043; knowledge: MASTG-KNOW-0023
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0392/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Enforced Updating APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Enforced Updating APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Enforced Updating APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if no code locations show an update enforcement mechanism.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0023 to determine whether the update enforcement is correct:
* Determine whether the update check executes before access to protected functionality or backend services and cannot be bypassed (for example, by checking the call graph or entry point context).
* Determine whether an immediate update flow (for example, AppUpdateType.IMMEDIATE via startUpdateFlowForResult) or a non-dismissible blocking screen (for example, a full-screen Activity or dialog that disables navigati...
* For Google Play In-App Updates, determine whether the app handles cancellation or denial of the update flow, checks update state when returning to the foreground, and restarts the immediate update flow when UpdateAvai...
* 観測期待: The output should contain a list of code locations where the app retrieves its version (for example, BuildConfig.VERSION_NAME, BuildConfig.VERSION_CODE, or PackageManager.getPackageInfo) or interacts with update enforcem
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
- MASTG-TEST-0392 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0392/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
