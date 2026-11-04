---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0065/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0065
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0065: Implementing Storage Integrity Checks on iOS

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Implementing Storage Integrity Checks on iOS」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Implement storage integrity checks in iOS apps to detect unauthorized modifications to data stored on the device (for example, in the Keychain, UserDefaults/NSUserDefaults, files, or databases). These checks raise the cost for attackers who try to tamper with the app's data, e...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0065/>
* 関連 Knowledge: `MASTG-KNOW-0086`
* 索引: [`../0000-index.md`](../0000-index.md)

## Implementing Storage Integrity Checks on iOSを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Implementing Storage Integrity Checks on iOSを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Implementing Storage Integrity Checks on iOSを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Implement storage integrity checks in iOS apps to detect unauthorized modifications to data stored on the device (for example, in the Keychain, UserDefaults/NSUserDefaults, files, or databases). These checks raise the cost for attackers who try to tamper with the app's data, especially on jailbroken devices, through backups, or by directly manipulating the app's data directory. For detecting modifications to the app's own executable code, see @MASTG-BEST-0067.
* Compute an HMAC over any data you store on the device before writing it, and verify the HMAC before reading. Use a key that is stored in the iOS Keychain with a strict accessibility setting (e.g., kSecAttrAccessibleWhenUnlockedThisDeviceOnly) so it cannot be extracted from a backup or transferred to another device.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Implementing Storage Integrity Checks on iOS を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Implementing Storage Integrity Checks on iOS を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0086）と合わせてレビューする
- Implement storage integrity checks in iOS apps to detect unauthorized modifications to data stored on the device (for example, in the Keychain, UserDefaults/NSUserDefaults, files, or databases). These checks raise the cost for attackers who try to tamper with the app's data, especially on jailbroken devices, through backups, or by directly manipulating the app's data directory. For detecting modifications to the app's own executable code, see @MASTG-BEST-0067.
- Compute an HMAC over any data you store on the device before writing it, and verify the HMAC before reading. Use a key that is stored in the iOS Keychain with a strict accessibility setting (e.g., kSecAttrAccessibleWhenUnlockedThisDeviceOnly) so it cannot be extracted from a backup or transferred to another device.
```

### DO NOT: MASTG-BEST-0065 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 改ざん検知をクライアント表示だけにしサーバ検証しない

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0065 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0065/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
