---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0385/
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
mastg_test_id: MASTG-TEST-0385
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0385: Missing Certificate Pinning in ATS

## 概要

* 本ドキュメントは OWASP MASTG Test「Missing Certificate Pinning in ATS」（iOS / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: iOS apps can configure certificate pinning via App Transport Security (ATS) by declaring expected CA or leaf certificate public key hashes in the Info.plist file under the NSPinnedDomains key. This is Apple's built-in mechanism for pinning connections made through the URL Loading System, such as URLSession.
* メタ: type: static; profiles: L2; weakness: MASWE-0028; knowledge: MASTG-KNOW-0072
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0385/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Missing Certificate Pinning in ATSのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Missing Certificate Pinning in ATSのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Missing Certificate Pinning in ATSのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Extract the app (MASTG-TECH-0058).
* Obtain the Info.plist file from the app bundle.
* Use MASTG-TECH-0138 to convert the Info.plist to a readable format (if necessary).
* Examine the NSAppTransportSecurity dictionary for the presence of a NSPinnedDomains key.
* Use MASTG-TECH-0071 to retrieve hardcoded URLs and identify the first-party domains the app connects to.
合否（Evaluation）の要点:
* The test case fails if the app uses URL Loading System connections to relevant first-party domains, but the app's Info.plist does not contain an NSAppTransportSecurity dictionary with a NSPinnedDomains key, or if NSPi...
* The test case should not fail only because unrelated third-party domains are not pinned.
* If another certificate pinning implementation is identified for the same domains, such as custom server trust evaluation, the result should be treated as not covered by ATS pinning rather than as a confirmed absence o...
* Further Validation Required:
* Before reporting a missing pin, confirm that the app actually establishes URL Loading System connections to the relevant first-party domains:
* Statically, follow the data references from the hardcoded URLs to the code that initiates the network connections (MASTG-TECH-0076).
* 観測期待: The output should contain the ATS configuration, if present, including whether NSPinnedDomains is defined with one or more pinned domains and their associated public key hashes. The output should also identify any releva
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
- MASTG-TEST-0385 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-NETWORK/MASTG-TEST-0385/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
