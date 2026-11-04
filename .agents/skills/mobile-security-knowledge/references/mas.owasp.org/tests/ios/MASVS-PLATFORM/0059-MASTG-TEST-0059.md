---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0059/
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
mastg_test_id: MASTG-TEST-0059
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0059: Testing Auto-Generated Screenshots for Sensitive Information

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Auto-Generated Screenshots for Sensitive Information」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: If you have the source code, search for the applicationDidEnterBackground method to determine whether the application sanitizes the screen before being backgrounded.
* メタ: profiles: L2; covered_by: MASTG-TEST-0290; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0059/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Auto-Generated Screenshots for Sensitive Informationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Auto-Generated Screenshots for Sensitive Informationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Auto-Generated Screenshots for Sensitive Informationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] If you have the source code, search for the applicationDidEnterBackground method to determine whether the application sanitizes the screen before being backgrounded.
* [Static] The following is a sample implementation using a default background image (overlayImage.png) whenever the application is backgrounded, overriding the current view:
* [Static] private var backgroundImage: UIImageView?
* [Static] func applicationDidEnterBackground(_ application: UIApplication) {
* [Static] let myBanner = UIImageView(image: #imageLiteral(resourceName: "overlayImage"))
* [Dynamic] You can use a _visual approach_ to quickly validate this test case using any iOS device (jailbroken or not):
* [Dynamic] Navigate to an application screen that displays sensitive information, such as a username, an email address, or account details.
* [Dynamic] Background the application by hitting the Home button on your iOS device.
合否（Evaluation）の要点:
* The screenshots inside that folder should not contain any sensitive information.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0290
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
- MASTG-TEST-0059 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0059/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
