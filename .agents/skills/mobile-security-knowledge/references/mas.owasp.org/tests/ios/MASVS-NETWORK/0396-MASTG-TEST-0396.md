---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0396/
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
mastg_test_id: MASTG-TEST-0396
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0396: References to URLSessionDelegate Bypassing Certificate Validation

## 概要

* 本ドキュメントは OWASP MASTG Test「References to URLSessionDelegate Bypassing Certificate Validation」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: iOS apps that use URLSession can optionally override the system's default server trust evaluation by implementing urlSession(_:didReceive:completionHandler:) from URLSessionDelegate (session-level) or urlSession(_:task:didReceive:completionHandler:) (task-level). When one of these methods is present, the URL Loading System delegates the entire certificate validation decision to the app, completely bypassing the default App Transport Security (...
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0027; knowledge: MASTG-KNOW-0072
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0396/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to URLSessionDelegate Bypassing Certificate Validationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to URLSessionDelegate Bypassing Certificate Validationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to URLSessionDelegate Bypassing Certificate Validationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from the app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if an implementation of urlSession(_:didReceive:completionHandler:) or urlSession(_:task:didReceive:completionHandler:) is found that has no corresponding cross-reference to SecTrustEvaluateWithError.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0076 to confirm the certificate validation bypass. Look for cases such as:
* Accepting a credential without trust evaluation: calling completionHandler(.useCredential, URLCredential(trust: serverTrust)) without first calling SecTrustEvaluateWithError(serverTrust, &error) and verifying it retur...
* Ignoring the challenge type: not checking challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust before accepting a credential, which may unintentionally bypass validation for other cha...
* Swallowing evaluation errors: wrapping SecTrustEvaluateWithError in a do/catch or ignoring its return value and calling completionHandler(.useCredential, ...) regardless of the outcome.
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 関連弱点 MASWE-0027 の有無をチケットへ併記する
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
- MASTG-TEST-0396 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0396/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
