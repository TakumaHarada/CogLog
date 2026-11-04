---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0028/
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
mastg_test_id: MASTG-TEST-0028
masvs_category: MASVS-PLATFORM
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0028: Testing Deep Links

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Deep Links」（Android / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Any existing deep links (including App Links) can potentially increase the app attack surface. This includes many risks such as link hijacking, sensitive functionality exposure, etc.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0393, MASTG-TEST-0394; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0028/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Deep Linksのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Deep Linksのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Deep Linksのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] The Android version in which the app runs also influences the risk of using deep links. Inspect the Android Manifest to check if minSdkVersion is 31 or higher.
* [Static] Before Android 12 (API level 31), if the app has any non-verifiable deep links, it can cause the system to not verify all Android App Links for that app.
* [Static] Starting on Android 12 (API level 31), apps benefit from a reduced attack surface. A generic web intent resolves to the user's default browser app unless the target app is approved for the specific domain con...
* [Static] Inspecting the Android Manifest:
* [Static] You can easily determine whether deep links (with or without custom URL schemes) are defined by MASTG-TECH-0007 and inspecting the Android Manifest file looking for elements.
* [Dynamic] Here you will use the list of deep links from the static analysis to iterate and determine each handler method and the processed data, if any. You will first start a MASTG-TOOL-0031 hook and then begin invok...
* [Dynamic] The following example assumes a target app that accepts this deep link: deeplinkdemo://load.html. However, we don't know the corresponding handler method yet, nor the parameters it potentially accepts.
* [Dynamic] [Step 1] Frida Hooking:
合否（Evaluation）の要点:
* All deep links must be enumerated and verified for correct website association. The actions they perform must be well tested, especially all input data, which should be deemed untrustworthy and thus should always be v...
* None of the input from these sources can be trusted; it must be validated and/or sanitized. Validation ensures processing of data that the app is expecting only. If validation is not enforced, any input can be sent to...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0393, MASTG-TEST-0394
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
- MASTG-TEST-0028 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0028/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
