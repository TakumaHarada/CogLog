---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0072/
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
mastg_know_id: MASTG-KNOW-0072
masvs_category: MASVS-NETWORK
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0072: Server Trust Evaluation

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Server Trust Evaluation」（iOS / ネットワーク）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: ATS imposes extended security checks that supplement the default server trust evaluation prescribed by the Transport Layer Security (TLS) protocol. Loosening ATS restrictions reduces the security of the app. Apps should prefer alternative ways to improve server security before adding ATS exceptions.
* 要旨: The Apple Developer Documentation explains that an app can use URLSession to automatically handle server trust evaluation. However, apps are also able to customize that process, for example they can:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0072/>
* 関連制御群: `MASVS-NETWORK`（ネットワーク）

## Server Trust Evaluationの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Server Trust Evaluationの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-NETWORK）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Server Trust Evaluationの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* bypass or customize certificate expiry.
* loosen/extend trust: accept server credentials that would otherwise be rejected by the system, e.g. to make secure connections to a development server using self-signed certificates embedded in the...
* tighten trust: reject credentials that would otherwise be accepted by the system.
* Preventing Insecure Network Connections
* Performing Manual Server Trust Authentication
* 公式記事内のコード例言語: xml
```

## ナレッジベース

### DO: 本番で cleartext / ATS 全面緩和を禁止する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 本番で cleartext / ATS 全面緩和を禁止する
- 証明書検証をスキップするコードパスを置かない
- 開発用例外を debug ビルドへ隔離する
- bypass or customize certificate expiry.
- loosen/extend trust: accept server credentials that would otherwise be rejected by the system, e.g. to make secure connections to a development server using self-signed certificates embedded in the app.
- tighten trust: reject credentials that would otherwise be accepted by the system.
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
- 変更レビューで MASTG-KNOW-0072 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-NETWORK/MASTG-KNOW-0072/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-NETWORK`: <https://mas.owasp.org/MASVS/>
