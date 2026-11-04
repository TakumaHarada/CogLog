---
source: https://mas.owasp.org/MASTG/0x05e-Testing-Cryptography/
scopes:
  - test
  - android
  - mobile
  - cryptography
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-CRYPTO
---

# MASTG 0x05e: Android Cryptographic APIs

## 概要

本ドキュメントは MASTG「Android Cryptographic APIs」を蒸留したものである。JCA / Conscrypt / Keystore を前提に、プロバイダ指定・乱数・パラメータの誤りをレビュー観点へ落とす。

* 正本: <https://mas.owasp.org/MASTG/0x05e-Testing-Cryptography/>
* Knowledge: MASTG-KNOW-0011 / 0012 / 0013 / 0043 / 0048 等
* Tests: `docs/security/mas.owasp.org/tests/android/MASVS-CRYPTO/`

## デフォルトのセキュリティプロバイダを使う

`getInstance` で古いプロバイダを固定せず、パッチ済みの既定実装（Conscrypt / AndroidOpenSSL）を使う。

### デフォルトのセキュリティプロバイダを使うの補足

* 利点: OS 更新に追従したアルゴリズム実装を得られる
* 注意点: Keystore 用途以外でのプロバイダ固定は API 28+ でエラーになりうる
* 適用範囲: 暗号 API 利用コード、依存ライブラリ
* 例外: Android Keystore を明示指定する場合

### デフォルトのセキュリティプロバイダを使うの実装例

```text
公式推奨（章内 General Recommendations）
* セキュリティプロバイダを指定せず既定実装を使う
* Crypto プロバイダと SHA1PRNG を使わない（削除済み）
* GCM では IvParameterSpec ではなく GCMParameterSpec
* Password-based cipher を IV 無しで使わない
* KeyGenParameterSpec を使い KeyPairGeneratorSpec を避ける
* ProviderInstaller 等でプロバイダ更新を検討する
```

## 鍵ライフサイクルを Keystore に寄せる

生成・利用・保管・破棄をアプリ独自平文ファイルへ落とさない。

### 鍵ライフサイクルを Keystore に寄せるの補足

* 利点: 鍵材料の露出面を TEE/StrongBox 側へ寄せられる
* 注意点: 「暗号している」ことと「鍵管理が正しい」ことは別である
* 適用範囲: ローカル暗号、トークン保護、署名
* 例外: なし

### 鍵ライフサイクルを Keystore に寄せるの実装例

```text
レビューで追う関数群
* 鍵生成（KeyGenParameterSpec 等）
* 乱数（CSPRNG）
* 鍵回転
* 保管が Keystore/KeyChain か

関連 Knowledge
* MASTG-KNOW-0011 Security Provider
* MASTG-KNOW-0012 Key Generation
* MASTG-KNOW-0013 Random Number Generation
* MASTG-KNOW-0043 Android KeyStore
```

## ナレッジベース

### DO: 暗号コードレビューでアルゴリズム名・モード・IV・鍵の所在を表にする

```text
# 推奨
alg: AES-GCM
iv: GCMParameterSpec / random
key: AndroidKeyStore (StrongBox?)
provider: default (no Crypto)
```

### DO NOT: 自前 XOR・固定鍵・SHA1PRNG・非推奨 Crypto プロバイダを新規採用する

* 理由: 章が明示する非推奨・削除済み経路である
* 理由: 解析で鍵が取れれば暗号の意味が消える

```text
# DO NOT: Hardcoded key + XOR "encryption"

# DO: Keystore 鍵 + 標準 AEAD
```

## 参考リンク

* Android Cryptographic APIs: <https://mas.owasp.org/MASTG/0x05e-Testing-Cryptography/>
* Updating security provider: <https://developer.android.com/training/articles/security-gms-provider>
