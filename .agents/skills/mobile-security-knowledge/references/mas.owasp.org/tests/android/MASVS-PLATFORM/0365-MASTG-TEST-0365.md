---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0365/
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
mastg_test_id: MASTG-TEST-0365
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0365: Exported And Unprotected Services That Expose Sensitive Functionality

## 概要

* 本ドキュメントは OWASP MASTG Test「Exported And Unprotected Services That Expose Sensitive Functionality」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: If an exported service does not define android:permission with a proper protection level and performs or grants access to sensitive functionality, another third-party app outside the intended trust boundary can start or bind to it and invoke that functionality. See MASTG-KNOW-0133 for details on services, MASTG-KNOW-0017 for permissions and protection levels, and MASTG-KNOW-0020 for the IPC model of Android.
* メタ: type: static, config, code, manual; profiles: L1, L2; weakness: MASWE-0018; knowledge: MASTG-KNOW-0133, MASTG-KNOW-0017, MASTG-KNOW-0020
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0365/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Exported And Unprotected Services That Expose Sensitive Functionalityのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Exported And Unprotected Services That Expose Sensitive Functionalityのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Exported And Unprotected Services That Expose Sensitive Functionalityのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0161 to list the exported services and their associated android:permission.
* Use MASTG-TECH-0014 to inspect the code of each exported service.
合否（Evaluation）の要点:
* The test case fails if any exported service is not protected by an appropriate android:permission that restricts which apps can start or bind to it and exposes or performs sensitive functionality, for example by retur...
* Further Validation Required:
* Inspect each exported service using MASTG-TECH-0023 to determine whether it exposes sensitive functionality:
* Determine whether the service returns sensitive data or performs a security-relevant action (for example, changing a password or PIN) in response to a request.
* Determine whether the service exposes a started-service or bound-service interface that lets callers trigger sensitive operations or access sensitive data.
* Then determine whether external access to the service is appropriately restricted for the functionality it exposes and the app's intended trust boundary:
* 観測期待: The output should contain a list of exported services and the relevant parts of their implementation, including the interface they expose and any permission checks they perform.
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
- MASTG-TEST-0365 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0365/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
