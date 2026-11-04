---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0057/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0057
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0057: Sanitize Data Coming from External Components

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Sanitize Data Coming from External Components」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: All data received from external sources (such as Intent extras, activity results, or ContentProvider results) must be treated as untrusted and thoroughly sanitized before use. Failure to validate this data can lead to serious vulnerabilities, including arbitrary file access an...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0057/>
* 関連 Knowledge: `MASTG-KNOW-0025`, `MASTG-KNOW-0138`
* 索引: [`../0000-index.md`](../0000-index.md)

## Sanitize Data Coming from External Componentsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Sanitize Data Coming from External Componentsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Sanitize Data Coming from External Componentsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* All data received from external sources (such as Intent extras, activity results, or ContentProvider results) must be treated as untrusted and thoroughly sanitized before use. Failure to validate this data can lead to serious vulnerabilities, including arbitrary file access and path traversal. Specifically, applications must always validate URIs and associated metadata before reading from them, copying their content, or passing them to sensitive system APIs.
* Prefer content:// URIs over file:// URIs when processing externally supplied data. A content:// URI routes access through a ContentProvider when opened with ContentResolver.openInputStream), allowing provider-level access controls and URI grants to apply. A file:// URI is resolved directly as a filesystem path using the calling app's own process identity and permissions. This means a malicious responding app can return a file:// URI pointing at any path the calling app can access, which, depending on the permissions the app holds, may go well beyond its own private storage. See @MASTG-KNOW-0138 for details on URI schemes in intent results.
* 公式記事内のコード例言語: kotlin
```

## ナレッジベース

### DO: Sanitize Data Coming from External Components を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Sanitize Data Coming from External Components を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0025, MASTG-KNOW-0138）と合わせてレビューする
- All data received from external sources (such as Intent extras, activity results, or ContentProvider results) must be treated as untrusted and thoroughly sanitized before use. Failure to validate this data can lead to serious vulnerabilities, including arbitrary file access and path traversal. Specifically, applications must always validate URIs and associated metadata before reading from them, copying their content, or passing them to sensitive system APIs.
- Prefer content:// URIs over file:// URIs when processing externally supplied data. A content:// URI routes access through a ContentProvider when opened with ContentResolver.openInputStream), allowing provider-level access controls and URI grants to apply. A file:// URI is resolved directly as a filesystem path using the calling app's own process identity and permissions. This means a malicious responding app can return a file:// URI pointing at any path the calling app can access, which, depending on the permissions the app holds, may go well beyond its own private storage. See @MASTG-KNOW-0138 for details on URI schemes in intent results.
```

### DO NOT: MASTG-BEST-0057 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 外部入力を信頼し検証なしで処理する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0057 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0057/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
