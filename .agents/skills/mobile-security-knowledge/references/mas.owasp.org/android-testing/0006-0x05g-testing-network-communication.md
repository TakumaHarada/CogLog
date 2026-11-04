---
source: https://mas.owasp.org/MASTG/0x05g-Testing-Network-Communication/
scopes:
  - test
  - android
  - backend
  - mobile
  - network
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-NETWORK
---

# MASTG 0x05g: Android Network Communication

## 概要

本ドキュメントは MASTG「Android Network Communication」を蒸留したものである。公衆 Wi-Fi 等の非信頼網を前提に、HTTP 系通信の機密性と完全性を確保する。詳細は Network Security Config・ピンニング・TLS の Knowledge / Tests へ展開する。

* 正本: <https://mas.owasp.org/MASTG/0x05g-Testing-Network-Communication/>
* Knowledge: MASTG-KNOW-0014 / 0015 等
* Tests: `docs/security/mas.owasp.org/tests/android/MASVS-NETWORK/`

## 非信頼ネットワーク前提で全通信を保護する

バックエンド・分析・課金・WebView 内通信を含め、平文と検証スキップを本番から排除する。

### 非信頼ネットワーク前提で全通信を保護するの補足

* 利点: MITM によるトークン・PII 盗聴を防げる
* 注意点: 「HTTPS を使っている」だけでは不十分。証明書検証と cleartext 例外を見る
* 適用範囲: API クライアント、SDK、ディープリンク先通信
* 例外: debug 限定の開発例外（本番分離）

### 非信頼ネットワーク前提で全通信を保護するの実装例

```text
必須確認
* Network Security Config / cleartextTrafficPermitted
* カスタム TrustManager / badCertificateCallback の有無
* ピンニング導入時は更新・障害手順（MASTG-TEST-0244 等）
* 第三者 SDK の通信先も対象

実装分離例
* debug: usesCleartextTraffic 可
* release: cleartext 禁止
```

```xml
<!-- debug 限定 -->
<application android:usesCleartextTraffic="true" ... />
```

## ナレッジベース

### DO: ネットワーク変更時にプロキシ観測または NSC 静的確認をテスト計画へ入れる

```text
# 推奨
checks: [NSC, cleartext, cert validation, pinning policy]
tests: MASVS-NETWORK current
```

### DO NOT: 開発用の証明書検証スキップを共通モジュールへ残す

* 理由: 本番ビルドへ混入しやすい
* 理由: NETWORK 制御の中核を無効化する

```text
# DO NOT: trustAllCerts = true

# DO: 開発はローカル CA / エミュレータ専用設定に閉じる
```

## 参考リンク

* Android Network Communication: <https://mas.owasp.org/MASTG/0x05g-Testing-Network-Communication/>
* Network Security Config Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0014/>
