---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0030/
scopes:
  - test
  - android
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0030
platform: generic
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0030: Implementing Root Detection

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Implementing Root Detection」（generic）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Root detection is an environment risk signal that helps identify devices with elevated privilege or common rooting artifacts. It is a cost raising measure and it is bypassable, so it should be used only when rooted device risk materially impacts the app.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0030/>
* 関連 Knowledge: `MASTG-KNOW-0027`
* 索引: [`../0000-index.md`](../0000-index.md)

## Implementing Root Detectionを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Implementing Root Detectionを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: generic アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Implementing Root Detectionを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Root detection is an environment risk signal that helps identify devices with elevated privilege or common rooting artifacts. It is a cost raising measure and it is bypassable, so it should be used only when rooted device risk materially impacts the app.
* Apply the relevant root detection techniques described in @MASTG-KNOW-0027 based on the app's threat model and risk tolerance.
* Layer defenses: Pair root signals with integrity checks, anti debugging signals, and backend enforcement.
* Distribute checks: Place checks near sensitive operations and session establishment, avoid a single centralized gate.
* Use multiple methods: Combine filesystem artifacts, property checks, process checks, and native level checks.
* Avoid well-known patterns only: Do not rely only on public signature lists or a single library default configuration.
* Use proportional responses: Limit high risk operations first, add step up authentication, avoid full lockout when confidence is low.
* Validate server-side: Use server policy to decide whether to allow transactions, based on risk and user context.
```

## ナレッジベース

### DO: Implementing Root Detection を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Implementing Root Detection を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0027）と合わせてレビューする
- Root detection is an environment risk signal that helps identify devices with elevated privilege or common rooting artifacts. It is a cost raising measure and it is bypassable, so it should be used only when rooted device risk materially impacts the app.
- Apply the relevant root detection techniques described in @MASTG-KNOW-0027 based on the app's threat model and risk tolerance.
- Layer defenses: Pair root signals with integrity checks, anti debugging signals, and backend enforcement.
```

### DO NOT: MASTG-BEST-0030 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0030 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0030/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
