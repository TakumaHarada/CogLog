---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0244/
scopes:
  - test
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - android
  - ios
  - network
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0244
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0244: Missing Certificate Pinning in Network Traffic

## 概要

* 本ドキュメントは OWASP MASTG Test「Missing Certificate Pinning in Network Traffic」（network / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: There are multiple ways an application can implement certificate pinning, including via the Android Network Security Config, custom TrustManager implementations, third-party libraries, and native code. Since some implementations might be difficult to identify through static analysis, especially when obfuscation or dynamic code loading is involved, this test uses network interception techniques to determine if certificate pinning is enforced at...
* メタ: type: dynamic, network; profiles: L2; weakness: MASWE-0028; knowledge: MASTG-KNOW-0015
* 正本: <https://mas.owasp.org/MASTG/tests/network/MASVS-NETWORK/MASTG-TEST-0244/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Missing Certificate Pinning in Network Trafficのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Missing Certificate Pinning in Network Trafficのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Missing Certificate Pinning in Network Trafficのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0011 to set up an interception proxy and to intercept the communication.
合否（Evaluation）の要点:
* The test case fails if any relevant domain appears in the intercepted traffic capture.
* 観測期待: The output should contain the intercepted traffic capture.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 関連弱点 MASWE-0028 の有無をチケットへ併記する
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
- MASTG-TEST-0244 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/network/MASVS-NETWORK/MASTG-TEST-0244/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
