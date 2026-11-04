---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0034/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0034
masvs_category: MASVS-CODE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0034: Testing Object Persistence

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Object Persistence」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for object persistence being used for storing sensitive information on the device, first identify all instances of object serialization and check if they carry any sensitive data. If yes, check if it is properly protected against eavesdropping or unauthorized modification.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0337; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0034/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Object Persistenceのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Object Persistenceのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Object Persistenceのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Search the source code for the following keywords:
* [Static] import java.io.Serializable
* [Static] implements Serializable
* [Static] If you need to counter memory-dumping, make sure that very sensitive information is not stored in the JSON format because you can't guarantee prevention of anti-memory dumping techniques with the standard lib...
* [Static] JSONObject Search the source code for the following keywords:
* [Dynamic] There are several ways to perform dynamic analysis:
* [Dynamic] For the actual persistence: Use the techniques described in the data storage chapter.
* [Dynamic] For reflection-based approaches: Use MASTG-TOOL-0001 to hook into the deserialization methods or add unprocessable information to the serialized objects to see how they are handled (e.g., whether the applica...
合否（Evaluation）の要点:
* To test for object persistence being used for storing sensitive information on the device, first identify all instances of object serialization and check if they carry any sensitive data. If yes, check if it is proper...
* Make sure that the keys used in step 1 can't be extracted easily. The user and/or application instance should be properly authenticated/authorized to obtain the keys. See the chapter "Data Storage on Android" for more...
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 後継: MASTG-TEST-0337
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ビルド設定を見ずにコードレビューだけで完了する

* 理由: MASVS-CODE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ビルド設定を見ずにコードレビューだけで完了する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0034 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0034/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
