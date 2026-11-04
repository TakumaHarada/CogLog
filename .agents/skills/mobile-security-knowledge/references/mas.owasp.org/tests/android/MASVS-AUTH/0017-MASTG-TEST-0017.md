---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0017/
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
mastg_test_id: MASTG-TEST-0017
masvs_category: MASVS-AUTH
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0017: Testing Confirm Credentials

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Confirm Credentials」（Android / 認証・認可）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Make sure that the unlocked key is used during the application flow. For example, the key may be used to decrypt local storage or a message received from a remote endpoint. If the application simply checks whether the user has unlocked the key or not, the application may be vulnerable to a local authentication bypass.
* メタ: profiles: L2; covered_by: MASTG-TEST-0327, MASTG-TEST-0330; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0017/>
* 関連制御群: `MASVS-AUTH`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Confirm Credentialsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Confirm Credentialsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Confirm Credentialsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Make sure that the unlocked key is used during the application flow. For example, the key may be used to decrypt local storage or a message received from a remote endpoint. If the application simply checks wh...
* [Dynamic] Validate the duration of time (seconds) for which the key is authorized to be used after the user is successfully authenticated. This is only needed if setUserAuthenticationRequired is used.
合否（Evaluation）の要点:
* Make sure that the unlocked key is used during the application flow. For example, the key may be used to decrypt local storage or a message received from a remote endpoint. If the application simply checks whether the...
```

## ナレッジベース

### DO: 認証・認可の最終判定をサーバ側で確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 認証・認可の最終判定をサーバ側で確認する
- ローカル認証成功ブール alone で機微操作を通さない
- 後継: MASTG-TEST-0327, MASTG-TEST-0330
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
- MASTG-TEST-0017 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-AUTH/MASTG-TEST-0017/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
