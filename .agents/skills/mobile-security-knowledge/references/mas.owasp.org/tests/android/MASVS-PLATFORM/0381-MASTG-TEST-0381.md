---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0381/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0381
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0381: References to Insecure PendingIntent Creation

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Insecure PendingIntent Creation」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks for references to PendingIntent creation APIs to identify potentially insecure implementations. A PendingIntent wraps an Intent that will be executed later on behalf of the app's identity and permissions, making it critical to configure them securely.
* メタ: type: static; profiles: L1, L2; weakness: MASWE-0032
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0381/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Insecure PendingIntent Creationのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Insecure PendingIntent Creationのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Insecure PendingIntent Creationのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Run a static analysis tool (MASTG-TECH-0014) to identify all usages of:
* PendingIntent.getActivity()
* PendingIntent.getActivities()
* PendingIntent.getService()
* PendingIntent.getForegroundService()
* PendingIntent.getBroadcast()
* For each identified usage, check:
* The flags parameter for the presence of FLAG_IMMUTABLE or FLAG_MUTABLE.
合否（Evaluation）の要点:
* The test case fails if any of the following conditions are met:
* A PendingIntent is created without FLAG_IMMUTABLE when the app's minSdkVersion is below 31, unless there is a specific need for mutability that is properly justified and the app takes other precautions.
* A PendingIntent is created with FLAG_MUTABLE without a valid use case requiring mutability (e.g., inline reply actions).
* The base intent is implicit (does not specify the target component using setClass(), setClassName(), or setComponent()), allowing potential hijacking by malicious apps.
* 観測期待: The output should contain a list of locations where PendingIntent creation APIs are used, along with the flags passed to the API (if identifiable) and whether the base intent appears to be explicit or implicit.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0032 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 未使用入口をテスト対象外のまま放置する

* 理由: MASVS-PLATFORM の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 未使用入口をテスト対象外のまま放置する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0381 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0381/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
