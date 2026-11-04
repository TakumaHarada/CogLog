---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0077/
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
mastg_test_id: MASTG-TEST-0077
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0077: Testing WebView Protocol Handlers

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing WebView Protocol Handlers」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: - Testing How WebViews Load Content - Testing WebView file access - Checking telephone number detection
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0335, MASTG-TEST-0336; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0077/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing WebView Protocol Handlersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing WebView Protocol Handlersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing WebView Protocol Handlersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Testing How WebViews Load Content
* [Static] Testing WebView file access
* [Static] Checking telephone number detection
* [Static] If a WebView is loading content from the app data directory, users should not be able to change the filename or path from which the file is loaded, and they shouldn't be able to edit the loaded file.
* [Static] This presents an issue especially in UIWebViews loading untrusted content via the deprecated methods loadHTMLString:baseURL: or loadData:MIMEType:textEncodingName:baseURL: and setting the baseURL parameter to...
* [Dynamic] If it's possible to load local files via a WebView, the app might be vulnerable to directory traversal attacks. This would allow access to all files within the sandbox or even to escape the sandbox with full...
* [Dynamic] To simulate an attack, you may inject your own JavaScript into the WebView with an interception proxy or simply by using dynamic instrumentation. Attempt to access local storage and any native methods and pr...
* [Dynamic] In a real-world scenario, JavaScript can only be injected through a permanent backend Cross-Site Scripting vulnerability or a MITM attack. See the OWASP XSS Prevention Cheat Sheet Prevention Cheat Sheet") an...
合否（Evaluation）の要点:
* Checking telephone number detection
* If a WebView is loading content from the app data directory, users should not be able to change the filename or path from which the file is loaded, and they shouldn't be able to edit the loaded file.
* Here's an example of a vulnerable UIWebView from "Where's My Browser?":
* Example in Swift from "Where's My Browser?":
* In a case like this, it is recommended to perform dynamic analysis to ensure that this is in fact being used and from which kind of WebView. The baseURL parameter here doesn't present an issue as it will be set to "nu...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0335, MASTG-TEST-0336
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
- MASTG-TEST-0077 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0077/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
