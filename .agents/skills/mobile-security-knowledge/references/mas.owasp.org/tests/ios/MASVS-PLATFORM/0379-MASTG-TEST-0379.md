---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0379/
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
mastg_test_id: MASTG-TEST-0379
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0379: References to `evaluateJavaScript` Without Content World Isolation

## 概要

* 本ドキュメントは OWASP MASTG Test「References to `evaluateJavaScript` Without Content World Isolation」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: When an app uses evaluateJavaScript(_:completionHandler:)) to read data from the DOM (for example, to extract form field values, account details, or page structure), the script executes in the .page world. In this world, the JavaScript prototype chain is shared with page scripts. A malicious or compromised page can override built-in functions such as document.querySelector or Element.prototype.getAttribute before the inspection code runs, caus...
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0034; knowledge: MASTG-KNOW-0076, MASTG-KNOW-0139
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0379/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to `evaluateJavaScript` Without Content World Isolationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to `evaluateJavaScript` Without Content World Isolationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to `evaluateJavaScript` Without Content World Isolationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if evaluateJavaScript:completionHandler: is used to read DOM content in a security-relevant context.
* Further Validation Required:
* Inspect each reported call site using MASTG-TECH-0076 to confirm whether the evaluated JavaScript string reads data from the DOM (for example via document.querySelector, document.getElementById, getAttribute, .value, ...
* Also confirm that the call uses the legacy evaluateJavaScript:completionHandler: selector rather than the content-world-aware evaluateJavaScript:inFrame:inContentWorld:completionHandler: variant. Only the legacy selec...
* 観測期待: The output should contain a list of locations where evaluateJavaScript:completionHandler: is called, along with the enclosing function symbols.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0034 の有無をチケットへ併記する
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
- MASTG-TEST-0379 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0379/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
