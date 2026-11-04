---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0046/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0046
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0046: Hardening Against Emulation

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Hardening Against Emulation」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Emulated devices allow target applications to be executed in controlled environments that may use custom system images, modified platform components, or instrumentation that is difficult for the app to detect. This enables advanced reverse-engineering techniques.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0046/>
* 関連 Knowledge: `MASTG-KNOW-0031`, `MASTG-KNOW-0035`, `MASTG-KNOW-0033`, `MASTG-KNOW-0030`
* 索引: [`../0000-index.md`](../0000-index.md)

## Hardening Against Emulationを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Hardening Against Emulationを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Hardening Against Emulationを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Emulated devices allow target applications to be executed in controlled environments that may use custom system images, modified platform components, or instrumentation that is difficult for the app to detect. This enables advanced reverse-engineering techniques.
* Defending against emulated devices involves a layered approach that commonly consists of applying several types of security controls:
* Detective controls: Scan for common device emulator indicators and properties (@MASTG-KNOW-0031) and use the Google Play Integrity API (@MASTG-KNOW-0035) to help identify risky devices, emulated environments, modified app binaries, and other untrusted interactions.
* Deterrent controls: Obfuscate this detection logic (@MASTG-KNOW-0033), scatter checks throughout the app, and vary their timing to increase the cost and effort required to bypass these checks.
* Hardening against reverse-engineering tools: Implement detection of reverse-engineering tools (@MASTG-KNOW-0030), as custom or emulated environments are often combined with such tools.
```

## ナレッジベース

### DO: Hardening Against Emulation を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Hardening Against Emulation を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0031, MASTG-KNOW-0035, MASTG-KNOW-0033, MASTG-KNOW-0030）と合わせてレビューする
- Emulated devices allow target applications to be executed in controlled environments that may use custom system images, modified platform components, or instrumentation that is difficult for the app to detect. This enables advanced reverse-engineering techniques.
- Defending against emulated devices involves a layered approach that commonly consists of applying several types of security controls:
- Detective controls: Scan for common device emulator indicators and properties (@MASTG-KNOW-0031) and use the Google Play Integrity API (@MASTG-KNOW-0035) to help identify risky devices, emulated environments, modified app binaries, and other untrusted interactions.
```

### DO NOT: MASTG-BEST-0046 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0046 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0046/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
