---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0321/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0321
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0321: Hardcoded HTTP URLs

## 概要

* 本ドキュメントは OWASP MASTG Test「Hardcoded HTTP URLs」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: An iOS app may have hardcoded HTTP URLs embedded in the app binary, library binaries, or other resources within the IPA. These URLs may indicate potential locations where the app communicates with servers over an unencrypted connection.
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0026
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0321/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Hardcoded HTTP URLsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Hardcoded HTTP URLsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Hardcoded HTTP URLsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0071 to search for any http:// URLs.
合否（Evaluation）の要点:
* The test case fails if any HTTP URLs are confirmed to be used for communication.
* The presence of HTTP URLs alone does not necessarily mean they are actively used for communication. Their usage may depend on runtime conditions, such as how the URLs are invoked and whether cleartext traffic is allow...
* Additionally, complement this static inspection with dynamic testing methods. For example, capture and analyze network traffic to confirm whether the app connects to the identified HTTP URLs during real-world usage. S...
* 観測期待: The output should contain a list of URLs and their locations within the app.
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
- MASTG-TEST-0321 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0321/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
