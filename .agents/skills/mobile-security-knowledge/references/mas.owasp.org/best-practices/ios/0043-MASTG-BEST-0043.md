---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0043/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0043
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0043: Enforce Strong TLS Settings When ATS Doesn't Apply

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Enforce Strong TLS Settings When ATS Doesn't Apply」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: App Transport Security (ATS) only protects connections made through the URL Loading System (URLSession and related Foundation APIs). When your app uses Network.framework, CFNetwork, BSD sockets, or a bundled third-party TLS library, ATS doesn't apply and you're responsible for...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0043/>
* 関連 Knowledge: `MASTG-KNOW-0073`
* 索引: [`../0000-index.md`](../0000-index.md)

## Enforce Strong TLS Settings When ATS Doesn't Applyを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Enforce Strong TLS Settings When ATS Doesn't Applyを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Enforce Strong TLS Settings When ATS Doesn't Applyを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* App Transport Security (ATS) only protects connections made through the URL Loading System (URLSession and related Foundation APIs). When your app uses Network.framework, CFNetwork, BSD sockets, or a bundled third-party TLS library, ATS doesn't apply and you're responsible for configuring strong TLS settings explicitly. Apple's documentation states that "ATS doesn't apply to calls your app makes to lower-level networking interfaces like the Network framework or CFNetwork. In these cases, you take responsibility for ensuring the security of the connection." See Preventing Insecure Network Connections.
* When possible, prefer URLSession and high-level Foundation APIs so that ATS protections apply automatically. See @MASTG-BEST-0042.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Enforce Strong TLS Settings When ATS Doesn't Apply を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Enforce Strong TLS Settings When ATS Doesn't Apply を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0073）と合わせてレビューする
- App Transport Security (ATS) only protects connections made through the URL Loading System (URLSession and related Foundation APIs). When your app uses Network.framework, CFNetwork, BSD sockets, or a bundled third-party TLS library, ATS doesn't apply and you're responsible for configuring strong TLS settings explicitly. Apple's documentation states that "ATS doesn't apply to calls your app makes to lower-level networking interfaces like the Network framework or CFNetwork. In these cases, you take responsibility for ensuring the security of the connection." See Preventing Insecure Network Connections.
- When possible, prefer URLSession and high-level Foundation APIs so that ATS protections apply automatically. See @MASTG-BEST-0042.
```

### DO NOT: MASTG-BEST-0043 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- ATS / TLS を全面緩和したまま本番公開する
- 証明書検証をスキップする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0043 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0043/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
