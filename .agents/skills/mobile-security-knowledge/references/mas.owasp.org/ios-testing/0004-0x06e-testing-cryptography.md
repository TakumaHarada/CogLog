---
source: https://mas.owasp.org/MASTG/0x06e-Testing-Cryptography/
scopes:
  - test
  - ios
  - mobile
  - cryptography
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-CRYPTO
---

# MASTG 0x06e: iOS Cryptographic APIs

## 概要

本ドキュメントは MASTG「iOS Cryptographic APIs」を蒸留したものである。CryptoKit / CommonCrypto / SecKey 等の公式 API を使い、パラメータを現行ベストプラクティスと照合する。

* 正本: <https://mas.owasp.org/MASTG/0x06e-Testing-Cryptography/>
* Knowledge: MASTG-KNOW-0066〜0070 等
* Tests: `docs/security/mas.owasp.org/tests/ios/MASVS-CRYPTO/`

## Apple 提供の暗号 API を優先する

自前プロトコルや古いサードパーティ実装より、CryptoKit / Security framework を使う。

### Apple 提供の暗号 API を優先するの補足

* 利点: 実装ミスと古いアルゴリズム残留を減らせる
* 注意点: API を使っていてもモード・IV・鍵管理が誤れば無効
* 適用範囲: ローカル暗号、署名、鍵合意
* 例外: 規制で特定実装が必須の場合（根拠を残す）

### Apple 提供の暗号 API を優先するの実装例

```text
確認
* CryptoKit / SecKey / CommonCrypto のどれか
* 非推奨ハッシュ・弱い鍵長が無いか
* 乱数は SecRandomCopyBytes 等の CSPRNG
* 鍵は Keychain / Secure Enclave 連携か
```

## 鍵管理を STORAGE / Keychain と一体で見る

暗号処理の正しさと鍵の所在は別問題である。

### 鍵管理を STORAGE / Keychain と一体で見るの補足

* 利点: 「暗号化している」だけの誤った充足判定を防げる
* 注意点: ハードコード鍵・ソース埋め込み秘密は即 fail
* 適用範囲: CRYPTO + STORAGE レビュー
* 例外: なし

### 鍵管理を STORAGE / Keychain と一体で見るの実装例

```text
レビュー表
alg / mode / iv / key_location / rotation
関連: 0x06d Data Storage、Key Management Knowledge
```

## ナレッジベース

### DO: 暗号コード変更でアルゴリズム・モード・IV・鍵の所在をレビューコメントに書く

```text
# 推奨
alg: AES-GCM or CryptoKit equivalent
key: Keychain / Secure Enclave
rng: SecRandomCopyBytes
```

### DO NOT: 自前 XOR・固定 IV・ハードコード鍵を新規採用する

* 理由: 一般暗号ベストプラクティス違反であり解析で破られる
* 理由: iOS でも鍵露出が致命傷になる点は Android と同じ

```text
# DO NOT: ソース内固定鍵で「暗号化」

# DO: OS API + Keychain
```

## 参考リンク

* iOS Cryptographic APIs: <https://mas.owasp.org/MASTG/0x06e-Testing-Cryptography/>
* Apple Cryptographic Services: <https://developer.apple.com/documentation/security>
