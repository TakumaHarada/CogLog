---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0039/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - resilience
  - profile-r
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0039
masvs_category: MASVS-RESILIENCE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0039: Testing whether the App is Debuggable

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing whether the App is Debuggable」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Check AndroidManifest.xml to determine whether the android:debuggable attribute has been set and to find the attribute's value:
* メタ: profiles: R; covered_by: MASTG-TEST-0226, MASTG-TEST-0227; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0039/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing whether the App is Debuggableのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing whether the App is Debuggableのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing whether the App is Debuggableのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Check AndroidManifest.xml to determine whether the android:debuggable attribute has been set and to find the attribute's value:
* [Static] You can use aapt tool from the Android SDK with the following command line to quickly check if the android:debuggable="true" directive is present:
* [Static] $ aapt d xmltree sieve.apk AndroidManifest.xml | grep -Ec "android:debuggable\(0x[0-9a-f]+\)=\(type\s0x[0-9a-f]+\)0xffffffff"
* [Static] For a release build, this attribute should always be set to "false" (the default value).
* [Dynamic] adb can be used to determine whether an application is debuggable.
* [Dynamic] Use the following command:
* [Dynamic] $ adb shell dumpsys package com.mwr.example.sieve | grep -c "DEBUGGABLE"
* [Dynamic] $ adb shell dumpsys package com.nondebuggableapp | grep -c "DEBUGGABLE"
合否（Evaluation）の要点:
* Check AndroidManifest.xml to determine whether the android:debuggable attribute has been set and to find the attribute's value:
* You can use aapt tool from the Android SDK with the following command line to quickly check if the android:debuggable="true" directive is present:
* For a release build, this attribute should always be set to "false" (the default value).
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 後継: MASTG-TEST-0226, MASTG-TEST-0227
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 難読化有無だけでセキュリティ完了とする

* 理由: MASVS-RESILIENCE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 難読化有無だけでセキュリティ完了とする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0039 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0039/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
