---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0035/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0035
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0035: Prefer Origin Scoped Messaging Over Legacy JavaScript Bridges

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Prefer Origin Scoped Messaging Over Legacy JavaScript Bridges」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: JavaScript bridges are not inherently unsafe, but they are a high-impact WebView feature and should only be exposed to content you fully trust. The main risk is not the bridge alone, but the combination of a bridge with untrusted or weakly validated content.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0035/>
* 関連 Knowledge: `MASTG-KNOW-0018`
* 索引: [`../0000-index.md`](../0000-index.md)

## Prefer Origin Scoped Messaging Over Legacy JavaScript Bridgesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Prefer Origin Scoped Messaging Over Legacy JavaScript Bridgesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Prefer Origin Scoped Messaging Over Legacy JavaScript Bridgesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* JavaScript bridges are not inherently unsafe, but they are a high-impact WebView feature and should only be exposed to content you fully trust. The main risk is not the bridge alone, but the combination of a bridge with untrusted or weakly validated content.
* The legacy addJavascriptInterface mechanism is exposed to every frame in the WebView, including iframes, and does not provide origin-based access control. This makes it unsuitable as a security boundary when the WebView may render untrusted or weakly validated content.
* expose only the specific operations the page needs
* avoid broad utility objects or generic command dispatchers
* do not expose sensitive capabilities unless they are essential
* require simple, well-defined message formats
* reject unexpected inputs and unsupported actions
```

## ナレッジベース

### DO: Prefer Origin Scoped Messaging Over Legacy JavaScript Bridges を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Prefer Origin Scoped Messaging Over Legacy JavaScript Bridges を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0018）と合わせてレビューする
- JavaScript bridges are not inherently unsafe, but they are a high-impact WebView feature and should only be exposed to content you fully trust. The main risk is not the bridge alone, but the combination of a bridge with untrusted or weakly validated content.
- The legacy addJavascriptInterface mechanism is exposed to every frame in the WebView, including iframes, and does not provide origin-based access control. This makes it unsuitable as a security boundary when the WebView may render untrusted or weakly validated content.
- expose only the specific operations the page needs
```

### DO NOT: MASTG-BEST-0035 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- レガシーな広い JS ブリッジを新規採用する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0035 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0035/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
