---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0001
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0001: Use Secure Random Number Generator APIs

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Secure Random Number Generator APIs」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Use a cryptographically secure pseudorandom number generator as provided by the platform or programming language you are using.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/>
* 関連 Knowledge: `MASTG-KNOW-0013`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Secure Random Number Generator APIsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Secure Random Number Generator APIsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Secure Random Number Generator APIsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Use a cryptographically secure pseudorandom number generator as provided by the platform or programming language you are using.
* Use java.security.SecureRandom, which complies with the statistical random number generator tests specified in FIPS 140-2, Security Requirements for Cryptographic Modules, section 4.9.1 and meets the cryptographic strength requirements described in RFC 4086: Randomness Requirements for Security. It produces non-deterministic output and automatically seeds itself during object initialization using system entropy, so manual seeding is generally unnecessary and can weaken randomness if not done properly.
```

## ナレッジベース

### DO: Use Secure Random Number Generator APIs を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Secure Random Number Generator APIs を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0013）と合わせてレビューする
- Use a cryptographically secure pseudorandom number generator as provided by the platform or programming language you are using.
- Use java.security.SecureRandom, which complies with the statistical random number generator tests specified in FIPS 140-2, Security Requirements for Cryptographic Modules, section 4.9.1 and meets the cryptographic strength requirements described in RFC 4086: Randomness Requirements for Security. It produces non-deterministic output and automatically seeds itself during object initialization using system entropy, so manual seeding is generally unnecessary and can weaken randomness if not done properly.
```

### DO NOT: MASTG-BEST-0001 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- java.util.Random / Math.random 等の非暗号乱数を鍵・トークン生成に使う
- SecureRandom に固定・推測可能な seed を渡す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0001 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
