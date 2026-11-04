---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0020/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0020
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0020: Update the GMS Security Provider

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Update the GMS Security Provider」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Android devices vary widely in OS version and update frequency. Relying solely on platform-level security can leave apps exposed to outdated SSL/TLS implementations and known vulnerabilities.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0020/>
* 関連 Knowledge: `MASTG-KNOW-0011`
* 索引: [`../0000-index.md`](../0000-index.md)

## Update the GMS Security Providerを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Update the GMS Security Providerを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Update the GMS Security Providerを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Android devices vary widely in OS version and update frequency. Relying solely on platform-level security can leave apps exposed to outdated SSL/TLS implementations and known vulnerabilities.
* The GMS Security Provider (delivered via Google Play Services) addresses this by updating critical cryptographic components—such as OpenSSL and TrustManager, independently of the Android OS. This helps ensure secure network communication, even on older or unpatched devices.
* On GMS-enabled devices, use the Security Provider to keep cryptographic libraries up to date.
* On non-GMS devices, consider bundling a secure TLS library like Conscrypt to ensure consistent and strong network security across your entire device fleet.
```

## ナレッジベース

### DO: Update the GMS Security Provider を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Update the GMS Security Provider を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0011）と合わせてレビューする
- Android devices vary widely in OS version and update frequency. Relying solely on platform-level security can leave apps exposed to outdated SSL/TLS implementations and known vulnerabilities.
- The GMS Security Provider (delivered via Google Play Services) addresses this by updating critical cryptographic components—such as OpenSSL and TrustManager, independently of the Android OS. This helps ensure secure network communication, even on older or unpatched devices.
- On GMS-enabled devices, use the Security Provider to keep cryptographic libraries up to date.
```

### DO NOT: MASTG-BEST-0020 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 古い Security Provider のまま TLS を運用する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0020 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0020/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
