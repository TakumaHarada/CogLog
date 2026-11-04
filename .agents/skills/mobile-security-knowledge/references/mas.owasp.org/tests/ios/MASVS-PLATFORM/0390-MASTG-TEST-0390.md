---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0390/
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
mastg_test_id: MASTG-TEST-0390
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0390: Full Access Requested by a Custom Keyboard Extension

## 概要

* 本ドキュメントは OWASP MASTG Test「Full Access Requested by a Custom Keyboard Extension」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: A custom keyboard is an app extension that replaces the system keyboard across all apps on the device (see MASTG-KNOW-0141). By default it runs without "Full Access", which keeps it from making network requests or reaching shared containers. A keyboard requests "Full Access" with the RequestsOpenAccess key in its Info.plist, and once the user grants it the keyboard can check the hasFullAccess property and then send what the user types off the ...
* メタ: type: static, code, manual; profiles: L2; weakness: MASWE-0066; knowledge: MASTG-KNOW-0082, MASTG-KNOW-0141
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0390/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Full Access Requested by a Custom Keyboard Extensionのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Full Access Requested by a Custom Keyboard Extensionのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Full Access Requested by a Custom Keyboard Extensionのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the app package, including the keyboard extension in the PlugIns/.appex bundle.
* Inspect the keyboard extension's Info.plist for the RequestsOpenAccess key under NSExtension > NSExtensionAttributes.
* Use MASTG-TECH-0066 to look for the relevant APIs in the keyboard extension binary, in particular hasFullAccess and networking APIs such as URLSession.
合否（Evaluation）の要点:
* The test case fails if the keyboard extension requests Full Access (RequestsOpenAccess is true) and uses it to send typed data off the device or to write it to a shared container, without a feature that justifies the ...
* Further Validation Required:
* Inspect the keyboard extension implementation using MASTG-TECH-0076 to determine:
* Whether the keyboard transmits the characters it receives (for example, in insertText(_:) or textDidChange(_:) handlers) when hasFullAccess is true.
* Whether the data it transmits or stores is sensitive.
* Whether Full Access is required by a user-facing feature, or requested without a justifying use.
* 観測期待: The output should indicate:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0066 の有無をチケットへ併記する
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
- MASTG-TEST-0390 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0390/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
