---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0010/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0010
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0010: Use Up-to-Date minSdkVersion

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Use Up-to-Date minSdkVersion」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Ensure that the minSdkVersion in the build.gradle file is set to the latest version of the Android platform that aligns with your app's requirements while maintaining compatibility with your user base.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0010/>
* 関連 Knowledge: （未リンク）
* 索引: [`../0000-index.md`](../0000-index.md)

## Use Up-to-Date minSdkVersionを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Use Up-to-Date minSdkVersionを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Use Up-to-Date minSdkVersionを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Ensure that the minSdkVersion in the build.gradle file is set to the latest version of the Android platform that aligns with your app's requirements while maintaining compatibility with your user base.
* Companies often hesitate to increase minSdkVersion because they want their app to be available on as many devices as possible. Even though Google doesn't enforce a specific minSdkVersion, as they do with the targetSdkVersion, it's crucial to understand the implications of setting a low minSdkVersion, as it directly impacts security, exposes users to vulnerabilities, and prevents the app from leveraging critical security protections.
* targetSdkVersion: Defines the highest API level the app is _designed_ to run on. The app _can_ run on lower API levels, but it won't necessarily take advantage of all new security enforcements.
* minSdkVersion: Defines the lowest API level the app is _allowed_ to run on. This is crucial because many security features are only available on devices running a certain API level or higher. If you set a low minSdkVersion, your app completely misses out on these protections on older devices.
* Android 4.2 (API level 16) in November 2012 (introduction of SELinux)
* Android 4.3 (API level 18) in July 2013 (SELinux became enabled by default)
* Android 4.4 (API level 19) in October 2013 (several new APIs and ART introduced)
* Android 5.0 (API level 21) in November 2014 (ART used by default and many other features added)
```

## ナレッジベース

### DO: Use Up-to-Date minSdkVersion を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Use Up-to-Date minSdkVersion を該当機能に適用する
- Ensure that the minSdkVersion in the build.gradle file is set to the latest version of the Android platform that aligns with your app's requirements while maintaining compatibility with your user base.
- Companies often hesitate to increase minSdkVersion because they want their app to be available on as many devices as possible. Even though Google doesn't enforce a specific minSdkVersion, as they do with the targetSdkVersion, it's crucial to understand the implications of setting a low minSdkVersion, as it directly impacts security, exposes users to vulnerabilities, and prevents the app from leveraging critical security protections.
- targetSdkVersion: Defines the highest API level the app is _designed_ to run on. The app _can_ run on lower API levels, but it won't necessarily take advantage of all new security enforcements.
```

### DO NOT: MASTG-BEST-0010 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 古い minSdk のままセキュリティ修正を後回しにする

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0010 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0010/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
