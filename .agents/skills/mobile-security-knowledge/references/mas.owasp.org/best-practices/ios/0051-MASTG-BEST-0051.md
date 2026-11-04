---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0051/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0051
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0051: Minimize iOS Permissions and Entitlements

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Minimize iOS Permissions and Entitlements」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Request only the iOS permissions and app capabilities that the app actually needs, and prefer the narrowest Apple-supported access model for each feature. This reduces unnecessary exposure of personal data and limits the blast radius if the app, an extension, or a shared conta...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0051/>
* 関連 Knowledge: `MASTG-KNOW-0077`
* 索引: [`../0000-index.md`](../0000-index.md)

## Minimize iOS Permissions and Entitlementsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Minimize iOS Permissions and Entitlementsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Minimize iOS Permissions and Entitlementsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Request only the iOS permissions and app capabilities that the app actually needs, and prefer the narrowest Apple-supported access model for each feature. This reduces unnecessary exposure of personal data and limits the blast radius if the app, an extension, or a shared container is later abused.
* Review Info.plist purpose strings, the signed entitlements, and any provisioning-profile entitlements together before release. A permission prompt or capability should map to a concrete feature that users can understand and justify. Remove unused or speculative entries instead of keeping them "just in case".
```

## ナレッジベース

### DO: Minimize iOS Permissions and Entitlements を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Minimize iOS Permissions and Entitlements を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0077）と合わせてレビューする
- Request only the iOS permissions and app capabilities that the app actually needs, and prefer the narrowest Apple-supported access model for each feature. This reduces unnecessary exposure of personal data and limits the blast radius if the app, an extension, or a shared container is later abused.
- Review Info.plist purpose strings, the signed entitlements, and any provisioning-profile entitlements together before release. A permission prompt or capability should map to a concrete feature that users can understand and justify. Remove unused or speculative entries instead of keeping them "just in case".
```

### DO NOT: MASTG-BEST-0051 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 不要な権限・entitlement を残す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0051 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0051/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
