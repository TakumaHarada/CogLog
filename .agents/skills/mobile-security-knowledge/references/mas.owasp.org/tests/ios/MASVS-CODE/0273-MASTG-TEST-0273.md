---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0273/
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
mastg_test_id: MASTG-TEST-0273
masvs_category: MASVS-CODE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0273: Identify Dependencies with Known Vulnerabilities by Scanning Dependency Managers Artifacts

## 概要

* 本ドキュメントは OWASP MASTG Test「Identify Dependencies with Known Vulnerabilities by Scanning Dependency Managers Artifacts」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: In this test case we are identifying dependencies with known vulnerabilities in iOS. Dependencies are integrated through dependency managers, and there might be one or more of them being used. We therefore need all of the relevant artifacts created by them to analyse them with a SCA scanning tool.
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0044
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0273/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Identify Dependencies with Known Vulnerabilities by Scanning Dependency Managers Artifactsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Identify Dependencies with Known Vulnerabilities by Scanning Dependency Managers Artifactsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Identify Dependencies with Known Vulnerabilities by Scanning Dependency Managers Artifactsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0133 for an overview of the package managers and to request the relevant artifact files from the development team.
* Use MASTG-TECH-0133 to scan the artifact files created by the dependency managers and to look for vulnerable dependencies.
合否（Evaluation）の要点:
* The test case fails if you can find dependencies with known vulnerabilities.
* 観測期待: The output should include the dependency name and the CVE identifiers for any dependency with known vulnerabilities.
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0044 の有無をチケットへ併記する
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
- MASTG-TEST-0273 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0273/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
