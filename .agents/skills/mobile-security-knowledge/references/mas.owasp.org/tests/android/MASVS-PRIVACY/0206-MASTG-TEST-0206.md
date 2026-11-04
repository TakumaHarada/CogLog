---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0206/
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
mastg_test_id: MASTG-TEST-0206
masvs_category: MASVS-PRIVACY
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0206: Undeclared PII in Network Traffic Capture

## 概要

* 本ドキュメントは OWASP MASTG Test「Undeclared PII in Network Traffic Capture」（Android / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Attackers may capture network traffic from Android devices using an intercepting proxy, such as MASTG-TOOL-0079, MASTG-TOOL-0077, or MASTG-TOOL-0097, to analyze the data being transmitted by the app. This works even if the app uses HTTPS, as the attacker can install a custom root certificate on the Android device to decrypt the traffic. Inspecting traffic that is not encrypted with HTTPS is even easier and can be done without installing a cust...
* メタ: type: dynamic, network; profiles: P; weakness: MASWE-0073
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0206/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Undeclared PII in Network Traffic Captureのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Undeclared PII in Network Traffic Captureのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Undeclared PII in Network Traffic Captureのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0100 to capture and log the app's network traffic.
* Launch and use the app going through the various workflows while inputting sensitive data wherever you can. Especially, places where you know that will trigger network traffic.
合否（Evaluation）の要点:
* The test case fails if you can find the PII you entered in the app that is not declared in the app's marketplace privacy declarations (e.g., Data Safety section in Google Play) and/or in its privacy policy.
* Note that this test does not provide any code locations where the sensitive data is being sent over the network. In order to identify the code locations you can use MASTG-TECH-0014 or MASTG-TECH-0015. Consult MASTG-TE...
* 観測期待: The output should contain a network traffic log that includes the decrypted HTTPS traffic.
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
- MASTG-TEST-0206 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0206/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
