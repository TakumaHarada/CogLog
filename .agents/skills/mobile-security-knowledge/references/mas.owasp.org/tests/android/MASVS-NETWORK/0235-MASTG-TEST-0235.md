---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0235/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0235
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0235: Android App Configurations Allowing Cleartext Traffic

## 概要

* 本ドキュメントは OWASP MASTG Test「Android App Configurations Allowing Cleartext Traffic」（Android / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Since Android 9 (API level 28) cleartext HTTP traffic is blocked by default (thanks to the default Network Security Configuration) but there are multiple ways in which an application can still send it:
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0026; knowledge: MASTG-KNOW-0014
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0235/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Android App Configurations Allowing Cleartext Trafficのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Android App Configurations Allowing Cleartext Trafficのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Android App Configurations Allowing Cleartext Trafficのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0150 to read the value of android:usesCleartextTraffic and check if android:networkSecurityConfig is present.
* Use MASTG-TECH-0151 to read the values of cleartextTrafficPermitted in the and elements from the Network Security Configuration file.
合否（Evaluation）の要点:
* The test case fails if cleartext traffic is permitted. This can happen if any of the following is true:
* The AndroidManifest sets usesCleartextTraffic to true and there's no NSC.
* The NSC sets cleartextTrafficPermitted to true in the .
* The NSC sets cleartextTrafficPermitted to true in any .
* The test doesn't fail if the AndroidManifest sets usesCleartextTraffic to true and there's a NSC, even if it only has an empty element. For example:
* 観測期待: The output should contain a list of configurations potentially allowing for cleartext traffic.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 関連弱点 MASWE-0026 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: HTTPS という文言だけで pass にする

* 理由: MASVS-NETWORK の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- HTTPS という文言だけで pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0235 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0235/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
