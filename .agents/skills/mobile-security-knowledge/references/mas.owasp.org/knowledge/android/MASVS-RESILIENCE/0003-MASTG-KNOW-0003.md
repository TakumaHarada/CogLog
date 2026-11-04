---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0003/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0003
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0003: App Signing

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「App Signing」（Android / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android requires all APKs to be digitally signed with a certificate before they are installed or run. The digital signature is used to verify the owner's identity for application updates. This process can prevent an app from being tampered with or modified to include malicious code.
* 要旨: When an APK is signed, a public-key certificate is attached to it. This certificate uniquely associates the APK with the developer and the developer's private key. When an app is being built in debug mode, the Android SDK signs the app with a debug key created specifically for debugging purposes. An app signed with a debug key is not meant to be distributed and won't be accepted in most app stores, including the G...

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0003/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## App Signingの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### App Signingの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### App Signingの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* APK Signature Scheme v2 (v2 scheme),
* APK Signature Scheme v3 (v3 scheme).
```

## ナレッジベース

### DO: 耐タンパは追加層としサーバ認可の代替にしない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 耐タンパは追加層としサーバ認可の代替にしない
- 脅威モデルで要否と深度を文書化する
- 検知結果はサーバ側判断と組み合わせる
- APK Signature Scheme v2 (v2 scheme),
- APK Signature Scheme v3 (v3 scheme).
```

### DO NOT: 難読化だけで平文保存や cleartext を許容する

* 理由: MASVS-RESILIENCE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 難読化だけで平文保存や cleartext を許容する
- クライアント検知成功 alone で権限を付与する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0003 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0003/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
