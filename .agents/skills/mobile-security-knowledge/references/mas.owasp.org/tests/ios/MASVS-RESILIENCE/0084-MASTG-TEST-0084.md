---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0084/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - resilience
  - profile-r
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0084
masvs_category: MASVS-RESILIENCE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0084: Testing for Debugging Code and Verbose Error Logging

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for Debugging Code and Verbose Error Logging」（iOS / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: You can take the following static analysis approach for the logging statements:
* メタ: profiles: R; covered_by: MASTG-TEST-0358, MASTG-TEST-0359; deprecation_note: "New version available in MASTG v2"
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0084/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for Debugging Code and Verbose Error Loggingのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for Debugging Code and Verbose Error Loggingのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for Debugging Code and Verbose Error Loggingのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] You can take the following static analysis approach for the logging statements:
* [Static] Import the application's code into Xcode.
* [Static] Search the code for the following printing functions: NSLog, println, print, dump, debugPrint.
* [Static] When you find one of them, determine whether the developers used a wrapping function around the logging function for better mark up of the statements to be logged; if so, add that function to your search.
* [Static] For every result of steps 2 and 3, determine whether macros or debug-state related guards have been set to turn the logging off in the release build. Please note the change in how Objective-C can use preproce...
* [Dynamic] Dynamic analysis should be executed on both a simulator and a device because developers sometimes use target-based functions (instead of functions based on a release/debug-mode) to execute the debugging code.
* [Dynamic] Run the application on a simulator and check for output in the console during the app's execution.
* [Dynamic] Attach a device to your Mac, run the application on the device via Xcode, and check for output in the console during the app's execution.
合否（Evaluation）の要点:
* For the "debug-management" code (which is built-in): inspect the storyboards to see whether there are any flows and/or view-controllers that provide functionality different from the functionality the application shoul...
* As a developer, incorporating debug statements into your application's debug version should not be a problem as long as you make sure that the debug statements are never present in the application's release version.
* Dynamic analysis should be executed on both a simulator and a device because developers sometimes use target-based functions (instead of functions based on a release/debug-mode) to execute the debugging code.
* Run the application on a simulator and check for output in the console during the app's execution.
* Attach a device to your Mac, run the application on the device via Xcode, and check for output in the console during the app's execution.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 後継: MASTG-TEST-0358, MASTG-TEST-0359
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
- MASTG-TEST-0084 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0084/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
