---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0004/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - code
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0004
masvs_category: MASVS-CODE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0004: Third-Party Libraries

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Third-Party Libraries」（Android / コード品質）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Android apps often make use of third party libraries. These third party libraries accelerate development as the developer has to write less code in order to solve a problem. There are two categories of libraries:
* 要旨: - Libraries that are not (or should not) be packed within the actual production application, such as Mockito used for testing and libraries like JavaAssist used to compile certain other libraries. - Libraries that are packed within the actual production application, such as Okhttp3.

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0004/>
* 関連制御群: `MASVS-CODE`（コード品質）

## Third-Party Librariesの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Third-Party Librariesの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-CODE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Third-Party Librariesの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Libraries that are not (or should not) be packed within the actual production application, such as Mockito used for testing and libraries like JavaAssist used to compile certain other libraries.
* Libraries that are packed within the actual production application, such as Okhttp3.
* A library can contain a vulnerability, which will make the application vulnerable. A good example are the versions of OKHTTP prior to 2.7.5 in which TLS chain pollution was possible to bypass SSL p...
* A library can no longer be maintained or hardly be used, which is why no vulnerabilities are reported and/or fixed. This can lead to having bad and/or vulnerable code in your application through th...
* A library can use a license, such as LGPL2.1, which requires the application author to provide access to the source code for those who use the application and request insight in its sources. In fac...
```

## ナレッジベース

### DO: 依存関係の既知脆弱性をリリース前にトリアージする

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 依存関係の既知脆弱性をリリース前にトリアージする
- debuggable / デバッグ記号を本番から除去する
- 例外情報に秘密を載せない
- Libraries that are not (or should not) be packed within the actual production application, such as Mockito used for testing and libraries like JavaAssist used to compile certain other libraries.
- Libraries that are packed within the actual production application, such as Okhttp3.
- A library can contain a vulnerability, which will make the application vulnerable. A good example are the versions of OKHTTP prior to 2.7.5 in which TLS chain pollution was possible to bypass SSL pinning.
```

### DO NOT: 本番で StrictMode 違反やデバッグ設定を残す

* 理由: MASVS-CODE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 本番で StrictMode 違反やデバッグ設定を残す
- 未検証の動的コードロードを行う

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0004 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-CODE/MASTG-KNOW-0004/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-CODE`: <https://mas.owasp.org/MASVS/>
