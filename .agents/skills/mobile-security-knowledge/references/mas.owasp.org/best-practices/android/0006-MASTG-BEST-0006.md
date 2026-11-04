---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0006/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0006
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0006: Use Up-to-Date APK Signing Schemes

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Up-to-Date APK Signing Schemes」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Ensure that the app is signed with at least the v2 or v3 APK signing scheme, as these provide comprehensive integrity checks and protect the entire APK from tampering. For optimal security and compatibility, consider using v3, which also supports key rotation.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0006/>
* 関連 Knowledge: `MASTG-KNOW-0003`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Up-to-Date APK Signing Schemesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Up-to-Date APK Signing Schemesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Up-to-Date APK Signing Schemesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Ensure that the app is signed with at least the v2 or v3 APK signing scheme, as these provide comprehensive integrity checks and protect the entire APK from tampering. For optimal security and compatibility, consider using v3, which also supports key rotation.
* Optionally, you can add v4 signing to enable faster incremental updates in Android 11 and above, but v4 alone does not provide security protections and should be used alongside v2 or v3.
* 公式記事内のコード例言語: default
```

## ナレッジベース

### DO: Use Up-to-Date APK Signing Schemes を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Up-to-Date APK Signing Schemes を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0003）と合わせてレビューする
- Ensure that the app is signed with at least the v2 or v3 APK signing scheme, as these provide comprehensive integrity checks and protect the entire APK from tampering. For optimal security and compatibility, consider using v3, which also supports key rotation.
- Optionally, you can add v4 signing to enable faster incremental updates in Android 11 and above, but v4 alone does not provide security protections and should be used alongside v2 or v3.
```

### DO NOT: MASTG-BEST-0006 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- v1 のみ等の古い署名スキームだけに依存する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0006 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0006/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
