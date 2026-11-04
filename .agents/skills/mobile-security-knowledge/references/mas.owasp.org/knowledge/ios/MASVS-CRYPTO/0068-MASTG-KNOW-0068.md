---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0068/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - crypto
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0068
masvs_category: MASVS-CRYPTO
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0068: Cryptographic Third-Party libraries

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Cryptographic Third-Party libraries」（iOS / 暗号）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: There are various third-party libraries available, such as:
* 要旨: - CJOSE: With the rise of JWE, and the lack of public support for AES GCM, other libraries have found their way, such as CJOSE. CJOSE still requires a higher level wrapping as they only provide a C/C++ implementation. - CryptoSwift: A library in Swift, which can be found at GitHub. The library supports various hash-functions, MAC-functions, CRC-functions, symmetric ciphers, and password-based key derivation functi...

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0068/>
* 関連制御群: `MASVS-CRYPTO`（暗号）

## Cryptographic Third-Party librariesの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Cryptographic Third-Party librariesの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CRYPTO）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Cryptographic Third-Party librariesの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* CJOSE: With the rise of JWE, and the lack of public support for AES GCM, other libraries have found their way, such as CJOSE. CJOSE still requires a higher level wrapping as they only provide a C/C...
* CryptoSwift: A library in Swift, which can be found at GitHub. The library supports various hash-functions, MAC-functions, CRC-functions, symmetric ciphers, and password-based key derivation functi...
* OpenSSL: OpenSSL is the toolkit library used for TLS, written in C. Most of its cryptographic functions can be used to do the various cryptographic actions necessary, such as creating (H)MACs, sign...
* LibSodium: Sodium is a modern, easy-to-use software library for encryption, decryption, signatures, password hashing and more. It is a portable, cross-compilable, installable, packageable fork of N...
* Tink: A new cryptography library by Google. Google explains its reasoning behind the library on its security blog. The sources can be found at Tinks GitHub repository.
```

## ナレッジベース

### DO: プラットフォーム提供の暗号 API を使う

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- プラットフォーム提供の暗号 API を使う
- CSPRNG で乱数・鍵材料を生成する
- 鍵を Keystore/Keychain 等へ保管する
- CJOSE: With the rise of JWE, and the lack of public support for AES GCM, other libraries have found their way, such as CJOSE. CJOSE still requires a higher level wrapping as they only provide a C/C++ implementation.
- CryptoSwift: A library in Swift, which can be found at GitHub. The library supports various hash-functions, MAC-functions, CRC-functions, symmetric ciphers, and password-based key derivation functions. It is not a wrapper, but a fully self-implemented version of each of the ciphers. It is important to verify the effective implementation of a function.
- OpenSSL: OpenSSL is the toolkit library used for TLS, written in C. Most of its cryptographic functions can be used to do the various cryptographic actions necessary, such as creating (H)MACs, signatures, symmetric- & asymmetric ciphers, hashing, etc.. There are various wrappers, such as OpenSSL and MIHCrypto.
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
- 変更レビューで MASTG-KNOW-0068 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0068/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CRYPTO`: <https://mas.owasp.org/MASVS/>
