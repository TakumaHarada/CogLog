---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0025/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0025
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0025: Use Secure Random Number Generator APIs

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Secure Random Number Generator APIs」（ios）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Use secure random number generator APIs that are backed by the operating system _cryptographically secure pseudorandom number generator (CSPRNG)_. Do not build your own _pseudorandom number generator (PRNG)_.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0025/>
* 関連 Knowledge: `MASTG-KNOW-0070`
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Secure Random Number Generator APIsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Secure Random Number Generator APIsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Secure Random Number Generator APIsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Use secure random number generator APIs that are backed by the operating system _cryptographically secure pseudorandom number generator (CSPRNG)_. Do not build your own _pseudorandom number generator (PRNG)_.
* Security Framework (preferred): Use the SecRandomCopyBytes) API from the Security framework, which produces cryptographically secure random bytes backed by the system CSPRNG.
* CommonCrypto: You _could_ use CCRandomCopyBytes or CCRandomGenerateBytes (not documented on the Apple Developers website), which are also backed by the system CSPRNG. However, prefer SecRandomCopyBytes which is a wrapper around these functions.
* Swift Standard Library: You can use the Swift Standard Library .random APIs which are backed by SystemRandomNumberGenerator. However, note that their random number generator can be customized, so ensure you use the default SystemRandomNumberGenerator (e.g., by not specifying a custom generator) or a secure alternative (ensure it is cryptographically secure).
* CryptoKit: CryptoKit doesn't expose a direct random byte generator, but it provides secure random nonces and keys through its cryptographic operations, which are backed by the system CSPRNG. For example, you can use SymmetricKey for keys and AES.GCM.Nonce for nonces without needing to manage raw random bytes directly.
* In Flutter or Dart use Random.secure(), which is documented as cryptographically secure. It reaches SecRandomCopyBytes through the platform integration layers. See this article for a security review.
* In React Native use a library such as react-native-secure-random or react-native-get-random-values, which internally calls SecRandomCopyBytes on iOS.
```

## ナレッジベース

### DO: Use Secure Random Number Generator APIs を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Secure Random Number Generator APIs を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0070）と合わせてレビューする
- Use secure random number generator APIs that are backed by the operating system _cryptographically secure pseudorandom number generator (CSPRNG)_. Do not build your own _pseudorandom number generator (PRNG)_.
- Security Framework (preferred): Use the SecRandomCopyBytes) API from the Security framework, which produces cryptographically secure random bytes backed by the system CSPRNG.
- CommonCrypto: You _could_ use CCRandomCopyBytes or CCRandomGenerateBytes (not documented on the Apple Developers website), which are also backed by the system CSPRNG. However, prefer SecRandomCopyBytes which is a wrapper around these functions.
```

### DO NOT: MASTG-BEST-0025 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- java.util.Random / Math.random 等の非暗号乱数を鍵・トークン生成に使う
- SecureRandom に固定・推測可能な seed を渡す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0025 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0025/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
