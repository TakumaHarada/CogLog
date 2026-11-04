---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0302/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0302
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0302: Sensitive Data Unencrypted in Private Storage Files

## 概要

* 本ドキュメントは OWASP MASTG Test「Sensitive Data Unencrypted in Private Storage Files」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test is designed to complement MASTG-TEST-0301. Instead of monitoring APIs during execution, it performs a differential analysis of the app's private storage by comparing snapshots taken before and after exercising the app. It also enumerates Keychain items created or modified during the session.
* メタ: type: dynamic, filesystem; profiles: L2; weakness: MASWE-0001; knowledge: MASTG-KNOW-0108
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0302/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Sensitive Data Unencrypted in Private Storage Filesのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Sensitive Data Unencrypted in Private Storage Filesのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Sensitive Data Unencrypted in Private Storage Filesのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0059 to get a baseline list of files of the app's private storage (sandbox) directory tree.
* Use MASTG-TECH-0061 to take an initial snapshot of the Keychain items. Optionally record attributes (accessible class, access control flags, etc).
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
* Use MASTG-TECH-0059 to retrieve the list of files again.
* Diff the two private storage snapshots to identify new, deleted, and modified files. For modified files, determine whether content changes involve potential sensitive values.
* Use MASTG-TECH-0061 to take a second snapshot of the Keychain items.
* Use MASTG-TECH-0061 to diff the two Keychain snapshots and identify new, deleted, and modified items.
合否（Evaluation）の要点:
* The test case fails if sensitive data appears in plaintext or trivially encoded in new or modified files.
* Inspect the list of files and Keychain entries for sensitive data. Attempt to identify and decode data that has been encoded using methods such as base64 encoding, hexadecimal representation, URL-encoding, escape sequ...
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 関連弱点 MASWE-0001 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 内部ストレージだから安全と一律 pass にする

* 理由: MASVS-STORAGE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 内部ストレージだから安全と一律 pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0302 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0302/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
