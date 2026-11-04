---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0066/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - crypto
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0066
masvs_category: MASVS-CRYPTO
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0066: CryptoKit

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「CryptoKit」（iOS / 暗号）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Apple CryptoKit was released with iOS 13 and is built on top of Apple's native cryptographic library corecrypto which is FIPS 140-2 validated. The Swift framework provides a strongly typed API interface, has effective memory management, conforms to equatable, and supports generics. CryptoKit contains secure algorithms for hashing, symmetric-key cryptography, and public-key cryptography. The framework can also util...
* 要旨: Apple CryptoKit contains the following algorithms:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0066/>
* 関連制御群: `MASVS-CRYPTO`（暗号）

## CryptoKitの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### CryptoKitの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CRYPTO）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### CryptoKitの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Message Authentication Codes (HMAC)
* Apple CryptoKit | Apple Developer Documentation
* Performing Common Cryptographic Operations | Apple Developer Documentation
* WWDC 2019 session 709 | Cryptography and Your Apps
* How to calculate the SHA hash of a String or Data instance | Hacking with Swift
* 公式記事内のコード例言語: default
```

## ナレッジベース

### DO: プラットフォーム提供の暗号 API を使う

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- プラットフォーム提供の暗号 API を使う
- CSPRNG で乱数・鍵材料を生成する
- 鍵を Keystore/Keychain 等へ保管する
- Message Authentication Codes (HMAC)
- Apple CryptoKit | Apple Developer Documentation
- Performing Common Cryptographic Operations | Apple Developer Documentation
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
- 変更レビューで MASTG-KNOW-0066 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0066/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CRYPTO`: <https://mas.owasp.org/MASVS/>
