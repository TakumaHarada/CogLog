---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0071/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0071
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0071: Testing UIActivity Sharing

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing UIActivity Sharing」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: When testing UIActivity Sharing you should pay special attention to:
* メタ: profiles: L1, L2; deprecation_note: "This test has no MASTG v2 successor by design. Whether to share a given item through the Share Sheet is a user-consent decision, and the `excludedActivityTypes` property is not a security control because it cannot restrict the third-party share extensions that are the dominant sharing channel on modern iOS. See @MASTG-KNOW-0081 for background. The static and dynamic analysis techniques from this test have been preserved as @MASTG-TECH-0167 and @MASTG-TECH-0168."
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0071/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing UIActivity Sharingのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing UIActivity Sharingのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing UIActivity Sharingのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] When testing UIActivity Sharing you should pay special attention to:
* [Static] the data (items) being shared,
* [Static] the custom activities,
* [Static] the excluded activity types.
* [Static] Data sharing via UIActivity works by creating a UIActivityViewController and passing it the desired items (URLs, text, a picture) on init(activityItems: applicationActivities:)").
* [Dynamic] There are three main things you can easily inspect by performing dynamic instrumentation:
* [Dynamic] The activityItems: an array of the items being shared. They might be of different types, e.g. one string and one picture to be shared via a messaging app.
* [Dynamic] The applicationActivities: an array of UIActivity objects representing the app's custom services.
合否（Evaluation）の要点:
* When testing UIActivity Sharing you should pay special attention to:
* If having the source code, you should take a look at the UIActivityViewController:
* Check if it defines custom activities (also being passed to the previous method).
* When receiving items, you should check:
* As you can see, the sending application is com.apple.sharingd and the URL's scheme is file://. Note that once we select the app that should open the file, the system already moved the file to the corresponding destina...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする

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
- MASTG-TEST-0071 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0071/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
