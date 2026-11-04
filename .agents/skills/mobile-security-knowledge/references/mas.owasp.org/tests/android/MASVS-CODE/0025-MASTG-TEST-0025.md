---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0025/
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
mastg_test_id: MASTG-TEST-0025
masvs_category: MASVS-CODE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0025: Testing for Injection Flaws

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing for Injection Flaws」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: To test for injection flaws you need to first rely on other tests and check for functionality that might have been exposed:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0339; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0025/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing for Injection Flawsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing for Injection Flawsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing for Injection Flawsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] An example of a vulnerable IPC mechanism is shown below.
* [Static] You can use _ContentProviders_ to access database information, and you can probe services to see if they return data. If data is not validated properly, the content provider may be prone to SQL injection whil...
* [Static] android:name=".OMTG_CODING_003_SQL_Injection_Content_Provider_Implementation"
* [Static] android:authorities="sg.vp.owasp_mobile.provider.College">
* [Static] The AndroidManifest.xml above defines a content provider that's exported and therefore available to all other apps. The query function in the OMTG_CODING_003_SQL_Injection_Content_Provider_Implementation.java...
* [Dynamic] The tester should manually test the input fields with strings like OR 1=1-- if, for example, a local SQL injection vulnerability has been identified.
* [Dynamic] On a rooted device, the command content can be used to query the data from a content provider. The following command queries the vulnerable function described above.
* [Dynamic] SQL injection can be exploited with the following command. Instead of getting the record for Bob only, the user can retrieve all data.
合否（Evaluation）の要点:
* To test for injection flaws you need to first rely on other tests and check for functionality that might have been exposed:
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 後継: MASTG-TEST-0339
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
- MASTG-TEST-0025 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0025/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
