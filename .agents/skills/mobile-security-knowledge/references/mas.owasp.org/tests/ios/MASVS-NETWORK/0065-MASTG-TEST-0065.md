---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0065/
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
mastg_test_id: MASTG-TEST-0065
masvs_category: MASVS-NETWORK
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0065: Testing Data Encryption on the Network

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Data Encryption on the Network」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: All the presented cases must be carefully analyzed as a whole. For example, even if the app does not permit cleartext traffic in its Info.plist, it might actually still be sending HTTP traffic. That could be the case if it's using a low-level API (for which ATS is ignored) or a badly configured cross-platform framework.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0321, MASTG-TEST-0322, MASTG-TEST-0322, MASTG-TEST-0236; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0065/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Data Encryption on the Networkのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Data Encryption on the Networkのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Data Encryption on the Networkのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] First, you should identify all network requests in the source code and ensure that no plain HTTP URLs are used. Make sure that sensitive information is sent over secure channels by using URLSession (which use...
* [Static] Identify the network APIs used by the app and see if it uses any low-level networking APIs.
* [Static] > Apple Recommendation: Prefer High-Level Frameworks in Your App: "ATS doesn't apply to calls your app makes to lower-level networking interfaces like the Network framework or CFNetwork. In these cases, you t...
* [Static] If the app uses any low-level APIs such as Network or CFNetwork, you should carefully investigate if they are being used securely. For apps using cross-platform frameworks (e.g. Flutter, React Native or Cordo...
* [Static] Make sure that the app:
* [Dynamic] Intercept the tested app's incoming and outgoing network traffic and make sure that this traffic is encrypted. You can intercept network traffic in any of the following ways:
* [Dynamic] Capture all HTTP(S) and Websocket traffic with an interception proxy like MASTG-TOOL-0079 or MASTG-TOOL-0077 and make sure all requests are made via HTTPS instead of HTTP.
* [Dynamic] Interception proxies like Burp and MASTG-TOOL-0079 will show web related traffic primarily (e.g. HTTP(S), Web Sockets, gRPC, etc.). You can, however, use a Burp plugin such as Burp-non-HTTP-Extension or the ...
合否（Evaluation）の要点:
* All the presented cases must be carefully analyzed as a whole. For example, even if the app does not permit cleartext traffic in its Info.plist, it might actually still be sending HTTP traffic. That could be the case ...
* > IMPORTANT: You should apply these tests to the app main code but also to any app extensions, frameworks or Watch apps embedded within the app as well.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 後継: MASTG-TEST-0321, MASTG-TEST-0322, MASTG-TEST-0322, MASTG-TEST-0236
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
- MASTG-TEST-0065 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0065/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
