---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0053/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0053
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0053: Hardening Against Virtual Devices

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Hardening Against Virtual Devices」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Virtual devices, such as @MASTG-TOOL-0108 and newer research environments, allow target applications to be executed in controlled environments that may use custom system images, modified platform components, missing or simulated hardware capabilities, or instrumentation that i...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0053/>
* 関連 Knowledge: `MASTG-KNOW-0135`, `MASTG-KNOW-0088`, `MASTG-KNOW-0136`, `MASTG-KNOW-0087`, `MASTG-KNOW-0089`
* 索引: [`../0000-index.md`](../0000-index.md)

## Hardening Against Virtual Devicesを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Hardening Against Virtual Devicesを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Hardening Against Virtual Devicesを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Virtual devices, such as @MASTG-TOOL-0108 and newer research environments, allow target applications to be executed in controlled environments that may use custom system images, modified platform components, missing or simulated hardware capabilities, or instrumentation that is difficult for the app to detect. This enables advanced reverse-engineering techniques.
* Do not confuse virtual devices with the iOS Simulator or with iPhone and iPad apps running on macOS. The iOS Simulator runs simulator builds, while virtual devices attempt to reproduce an iOS device environment for iOS device binaries. iPhone and iPad apps running on macOS use a separate official Mac App Store distribution path on Macs with Apple silicon. See @MASTG-KNOW-0088 and @MASTG-KNOW-0136.
* Virtual device detection: Check for virtual device indicators such as missing hardware capabilities, inconsistent device properties, known virtualization artifacts, and App Attest validation failures. See @MASTG-KNOW-0135.
* Reverse engineering tool detection: Detect debuggers, instrumentation frameworks, hooking tools, and other runtime manipulation techniques, because virtual devices are often used together with these tools. See @MASTG-KNOW-0087.
* Server-side enforcement: Use server-side checks for high-risk actions, such as App Attest validation, app integrity validation, request risk scoring, throttling, step-up verification, or denying access to sensitive features when multiple high-risk signals are present.
* Obfuscation and diversification: Obfuscate detection logic, scatter checks throughout the app, vary their timing, and avoid relying on a single static indicator. See @MASTG-KNOW-0089.
* Graceful response handling: Avoid exposing precise detection reasons to the client. Prefer generic errors, reduced functionality, delayed responses, or server-side policy decisions that do not reveal which specific check was triggered.
```

## ナレッジベース

### DO: Hardening Against Virtual Devices を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Hardening Against Virtual Devices を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0135, MASTG-KNOW-0088, MASTG-KNOW-0136, MASTG-KNOW-0087, MASTG-KNOW-0089）と合わせてレビューする
- Virtual devices, such as @MASTG-TOOL-0108 and newer research environments, allow target applications to be executed in controlled environments that may use custom system images, modified platform components, missing or simulated hardware capabilities, or instrumentation that is difficult for the app to detect. This enables advanced reverse-engineering techniques.
- Do not confuse virtual devices with the iOS Simulator or with iPhone and iPad apps running on macOS. The iOS Simulator runs simulator builds, while virtual devices attempt to reproduce an iOS device environment for iOS device binaries. iPhone and iPad apps running on macOS use a separate official Mac App Store distribution path on Macs with Apple silicon. See @MASTG-KNOW-0088 and @MASTG-KNOW-0136.
- Virtual device detection: Check for virtual device indicators such as missing hardware capabilities, inconsistent device properties, known virtualization artifacts, and App Attest validation failures. See @MASTG-KNOW-0135.
```

### DO NOT: MASTG-BEST-0053 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 耐タンパ検知を単一チェック・クライアント alone で完結させる

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0053 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0053/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
