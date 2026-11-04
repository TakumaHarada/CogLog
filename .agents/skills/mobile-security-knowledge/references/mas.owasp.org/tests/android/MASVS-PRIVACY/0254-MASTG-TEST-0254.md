---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0254/
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
mastg_test_id: MASTG-TEST-0254
masvs_category: MASVS-PRIVACY
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0254: Dangerous App Permissions

## 概要

* 本ドキュメントは OWASP MASTG Test「Dangerous App Permissions」（Android / プライバシー）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: In Android apps, permissions are acquired through different methods to access information and system functionalities, including the camera, location, or storage. The necessary permissions are specified in the AndroidManifest.xml file with tags.
* メタ: type: static, code; profiles: P; weakness: MASWE-0066; knowledge: MASTG-KNOW-0017
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0254/>
* 関連制御群: `MASVS-PRIVACY`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Dangerous App Permissionsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Dangerous App Permissionsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Dangerous App Permissionsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0117 to obtain the AndroidManifest.xml.
* Use MASTG-TECH-0126 to obtain the list of declared permissions.
合否（Evaluation）の要点:
* The test case fails if there are any dangerous permissions in the app.
* Compare the list of declared permissions with the list of dangerous permissions defined by Android. You can find more details in the Android documentation.
* Context Consideration:
* Context is essential when evaluating permissions. For example, an app that uses the camera to scan QR codes should have the CAMERA permission. However, if the app does not have a camera feature, the permission is unne...
* Also, consider if there are any privacy-preserving alternatives to the permissions used by the app. For example, instead of using the CAMERA permission, the app could use the device's built-in camera app to capture ph...
* 観測期待: The output should contain the list of permissions declared by the app.
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
- MASTG-TEST-0254 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0254/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
