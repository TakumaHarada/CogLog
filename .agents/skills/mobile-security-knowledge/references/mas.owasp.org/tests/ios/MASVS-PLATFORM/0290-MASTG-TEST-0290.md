---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0290/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0290
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0290: Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgrounding

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgrounding」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test verifies that the app hides sensitive content from the screen when it moves to the background. This is important because iOS captures a snapshot of the app UI when it transitions to the background. This snapshot is used for the App Switcher and transitions, and can expose sensitive content if the app does not protect it.
* メタ: type: dynamic, filesystem; profiles: L2; weakness: MASWE-0038; knowledge: MASTG-KNOW-0099
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0290/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgroundingのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgroundingのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Verification of Sensitive Content Exposure in Screenshots During App Backgroundingのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Exercise your app until you get to each of the screens identified as sensitive. While on each of those screens, move the app to the background (for example by pressing Home or opening the App Switcher and exiting it) ...
* Use MASTG-TECH-0053 to copy the snapshots taken by the system to your analysis workstation. The system stores them under /var/mobile/Containers/Data/Application//Library/SplashBoard/Snapshots/sceneID:-default/. Note t...
合否（Evaluation）の要点:
* The test case fails if any snapshot displays sensitive data that should have been protected.
* 観測期待: The output should include a collection of snapshots cached when the app entered the background state.
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
- MASTG-TEST-0290 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0290/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
