---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0061/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0061
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0061: Use WKContentWorld Isolation for DOM Inspection Scripts

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use WKContentWorld Isolation for DOM Inspection Scripts」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When an app uses evaluateJavaScript(_:completionHandler:)) or WKUserScript to read data from the DOM (for example, to extract form field values, account details, or page metadata), that code runs in the .page world by default. In the .page world, all built-in prototypes are sh...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0061/>
* 関連 Knowledge: `MASTG-KNOW-0076`, `MASTG-KNOW-0139`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use WKContentWorld Isolation for DOM Inspection Scriptsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use WKContentWorld Isolation for DOM Inspection Scriptsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use WKContentWorld Isolation for DOM Inspection Scriptsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When an app uses evaluateJavaScript(_:completionHandler:)) or WKUserScript to read data from the DOM (for example, to extract form field values, account details, or page metadata), that code runs in the .page world by default. In the .page world, all built-in prototypes are shared with page JavaScript. A malicious script running on the page can override document.querySelector, Element.prototype.getAttribute, or any other native function before your inspection code runs, causing it to receive manipulated results.
* Use the content-world variants of these APIs (introduced in iOS 14, see @MASTG-KNOW-0139) to run DOM inspection code in an isolated world where the prototype chain cannot be tampered with by page JavaScript.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Use WKContentWorld Isolation for DOM Inspection Scripts を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use WKContentWorld Isolation for DOM Inspection Scripts を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0076, MASTG-KNOW-0139）と合わせてレビューする
- When an app uses evaluateJavaScript(_:completionHandler:)) or WKUserScript to read data from the DOM (for example, to extract form field values, account details, or page metadata), that code runs in the .page world by default. In the .page world, all built-in prototypes are shared with page JavaScript. A malicious script running on the page can override document.querySelector, Element.prototype.getAttribute, or any other native function before your inspection code runs, causing it to receive manipulated results.
- Use the content-world variants of these APIs (introduced in iOS 14, see @MASTG-KNOW-0139) to run DOM inspection code in an isolated world where the prototype chain cannot be tampered with by page JavaScript.
```

### DO NOT: MASTG-BEST-0061 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- レガシーな広い JS ブリッジを新規採用する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0061 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0061/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
