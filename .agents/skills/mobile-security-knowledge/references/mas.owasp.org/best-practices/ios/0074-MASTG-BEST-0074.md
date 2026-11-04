---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0074/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0074
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0074: Implementing Anti-Debugging Checks on iOS

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Implementing Anti-Debugging Checks on iOS」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Implement anti-debugging checks in iOS apps that handle high-risk flows, and run those checks at startup and before or during sensitive operations instead of relying on a single startup check.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0074/>
* 関連 Knowledge: `MASTG-KNOW-0085`
* 索引: [`../0000-index.md`](../0000-index.md)

## Implementing Anti-Debugging Checks on iOSを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Implementing Anti-Debugging Checks on iOSを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Implementing Anti-Debugging Checks on iOSを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Implement anti-debugging checks in iOS apps that handle high-risk flows, and run those checks at startup and before or during sensitive operations instead of relying on a single startup check.
* Use anti-debugging as a defense-in-depth control. A local attacker who controls the device or app package can eventually bypass client-side checks through patching, instrumentation, or a modified runtime. The goal is to raise attacker effort, make bypasses harder to maintain, and feed risk signals into broader app and backend policy.
* Use ptrace") and PT_DENY_ATTACH where this is acceptable for the app's distribution model.
* Use process-state checks such as Apple's archived sysctl debugger detection example as one reactive signal.
* Add parent-process or Mach exception port checks where they fit the app's threat model.
* key unwrapping or signing
* payment approval
* authentication or step-up authorization
```

## ナレッジベース

### DO: Implementing Anti-Debugging Checks on iOS を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Implementing Anti-Debugging Checks on iOS を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0085）と合わせてレビューする
- Implement anti-debugging checks in iOS apps that handle high-risk flows, and run those checks at startup and before or during sensitive operations instead of relying on a single startup check.
- Use anti-debugging as a defense-in-depth control. A local attacker who controls the device or app package can eventually bypass client-side checks through patching, instrumentation, or a modified runtime. The goal is to raise attacker effort, make bypasses harder to maintain, and feed risk signals into broader app and backend policy.
- Use ptrace") and PT_DENY_ATTACH where this is acceptable for the app's distribution model.
```

### DO NOT: MASTG-BEST-0074 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0074 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0074/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
