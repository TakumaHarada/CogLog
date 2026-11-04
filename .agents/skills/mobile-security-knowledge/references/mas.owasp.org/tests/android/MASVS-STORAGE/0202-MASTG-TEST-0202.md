---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0202/
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
mastg_test_id: MASTG-TEST-0202
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0202: References to APIs and Permissions for Accessing External Storage

## 概要

* 本ドキュメントは OWASP MASTG Test「References to APIs and Permissions for Accessing External Storage」（Android / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test uses static analysis to look for uses of APIs allowing an app to write to locations that are shared with other apps (MASTG-TEST-0001) such as the External Storage APIs or the MediaStore API as well as the relevant Android manifest storage-related permissions.
* メタ: type: static, code, manual; profiles: L1, L2; weakness: MASWE-0002; knowledge: MASTG-KNOW-0042
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0202/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to APIs and Permissions for Accessing External Storageのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to APIs and Permissions for Accessing External Storageのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to APIs and Permissions for Accessing External Storageのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0126 to obtain the relevant permissions.
合否（Evaluation）の要点:
* The test case fails if all of the following apply:
* the app has the proper permissions declared in the Android manifest (e.g. WRITE_EXTERNAL_STORAGE, MANAGE_EXTERNAL_STORAGE, etc.)
* the app uses APIs that write to shared storage (e.g. getExternalStoragePublicDirectory, getExternalStorageDirectory, getExternalFilesDir, getExternalCacheDir, MediaStore, etc.)
* the data being written to shared storage is sensitive and not encrypted.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0023 to determine whether the data is sensitive:
* 観測期待: The output should contain a list of APIs and storage-related permissions used to write to shared storage and their code locations.
```

## ナレッジベース

### DO: 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 保存場所・バックアップ・ログ・UI 漏洩経路を網羅確認する
- 機微データの平文保存を fail とする
- 関連弱点 MASWE-0002 の有無をチケットへ併記する
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
- MASTG-TEST-0202 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0202/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
