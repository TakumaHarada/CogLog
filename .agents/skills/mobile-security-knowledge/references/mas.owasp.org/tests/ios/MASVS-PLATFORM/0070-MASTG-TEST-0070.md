---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0070/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0070
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0070: Testing Universal Links

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Universal Links」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Testing universal links on a static approach includes doing the following:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0370, MASTG-TEST-0371, MASTG-TEST-0395; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0070/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Universal Linksのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Universal Linksのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Universal Linksのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Testing universal links on a static approach includes doing the following:
* [Static] Checking the Associated Domains entitlement
* [Static] Retrieving the Apple App Site Association file
* [Static] Checking the link receiver method
* [Static] Checking the data handler method
* [Dynamic] If an app is implementing universal links, you should have the following outputs from the static analysis:
* [Dynamic] the associated domains
* [Dynamic] the Apple App Site Association file
合否（Evaluation）の要点:
* Checking the Associated Domains entitlement
* Checking the link receiver method
* Checking the data handler method
* Checking if the app is calling other app's universal links
* ### Checking the Associated Domains Entitlement
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0370, MASTG-TEST-0371, MASTG-TEST-0395
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
- MASTG-TEST-0070 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0070/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
