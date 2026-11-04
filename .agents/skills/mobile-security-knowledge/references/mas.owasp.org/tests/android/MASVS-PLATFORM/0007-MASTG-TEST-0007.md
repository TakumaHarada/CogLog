---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0007/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0007
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0007: Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanisms

## 概要

* 本ドキュメントは OWASP MASTG Test「Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanisms」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: The first step is to look at AndroidManifest.xml to detect content providers exposed by the app. You can identify content providers by the element. Complete the following steps:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0339, MASTG-TEST-0355, MASTG-TEST-0356, MASTG-TEST-0357; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0007/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanismsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanismsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanismsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] The first step is to look at AndroidManifest.xml to detect content providers exposed by the app. You can identify content providers by the element. Complete the following steps:
* [Static] Determine whether the value of the export tag (android:exported) is "true". Even if it is not, the tag will be set to "true" automatically if an has been defined for the tag. If the content is meant to be acc...
* [Static] Determine whether the data is being protected by a permission tag (android:permission). Permission tags limit exposure to other apps.
* [Static] Determine whether the android:protectionLevel attribute has the value signature. This setting indicates that the data is intended to be accessed only by apps from the same enterprise (i.e., signed with the sa...
* [Static] Inspect the source code to understand how the content provider is meant to be used. Search for the following keywords:
* [Dynamic] To dynamically analyze an application's content providers, first enumerate the attack surface: pass the app's package name to the Drozer module app.provider.info:
* [Dynamic] dz> run app.provider.info -a com.mwr.example.sieve
* [Dynamic] Package: com.mwr.example.sieve
合否（Evaluation）の要点:
* Determine whether the android:protectionLevel attribute has the value signature. This setting indicates that the data is intended to be accessed only by apps from the same enterprise (i.e., signed with the same key). ...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0339, MASTG-TEST-0355, MASTG-TEST-0356, MASTG-TEST-0357
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 未使用入口をテスト対象外のまま放置する

* 理由: MASVS-PLATFORM の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 未使用入口をテスト対象外のまま放置する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0007 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0007/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
