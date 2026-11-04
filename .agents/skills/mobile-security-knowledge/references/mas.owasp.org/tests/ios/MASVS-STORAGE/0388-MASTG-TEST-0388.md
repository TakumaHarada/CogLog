---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0388/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0388
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0388: References to Sensitive Data Stored Unprotected in Shared App Group Containers

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Sensitive Data Stored Unprotected in Shared App Group Containers」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: An iOS app and its app extensions can share data through an App Group container (see MASTG-KNOW-0082). Every member of the App Group has equal read/write access to everything in that container, and the container has no per-item access control between members. When the app or any of its extensions stores credentials, tokens, or other secrets there, all members of the App Group can read them, even those that do not need the data, and the values ...
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0001; knowledge: MASTG-KNOW-0082
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0388/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Sensitive Data Stored Unprotected in Shared App Group Containersのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Sensitive Data Stored Unprotected in Shared App Group Containersのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Sensitive Data Stored Unprotected in Shared App Group Containersのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from the app package, including the extension binaries in the PlugIns/.appex bundles.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app and extension binaries.
合否（Evaluation）の要点:
* The test case fails if sensitive data is written to an App Group shared container (shared UserDefaults, the shared file container, or a shared Core Data store) without adequate protection, for example when secrets are...
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0076 to determine:
* Whether the value written to the shared container is sensitive (for example, credentials, authentication tokens, or API keys).
* Whether the value is encrypted before being written, or whether files are written with NSFileProtectionComplete (see MASTG-TEST-0299).
* Whether the data is a secret that should have been stored in a shared Keychain (keychain-access-groups) rather than the shared container.
* 観測期待: The output should contain a list of locations where the app or its extensions access an App Group shared container, in particular:
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
- MASTG-TEST-0388 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0388/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
