---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0039/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0039
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0039: Prevent SQL Injection in ContentProviders

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Prevent SQL Injection in ContentProviders」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: The ContentProvider enables Android applications to share data with other applications and system components. If a ContentProvider constructs SQL queries using untrusted input from URIs, IPC calls, or Intents without validation or parameterization, it becomes vulnerable to SQL...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0039/>
* 関連 Knowledge: `MASTG-KNOW-0117`
* 索引: [`../0000-index.md`](../0000-index.md)

## Prevent SQL Injection in ContentProvidersを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Prevent SQL Injection in ContentProvidersを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Prevent SQL Injection in ContentProvidersを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* The ContentProvider enables Android applications to share data with other applications and system components. If a ContentProvider constructs SQL queries using untrusted input from URIs, IPC calls, or Intents without validation or parameterization, it becomes vulnerable to SQL injection. Attackers can take advantage of this vulnerability to bypass access controls and extract sensitive data. Improper handling of URI path segments, query parameters, or selection arguments in ContentProvider queries can lead to arbitrary SQL execution.
* Use Parameterized Queries: Instead of building SQL using string concatenation, use selection and selectionArgs parameters.
* Use Prepared Statements: When performing insert, update, or delete operations, use SQLite prepared statements (for example, SQLiteStatement or SQLiteDatabase methods that support argument binding) instead of dynamically constructed SQL. Prepared statements ensure that untrusted input is bound as parameters and cannot alter the structure of the SQL query, effectively preventing SQL injection even when input originates from URIs or IPC calls.
* 公式記事内のコード例言語: kotlin
```

## ナレッジベース

### DO: Prevent SQL Injection in ContentProviders を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Prevent SQL Injection in ContentProviders を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0117）と合わせてレビューする
- The ContentProvider enables Android applications to share data with other applications and system components. If a ContentProvider constructs SQL queries using untrusted input from URIs, IPC calls, or Intents without validation or parameterization, it becomes vulnerable to SQL injection. Attackers can take advantage of this vulnerability to bypass access controls and extract sensitive data. Improper handling of URI path segments, query parameters, or selection arguments in ContentProvider queries can lead to arbitrary SQL execution.
- Use Parameterized Queries: Instead of building SQL using string concatenation, use selection and selectionArgs parameters.
- Use Prepared Statements: When performing insert, update, or delete operations, use SQLite prepared statements (for example, SQLiteStatement or SQLiteDatabase methods that support argument binding) instead of dynamically constructed SQL. Prepared statements ensure that untrusted input is bound as parameters and cannot alter the structure of the SQL query, effectively preventing SQL injection even when input originates from URIs or IPC calls.
```

### DO NOT: MASTG-BEST-0039 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- ContentProvider で selection を文字列連結する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0039 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0039/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
