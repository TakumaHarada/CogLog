---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0386/
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
mastg_test_id: MASTG-TEST-0386
masvs_category: MASVS-CODE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0386: References to Object Deserialization of Untrusted Data

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Object Deserialization of Untrusted Data」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: iOS apps can reconstruct objects from serialized data received through files, IPC payloads, network responses, pasteboard data, app extensions, or archived data stored locally. If an attacker can influence this data and the app decodes it without restricting the expected classes, the app may accept unexpected object types. This can lead to object substitution, unintended application behavior, or unsafe state changes.
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0050; knowledge: MASTG-KNOW-0075
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0386/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Object Deserialization of Untrusted Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Object Deserialization of Untrusted Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Object Deserialization of Untrusted Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from the app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
合否（Evaluation）の要点:
* The test case fails if the app deserializes data from a potentially untrusted or attacker-influenced source using APIs that don't enforce secure coding, class restrictions, or equivalent validation.
* Further Validation Required:
* A reference to one of these APIs doesn't fail the test on its own. Inspect each reported code location using MASTG-TECH-0076 to determine whether the deserialized data can cross a trust boundary:
* Determine whether the decoded data can originate from an untrusted or attacker-influenced source, such as files, IPC, network responses, app extensions, pasteboard data, or archived data stored locally.
* Determine whether the unarchiver enforces secure coding and whether decoded objects are restricted to the expected classes.
* Uses of these APIs on constant, bundled, or otherwise trusted data that an attacker can't control should be reviewed manually rather than treated as a confirmed failure.
* 観測期待: The output should contain a list of locations where object deserialization APIs are used, indicating whether each location enforces secure coding and restricts the decoded classes.
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0050 の有無をチケットへ併記する
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
- MASTG-TEST-0386 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0386/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
