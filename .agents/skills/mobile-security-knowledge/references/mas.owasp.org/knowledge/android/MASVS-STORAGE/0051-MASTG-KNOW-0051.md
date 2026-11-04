---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0051/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - storage
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0051
masvs_category: MASVS-STORAGE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0051: Process Memory

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Process Memory」（Android / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Many applications handle sensitive information, provided either by the user, the operating system or the backend. This data is often available in-memory while the user is using the application, as it is needed for the application to function. When the application no longer actively needs the sensitive data, it should dispose of it immediately.
* 要旨: The investigation of an application's memory can be done from memory dumps, and from analyzing the memory in real time via a debugger or a binary instrumentation framework (see and ).

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0051/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Process Memoryの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Process Memoryの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Process Memoryの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Overwriting the byte array returned by secretKey.getEncoded() does not clear the internal key, because getEncoded() returns a copy. Zeroing that copy has no effect on the bytes held by the key object.
* SecretKeySpec does not provide a functional destroy() implementation, and this gap has been tracked in the JDK. Calling destroy() on a SecretKey backed by SecretKeySpec therefore does not guarantee...
* RSA keys handled outside the Android Keystore are backed by immutable BigInteger objects, which cannot be cleared once created, leaving their data in memory until garbage collected.
* User-provided data (such as credentials, social security numbers, or credit card information) entered through EditText is delivered via the Editable interface. If your app does not supply a custom ...
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- Overwriting the byte array returned by secretKey.getEncoded() does not clear the internal key, because getEncoded() returns a copy. Zeroing that copy has no effect on the bytes held by the key object.
- SecretKeySpec does not provide a functional destroy() implementation, and this gap has been tracked in the JDK. Calling destroy() on a SecretKey backed by SecretKeySpec therefore does not guarantee that the key material is wiped.
- RSA keys handled outside the Android Keystore are backed by immutable BigInteger objects, which cannot be cleared once created, leaving their data in memory until garbage collected.
```

### DO NOT: SharedPreferences / UserDefaults にパスワードを平文保存する

* 理由: MASVS-STORAGE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- SharedPreferences / UserDefaults にパスワードを平文保存する
- バックアップ対象にトークンを残す

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0051 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0051/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
