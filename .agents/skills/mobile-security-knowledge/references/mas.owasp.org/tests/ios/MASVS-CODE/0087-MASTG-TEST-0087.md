---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0087/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0087
masvs_category: MASVS-CODE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0087: Make Sure That Free Security Features Are Activated

## 概要

* 本ドキュメントは OWASP MASTG Test「Make Sure That Free Security Features Are Activated」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: You can use radare2 to check the binary security features.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0228, MASTG-TEST-0229, MASTG-TEST-0230; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0087/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Make Sure That Free Security Features Are Activatedのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Make Sure That Free Security Features Are Activatedのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Make Sure That Free Security Features Are Activatedのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] You can use radare2 to check the binary security features.
* [Static] Let's use the Damn Vulnerable iOS App DVIA v1 as an example. Open its main binary with radare2:
* [Static] r2 DamnVulnerableIOSApp
* [Static] And run the following commands:
* [Static] [0x1000180c8]> i~pic,canary
* [Dynamic] These checks can be performed dynamically using MASTG-TOOL-0038. Here's one example:
* [Dynamic] com.yourcompany.PPClient on (iPhone: 13.2.3) [usb] # ios info binary
* [Dynamic] Name Type Encrypted PIE ARC Canary Stack Exec RootSafe
合否（Evaluation）の要点:
* You can use radare2 to check the binary security features.
* These checks can be performed dynamically using MASTG-TOOL-0038. Here's one example:
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 後継: MASTG-TEST-0228, MASTG-TEST-0229, MASTG-TEST-0230
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ビルド設定を見ずにコードレビューだけで完了する

* 理由: MASVS-CODE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ビルド設定を見ずにコードレビューだけで完了する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0087 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0087/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
