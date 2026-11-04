---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0236/
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
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0236
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0236: Cleartext Traffic Observed on the Network

## 概要

* 本ドキュメントは OWASP MASTG Test「Cleartext Traffic Observed on the Network」（network / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test intercepts the app's incoming and outgoing network traffic, and checks for any cleartext communication. Whilst the static checks can only show _potential_ cleartext traffic, this dynamic test shows all communication the application definitely makes.
* メタ: type: dynamic, network; profiles: L1, L2; weakness: MASWE-0026
* 正本: <https://mas.owasp.org/MASTG/tests/network/MASVS-NETWORK/MASTG-TEST-0236/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Cleartext Traffic Observed on the Networkのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Cleartext Traffic Observed on the Networkのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Cleartext Traffic Observed on the Networkのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* You can use one of the following approaches:
* Set up MASTG-TECH-0010 (for Android) or MASTG-TECH-0062 (for iOS) to capture all traffic.
* Set up MASTG-TECH-0011 (for Android) or MASTG-TECH-0063 (for iOS) to capture all traffic.
* Interception proxies will show HTTP(S) traffic only. You can, however, use some tool-specific plugins such as Burp-non-HTTP-Extension or other tools like MASTG-TOOL-0078 to decode and visualize communication via XMPP ...
* Some apps may not function correctly with proxies like Burp and MASTG-TOOL-0079 because of certificate pinning. In such a scenario, you can still use basic network sniffing to detect cleartext traffic. Otherwise, you ...
合否（Evaluation）の要点:
* The test case fails if any clear text traffic originates from the target app.
* This can be challenging to determine because traffic can potentially come from any app on the device. See the Overview section.
* 観測期待: The output should contain the captured network traffic.
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
- MASTG-TEST-0236 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/network/MASVS-NETWORK/MASTG-TEST-0236/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
