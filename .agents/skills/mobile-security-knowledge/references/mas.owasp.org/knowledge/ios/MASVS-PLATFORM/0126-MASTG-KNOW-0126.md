---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0126/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0126
masvs_category: MASVS-PLATFORM
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0126: Keychain Access Groups

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Keychain Access Groups」（iOS / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Keychain access groups allow multiple apps from the same developer team to share keychain items. Without a shared access group, keychain items are private to the app's default keychain access group.
* 要旨: An app declares its keychain access groups in the keychain-access-groups entitlement. The entitlement value is an array of group identifiers, each prefixed with the app's App ID prefix, which is usually the Team ID, for example TeamID.com.example.shared.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0126/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Keychain Access Groupsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Keychain Access Groupsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Keychain Access Groupsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Keychain access groups are scoped to the app's App ID prefix, which is usually tied to the developer team. Apps from different teams normally cannot share a keychain access group.
* Items stored in a shared access group are accessible to all apps declaring that group, subject to the item's accessibility and access control settings.
* The access group is set when the keychain item is created by passing kSecAttrAccessGroup to SecItemAdd.
* Keychain items are protected by the iOS Keychain's Data Protection classes (kSecAttrAccessible), independent of the access group.
* Shared keychain items should be minimized because any app or extension in the group may be able to read, update, or delete them.
* 公式記事内のコード例言語: swift
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Keychain access groups are scoped to the app's App ID prefix, which is usually tied to the developer team. Apps from different teams normally cannot share a keychain access group.
- Items stored in a shared access group are accessible to all apps declaring that group, subject to the item's accessibility and access control settings.
- The access group is set when the keychain item is created by passing kSecAttrAccessGroup to SecItemAdd.
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
- 変更レビューで MASTG-KNOW-0126 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0126/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
