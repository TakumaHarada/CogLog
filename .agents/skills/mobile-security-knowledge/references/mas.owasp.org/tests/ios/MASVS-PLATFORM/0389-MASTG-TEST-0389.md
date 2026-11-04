---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0389/
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
mastg_test_id: MASTG-TEST-0389
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0389: References to the App-Wide Restriction of Custom Keyboards

## 概要

* 本ドキュメントは OWASP MASTG Test「References to the App-Wide Restriction of Custom Keyboards」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: iOS lets users install custom keyboards, which are app extensions that replace the system keyboard across all apps (see MASTG-KNOW-0141). Once granted "Full Access", a custom keyboard can transmit what the user types off the device. An app that collects sensitive input, such as a banking PIN or a one-time passcode, keeps using whichever keyboard the user has selected unless it opts out.
* メタ: type: static, code, manual; profiles: L2; weakness: MASWE-0031; knowledge: MASTG-KNOW-0082, MASTG-KNOW-0141
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0389/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to the App-Wide Restriction of Custom Keyboardsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to the App-Wide Restriction of Custom Keyboardsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to the App-Wide Restriction of Custom Keyboardsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from the app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if the app handles sensitive data entered through the keyboard and does not reject the custom keyboard extension point app-wide, that is, it does not implement application:shouldAllowExtensionPoint...
* Further Validation Required:
* Inspect the app delegate implementation using MASTG-TECH-0076 to determine the value returned for the keyboard extension point (UIApplicationKeyboardExtensionPointIdentifier) and whether the app handles sensitive data...
* An app may instead keep individual sensitive fields on the system keyboard with isSecureTextEntry rather than restricting custom keyboards app-wide; that field-level control is covered by MASTG-TEST-0346 and MASTG-TES...
* 観測期待: The output should contain whether the app implements application:shouldAllowExtensionPointIdentifier: in its app delegate and the value it returns for the keyboard extension point (UIApplicationKeyboardExtensionPointIden
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0031 の有無をチケットへ併記する
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
- MASTG-TEST-0389 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0389/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
