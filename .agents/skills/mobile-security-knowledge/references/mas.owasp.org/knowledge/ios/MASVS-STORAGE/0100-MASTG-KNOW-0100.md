---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0100/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - storage
  - backend
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0100
masvs_category: MASVS-STORAGE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0100: Keyboard Cache

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Keyboard Cache」（iOS / データ保存）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Several options, such as autocorrect and spell check, are available to users to simplify keyboard input and are cached by default in .dat files in /private/var/mobile/Library/Keyboard/ and its subdirectories.
* 要旨: The UITextInputTraits protocol is used for keyboard caching. The UITextField, UITextView, and UISearchBar classes automatically support this protocol and it offers the following properties:

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0100/>
* 関連制御群: `MASVS-STORAGE`（データ保存）

## Keyboard Cacheの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Keyboard Cacheの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-STORAGE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Keyboard Cacheの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* var autocorrectionType: UITextAutocorrectionType determines whether autocorrection is enabled during typing. When autocorrection is enabled, the text object tracks unknown words and suggests suitab...
* var secureTextEntry: BOOL determines whether text copying and text caching are disabled and hides the text being entered for UITextField. The default value of this property is NO.
```

## ナレッジベース

### DO: 機微データは内部ストレージまたは Keystore/Keychain へ

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 機微データは内部ストレージまたは Keystore/Keychain へ
- ログ・バックアップ・スクショ・通知から秘密を除外する
- 外部ストレージへ秘密を書かない
- var autocorrectionType: UITextAutocorrectionType determines whether autocorrection is enabled during typing. When autocorrection is enabled, the text object tracks unknown words and suggests suitable replacements, replacing the typed text automatically unless the user overrides the replacement. The default value of this property is UITextAutocorrectionTypeDefault, which for most input methods enables autocorrection.
- var secureTextEntry: BOOL determines whether text copying and text caching are disabled and hides the text being entered for UITextField. The default value of this property is NO.
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
- 変更レビューで MASTG-KNOW-0100 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-STORAGE/MASTG-KNOW-0100/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-STORAGE`: <https://mas.owasp.org/MASVS/>
