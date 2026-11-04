---
source: https://developer.android.com/security/fraud-prevention/activities
scopes:
  - test
  - android
  - mobile
  - fraud-prevention
  - ui-security
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android Fraud Prevention: 機密性の高いアクティビティを保護する

## 概要

本ドキュメントは [機密性の高いアクティビティを保護する](https://developer.android.com/security/fraud-prevention/activities) を蒸留したものである。ログイン・購入など機微画面で `FLAG_SECURE` と `HIDE_OVERLAY_WINDOWS` を使い、画面キャプチャ・非セキュア表示・オーバーレイ攻撃を緩和する。

* 正本: <https://developer.android.com/security/fraud-prevention/activities>
* 関連: `0004-fraud-prevention-environment.md`（アクセスリスク）、`0006-fraud-prevention-authentication.md`

## FLAG_SECURE で機微画面のキャプチャと非セキュア表示を防ぐ

保護対象ウィンドウに `FLAG_SECURE` を設定し、スクリーンショットとセキュアでないディスプレイへの表示を抑止する。

### FLAG_SECURE で機微画面のキャプチャと非セキュア表示を防ぐの補足

* 利点: バックグラウンドでの不正スクリーンショットや画面共有経由の漏洩を減らせる
* 注意点: オーバーレイ攻撃の完全防止にはならない。Android 11 以前では端末差で確実性が下がる場合がある
* 適用範囲: バンキング、パスワード、決済、認証コード表示など
* 例外: サポート用途で画面共有が必須な画面はプロダクト判断で除外し、根拠を残す

### FLAG_SECURE で機微画面のキャプチャと非セキュア表示を防ぐの実装例

```kotlin
window?.setFlags(
    WindowManager.LayoutParams.FLAG_SECURE,
    WindowManager.LayoutParams.FLAG_SECURE
)
```

```text
運用
* 機微 Activity / 画面遷移時に付与、不要画面では外す方針を明確化
* バックグラウンド遷移時の露出も脅威モデルに含める
```

## HIDE_OVERLAY_WINDOWS で第三者オーバーレイを拒否する

Android 12 以降、マニフェストで `HIDE_OVERLAY_WINDOWS` を宣言し、自アプリ上へのアプリオーバーレイ描画をオプトアウトする。

### HIDE_OVERLAY_WINDOWS で第三者オーバーレイを拒否するの補足

* 利点: クローク＆ダガー型のオーバーレイ攻撃を緩和できる
* 注意点: 信頼できないアプリのオーバーレイを許可しない。SYSTEM_ALERT_WINDOW 取得も Android 12 で厳格化されている
* 適用範囲: ログイン・送金・設定変更など入力が機微な画面全体
* 例外: なし（ターゲット SDK と端末 API レベルを確認）

### HIDE_OVERLAY_WINDOWS で第三者オーバーレイを拒否するの実装例

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.HIDE_OVERLAY_WINDOWS" />
```

```text
方針
* 他アプリのオーバーレイは原則拒否
* 許可する場合は信頼根拠を文書化
```

## ナレッジベース

### DO: 機微画面に FLAG_SECURE と（API 31+）オーバーレイ拒否をセットでレビューする

```text
# 推奨
sensitive_screens:
  - flag_secure: true
  - hide_overlay_windows: true  # API 31+
```

### DO NOT: FLAG_SECURE だけでオーバーレイ・入力ハイジャック対策完了とみなす

* 理由: 公式がオーバーレイには別権限を案内している
* 理由: 画面共有・ユーザー補助経由のリスクは Integrity 側とも組み合わせる

```text
# DO NOT: FLAG_SECURE のみで完了

# DO: FLAG_SECURE + HIDE_OVERLAY_WINDOWS + 必要なら Play Integrity アクセスリスク
```

## 参考リンク

* 機密性の高いアクティビティを保護する: <https://developer.android.com/security/fraud-prevention/activities>
* 環境を保護する: <https://developer.android.com/security/fraud-prevention/environment>
