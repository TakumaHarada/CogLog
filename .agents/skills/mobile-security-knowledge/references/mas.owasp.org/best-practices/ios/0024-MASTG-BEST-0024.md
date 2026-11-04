---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0024/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0024
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0024: Store Data Encrypted in App Sandbox Directory

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Store Data Encrypted in App Sandbox Directory」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Choose the right location for storing the app's and the user's data to the app sandbox: use Documents directory to store user-generated content and Library directory for app's internal data.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0024/>
* 関連 Knowledge: `MASTG-KNOW-0108`
* 索引: [`../0000-index.md`](../0000-index.md)

## Store Data Encrypted in App Sandbox Directoryを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Store Data Encrypted in App Sandbox Directoryを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Store Data Encrypted in App Sandbox Directoryを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Choose the right location for storing the app's and the user's data to the app sandbox: use Documents directory to store user-generated content and Library directory for app's internal data.
* An app can be configured to make Documents directory accessible to the user in the Files app by setting UIFileSharingEnabled and LSSupportsOpeningDocumentsInPlace. Therefore, storing databases, config files, purchase state in this directory is highly dangerous because:
* a user can tamper with internal app files
* an attacker with a physical access to the device can copy content of Documents directory
* other apps can access Documents directory of other apps with a document picker interface
```

## ナレッジベース

### DO: Store Data Encrypted in App Sandbox Directory を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Store Data Encrypted in App Sandbox Directory を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0108）と合わせてレビューする
- Choose the right location for storing the app's and the user's data to the app sandbox: use Documents directory to store user-generated content and Library directory for app's internal data.
- An app can be configured to make Documents directory accessible to the user in the Files app by setting UIFileSharingEnabled and LSSupportsOpeningDocumentsInPlace. Therefore, storing databases, config files, purchase state in this directory is highly dangerous because:
- a user can tamper with internal app files
```

### DO NOT: MASTG-BEST-0024 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- サンドボックス外や平文で機微データを保存する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0024 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0024/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
