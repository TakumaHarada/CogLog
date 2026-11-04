---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0018/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0018
platform: android
status: placeholder
upstream_revision: d7fd7d4
---

# MASTG-BEST-0018: Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは placeholder である。新規採用の完了根拠にしない。詳細手順・コード例は公式記事を正本とする。
* 要旨: Preventing screenshots and screen recording helps protect sensitive data from being exposed in system-generated snapshots and recordings.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0018/>
* 関連 Knowledge: （未リンク）
* 索引: [`../0000-index.md`](../0000-index.md)

## Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components（placeholder）の意図を把握し、current 化を待つ

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components（placeholder）の意図を把握し、current 化を待つの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components（placeholder）の意図を把握し、current 化を待つの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* 公式 BEST `MASTG-BEST-0018` の現行本文に従う
* ノート: Preventing screenshots and screen recording helps protect sensitive data from being exposed in system-generated snapshots and recordings.
```

## ナレッジベース

### DO: Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use `SecureFlagPolicy.SecureOn` to Prevent Screenshots in Compose Components を該当機能に適用する
```

### DO NOT: MASTG-BEST-0018 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 機微画面で FLAG_SECURE / 同等保護を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0018 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0018/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
