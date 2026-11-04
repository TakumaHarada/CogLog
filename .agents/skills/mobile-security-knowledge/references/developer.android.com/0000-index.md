---
source: https://developer.android.com/security
scopes:
  - test
  - android
  - backend
  - mobile
  - privacy
  - identity
  - fraud-prevention
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android Developers 公式セキュリティ（索引）

## 概要

[Android Developers Security](https://developer.android.com/security) 配下の公式ガイドを、DO / DO NOT 監査向けに蒸留した索引である。ハブは入口、各ガイドが実装・検証の正本である。

* サイト区分: Security / Privacy / Permissions / Identity / Fraud prevention
* 関連: OWASP MAS（`docs/security/mas.owasp.org/`）、本ツリーの個別文書

## 読み順

機能変更の種類に応じて、ハブ → 該当ガイド → 必要なら Security tips の順で辿る。

### 読み順の補足

* 利点: 入口ページだけで実装完了と誤認しない
* 注意点: 日本語 URL（`?hl=ja`）と英語 URL は同一文書のロケール差である。`source` は安定なパスを優先する
* 適用範囲: Android 実装レビュー、リリース前監査
* 例外: なし

### 読み順の実装例

```text
1. 0001 Security ハブ … 領域割当
2. 領域ガイド（privacy / fraud / tips）
3. 実機・サーバ側の合否確認（Integrity はサーバ検証）
```

## ナレッジベース

### DO: PR に公式ガイド URL と本ツリーの対応文書を併記する

```text
# 推奨
refs:
  - developer.android.com/security/...
  - docs/security/developer.android.com/000x-...
```

### DO NOT: ハブの見出しだけ読んで詳細チェックリストを省略する

* 理由: ハブは導線であり、禁止事項は各ガイドにある
* 理由: Fraud / Privacy はサーバ判定や申告とセットである

```text
# DO NOT: 「Security ハブを確認した」だけで完了

# DO: 該当 000x の DO NOT を差分に適用する
```

## 一覧

| No | Source | Title | Path |
| --- | --- | --- | --- |
| 0001 | [security](https://developer.android.com/security) | Security ハブ | [`0001-security.md`](./0001-security.md) |
| 0002 | [security-tips](https://developer.android.com/privacy-and-security/security-tips) | Security tips | [`0002-security-tips.md`](./0002-security-tips.md) |
| 0003 | [privacy about](https://developer.android.com/privacy-and-security/about) | プライバシー ガイドライン | [`0003-privacy-guidelines.md`](./0003-privacy-guidelines.md) |
| 0004 | [fraud environment](https://developer.android.com/security/fraud-prevention/environment) | 環境を保護する | [`0004-fraud-prevention-environment.md`](./0004-fraud-prevention-environment.md) |
| 0005 | [fraud activities](https://developer.android.com/security/fraud-prevention/activities) | 機密アクティビティを保護する | [`0005-fraud-prevention-activities.md`](./0005-fraud-prevention-activities.md) |
| 0006 | [fraud authentication](https://developer.android.com/security/fraud-prevention/authentication) | 安全なユーザー認証 | [`0006-fraud-prevention-authentication.md`](./0006-fraud-prevention-authentication.md) |

## 参考リンク

* Security 概要: <https://developer.android.com/security>
* Fraud prevention: <https://developer.android.com/security/fraud-prevention>
