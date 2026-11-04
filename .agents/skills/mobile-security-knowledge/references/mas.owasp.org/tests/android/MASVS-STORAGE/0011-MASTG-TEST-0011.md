---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0011/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0011
masvs_category: MASVS-STORAGE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0011: Testing Memory for Sensitive Data

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Memory for Sensitive Data」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Analyzing memory can help developers identify the root causes of several problems, such as application crashes. However, it can also be used to access sensitive data. This section describes how to check for data disclosure via process memory.
* メタ: profiles: L2; deprecation_note: The associated weaknesses are best addressed during the development process. See @MASTG-KNOW-0051 for more details.
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0011/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Memory for Sensitive Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Memory for Sensitive Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Memory for Sensitive Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] When performing static analysis to identify sensitive data that is exposed in memory, you should:
* [Static] Try to identify application components and map where data is used.
* [Static] Make sure that sensitive data is handled by as few components as possible.
* [Static] Make sure that object references are properly removed once the object containing the sensitive data is no longer needed.
* [Static] Make sure that garbage collection is requested after references have been removed.
* [Dynamic] Static analysis will help you identify potential problems, but it can't provide statistics about how long data has been exposed in memory, nor can it help you identify problems in closed-source dependencies....
* [Dynamic] There are various ways to analyze the memory of a process, e.g. live analysis via a debugger/dynamic instrumentation and analyzing one or more memory dumps.
* [Dynamic] Whether you are using a rooted or a non-rooted device, you can dump the app's process memory with MASTG-TOOL-0038 and MASTG-TOOL-0106. You can find a detailed explanation of this process in MASTG-TECH-0044, ...
合否（Evaluation）の要点:
* Analyzing memory can help developers identify the root causes of several problems, such as application crashes. However, it can also be used to access sensitive data. This section describes how to check for data discl...
* To investigate an application's memory, you must first create a memory dump. You can also analyze the memory in real-time, e.g., via a debugger. Regardless of your approach, memory dumping is a very error-prone proces...
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする

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
- MASTG-TEST-0011 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0011/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
