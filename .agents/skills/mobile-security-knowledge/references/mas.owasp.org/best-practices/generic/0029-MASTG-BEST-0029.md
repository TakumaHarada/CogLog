---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0029/
scopes:
  - test
  - android
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0029
platform: generic
status: placeholder
upstream_revision: d7fd7d4
---

# MASTG-BEST-0029: Implementing Resilience and RASP Signals

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Implementing Resilience and RASP Signals」（generic）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは placeholder である。新規採用の完了根拠にしない。詳細手順・コード例は公式記事を正本とする。
* 要旨: Resilience controls and RASP (Runtime Application Self-Protection) style checks are defense in depth measures that raise attacker cost by detecting risky environments and runtime tampering. They do not replace secure design and they are inherently bypassable, so they should be selected and tuned based on the app's threat model and risk tolerance.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0029/>
* 関連 Knowledge: `MASTG-KNOW-0027`, `MASTG-KNOW-0028`, `MASTG-KNOW-0029`, `MASTG-KNOW-0030`, `MASTG-KNOW-0031`, `MASTG-KNOW-0032`, `MASTG-KNOW-0033`, `MASTG-KNOW-0034`, `MASTG-KNOW-0035`, `MASTG-KNOW-0089`
* 索引: [`../0000-index.md`](../0000-index.md)

## Implementing Resilience and RASP Signals（placeholder）の意図を把握し、current 化を待つ

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Implementing Resilience and RASP Signals（placeholder）の意図を把握し、current 化を待つの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: generic アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Implementing Resilience and RASP Signals（placeholder）の意図を把握し、current 化を待つの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* 公式 BEST `MASTG-BEST-0029` の現行本文に従う
* ノート: Resilience controls and RASP (Runtime Application Self-Protection) style checks are defense in depth measures that raise attacker cost by detecting risky environments and runtime tampering. They do not replace secure design and they are inherently bypassable, so they should be selected and tuned based on the app's threat model and risk tolerance.
```

## ナレッジベース

### DO: Implementing Resilience and RASP Signals を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Implementing Resilience and RASP Signals を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0027, MASTG-KNOW-0028, MASTG-KNOW-0029, MASTG-KNOW-0030, MASTG-KNOW-0031, MASTG-KNOW-0032, MASTG-KNOW-0033, MASTG-KNOW-0034, MASTG-KNOW-0035, MASTG-KNOW-0089）と合わせてレビューする
```

### DO NOT: MASTG-BEST-0029 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0029 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0029/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
