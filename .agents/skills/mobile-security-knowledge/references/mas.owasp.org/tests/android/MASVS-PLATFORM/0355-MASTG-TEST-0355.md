---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0355/
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
mastg_test_id: MASTG-TEST-0355
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0355: References to Unauthorized Database Access through Content Providers

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Unauthorized Database Access through Content Providers」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks whether the app exposes content providers that can be accessed by other apps without appropriate permission enforcement. Specifically, it verifies whether exported elements in the AndroidManifest.xml enforce access control via android:readPermission and android:writePermission (or the combined android:permission). If a content provider is exported (android:exported="true") without these permissions, any app on the device can q...
* メタ: type: static, config, manual; profiles: L1, L2; weakness: MASWE-0018; knowledge: MASTG-KNOW-0020, MASTG-KNOW-0117
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0355/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Unauthorized Database Access through Content Providersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Unauthorized Database Access through Content Providersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Unauthorized Database Access through Content Providersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0150 to identify exported content providers and check their permission configuration.
合否（Evaluation）の要点:
* The test case fails if one or more content providers are exported (android:exported="true") without declaring android:readPermission, android:writePermission, or android:permission.
* Further Validation Required:
* Inspect the permission configuration of each reported provider to determine whether the enforced permission provides adequate protection:
* Determine whether the declared permission uses android:protectionLevel="normal" or android:protectionLevel="dangerous", which does not guarantee that only trusted apps can access the provider.
* Determine whether the data exposed through the provider is sensitive.
* 観測期待: The output should contain a list of exported elements from the AndroidManifest, including their declared read and write permission attributes.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0018 の有無をチケットへ併記する
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
- MASTG-TEST-0355 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0355/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
