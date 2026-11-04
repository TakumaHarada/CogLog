---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0141/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0141
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0141: Custom Keyboards

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Custom Keyboards」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: A custom keyboard is an app extension (see ) that replaces the system keyboard across all apps on the device. The user installs it through its containing app and must explicitly enable it in Settings (General > Keyboard > Keyboards).
* 要旨: By default a custom keyboard runs without "Full Access", which prevents it from making network requests or accessing shared containers; the user can grant "Full Access" in Settings, which the keyboard requests via the RequestsOpenAccess key and is able to check whether it has it through the hasFullAccess property of UIInputViewController.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0141/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Custom Keyboardsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Custom Keyboardsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Custom Keyboardsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* A UITextField or UITextView whose isSecureTextEntry trait is true (or a SwiftUI SecureField) always uses the system keyboard. Third-party keyboards are not shown for secure fields, so they never re...
* An app can reject custom keyboard extensions across the whole app by implementing application(_:shouldAllowExtensionPointIdentifier:)) in its UIApplicationDelegate and returning false for UIApplica...
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- A UITextField or UITextView whose isSecureTextEntry trait is true (or a SwiftUI SecureField) always uses the system keyboard. Third-party keyboards are not shown for secure fields, so they never receive the typed characters.
- An app can reject custom keyboard extensions across the whole app by implementing application(_:shouldAllowExtensionPointIdentifier:)) in its UIApplicationDelegate and returning false for UIApplicationKeyboardExtensionPointIdentifier (com.apple.keyboard-service). The system then uses the built-in keyboard throughout the app, regardless of the keyboards the user has installed.
```

### DO NOT: 不要な Deep Link を有効化する

* 理由: MASVS-PLATFORM の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 不要な Deep Link を有効化する
- 信頼できないコンテンツを WebView で無制限に開く

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0141 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0141/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
