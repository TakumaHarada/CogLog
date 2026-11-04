---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0056/
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
mastg_test_id: MASTG-TEST-0056
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0056: Determining Whether Sensitive Data Is Exposed via IPC Mechanisms

## 概要

* 本ドキュメントは OWASP MASTG Test「Determining Whether Sensitive Data Is Exposed via IPC Mechanisms」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: The following section summarizes keywords that you should look for to identify IPC implementations within iOS source code.
* メタ: profiles: L1, L2; deprecation_note: The content from this test was insufficient to port it properly. See @MASTG-KNOW-0104 and related knowledge for more details on IPC mechanisms. New tests will be added in the future to cover specific IPC mechanisms and their security implications.
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0056/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Determining Whether Sensitive Data Is Exposed via IPC Mechanismsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Determining Whether Sensitive Data Is Exposed via IPC Mechanismsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Determining Whether Sensitive Data Is Exposed via IPC Mechanismsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] The following section summarizes keywords that you should look for to identify IPC implementations within iOS source code.
* [Static] Several classes may be used to implement the NSXPCConnection API:
* [Static] NSXPCConnection
* [Static] NSXPCInterface
* [Static] NSXPCListener
* [Dynamic] Verify IPC mechanisms with static analysis of the iOS source code. No iOS tool is currently available to verify IPC usage.
合否（Evaluation）の要点:
* The following section summarizes keywords that you should look for to identify IPC implementations within iOS source code.
* You can set security attributes for the connection. The attributes should be verified.
* Check for the following two files in the Xcode project for the XPC Services API (which is C-based):
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
- MASTG-TEST-0056 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0056/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
