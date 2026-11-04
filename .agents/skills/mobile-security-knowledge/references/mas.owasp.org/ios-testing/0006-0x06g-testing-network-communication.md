---
source: https://mas.owasp.org/MASTG/0x06g-Testing-Network-Communication/
scopes:
  - test
  - ios
  - backend
  - mobile
  - network
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-NETWORK
---

# MASTG 0x06g: iOS Network Communication

## 概要

本ドキュメントは MASTG「iOS Network Communication」を蒸留したものである。公衆 Wi-Fi 等の非信頼網を前提に、ATS・サーバ信頼評価・低レイヤ API 抜け道を確認する。

* 正本: <https://mas.owasp.org/MASTG/0x06g-Testing-Network-Communication/>
* Knowledge: MASTG-KNOW-0071 / 0072 / 0073
* Tests: `docs/security/mas.owasp.org/tests/ios/MASVS-NETWORK/`

## ATS 既定を本番で維持する

`NSAllowsArbitraryLoads` や広範な例外を本番 Info.plist に残さない。例外は最小ドメイン・理由付きとする。

### ATS 既定を本番で維持するの補足

* 利点: 平文・弱い TLS への後退を防げる
* 注意点: ATS は URL Loading System 系に主に適用。BSD ソケット等の低レイヤは対象外になりうる
* 適用範囲: URLSession、WKWebView、SDK 通信
* 例外: 開発専用（Debug 設定へ隔離）

### ATS 既定を本番で維持するの実装例

```text
確認
* NSAppTransportSecurity 例外の有無
* 自己署名許可・検証スキップ API の不使用
* 第三者 SDK の平文通信
* IP / .local 接続が機微データを運んでいないか
```

## サーバ信頼評価を無効化しない

カスタム評価で常時成功を返す実装を禁止する。ピンニング導入時は更新手順を先に決める。

### サーバ信頼評価を無効化しないの補足

* 利点: MITM 耐性の中核を維持できる
* 注意点: 開発用スキップの残留が最大リスク
* 適用範囲: NETWORK テスト・実装レビュー
* 例外: なし

### サーバ信頼評価を無効化しないの実装例

```text
関連 Knowledge
* MASTG-KNOW-0071 ATS
* MASTG-KNOW-0072 Server Trust Evaluation
* MASTG-KNOW-0073 iOS Network APIs
```

## ナレッジベース

### DO: ネットワーク変更で ATS / 信頼評価 / 例外ドメインをセット確認する

```text
# 推奨
ats_exceptions: none | minimal+justified
trust_eval: platform default
proxy_test: required for sensitive flows
```

### DO NOT: 開発用の証明書検証スキップを共通コードへ残す

* 理由: 本番へ混入しやすい
* 理由: NETWORK 制御を無効化する

```text
# DO NOT: 常時成功の trust evaluation

# DO: Debug 専用設定に閉じる / ローカル CA
```

## 参考リンク

* iOS Network Communication: <https://mas.owasp.org/MASTG/0x06g-Testing-Network-Communication/>
* ATS Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0071/>
