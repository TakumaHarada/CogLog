---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0023/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - network
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0023
masvs_category: MASVS-NETWORK
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0023: Testing the Security Provider

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing the Security Provider」（Android / ネットワーク）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Applications based on the Android SDK should depend on GooglePlayServices. For example, in the gradle build file, you will find compile 'com.google.android.gms:play-services-gcm:x.x.x' in the dependencies block. You need to make sure that the ProviderInstaller class is called with either installIfNeeded or installIfNeededAsync. ProviderInstaller needs to be called by a component of the application as early as possible. Exceptions thrown by the...
* メタ: profiles: L2; covered_by: MASTG-TEST-0295; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0023/>
* 関連制御群: `MASVS-NETWORK`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing the Security Providerのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing the Security Providerのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing the Security Providerのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Applications based on the Android SDK should depend on GooglePlayServices. For example, in the gradle build file, you will find compile 'com.google.android.gms:play-services-gcm:x.x.x' in the dependencies blo...
* [Static] If you have access to the source code, check if the app handle any exceptions related to the security provider updates properly, and if it reports to the backend when the application is working with an unpatc...
* [Static] Lastly, make sure that NDK-based applications bind only to a recent and properly patched library that provides SSL/TLS functionality.
* [Dynamic] When you have the source code:
* [Dynamic] Run the application in debug mode, then create a breakpoint where the app will first contact the endpoint(s).
* [Dynamic] Right click the highlighted code and select Evaluate Expression.
* [Dynamic] Type Security.getProviders() and press enter.
* [Dynamic] Check the providers and try to find GmsCore_OpenSSL, which should be the new top-listed provider.
合否（Evaluation）の要点:
* Applications based on the Android SDK should depend on GooglePlayServices. For example, in the gradle build file, you will find compile 'com.google.android.gms:play-services-gcm:x.x.x' in the dependencies block. You n...
* If you have access to the source code, check if the app handle any exceptions related to the security provider updates properly, and if it reports to the backend when the application is working with an unpatched secur...
* Check the providers and try to find GmsCore_OpenSSL, which should be the new top-listed provider.
```

## ナレッジベース

### DO: TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- TLS・証明書検証・cleartext 例外を成果物と通信観測で確認する
- 検証スキップ経路があれば fail とする
- 後継: MASTG-TEST-0295
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
- MASTG-TEST-0023 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-NETWORK/MASTG-TEST-0023/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
