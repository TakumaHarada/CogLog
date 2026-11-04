---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0338/
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
mastg_test_id: MASTG-TEST-0338
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0338: References to Storage Integrity Check APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Storage Integrity Check APIs」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Android apps can protect the integrity and authenticity of data they store on the device (e.g., in SharedPreferences, files, or databases) by computing an HMAC or a digital signature over the data and verifying it before use (see MASTG-KNOW-0036). If the app does not implement such checks, an attacker who modifies the stored data can go undetected and the app may trust the tampered input in a security-relevant decision.
* メタ: type: static, code, manual; profiles: R; weakness: MASWE-0057; knowledge: MASTG-KNOW-0036
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0338/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Storage Integrity Check APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Storage Integrity Check APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Storage Integrity Check APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if the app uses data loaded from local storage (SharedPreferences, files, or databases) in a security-relevant decision without verifying its integrity and authenticity beforehand.
* Further Validation Required:
* These APIs are commonly used for unrelated purposes (for example, networking, analytics, or generic checksums), so their mere presence does not confirm a storage integrity mechanism. Inspect each reported code locatio...
* Determine whether the loaded value can influence a security-relevant decision, such as authentication state, authorization, feature access, configuration, or trust decisions.
* Determine whether the app computes an HMAC or signature over the data it reads back from local storage, and verifies it before use, reacting when verification fails.
* Determine whether that validation is effective for the attacker model in scope.
* 観測期待: The output should contain a list of code locations where the relevant APIs are used. Depending on the storage API and the analysis rule, these locations may include storage read APIs such as SharedPreferences.getString, 
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 関連弱点 MASWE-0057 の有無をチケットへ併記する
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
- MASTG-TEST-0338 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0338/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
