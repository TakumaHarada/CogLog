---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0073/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - network
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0073
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0073: iOS Network APIs

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「iOS Network APIs」（iOS / ネットワーク）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: On iOS, you can create network connections through multiple API layers. These layers differ in abstraction level, supported protocols, and how much of the connection lifecycle they manage. See "TN3151: Choosing the right networking API" for advice on selecting the appropriate API for your use case.
* 要旨: The URL Loading System is the highest-level networking stack in Foundation. It is the primary API surface for HTTP and HTTPS.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0073/>
* 関連制御群: `MASVS-NETWORK`（ネットワーク）

## iOS Network APIsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### iOS Network APIsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-NETWORK）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### iOS Network APIsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* URLAuthenticationChallenge
* tlsMinimumSupportedProtocolVersion: sets the minimum TLS version the session accepts. Accepts tls_protocol_version_t values such as tls_protocol_version_TLSv10, tls_protocol_version_TLSv11, tls_pro...
* tlsMaximumSupportedProtocolVersion: sets the maximum TLS version the session uses.
* sec_protocol_options_set_min_tls_protocol_version(_:_:)): sets the minimum TLS version. Accepts tls_protocol_version_t values such as tls_protocol_version_TLSv10, tls_protocol_version_TLSv12, etc.
* sec_protocol_options_set_max_tls_protocol_version(_:_:)): sets the maximum TLS version.
```

## ナレッジベース

### DO: 本番で cleartext / ATS 全面緩和を禁止する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 本番で cleartext / ATS 全面緩和を禁止する
- 証明書検証をスキップするコードパスを置かない
- 開発用例外を debug ビルドへ隔離する
- URLAuthenticationChallenge
- tlsMinimumSupportedProtocolVersion: sets the minimum TLS version the session accepts. Accepts tls_protocol_version_t values such as tls_protocol_version_TLSv10, tls_protocol_version_TLSv11, tls_protocol_version_TLSv12, and tls_protocol_version_TLSv13.
- tlsMaximumSupportedProtocolVersion: sets the maximum TLS version the session uses.
```

### DO NOT: badCertificateCallback 等で常時成功を返す

* 理由: MASVS-NETWORK の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- badCertificateCallback 等で常時成功を返す
- 自己署名を本番で無条件許可する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0073 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0073/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-NETWORK`: <https://mas.owasp.org/MASVS/>
