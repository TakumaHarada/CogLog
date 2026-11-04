---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0329/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - auth
  - backend
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0329
masvs_category: MASVS-AUTH
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0329: References to APIs Enforcing Authentication without Explicit User Action

## 概要

* 本ドキュメントは OWASP MASTG Test「References to APIs Enforcing Authentication without Explicit User Action」（Android / 認証・認可）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: This test checks if the app enforces biometric authentication (MASTG-KNOW-0001) without requiring explicit user action. When using android.hardware.biometrics.BiometricPrompt API (or its Jetpack counterpart androidx.biometric.BiometricPrompt that backward compatibility to API level 23), the setConfirmationRequired()) method in BiometricPrompt.Builder controls whether the user must explicitly confirm their authentication, which is enforced by d...
* メタ: type: static, code; profiles: L2; weakness: MASWE-0020; knowledge: MASTG-KNOW-0001
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0329/>
* 関連制御群: `MASVS-AUTH`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to APIs Enforcing Authentication without Explicit User Actionのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to APIs Enforcing Authentication without Explicit User Actionのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to APIs Enforcing Authentication without Explicit User Actionのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for the relevant APIs.
合否（Evaluation）の要点:
* The test case fails if the app sets setConfirmationRequired() to false for sensitive operations that require explicit user authorization.
* Using setConfirmationRequired(false) is not inherently a vulnerability. It may be appropriate for low-risk operations, but for sensitive operations like payments or data access, the app should use setConfirmationRequi...
* 観測期待: The output should include a list of locations where the relevant APIs are used.
```

## ナレッジベース

### DO: 認証・認可の最終判定をサーバ側で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 認証・認可の最終判定をサーバ側で確認する
- ローカル認証成功ブール alone で機微操作を通さない
- 関連弱点 MASWE-0020 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: クライアント申告のロールを信頼する

* 理由: MASVS-AUTH の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- クライアント申告のロールを信頼する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0329 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0329/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
