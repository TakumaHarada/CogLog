---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0002/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0002
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0002: Remove Logging Code

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Remove Logging Code」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Ideally, a release build shouldn't use any logging functions, making it easier to assess sensitive data exposure.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0002/>
* 関連 Knowledge: `MASTG-KNOW-0049`
* 索引: [`../0000-index.md`](../0000-index.md)

## Remove Logging Codeを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Remove Logging Codeを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Remove Logging Codeを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Ideally, a release build shouldn't use any logging functions, making it easier to assess sensitive data exposure.
* While preparing the production release, you can use tools like @MASTG-TOOL-0022 (included in Android Studio). To determine whether all logging functions from the android.util.Log class have been removed, check the ProGuard configuration file (proguard-rules.pro) for the following options (according to this example of removing logging code and this article about enabling ProGuard in an Android Studio project):
* 公式記事内のコード例言語: default, java, kotlin
```

## ナレッジベース

### DO: Remove Logging Code を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Remove Logging Code を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0049）と合わせてレビューする
- Ideally, a release build shouldn't use any logging functions, making it easier to assess sensitive data exposure.
- While preparing the production release, you can use tools like @MASTG-TOOL-0022 (included in Android Studio). To determine whether all logging functions from the android.util.Log class have been removed, check the ProGuard configuration file (proguard-rules.pro) for the following options (according to this example of removing logging code and this article about enabling ProGuard in an Android Studio project):
```

### DO NOT: MASTG-BEST-0002 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 本番ビルドに verbose / debug ログや機微データ出力を残す
- トークン・PII を Logcat / NSLog 相当へ出す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0002 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0002/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
