---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0052/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0052
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0052: Restrict Access to Android App Components

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Restrict Access to Android App Components」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Only export an app component when another app genuinely needs to interact with it. Every exported component is an entry point that other apps on the device may be able to invoke, so keeping components private by default reduces the app's attack surface.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0052/>
* 関連 Knowledge: `MASTG-KNOW-0017`, `MASTG-KNOW-0132`, `MASTG-KNOW-0133`, `MASTG-KNOW-0134`, `MASTG-KNOW-0020`
* 索引: [`../0000-index.md`](../0000-index.md)

## Restrict Access to Android App Componentsを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Restrict Access to Android App Componentsを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Restrict Access to Android App Componentsを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Only export an app component when another app genuinely needs to interact with it. Every exported component is an entry point that other apps on the device may be able to invoke, so keeping components private by default reduces the app's attack surface.
* Declare android:exported="false" on every manifest-declared component that doesn't need to be accessible to other apps. Don't rely on the default value: it has changed across Android versions and component types, and an <intent-filter> historically makes a component exported unless the attribute is set explicitly. Since Android 12 (API level 31), any activity, service, or broadcast receiver with an intent filter must explicitly declare android:exported.
* 公式記事内のコード例言語: xml, kotlin
```

## ナレッジベース

### DO: Restrict Access to Android App Components を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Restrict Access to Android App Components を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0017, MASTG-KNOW-0132, MASTG-KNOW-0133, MASTG-KNOW-0134, MASTG-KNOW-0020）と合わせてレビューする
- Only export an app component when another app genuinely needs to interact with it. Every exported component is an entry point that other apps on the device may be able to invoke, so keeping components private by default reduces the app's attack surface.
- Declare android:exported="false" on every manifest-declared component that doesn't need to be accessible to other apps. Don't rely on the default value: it has changed across Android versions and component types, and an <intent-filter> historically makes a component exported unless the attribute is set explicitly. Since Android 12 (API level 31), any activity, service, or broadcast receiver with an intent filter must explicitly declare android:exported.
```

### DO NOT: MASTG-BEST-0052 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 不要コンポーネントを exported のまま公開する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0052 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0052/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
