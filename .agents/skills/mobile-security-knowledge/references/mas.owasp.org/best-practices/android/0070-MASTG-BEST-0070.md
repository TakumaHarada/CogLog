---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0070/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0070
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0070: Verify Android App Links with autoVerify and Digital Asset Links

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Verify Android App Links with autoVerify and Digital Asset Links」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When your app handles http/https deep links, declare them as Android App Links so the OS verifies that your app owns the target domain. Without verification, any other app can register the same intent filter and intercept the links (see @MASTG-KNOW-0019).

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0070/>
* 関連 Knowledge: `MASTG-KNOW-0019`
* 索引: [`../0000-index.md`](../0000-index.md)

## Verify Android App Links with autoVerify and Digital Asset Linksを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Verify Android App Links with autoVerify and Digital Asset Linksを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Verify Android App Links with autoVerify and Digital Asset Linksを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When your app handles http/https deep links, declare them as Android App Links so the OS verifies that your app owns the target domain. Without verification, any other app can register the same intent filter and intercept the links (see @MASTG-KNOW-0019).
* Set android:autoVerify="true" on every <intent-filter> that declares an http/https deep link. This tells Android to confirm the domain association before routing matching links to your app.
* Served over HTTPS, without redirects (a redirect from http to https or example.com to www.example.com causes verification to fail).
* Valid JSON that includes the target app's package.
* Present on every host declared in the intent filters, including each subdomain, and at the root domain when a wildcard host is used.
* 公式記事内のコード例言語: xml
```

## ナレッジベース

### DO: Verify Android App Links with autoVerify and Digital Asset Links を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Verify Android App Links with autoVerify and Digital Asset Links を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0019）と合わせてレビューする
- When your app handles http/https deep links, declare them as Android App Links so the OS verifies that your app owns the target domain. Without verification, any other app can register the same intent filter and intercept the links (see @MASTG-KNOW-0019).
- Set android:autoVerify="true" on every <intent-filter> that declares an http/https deep link. This tells Android to confirm the domain association before routing matching links to your app.
- Served over HTTPS, without redirects (a redirect from http to https or example.com to www.example.com causes verification to fail).
```

### DO NOT: MASTG-BEST-0070 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 外部入口の入力検証・送信元検証を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0070 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0070/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
