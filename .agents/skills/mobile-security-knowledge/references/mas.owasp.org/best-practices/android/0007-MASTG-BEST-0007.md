---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0007/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0007
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0007: Debuggable Flag Disabled in the AndroidManifest

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Debuggable Flag Disabled in the AndroidManifest」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Ensure the debuggable flag in the AndroidManifest.xml is set to false for all release builds.

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0007/>
* 関連 Knowledge: `MASTG-KNOW-0007`
* 索引: [`../0000-index.md`](../0000-index.md)

## Debuggable Flag Disabled in the AndroidManifestを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Debuggable Flag Disabled in the AndroidManifestを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Debuggable Flag Disabled in the AndroidManifestを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Ensure the debuggable flag in the AndroidManifest.xml is set to false for all release builds.
* Note: Disabling debugging via the debuggable flag is an important first step but does not fully protect the app from advanced attacks. Skilled attackers can enable debugging through various means, such as binary patching (see @MASTG-TECH-0038) to allow attachment of a debugger or the use of binary instrumentation tools like @MASTG-TOOL-0001 to achieve similar capabilities. For apps requiring a higher level of security, consider implementing anti-debugging techniques as an additional layer of defense. Refer to @MASWE-0064 for detailed guidance.
```

## ナレッジベース

### DO: Debuggable Flag Disabled in the AndroidManifest を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Debuggable Flag Disabled in the AndroidManifest を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0007）と合わせてレビューする
- Ensure the debuggable flag in the AndroidManifest.xml is set to false for all release builds.
- Note: Disabling debugging via the debuggable flag is an important first step but does not fully protect the app from advanced attacks. Skilled attackers can enable debugging through various means, such as binary patching (see @MASTG-TECH-0038) to allow attachment of a debugger or the use of binary instrumentation tools like @MASTG-TOOL-0001 to achieve similar capabilities. For apps requiring a higher level of security, consider implementing anti-debugging techniques as an additional layer of defense. Refer to @MASWE-0064 for detailed guidance.
```

### DO NOT: MASTG-BEST-0007 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- release で android:debuggable=true を残す

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0007 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0007/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
