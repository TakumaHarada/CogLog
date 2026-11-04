---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0319/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - privacy
  - profile-p
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0319
masvs_category: MASVS-PRIVACY
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0319: Runtime Use of SDK APIs Known to Handle Sensitive User Data

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of SDK APIs Known to Handle Sensitive User Data」（Android / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test is the dynamic counterpart to MASTG-TEST-0318.
* メタ: type: dynamic, hooks; profiles: P; weakness: MASWE-0073
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0319/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of SDK APIs Known to Handle Sensitive User Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of SDK APIs Known to Handle Sensitive User Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of SDK APIs Known to Handle Sensitive User Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0043 to hook the relevant API calls.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if you can find sensitive user data being passed to these SDK methods in the app code, indicating that the app is sharing sensitive user data with the third-party SDK.
* 観測期待: The output should list the locations where SDK methods are called, their stacktrace (call hierarchy leading to the call), and the arguments (values) passed to the SDK method at runtime.
```

## ナレッジベース

### DO: 権限・収集・申告の一致を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 権限・収集・申告の一致を確認する
- 関連弱点 MASWE-0073 の有無をチケットへ併記する
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
- MASTG-TEST-0319 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0319/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
