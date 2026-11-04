---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0287/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0287
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0287: Runtime Storage of Unencrypted Data via the SharedPreferences API

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Storage of Unencrypted Data via the SharedPreferences API」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: In Android, applications can use the SharedPreferences API to store sensitive data without encryption, typically under the app's private data directory, such as /data/user/0//shared_prefs/ or /data/data//shared_prefs/.
* メタ: type: dynamic, hooks, manual; profiles: L1, L2; weakness: MASWE-0001; knowledge: MASTG-KNOW-0036
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0287/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Storage of Unencrypted Data via the SharedPreferences APIのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Storage of Unencrypted Data via the SharedPreferences APIのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Storage of Unencrypted Data via the SharedPreferences APIのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0005 to install the app.
* Use MASTG-TECH-0043 to hook the relevant API calls.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
* Use MASTG-TECH-0008 to retrieve the app's SharedPreferences XML files.
合否（Evaluation）の要点:
* The test case fails if sensitive data is written to SharedPreferences without being encrypted first.
* Further Validation Required:
* High-level trace inspection: Review the sequence of calls from the hook output to identify if SharedPreferences.Editor.putString or putStringSet calls are preceded by Cipher operations. Values written without prior en...
* Pattern matching: Use a secrets detection tool (for example, MASTG-TOOL-0144) to scan the output for known secret patterns such as API keys, tokens, passwords, or private keys.
* Manual verification: Use the stack traces from the hook output to navigate to the relevant code locations in the reversed app (MASTG-TECH-0023) and trace back the source of the values being written to confirm whether ...
* 観測期待: The output should contain a list of all calls to SharedPreferences write methods, including the keys, values, and stack traces showing where in the app's code these calls originate. The trace should also include related 
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
- MASTG-TEST-0287 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0287/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
