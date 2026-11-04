---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0056/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0056
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0056: Use Explicit Intents for Internal IPC

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Explicit Intents for Internal IPC」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Use explicit intents when communicating between components within the same app. An explicit intent specifies the target component directly by package name or class name, ensuring the intent can only be delivered to the intended recipient and can't be intercepted by a third-par...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0056/>
* 関連 Knowledge: `MASTG-KNOW-0025`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Explicit Intents for Internal IPCを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Explicit Intents for Internal IPCを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Explicit Intents for Internal IPCを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Use explicit intents when communicating between components within the same app. An explicit intent specifies the target component directly by package name or class name, ensuring the intent can only be delivered to the intended recipient and can't be intercepted by a third-party app through normal intent resolution.
* Set the target package with Intent.setPackage) or target a specific component before sending the intent:
* 公式記事内のコード例言語: kotlin
```

## ナレッジベース

### DO: Use Explicit Intents for Internal IPC を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Explicit Intents for Internal IPC を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0025）と合わせてレビューする
- Use explicit intents when communicating between components within the same app. An explicit intent specifies the target component directly by package name or class name, ensuring the intent can only be delivered to the intended recipient and can't be intercepted by a third-party app through normal intent resolution.
- Set the target package with Intent.setPackage) or target a specific component before sending the intent:
```

### DO NOT: MASTG-BEST-0056 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 内部 IPC に暗黙 Intent を使う
- mutable / 非明示 PendingIntent を安易に使う

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0056 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0056/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
