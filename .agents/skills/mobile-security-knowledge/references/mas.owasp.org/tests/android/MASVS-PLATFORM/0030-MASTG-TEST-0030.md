---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0030/
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
mastg_test_id: MASTG-TEST-0030
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0030: Testing for Vulnerable Implementation of PendingIntent

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for Vulnerable Implementation of PendingIntent」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: When testing Pending Intents you must ensure that they are immutable and that the app explicitly specifies the exact package, action, and component that will receive the base intent.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0381; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0030/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for Vulnerable Implementation of PendingIntentのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for Vulnerable Implementation of PendingIntentのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for Vulnerable Implementation of PendingIntentのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] To identify vulnerable implementations, static analysis can be performed by looking for API calls used for obtaining a PendingIntent. Such APIs are listed below:
* [Static] PendingIntent getActivity(Context, int, Intent, int)
* [Static] PendingIntent getActivity(Context, int, Intent, int, Bundle)
* [Static] PendingIntent getActivities(Context, int, Intent, int, Bundle)
* [Static] PendingIntent getActivities(Context, int, Intent, int)
* [Dynamic] Frida can be used to hook the APIs used to get a PendingIntent. This information can be used to determine the code location of the call, which can be further used to perform static analysis as described above.
* [Dynamic] Here's an example of such a Frida script that can be used to hook the PendingIntent.getActivity function:
* [Dynamic] var pendingIntent = Java.use('android.app.PendingIntent');
合否（Evaluation）の要点:
* When testing Pending Intents you must ensure that they are immutable and that the app explicitly specifies the exact package, action, and component that will receive the base intent.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0381
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
- MASTG-TEST-0030 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0030/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
