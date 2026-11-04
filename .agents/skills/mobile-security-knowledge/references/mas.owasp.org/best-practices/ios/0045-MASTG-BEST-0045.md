---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0045/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0045
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0045: Limit Sensitive Data Exposure Through iOS IPC Channels

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Limit Sensitive Data Exposure Through iOS IPC Channels」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When your app exchanges data across iOS IPC channels, share the minimum amount of data for the shortest time possible. Design these flows so that intercepted payloads are low value and short lived. Follow the principle of least privilege: grant each IPC channel and shared cont...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0045/>
* 関連 Knowledge: `MASTG-KNOW-0083`, `MASTG-KNOW-0079`, `MASTG-KNOW-0080`, `MASTG-KNOW-0081`, `MASTG-KNOW-0082`, `MASTG-KNOW-0122`, `MASTG-KNOW-0123`, `MASTG-KNOW-0124`, `MASTG-KNOW-0125`, `MASTG-KNOW-0126`, `MASTG-KNOW-0127`, `MASTG-KNOW-0128`, `MASTG-KNOW-0129`, `MASTG-KNOW-0130`, `MASTG-KNOW-0131`, `MASTG-KNOW-0104`
* 索引: [`../0000-index.md`](../0000-index.md)

## Limit Sensitive Data Exposure Through iOS IPC Channelsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Limit Sensitive Data Exposure Through iOS IPC Channelsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Limit Sensitive Data Exposure Through iOS IPC Channelsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When your app exchanges data across iOS IPC channels, share the minimum amount of data for the shortest time possible. Design these flows so that intercepted payloads are low value and short lived. Follow the principle of least privilege: grant each IPC channel and shared container only the minimum permissions required for its intended purpose, and validate all inbound data as untrusted input.
* For guidance on channel behavior, see @MASTG-KNOW-0078.
```

## ナレッジベース

### DO: Limit Sensitive Data Exposure Through iOS IPC Channels を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Limit Sensitive Data Exposure Through iOS IPC Channels を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0083, MASTG-KNOW-0079, MASTG-KNOW-0080, MASTG-KNOW-0081, MASTG-KNOW-0082, MASTG-KNOW-0122, MASTG-KNOW-0123, MASTG-KNOW-0124, MASTG-KNOW-0125, MASTG-KNOW-0126, MASTG-KNOW-0127, MASTG-KNOW-0128, MASTG-KNOW-0129, MASTG-KNOW-0130, MASTG-KNOW-0131, MASTG-KNOW-0104）と合わせてレビューする
- When your app exchanges data across iOS IPC channels, share the minimum amount of data for the shortest time possible. Design these flows so that intercepted payloads are low value and short lived. Follow the principle of least privilege: grant each IPC channel and shared container only the minimum permissions required for its intended purpose, and validate all inbound data as untrusted input.
- For guidance on channel behavior, see @MASTG-KNOW-0078.
```

### DO NOT: MASTG-BEST-0045 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- IPC 経由で機微データを過剰公開する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0045 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0045/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
