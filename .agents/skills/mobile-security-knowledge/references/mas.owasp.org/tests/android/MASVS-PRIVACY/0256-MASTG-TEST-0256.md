---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0256/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - privacy
  - profile-p
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0256
masvs_category: MASVS-PRIVACY
platform: android
status: placeholder
upstream_revision: d7fd7d4
---

# MASTG-TEST-0256: Missing Permission Rationale

## 概要

* 本ドキュメントは OWASP MASTG Test「Missing Permission Rationale」（Android / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは placeholder である。手順が未充足の可能性があるため、単独の準拠根拠にしない。
* 要旨: This test checks if the app does not provide a rationale for requesting permissions. See <https://developer.android.com/training/permissions/requesting#explain> and <https://developer.android.com/training/permissions/explaining-access#privacy-dashboard-show-rationale>
* メタ: profiles: P; weakness: MASWE-0066; knowledge: MASTG-KNOW-0017
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0256/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Missing Permission Rationaleのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Missing Permission Rationaleのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Missing Permission Rationaleのテスト実施の実装例

```text
公式記事の Overview / Static / Dynamic を読み、再現可能な手順へ落とす。
* note: This test checks if the app does not provide a rationale for requesting permissions. See https://developer.android.com/training/permissions/requesting#explain and https://developer.android.com/training/permissions/explai
```

## ナレッジベース

### DO: 権限・収集・申告の一致を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 権限・収集・申告の一致を確認する
- 関連弱点 MASWE-0066 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ストア文言だけで privacy pass にする

* 理由: MASVS-PRIVACY の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ストア文言だけで privacy pass にする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0256 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0256/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
