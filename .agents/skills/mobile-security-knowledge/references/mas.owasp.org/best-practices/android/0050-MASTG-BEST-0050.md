---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0050/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0050
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0050: Store Data Encrypted in App Sandbox Directory

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Store Data Encrypted in App Sandbox Directory」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Store sensitive data in SharedPreferences only after encrypting it. Standard SharedPreferences stores values in XML files inside the app's private data directory, so values such as credentials, authentication tokens, private keys, or personally identifiable information (PII) s...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0050/>
* 関連 Knowledge: `MASTG-KNOW-0036`
* 索引: [`../0000-index.md`](../0000-index.md)

## Store Data Encrypted in App Sandbox Directoryを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Store Data Encrypted in App Sandbox Directoryを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Store Data Encrypted in App Sandbox Directoryを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Store sensitive data in SharedPreferences only after encrypting it. Standard SharedPreferences stores values in XML files inside the app's private data directory, so values such as credentials, authentication tokens, private keys, or personally identifiable information (PII) should not be stored in cleartext.
* For apps that use SharedPreferences, use EncryptedSharedPreferences or an equivalent mechanism that encrypts preference keys and values before they are written to disk. An equivalent mechanism should use authenticated encryption, protect encryption keys with the Android Keystore or another appropriate key management system, and avoid custom cryptography.
```

## ナレッジベース

### DO: Store Data Encrypted in App Sandbox Directory を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Store Data Encrypted in App Sandbox Directory を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0036）と合わせてレビューする
- Store sensitive data in SharedPreferences only after encrypting it. Standard SharedPreferences stores values in XML files inside the app's private data directory, so values such as credentials, authentication tokens, private keys, or personally identifiable information (PII) should not be stored in cleartext.
- For apps that use SharedPreferences, use EncryptedSharedPreferences or an equivalent mechanism that encrypts preference keys and values before they are written to disk. An equivalent mechanism should use authenticated encryption, protect encryption keys with the Android Keystore or another appropriate key management system, and avoid custom cryptography.
```

### DO NOT: MASTG-BEST-0050 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- サンドボックス外や平文で機微データを保存する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0050 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0050/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
