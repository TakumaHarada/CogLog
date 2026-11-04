---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0360/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - privacy
  - profile-p
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0360
masvs_category: MASVS-PRIVACY
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0360: Purpose String Accuracy for Reachable Protected Resource Access

## 概要

* 本ドキュメントは OWASP MASTG Test「Purpose String Accuracy for Reachable Protected Resource Access」（iOS / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Purpose strings are user-facing explanations that iOS displays when an app requests access to protected resources such as location, camera, microphone, contacts, photos, health data, Bluetooth, motion, or speech recognition. Unlike entitlements, purpose strings are tied to privacy-sensitive protected resources and runtime authorization prompts.
* メタ: type: static, config, manual; profiles: P; weakness: MASWE-0066; knowledge: MASTG-KNOW-0077
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0360/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Purpose String Accuracy for Reachable Protected Resource Accessのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Purpose String Accuracy for Reachable Protected Resource Accessのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Purpose String Accuracy for Reachable Protected Resource Accessのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to unzip the app package.
* Use MASTG-TECH-0153 to retrieve the Info.plist file.
* Use MASTG-TECH-0138 to convert the Info.plist file to a readable format if needed.
* Use MASTG-TECH-0154 to inspect all UsageDescription keys.
* Use MASTG-TECH-0058 to extract the relevant binaries from the app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if there is evidence that the app has a reachable code path that requests or accesses a protected resource and the purpose string does not meaningfully, accurately, and specifically explain why the...
* The test case also fails if a reachable code path requests or accesses a protected resource without a matching required purpose string.
* Further Validation Required:
* Use the declared purpose strings, referenced APIs, app metadata and App Store information, visible app features, and runtime behavior to determine whether each protected resource access path is justified and accuratel...
* Consider the following when evaluating:
* Is the protected resource access reachable during normal or reasonably expected app use, and is it connected to a real user-visible feature?
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: 権限・収集・申告の一致を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 権限・収集・申告の一致を確認する
- 関連弱点 MASWE-0066 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ストア文言だけで privacy pass にする

* 理由: MASVS-PRIVACY の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ストア文言だけで privacy pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0360 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PRIVACY/MASTG-TEST-0360/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
