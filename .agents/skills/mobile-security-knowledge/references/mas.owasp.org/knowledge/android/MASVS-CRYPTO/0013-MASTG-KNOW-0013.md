---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CRYPTO/MASTG-KNOW-0013/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - crypto
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0013
masvs_category: MASVS-CRYPTO
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0013: Random Number Generation

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Random Number Generation」（Android / 暗号）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Cryptography requires secure pseudo random number generation (PRNG). Standard Java classes as java.util.Random do not provide sufficient randomness and in fact may make it possible for an attacker to guess the next value that will be generated, and use this guess to impersonate another user or access sensitive information.
* 要旨: In general, SecureRandom should be used. However, if the Android versions below Android 4.4 (API level 19) are supported, additional care needs to be taken in order to work around the bug in Android 4.1-4.3 (API level 16-18) versions that failed to properly initialize the PRNG.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CRYPTO/MASTG-KNOW-0013/>
* 関連制御群: `MASVS-CRYPTO`（暗号）

## Random Number Generationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Random Number Generationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CRYPTO）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Random Number Generationの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* プラットフォーム提供の暗号 API を使う
* CSPRNG で乱数・鍵材料を生成する
* 鍵を Keystore/Keychain 等へ保管する
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
- 変更レビューで MASTG-KNOW-0013 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CRYPTO/MASTG-KNOW-0013/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CRYPTO`: <https://mas.owasp.org/MASVS/>
