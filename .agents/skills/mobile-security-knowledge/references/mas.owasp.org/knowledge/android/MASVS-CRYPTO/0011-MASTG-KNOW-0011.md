---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CRYPTO/MASTG-KNOW-0011/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - crypto
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0011
masvs_category: MASVS-CRYPTO
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0011: Security Provider

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Security Provider」（Android / 暗号）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android relies on a security provider via the java.security.Provider class to implement Java Security services and provide SSL/TLS-based connections. These providers are crucial to ensure secure network communications and secure other functionalities which depend on cryptography. The list of security providers included in Android varies between versions of Android and the OEM-specific builds.
* 要旨: The problem with this kind of security provider (one example is OpenSSL), which comes with the device, is that it often has bugs and/or vulnerabilities. Thus, Android applications should not only choose the correct algorithms and provide a good configuration, in some cases they should also pay attention to the strength of the implementations in the legacy security providers.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CRYPTO/MASTG-KNOW-0011/>
* 関連制御群: `MASVS-CRYPTO`（暗号）

## Security Providerの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Security Providerの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CRYPTO）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Security Providerの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* プラットフォーム提供の暗号 API を使う
* CSPRNG で乱数・鍵材料を生成する
* 鍵を Keystore/Keychain 等へ保管する
* 公式記事内のコード例言語: default, groovy, java, kotlin
```

## ナレッジベース

### DO: プラットフォーム提供の暗号 API を使う

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- プラットフォーム提供の暗号 API を使う
- CSPRNG で乱数・鍵材料を生成する
- 鍵を Keystore/Keychain 等へ保管する

```

### DO NOT: 自前プロトコルや固定 IV・ハードコード鍵を使う

* 理由: MASVS-CRYPTO の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 自前プロトコルや固定 IV・ハードコード鍵を使う
- 非推奨アルゴリズムを新規採用する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0011 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CRYPTO/MASTG-KNOW-0011/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CRYPTO`: <https://mas.owasp.org/MASVS/>
