---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0068/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0068
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0068: Secure Data Sharing Between App Extensions and Containing Apps

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Secure Data Sharing Between App Extensions and Containing Apps」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: When an app and its extensions share data through an App Group, the shared container is readable and writable by every member of the group, with no per-item access control between members (see @MASTG-KNOW-0082). Choose the sharing channel based on the sensitivity of the data, ...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0068/>
* 関連 Knowledge: `MASTG-KNOW-0082`
* 索引: [`../0000-index.md`](../0000-index.md)

## Secure Data Sharing Between App Extensions and Containing Appsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Secure Data Sharing Between App Extensions and Containing Appsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Secure Data Sharing Between App Extensions and Containing Appsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* When an app and its extensions share data through an App Group, the shared container is readable and writable by every member of the group, with no per-item access control between members (see @MASTG-KNOW-0082). Choose the sharing channel based on the sensitivity of the data, and protect what you store.
* Store credentials, tokens, and keys that both the app and an extension need in a shared Keychain Access Group (the keychain-access-groups entitlement), not in shared UserDefaults or a shared file container. The Keychain provides dedicated, access-controlled key storage with its own accessibility class. Set an appropriate accessibility attribute such as kSecAttrAccessibleWhenUnlockedThisDeviceOnly.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Secure Data Sharing Between App Extensions and Containing Apps を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Secure Data Sharing Between App Extensions and Containing Apps を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0082）と合わせてレビューする
- When an app and its extensions share data through an App Group, the shared container is readable and writable by every member of the group, with no per-item access control between members (see @MASTG-KNOW-0082). Choose the sharing channel based on the sensitivity of the data, and protect what you store.
- Store credentials, tokens, and keys that both the app and an extension need in a shared Keychain Access Group (the keychain-access-groups entitlement), not in shared UserDefaults or a shared file container. The Keychain provides dedicated, access-controlled key storage with its own accessibility class. Set an appropriate accessibility attribute such as kSecAttrAccessibleWhenUnlockedThisDeviceOnly.
```

### DO NOT: MASTG-BEST-0068 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- App Extension と本体の共有領域を無制限にする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0068 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0068/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
