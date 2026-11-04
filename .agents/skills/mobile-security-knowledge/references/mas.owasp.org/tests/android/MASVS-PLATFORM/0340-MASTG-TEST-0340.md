---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0340/
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
mastg_test_id: MASTG-TEST-0340
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0340: References to Overlay Attack Protections

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Overlay Attack Protections」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Overlay attacks (also known as tapjacking) allow malicious apps to place deceptive UI elements over a legitimate app's interface, potentially tricking users into performing unintended actions such as granting permissions, revealing credentials, or authorizing payments. If the app does not implement appropriate protections, users can interact with overlaid malicious content while believing they are interacting with the legitimate app.
* メタ: type: static, code; profiles: L2; weakness: MASWE-0036; knowledge: MASTG-KNOW-0022
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0340/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Overlay Attack Protectionsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Overlay Attack Protectionsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Overlay Attack Protectionsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0150 to obtain the targetSdkVersion from the AndroidManifest.xml file.
* Use MASTG-TECH-0126 to obtain the relevant permissions.
合否（Evaluation）の要点:
* The test fails if the app handles sensitive user interactions (such as login, payment confirmation, permission requests, or security settings) and does not implement any overlay attack protections on those sensitive U...
* The app doesn't implement setFilterTouchesWhenObscured(true) or android:filterTouchesWhenObscured="true" on sensitive UI elements.
* The app doesn't override onFilterTouchEventForSecurity to implement custom security policies.
* The app doesn't check for FLAG_WINDOW_IS_OBSCURED or FLAG_WINDOW_IS_PARTIALLY_OBSCURED in touch event handlers for sensitive interactions.
* The app targets API level 31 or higher but does not use setHideOverlayWindows(true) and declare the HIDE_OVERLAY_WINDOWS permission.
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 関連弱点 MASWE-0036 の有無をチケットへ併記する
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
- MASTG-TEST-0340 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0340/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
