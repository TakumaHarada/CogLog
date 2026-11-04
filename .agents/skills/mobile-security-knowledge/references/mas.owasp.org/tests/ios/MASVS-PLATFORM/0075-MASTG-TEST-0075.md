---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0075/
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
mastg_test_id: MASTG-TEST-0075
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0075: Testing Custom URL Schemes

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Custom URL Schemes」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: There are a couple of things that we can do using static analysis. In the next sections we will see the following:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0370, MASTG-TEST-0371; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0075/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Custom URL Schemesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Custom URL Schemesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Custom URL Schemesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] There are a couple of things that we can do using static analysis. In the next sections we will see the following:
* [Static] Testing custom URL schemes registration
* [Static] Testing application query schemes registration
* [Static] Testing URL handling and validation
* [Static] Testing URL requests to other apps
* [Dynamic] Once you've identified the custom URL schemes the app has registered, there are several methods that you can use to test them:
* [Dynamic] Performing URL requests
* [Dynamic] Identifying and hooking the URL handler method
合否（Evaluation）の要点:
* In a compiled application (or IPA), registered protocol handlers are found in the file Info.plist in the app bundle's root folder. Open it and search for the CFBundleURLSchemes key, if present, it should contain an ar...
* Before calling the openURL:options:completionHandler: method, apps can call canOpenURL: to verify that the target app is available. However, as this method was being used by malicious app as a way to enumerate install...
* application:openURL:options:: verify how the resource is being opened, i.e. how the data is being parsed, verify the options, especially if access by the calling app (sourceApplication) should be allowed or denied. Th...
* The method openURL:options:completionHandler: and the deprecated openURL: method of UIApplication are responsible for opening URLs (i.e. to send requests / make queries to other apps) that may be local to the current ...
* Check if LSApplicationQueriesSchemes was declared or search for common URL schemes.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0370, MASTG-TEST-0371
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
- MASTG-TEST-0075 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0075/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
