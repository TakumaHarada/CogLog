---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0005/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0005
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0005: Use Secure Encryption Modes

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Secure Encryption Modes」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Replace insecure encryption modes with secure block cipher modes such as AES-GCM or AES-CCM which are authenticated encryption modes that provide confidentiality, integrity, and authenticity.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0005/>
* 関連 Knowledge: （未リンク）
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Secure Encryption Modesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Secure Encryption Modesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Secure Encryption Modesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Replace insecure encryption modes with secure block cipher modes such as AES-GCM or AES-CCM which are authenticated encryption modes that provide confidentiality, integrity, and authenticity.
* We recommend avoiding CBC, which while being more secure than ECB, improper implementation, especially incorrect padding, can lead to vulnerabilities such as padding oracle attacks.
```

## ナレッジベース

### DO: Use Secure Encryption Modes を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Secure Encryption Modes を該当機能に適用する
- Replace insecure encryption modes with secure block cipher modes such as AES-GCM or AES-CCM which are authenticated encryption modes that provide confidentiality, integrity, and authenticity.
- We recommend avoiding CBC, which while being more secure than ECB, improper implementation, especially incorrect padding, can lead to vulnerabilities such as padding oracle attacks.
```

### DO NOT: MASTG-BEST-0005 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- ECB 等の不安全なモードを採用する
- IV / nonce を固定・再利用する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0005 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0005/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
