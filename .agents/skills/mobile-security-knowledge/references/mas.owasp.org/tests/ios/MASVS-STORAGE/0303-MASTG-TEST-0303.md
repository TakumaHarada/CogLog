---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0303/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - storage
  - backend
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0303
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0303: References to APIs for Storing Unencrypted Data in Shared Storage

## 概要

* 本ドキュメントは OWASP MASTG Test「References to APIs for Storing Unencrypted Data in Shared Storage」（iOS / データ保存）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks whether the app stores sensitive data without encryption in iOS sandbox locations that may become user accessible when file sharing is enabled.
* メタ: type: static, code; profiles: L1, L2; weakness: MASWE-0002; knowledge: MASTG-KNOW-0122, MASTG-KNOW-0091, MASTG-KNOW-0057, MASTG-KNOW-0108
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0303/>
* 関連制御群: `MASVS-STORAGE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to APIs for Storing Unencrypted Data in Shared Storageのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to APIs for Storing Unencrypted Data in Shared Storageのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to APIs for Storing Unencrypted Data in Shared Storageのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0058 to extract the relevant binaries from app package.
* Use MASTG-TECH-0066 to look for the relevant APIs in the app binaries.
* Use MASTG-TECH-0153 to retrieve the Info.plist file.
* Use MASTG-TECH-0154 to check for the UIFileSharingEnabled and LSSupportsOpeningDocumentsInPlace flags.
合否（Evaluation）の要点:
* The test case fails if:
* The app writes unencrypted sensitive data to documentDirectory (or equivalent shared storage path), and
* Info.plist enables user access to the Documents directory (UIFileSharingEnabled and/or LSSupportsOpeningDocumentsInPlace).
* Note: documentDirectory by itself is not inherently insecure; the risk arises when sensitive data is stored there and exposed via file sharing or Files app access. In contrast, data stored in other locations within th...
* 観測期待: The output should contain:
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
- MASTG-TEST-0303 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0303/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
