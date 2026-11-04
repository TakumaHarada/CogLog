---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0014/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0014
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0014: Preventing Screenshots and Screen Recording

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Preventing Screenshots and Screen Recording」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Ensure the app hides sensitive content, such as card numbers and passcodes, from screenshots, screen recording, nonsecure displays, task switcher thumbnails, and remote screen sharing. Malware may capture screen output and extract confidential information. Protect on screen ke...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0014/>
* 関連 Knowledge: （未リンク）
* 索引: [`../0000-index.md`](../0000-index.md)

## Preventing Screenshots and Screen Recordingを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Preventing Screenshots and Screen Recordingを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Preventing Screenshots and Screen Recordingを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Ensure the app hides sensitive content, such as card numbers and passcodes, from screenshots, screen recording, nonsecure displays, task switcher thumbnails, and remote screen sharing. Malware may capture screen output and extract confidential information. Protect on screen keyboards or custom keypad views as they may leak keystrokes from passcode fields. Screenshots can be saved in locations accessible to other apps or a local attacker.
* Setting FLAG_SECURE on the window prevents screenshots (or appear black), blocks screen recording, and hides content on nonsecure displays and in the system task switcher.
```

## ナレッジベース

### DO: Preventing Screenshots and Screen Recording を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Preventing Screenshots and Screen Recording を該当機能に適用する
- Ensure the app hides sensitive content, such as card numbers and passcodes, from screenshots, screen recording, nonsecure displays, task switcher thumbnails, and remote screen sharing. Malware may capture screen output and extract confidential information. Protect on screen keyboards or custom keypad views as they may leak keystrokes from passcode fields. Screenshots can be saved in locations accessible to other apps or a local attacker.
- Setting FLAG_SECURE on the window prevents screenshots (or appear black), blocks screen recording, and hides content on nonsecure displays and in the system task switcher.
```

### DO NOT: MASTG-BEST-0014 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 機微画面で FLAG_SECURE / 同等保護を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0014 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0014/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
