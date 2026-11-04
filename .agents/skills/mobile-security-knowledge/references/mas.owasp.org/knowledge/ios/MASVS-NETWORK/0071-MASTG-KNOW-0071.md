---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0071/
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
mastg_know_id: MASTG-KNOW-0071
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0071: iOS App Transport Security

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「iOS App Transport Security」（iOS / ネットワーク）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Starting with iOS 9, Apple introduced App Transport Security (ATS) which is a set of security checks enforced by the operating system for connections made using the URL Loading System (typically via URLSession) to always use HTTPS. Apps should follow Apple's best practices to properly secure their connections.
* 要旨: ATS performs default server trust evaluation and requires a minimum set of security requirements.

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0071/>
* 関連制御群: `MASVS-NETWORK`（ネットワーク）

## iOS App Transport Securityの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### iOS App Transport Securityの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-NETWORK）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### iOS App Transport Securityの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Has a name that matches the server's DNS name.
* Has a digital signature that is valid (hasn't been tampered with) and can be traced back to a trusted Certificate Authority (CA) included in the operating system Trust Store, or be installed on the...
* TLS version 1.2 or greater.
* Data encryption with AES-128 or AES-256.
* The certificate must be signed with an RSA key (2048 bits or greater), or an ECC key (256 bits or greater).
* 公式記事内のコード例言語: objectivec, xml
```

## ナレッジベース

### DO: 本番で cleartext / ATS 全面緩和を禁止する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 本番で cleartext / ATS 全面緩和を禁止する
- 証明書検証をスキップするコードパスを置かない
- 開発用例外を debug ビルドへ隔離する
- Has a name that matches the server's DNS name.
- Has a digital signature that is valid (hasn't been tampered with) and can be traced back to a trusted Certificate Authority (CA) included in the operating system Trust Store, or be installed on the client by the user or a system administrator.
- TLS version 1.2 or greater.
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
- 変更レビューで MASTG-KNOW-0071 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0071/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-NETWORK`: <https://mas.owasp.org/MASVS/>
