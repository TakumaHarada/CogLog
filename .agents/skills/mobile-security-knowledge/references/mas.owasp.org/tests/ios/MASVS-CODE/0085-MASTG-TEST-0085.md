---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0085/
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
mastg_test_id: MASTG-TEST-0085
masvs_category: MASVS-CODE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0085: Checking for Weaknesses in Third Party Libraries

## 概要

* 本ドキュメントは OWASP MASTG Test「Checking for Weaknesses in Third Party Libraries」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: In order to ensure that the libraries used by the apps are not carrying vulnerabilities, one can best check the dependencies installed by CocoaPods or Carthage.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0273, MASTG-TEST-0275; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0085/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Checking for Weaknesses in Third Party Librariesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Checking for Weaknesses in Third Party Librariesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Checking for Weaknesses in Third Party Librariesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] In order to ensure that the libraries used by the apps are not carrying vulnerabilities, one can best check the dependencies installed by CocoaPods or Carthage.
* [Static] In case Swift Package Manager is used for managing third party dependencies, the following steps can be taken to analyze the third party libraries for vulnerabilities:
* [Static] First, at the root of the project, where the Package.swift file is located, type
* [Static] Next, check the file Package.resolved for the actual versions used and inspect the given libraries for known vulnerabilities.
* [Static] You can utilize the OWASP Dependency-Check's experimental Swift Package Manager Analyzer to identify the Common Platform Enumeration (CPE) naming scheme of all dependencies and any corresponding Common Vulner...
* [Dynamic] The dynamic analysis of this section comprises of two parts: the actual license verification and checking which libraries are involved in case of missing sources.
* [Dynamic] It need to be validated whether the copyrights of the licenses have been adhered to. This often means that the application should have an about or EULA section in which the copy-right statements are noted as...
* [Dynamic] When performing app analysis, it is important to also analyze the app dependencies (usually in form of libraries or so-called iOS Frameworks) and ensure that they don't contain any vulnerabilities. Even when...
合否（Evaluation）の要点:
* In order to ensure that the libraries used by the apps are not carrying vulnerabilities, one can best check the dependencies installed by CocoaPods or Carthage.
* Next, check the file Package.resolved for the actual versions used and inspect the given libraries for known vulnerabilities.
* You can utilize the OWASP Dependency-Check's experimental Swift Package Manager Analyzer to identify the Common Platform Enumeration (CPE) naming scheme of all dependencies and any corresponding Common Vulnerability a...
* dependency-check --enableExperimental --out . --scan Package.swift
* If the developer packs all dependencies in terms of its own support library using a .podspec file, then this .podspec file can be checked with the experimental CocoaPods podspec checker.
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 後継: MASTG-TEST-0273, MASTG-TEST-0275
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
- MASTG-TEST-0085 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0085/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
