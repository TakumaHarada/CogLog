---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0069/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0069
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0069: Keep Sensitive Input on the System Keyboard

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Keep Sensitive Input on the System Keyboard」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Custom keyboards are app extensions that replace the system keyboard across all apps and, once granted "Full Access", can transmit what the user types off the device (see @MASTG-KNOW-0082). For input that carries secrets, such as passwords, PINs, one-time passcodes, or payment...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0069/>
* 関連 Knowledge: `MASTG-KNOW-0082`, `MASTG-KNOW-0141`
* 索引: [`../0000-index.md`](../0000-index.md)

## Keep Sensitive Input on the System Keyboardを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Keep Sensitive Input on the System Keyboardを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Keep Sensitive Input on the System Keyboardを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Custom keyboards are app extensions that replace the system keyboard across all apps and, once granted "Full Access", can transmit what the user types off the device (see @MASTG-KNOW-0082). For input that carries secrets, such as passwords, PINs, one-time passcodes, or payment data, keep the entry on the trusted system keyboard rather than relying on whichever keyboard the user has installed.
* Set isSecureTextEntry to true on the UITextField/UITextView, or use a SwiftUI SecureField. iOS does not display third-party keyboards for secure fields, so the typed characters stay on the system keyboard. This is field-scoped, so it does not disrupt the user's keyboard choice elsewhere in the app, and it also masks the input and prevents keyboard caching.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: Keep Sensitive Input on the System Keyboard を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Keep Sensitive Input on the System Keyboard を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0082, MASTG-KNOW-0141）と合わせてレビューする
- Custom keyboards are app extensions that replace the system keyboard across all apps and, once granted "Full Access", can transmit what the user types off the device (see @MASTG-KNOW-0082). For input that carries secrets, such as passwords, PINs, one-time passcodes, or payment data, keep the entry on the trusted system keyboard rather than relying on whichever keyboard the user has installed.
- Set isSecureTextEntry to true on the UITextField/UITextView, or use a SwiftUI SecureField. iOS does not display third-party keyboards for secure fields, so the typed characters stay on the system keyboard. This is field-scoped, so it does not disrupt the user's keyboard choice elsewhere in the app, and it also masks the input and prevents keyboard caching.
```

### DO NOT: MASTG-BEST-0069 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 機微入力のマスク / キャッシュ無効を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0069 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0069/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
