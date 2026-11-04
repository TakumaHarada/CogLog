---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0068/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0068
masvs_category: MASVS-NETWORK
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0068: Testing Custom Certificate Stores and Certificate Pinning

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Custom Certificate Stores and Certificate Pinning」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Verify that the server certificate is pinned. Pinning can be implemented on various levels in terms of the certificate tree presented by the server:
* メタ: profiles: L2; covered_by: MASTG-TEST-0385; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0068/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Custom Certificate Stores and Certificate Pinningのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Custom Certificate Stores and Certificate Pinningのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Custom Certificate Stores and Certificate Pinningのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Verify that the server certificate is pinned. Pinning can be implemented on various levels in terms of the certificate tree presented by the server:
* [Static] Including server's certificate in the application bundle and performing verification on each connection. This requires an update mechanisms whenever the certificate on the server is updated.
* [Static] Limiting certificate issuer to e.g. one entity and bundling the intermediate CA's public key into the application. In this way we limit the attack surface and have a valid certificate.
* [Static] Owning and managing your own PKI. The application would contain the intermediate CA's public key. This avoids updating the application every time you change the certificate on the server, due to e.g. expirati...
* [Static] The latest approach recommended by Apple is to specify a pinned CA public key in the Info.plist file under App Transport Security Settings. You can find an example in their article Identity Pinning: How to co...
* [Dynamic] Follow the instructions from the Dynamic Analysis section of MASTG-TEST-0067. If doing so doesn't lead to traffic being proxied, it may mean that certificate pinning is actually implemented and all security ...
* [Dynamic] As a quick smoke test, you can try to bypass certificate pinning using MASTG-TOOL-0038 as described in MASTG-TECH-0064. Pinning related APIs being hooked by objection should appear in objection's output.
* [Dynamic] However, keep in mind that:
合否（Evaluation）の要点:
* Another common approach is to use the connection:willSendRequestForAuthenticationChallenge: method of NSURLConnectionDelegate to check if the certificate provided by the server is valid and matches the certificate sto...
* As a quick smoke test, you can try to bypass certificate pinning using MASTG-TOOL-0038 as described in MASTG-TECH-0064. Pinning related APIs being hooked by objection should appear in objection's output.
* In both cases, the app or some of its components might implement custom pinning in a way that is supported by objection. Please check the static analysis section for specific pinning indicators and more in-depth testing.
* Some applications use mTLS (mutual TLS), meaning that the application verifies the server's certificate and the server verifies the client's certificate. You can notice this if there is an error in Burp Alerts tab ind...
* Second way of storing the certificate (and possibly password) is to use the Keychain. Upon first login, the application should download the personal certificate and store it securely in the Keychain.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 後継: MASTG-TEST-0385
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
- MASTG-TEST-0068 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0068/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
