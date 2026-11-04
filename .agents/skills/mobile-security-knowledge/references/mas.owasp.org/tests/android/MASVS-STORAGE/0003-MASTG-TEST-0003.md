---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0003/
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
mastg_test_id: MASTG-TEST-0003
masvs_category: MASVS-STORAGE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0003: Testing Logs for Sensitive Data

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Logs for Sensitive Data」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: This test case focuses on identifying any sensitive application data within both system and application logs. The following checks should be performed:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0203, MASTG-TEST-0231; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0003/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Logs for Sensitive Dataのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Logs for Sensitive Dataのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Logs for Sensitive Dataのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Applications will often use the Log Class and Logger Class to create logs. To discover this, you should audit the application's source code for any such logging classes. These can often be found by searching ...
* [Static] Functions and classes, such as:
* [Static] android.util.Log
* [Static] Log.d | Log.e | Log.i | Log.v | Log.w | Log.wtf
* [Static] Logger
* [Dynamic] Use all the mobile app functions at least once, then identify the application's data directory and look for log files (/data/data/). Check the application logs to determine whether log data has been generate...
* [Dynamic] Many application developers still use System.out.println or printStackTrace instead of a proper logging class. Therefore, your testing strategy must include all output generated while the application is star...
* [Dynamic] Remember that you can target a specific app by filtering the Logcat output as follows:
合否（Evaluation）の要点:
* This test case focuses on identifying any sensitive application data within both system and application logs. The following checks should be performed:
* Check application data directory for log files.
* As a general recommendation to avoid potential sensitive application data leakage, logging statements should be removed from production releases unless deemed necessary to the application or explicitly identified as s...
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 後継: MASTG-TEST-0203, MASTG-TEST-0231
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
- MASTG-TEST-0003 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0003/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
