---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0081/
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
mastg_test_id: MASTG-TEST-0081
masvs_category: MASVS-RESILIENCE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0081: Making Sure that the App Is Properly Signed

## 概要

* 本ドキュメントは OWASP MASTG Test「Making Sure that the App Is Properly Signed」（iOS / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: You have to ensure that the app is using the latest code signature format. You can retrieve the signing certificate information from the application's .app file with MASTG-TOOL-0114. Codesign is used to create, check, and display code signatures, as well as inquire into the dynamic status of signed code in the system.
* メタ: profiles: R; covered_by: MASTG-TEST-0220; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0081/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Making Sure that the App Is Properly Signedのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Making Sure that the App Is Properly Signedのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Making Sure that the App Is Properly Signedのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] You have to ensure that the app is using the latest code signature format. You can retrieve the signing certificate information from the application's .app file with MASTG-TOOL-0114. Codesign is used to creat...
* [Static] After you get the application's IPA file, re-save it as a ZIP file and decompress the ZIP file. Navigate to the Payload directory, where the application's .app file will be.
* [Static] Execute the following codesign command to display the signing information:
* [Static] $ codesign -dvvv YOURAPP.app
* [Static] Executable=/Users/Documents/YOURAPP/Payload/YOURAPP.app/YOURNAME
合否（Evaluation）の要点:
* You have to ensure that the app is using the latest code signature format. You can retrieve the signing certificate information from the application's .app file with MASTG-TOOL-0114. Codesign is used to create, check,...
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 後継: MASTG-TEST-0220
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
- MASTG-TEST-0081 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-RESILIENCE/MASTG-TEST-0081/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
