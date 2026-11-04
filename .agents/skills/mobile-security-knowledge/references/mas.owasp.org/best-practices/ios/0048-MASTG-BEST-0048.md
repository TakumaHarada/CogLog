---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0048/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0048
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0048: Hardening Against Reverse Engineering Tools

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Hardening Against Reverse Engineering Tools」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Defending against reverse engineering tools on iOS requires a layered approach that combines several types of security controls:

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0048/>
* 関連 Knowledge: `MASTG-KNOW-0087`
* 索引: [`../0000-index.md`](../0000-index.md)

## Hardening Against Reverse Engineering Toolsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Hardening Against Reverse Engineering Toolsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Hardening Against Reverse Engineering Toolsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Defending against reverse engineering tools on iOS requires a layered approach that combines several types of security controls:
* Detective controls: Scan for known reverse engineering tool artifacts (@MASTG-KNOW-0087), such as checking loaded dynamic libraries via _dyld_image_count/_dyld_get_image_name for names containing "frida", "gadget", "cynject", or other tool-specific strings. This technique is effective against Frida Gadget (embedded mode) and tools loaded through dyld, but on official builds frida-server injects its agent using a custom Mach-O loader that bypasses dyld, so it does not detect frida-server in injected mode. Additionally, probe TCP port 27042 for a D-Bus authentication response to reveal a running frida-server.
* Deterrent controls: Obfuscate detection logic (@MASTG-KNOW-0089), scatter checks throughout the app, and vary their timing to increase the cost and effort required to bypass these checks. Avoid centralizing detection in a single function, as a fixed entry point can be patched or hooked.
* Responsive controls: Terminate the app immediately, clear sensitive data from memory, or alert the backend server when a tool is detected.
* Library name scanning: Iterate loaded dylibs using _dyld_image_count/_dyld_get_image_name for known artifact names (see Inspect Loaded Dynamic Libraries above for its coverage and limitations).
* TCP port probing: Check whether port 27042 is open and responds to a D-Bus AUTH message, which reveals a default frida-server configuration.
* Named pipe detection: Scan for named pipes used by frida-server for inter-process communication.
* Terminate the app session immediately.
```

## ナレッジベース

### DO: Hardening Against Reverse Engineering Tools を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Hardening Against Reverse Engineering Tools を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0087）と合わせてレビューする
- Defending against reverse engineering tools on iOS requires a layered approach that combines several types of security controls:
- Detective controls: Scan for known reverse engineering tool artifacts (@MASTG-KNOW-0087), such as checking loaded dynamic libraries via _dyld_image_count/_dyld_get_image_name for names containing "frida", "gadget", "cynject", or other tool-specific strings. This technique is effective against Frida Gadget (embedded mode) and tools loaded through dyld, but on official builds frida-server injects its agent using a custom Mach-O loader that bypasses dyld, so it does not detect frida-server in injected mode. Additionally, probe TCP port 27042 for a D-Bus authentication response to reveal a running frida-server.
- Deterrent controls: Obfuscate detection logic (@MASTG-KNOW-0089), scatter checks throughout the app, and vary their timing to increase the cost and effort required to bypass these checks. Avoid centralizing detection in a single function, as a fixed entry point can be patched or hooked.
```

### DO NOT: MASTG-BEST-0048 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0048 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0048/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
