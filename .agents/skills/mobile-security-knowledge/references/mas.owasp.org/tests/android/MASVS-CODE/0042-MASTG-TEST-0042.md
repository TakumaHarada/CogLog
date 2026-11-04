---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0042/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0042
masvs_category: MASVS-CODE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0042: Checking for Weaknesses in Third Party Libraries

## 概要

* 本ドキュメントは OWASP MASTG Test「Checking for Weaknesses in Third Party Libraries」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Detecting vulnerabilities in third party dependencies can be done by means of the OWASP Dependency checker. This is best done by using a gradle plugin, such as dependency-check-gradle. In order to use the plugin, the following steps need to be applied: Install the plugin from the Maven central repository by adding the following script to your build.gradle:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0272, MASTG-TEST-0274; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0042/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Checking for Weaknesses in Third Party Librariesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Checking for Weaknesses in Third Party Librariesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Checking for Weaknesses in Third Party Librariesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Detecting vulnerabilities in third party dependencies can be done by means of the OWASP Dependency checker. This is best done by using a gradle plugin, such as dependency-check-gradle.
* [Static] In order to use the plugin, the following steps need to be applied:
* [Static] Install the plugin from the Maven central repository by adding the following script to your build.gradle:
* [Static] classpath 'org.owasp:dependency-check-gradle:3.2.0'
* [Static] apply plugin: 'org.owasp.dependencycheck'
* [Dynamic] The dynamic analysis of this section comprises validating whether the copyrights of the licenses have been adhered to. This often means that the application should have an about or EULA section in which the ...
合否（Evaluation）の要点:
* Detecting vulnerabilities in third party dependencies can be done by means of the OWASP Dependency checker. This is best done by using a gradle plugin, such as dependency-check-gradle.
* classpath 'org.owasp:dependency-check-gradle:3.2.0'
* apply plugin: 'org.owasp.dependencycheck'
* gradle dependencyCheckAnalyze --info
* Lastly, please note that for hybrid applications, you will have to check the JavaScript dependencies with RetireJS. Similarly for mobile cross platform frameworks, you will have to check their dependencies.
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 後継: MASTG-TEST-0272, MASTG-TEST-0274
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
- MASTG-TEST-0042 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0042/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
