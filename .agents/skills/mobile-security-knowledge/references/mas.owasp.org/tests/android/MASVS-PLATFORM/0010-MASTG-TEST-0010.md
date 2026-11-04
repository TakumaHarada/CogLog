---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0010/
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
mastg_test_id: MASTG-TEST-0010
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0010: Finding Sensitive Information in Auto-Generated Screenshots

## 概要

* 本ドキュメントは OWASP MASTG Test「Finding Sensitive Information in Auto-Generated Screenshots」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: A screenshot of the current activity is taken when an Android app goes into background and displayed for aesthetic purposes when the app returns to the foreground. However, this may leak sensitive information.
* メタ: profiles: L2; covered_by: MASTG-TEST-0289, MASTG-TEST-0291; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0010/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Finding Sensitive Information in Auto-Generated Screenshotsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Finding Sensitive Information in Auto-Generated Screenshotsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Finding Sensitive Information in Auto-Generated Screenshotsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] A screenshot of the current activity is taken when an Android app goes into background and displayed for aesthetic purposes when the app returns to the foreground. However, this may leak sensitive information.
* [Static] To determine whether the application may expose sensitive information via the app switcher, find out whether the FLAG_SECURE option has been set. You should find something similar to the following code snippet:
* [Static] getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE,
* [Static] WindowManager.LayoutParams.FLAG_SECURE);
* [Static] setContentView(R.layout.activity_main);
* [Dynamic] While black-box testing the app, navigate to any screen that contains sensitive information and click the home button to send the app to the background, then press the app switcher button to see the snapshot...
* [Dynamic] On devices supporting file-based encryption (FBE), snapshots are stored in the /data/system_ce// folder. depends on the vendor but most common names are snapshots and recent_images. If the device doesn't sup...
* [Dynamic] > Accessing these folders and the snapshots requires root.
合否（Evaluation）の要点:
* To determine whether the application may expose sensitive information via the app switcher, find out whether the FLAG_SECURE option has been set. You should find something similar to the following code snippet:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0289, MASTG-TEST-0291
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
- MASTG-TEST-0010 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0010/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
