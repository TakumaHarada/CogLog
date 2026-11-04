---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0229/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0229
masvs_category: MASVS-CODE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0229: Stack Canaries Not enabled

## 概要

* 本ドキュメントは OWASP MASTG Test「Stack Canaries Not enabled」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test case checks if the native libraries of the app are compiled without common binary protection mechanisms (MASTG-KNOW-0061) such as stack smashing protection, a mitigation technique against buffer overflow attacks.
* メタ: type: static, code; profiles: L2; weakness: MASWE-0045; knowledge: MASTG-KNOW-0061
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0229/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Stack Canaries Not enabledのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Stack Canaries Not enabledのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Stack Canaries Not enabledのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0082 to identify all bundled libraries.
* Use MASTG-TECH-0118 on the main binary and each shared library to obtain all relevant artifacts related to the compiler-provided security features.
合否（Evaluation）の要点:
* The test case fails if any binary or library is not purely Swift but does not contain methods indicating stack canaries like objc_autorelease or objc_retainAutorelease.
* Checking for the stack_chk_fail symbol only indicates that stack smashing protection is enabled somewhere in the app. While stack canaries are typically enabled or disabled for the entire binary, there may be corner c...
* If you want to be sure that specific security-critical methods are sufficiently protected, you need to reverse-engineer each of them and manually check for stack smashing protection.
* When evaluating this, please note that there are potential expected false positives for which the test case should be considered as passed. To be certain for these cases, they require manual review of the original sou...
* The following examples cover some of the false positive cases that might be encountered:
* The Flutter framework does not use stack canaries because of the way Dart mitigates buffer overflows.
* 観測期待: The output should contain a list of symbols of the main binary and each shared library.
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0045 の有無をチケットへ併記する
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
- MASTG-TEST-0229 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0229/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
