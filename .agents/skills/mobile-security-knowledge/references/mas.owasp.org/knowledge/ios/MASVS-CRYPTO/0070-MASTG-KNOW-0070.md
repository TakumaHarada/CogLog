---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0070/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - crypto
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0070
masvs_category: MASVS-CRYPTO
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0070: Random Number Generator

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Random Number Generator」（iOS / 暗号）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Random number generation is a critical component of many cryptographic operations, including key generation, initialization vectors, nonces, and tokens. Apple systems provide a trusted Cryptographically Secure Pseudorandom Number Generator (CSPRNG) that applications should use to ensure the security and unpredictability of generated random values. This CSPRNG is seeded from multiple entropy sources during system s...
* 要旨: The kernel CSPRNG is based on the Fortuna design and is exposed to user space via the /dev/random and /dev/urandom device files, as well as the getentropy(2) system call.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0070/>
* 関連制御群: `MASVS-CRYPTO`（暗号）

## Random Number Generatorの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Random Number Generatorの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CRYPTO）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Random Number Generatorの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Using arc4random() % n to generate a bounded value can introduce modulo bias, where some outcomes are slightly more likely than others.
* arc4random_buf() produces cryptographically strong random bytes into a caller provided buffer, and does not itself suffer from modulo bias. Any bias only appears if you convert those bytes to a bou...
* arc4random_uniform(n) is specifically designed to avoid modulo bias for arbitrary upper bounds, returning a uniformly distributed integer in the range [0, n), and should be preferred over arc4rando...
* 公式記事内のコード例言語: bash, swift
```

## ナレッジベース

### DO: プラットフォーム提供の暗号 API を使う

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- プラットフォーム提供の暗号 API を使う
- CSPRNG で乱数・鍵材料を生成する
- 鍵を Keystore/Keychain 等へ保管する
- Using arc4random() % n to generate a bounded value can introduce modulo bias, where some outcomes are slightly more likely than others.
- arc4random_buf() produces cryptographically strong random bytes into a caller provided buffer, and does not itself suffer from modulo bias. Any bias only appears if you convert those bytes to a bounded range incorrectly, for example by doing % n on derived integers.
- arc4random_uniform(n) is specifically designed to avoid modulo bias for arbitrary upper bounds, returning a uniformly distributed integer in the range [0, n), and should be preferred over arc4random() % n.
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
- 変更レビューで MASTG-KNOW-0070 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-CRYPTO/MASTG-KNOW-0070/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CRYPTO`: <https://mas.owasp.org/MASVS/>
