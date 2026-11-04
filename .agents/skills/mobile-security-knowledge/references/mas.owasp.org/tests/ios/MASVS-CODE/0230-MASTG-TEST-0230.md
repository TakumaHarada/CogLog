---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0230/
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
mastg_test_id: MASTG-TEST-0230
masvs_category: MASVS-CODE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0230: Automatic Reference Counting (ARC) not enabled

## 概要

* 本ドキュメントは OWASP MASTG Test「Automatic Reference Counting (ARC) not enabled」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test case checks if ARC (Automatic Reference Counting) is enabled in iOS apps. ARC is a compiler feature in Objective-C and Swift that automates memory management, reducing the likelihood of memory leaks and other related issues. Enabling ARC is crucial for maintaining the security and stability of iOS applications.
* メタ: type: static, code; profiles: L2; weakness: MASWE-0045; knowledge: MASTG-KNOW-0061
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0230/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Automatic Reference Counting (ARC) not enabledのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Automatic Reference Counting (ARC) not enabledのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Automatic Reference Counting (ARC) not enabledのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0082 to identify all bundled libraries.
* Use MASTG-TECH-0118 on the main binary and each shared library to obtain all relevant artifacts related to the compiler-provided security features.
合否（Evaluation）の要点:
* The test case fails if any binary or library containing Objective-C or Swift code is missing ARC-related symbols. The presence of symbols such as _objc_msgSend (Objective-C) or _swift_allocObject (Swift) without corre...
* Checking for these symbols only indicates that ARC is enabled somewhere in the app. While ARC is typically enabled or disabled for the entire binary, there can be corner cases where only parts of the application or li...
* If you want to be sure that specific security-critical methods are adequately protected, you need to reverse-engineer each of them and manually check for ARC, or request the source code from the developer.
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
- MASTG-TEST-0230 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0230/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
