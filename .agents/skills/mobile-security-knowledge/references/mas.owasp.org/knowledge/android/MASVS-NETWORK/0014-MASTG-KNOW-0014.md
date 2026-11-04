---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0014/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - network
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0014
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0014: Android Network Security Configuration

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Android Network Security Configuration」（Android / ネットワーク）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Starting on Android 7.0 (API level 24), Android apps can customize their network security settings using the so-called Network Security Configuration feature which offers the following key capabilities:
* 要旨: - Cleartext traffic: Protect apps from accidental usage of cleartext traffic (or enables it). - Custom trust anchors: Customize which Certificate Authorities (CAs) are trusted for an app's secure connections. For example, trusting particular self-signed certificates or restricting the set of public CAs that the app trusts. - Certificate pinning: Restrict an app's secure connection to particular certificates. - Deb...

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0014/>
* 関連制御群: `MASVS-NETWORK`（ネットワーク）

## Android Network Security Configurationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Android Network Security Configurationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-NETWORK）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Android Network Security Configurationの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Cleartext traffic: Protect apps from accidental usage of cleartext traffic (or enables it).
* Custom trust anchors: Customize which Certificate Authorities (CAs) are trusted for an app's secure connections. For example, trusting particular self-signed certificates or restricting the set of ...
* Certificate pinning: Restrict an app's secure connection to particular certificates.
* Debug-only overrides: Safely debug secure connections in an app without added risk to the installed base.
* base-config applies to all connections that the app attempts to make.
* 公式記事内のコード例言語: bash, xml
```

## ナレッジベース

### DO: 本番で cleartext / ATS 全面緩和を禁止する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 本番で cleartext / ATS 全面緩和を禁止する
- 証明書検証をスキップするコードパスを置かない
- 開発用例外を debug ビルドへ隔離する
- Cleartext traffic: Protect apps from accidental usage of cleartext traffic (or enables it).
- Custom trust anchors: Customize which Certificate Authorities (CAs) are trusted for an app's secure connections. For example, trusting particular self-signed certificates or restricting the set of public CAs that the app trusts.
- Certificate pinning: Restrict an app's secure connection to particular certificates.
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
- 変更レビューで MASTG-KNOW-0014 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0014/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-NETWORK`: <https://mas.owasp.org/MASVS/>
