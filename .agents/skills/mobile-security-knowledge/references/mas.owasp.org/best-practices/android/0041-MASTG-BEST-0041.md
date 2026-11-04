---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0041/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0041
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0041: Hardening Against Runtime Hooking

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Hardening Against Runtime Hooking」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Defending against runtime hooking requires a layered approach that combines several types of security controls:

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0041/>
* 関連 Knowledge: `MASTG-KNOW-0027`, `MASTG-KNOW-0030`, `MASTG-KNOW-0032`, `MASTG-KNOW-0118`, `MASTG-KNOW-0033`, `MASTG-KNOW-0119`, `MASTG-KNOW-0120`
* 索引: [`../0000-index.md`](../0000-index.md)

## Hardening Against Runtime Hookingを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Hardening Against Runtime Hookingを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Hardening Against Runtime Hookingを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Defending against runtime hooking requires a layered approach that combines several types of security controls:
* Preventive controls: Implement root detection (@MASTG-KNOW-0027) and device/app attestation (@MASTG-KNOW-0120, @MASTG-KNOW-0119) as the first line of defense, since most hooking frameworks (e.g., Frida server, Xposed) require rooted devices.
* Detective controls: Scan for tool signatures using artifact-based detection (@MASTG-KNOW-0030) and verify the app's code and memory integrity at runtime (@MASTG-KNOW-0032) to detect hooking attempts.
* Deterrent controls: Obfuscate detection logic, scatter checks throughout the app, and vary their timing to increase the cost and effort required to bypass protections.
* Responsive controls: Terminate the session, clear sensitive data from memory, or even alert the backend server when a threat is detected.
* Memory scanning: Scan /proc/self/maps and process memory for known artifacts (e.g., "LIBFRIDA", frida-agent libraries, Xposed bridge classes).
* Integrity checksums: Compute checksums of critical code sections at build time and verify them periodically at runtime to detect patches and inline hooks.
* GOT/PLT verification: Verify that Global Offset Table entries point to addresses within their expected libraries.
```

## ナレッジベース

### DO: Hardening Against Runtime Hooking を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Hardening Against Runtime Hooking を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0027, MASTG-KNOW-0030, MASTG-KNOW-0032, MASTG-KNOW-0118, MASTG-KNOW-0033, MASTG-KNOW-0119, MASTG-KNOW-0120）と合わせてレビューする
- Defending against runtime hooking requires a layered approach that combines several types of security controls:
- Preventive controls: Implement root detection (@MASTG-KNOW-0027) and device/app attestation (@MASTG-KNOW-0120, @MASTG-KNOW-0119) as the first line of defense, since most hooking frameworks (e.g., Frida server, Xposed) require rooted devices.
- Detective controls: Scan for tool signatures using artifact-based detection (@MASTG-KNOW-0030) and verify the app's code and memory integrity at runtime (@MASTG-KNOW-0032) to detect hooking attempts.
```

### DO NOT: MASTG-BEST-0041 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0041 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0041/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
