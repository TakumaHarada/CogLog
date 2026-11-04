---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0015/
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
mastg_know_id: MASTG-KNOW-0015
masvs_category: MASVS-NETWORK
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0015: Certificate Pinning

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Certificate Pinning」（Android / ネットワーク）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Certificate pinning can be employed in Android apps to safeguard against Machine-in-the-Middle (MITM) attacks by ensuring that the app communicates exclusively with remote endpoints possessing specific identities.
* 要旨: While effective when implemented correctly, insecure implementations potentially enable attackers to read and modify all communication. For more general details on pinning, refer to @MASWE-0028.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0015/>
* 関連制御群: `MASVS-NETWORK`（ネットワーク）

## Certificate Pinningの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Certificate Pinningの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-NETWORK）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Certificate Pinningの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Modifying the certificate validation logic: in the app's TrustManager.
* Replacing pinned certificates: stored in resource directories (res/raw/, assets/).
* Altering or removing pins: in the Network Security Configuration.
* Get and validate the incoming certificate.
* Calculate a digest over the extracted public key.
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
- Modifying the certificate validation logic: in the app's TrustManager.
- Replacing pinned certificates: stored in resource directories (res/raw/, assets/).
- Altering or removing pins: in the Network Security Configuration.
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
- 変更レビューで MASTG-KNOW-0015 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-NETWORK/MASTG-KNOW-0015/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-NETWORK`: <https://mas.owasp.org/MASVS/>
