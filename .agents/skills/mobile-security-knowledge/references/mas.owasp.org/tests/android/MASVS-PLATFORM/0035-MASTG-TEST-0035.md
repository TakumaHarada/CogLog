---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0035/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0035
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0035: Testing for Overlay Attacks

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for Overlay Attacks」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for overlay attacks you need to check the app for usage of certain APIs and attributed typically used to protect against overlay attacks as well as check the Android version that app is targeting.
* メタ: profiles: L2; covered_by: MASTG-TEST-0340; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0035/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for Overlay Attacksのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for Overlay Attacksのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for Overlay Attacksのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] To start your static analysis you can check the app for the following methods and attributes (non-exhaustive list):
* [Static] Override onFilterTouchEventForSecurity for more fine-grained control and to implement a custom security policy for views.
* [Static] Set the layout attribute android:filterTouchesWhenObscured to true or call setFilterTouchesWhenObscured.
* [Static] Check FLAG_WINDOW_IS_OBSCURED (since API level 9) or FLAG_WINDOW_IS_PARTIALLY_OBSCURED (starting on API level 29).
* [Static] Some attributes might affect the app as a whole, while others can be applied to specific components. The latter would be the case when, for example, there is a business need to specifically allow overlays whi...
* [Dynamic] Abusing this kind of vulnerability on a dynamic manner can be pretty challenging and very specialized as it closely depends on the target Android version. For instance, for versions up to Android 7.0 (API le...
* [Dynamic] Tapjacking POC: This APK creates a simple overlay which sits on top of the testing application.
* [Dynamic] Invisible Keyboard: This APK creates multiple overlays on the keyboard to capture keystrokes. This is one of the exploit demonstrated in Cloak and Dagger attacks.
合否（Evaluation）の要点:
* To test for overlay attacks you need to check the app for usage of certain APIs and attributed typically used to protect against overlay attacks as well as check the Android version that app is targeting.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0340
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
- MASTG-TEST-0035 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0035/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
