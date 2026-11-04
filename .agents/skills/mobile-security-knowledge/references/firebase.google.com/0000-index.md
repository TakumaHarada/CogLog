---
source: https://firebase.google.com/support/guides/security-checklist
scopes:
  - test
  - backend
  - firebase
  - gcp
  - mobile
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Firebase セキュリティ（索引）

## 概要

Firebase 公式のセキュリティチェックリストと関連ガイドを、DO / DO NOT 監査向けに蒸留した索引である。GCP 基盤制御は [cloud.google.com](../cloud.google.com/0000-index.md) を正本とし、本ツリーは Firebase プロダクト固有の層を扱う。

* 入口チェックリスト: [Firebase security checklist](https://firebase.google.com/support/guides/security-checklist)
* 環境別ガイドライン: [General security guidelines](https://firebase.google.com/docs/projects/dev-workflows/general-security-guidelines)

## 読み順

Checklist → App Check / Rules / IAM → 環境分離の順で辿る。

### 読み順の補足

* 利点: 「Rules だけ」「App Check だけ」の片手落ちを防げる
* 注意点: Firebase API キーは秘密ではないが、制限と SA／FCM サーバ鍵は秘密である
* 適用範囲: モバイル／バックエンド連携、Firestore／Storage、Auth
* 例外: なし

### 読み順の実装例

```text
1. 0001 Security checklist
2. 0002 App Check / 0003 Security Rules
3. 0004 IAM / 0005 環境別ガイドライン
4. cloud.google.com（IAM / Secret / Run）
```

## ナレッジベース

### DO: Checklist の該当節をリリースゲートの必須項目にする

```text
# 推奨
app_check: enforced (metrics OK)
rules: deny-by-default + CI tests
projects: dev != prod
secrets: SA/FCM server key のみ秘匿
```

### DO NOT: Firebase クライアント API キーを「漏洩＝即侵害」と同等に扱い、Rules／App Check を後回しにする

* 理由: 公式が Firebase API キーはプロジェクト識別子であり認可は Rules / IAM / App Check だと明記している
* 理由: 逆に SA 鍵・FCM server key は秘密である

```text
# DO NOT: API キー隠匿だけして Rules を allow all

# DO: locked Rules + App Check 強制 + 秘密は Secret Manager
```

## 一覧

| No | Source | Title | Path |
| --- | --- | --- | --- |
| 0001 | [checklist](https://firebase.google.com/support/guides/security-checklist) | Security checklist | [`0001-security-checklist.md`](./0001-security-checklist.md) |
| 0002 | [App Check](https://firebase.google.com/docs/app-check) | App Check | [`0002-app-check.md`](./0002-app-check.md) |
| 0003 | [Rules](https://firebase.google.com/docs/rules) | Security Rules | [`0003-security-rules.md`](./0003-security-rules.md) |
| 0004 | [IAM](https://firebase.google.com/docs/projects/iam/overview) | Firebase IAM | [`0004-iam.md`](./0004-iam.md) |
| 0005 | [dev workflows](https://firebase.google.com/docs/projects/dev-workflows/general-security-guidelines) | 環境別セキュリティ | [`0005-dev-workflow-security-guidelines.md`](./0005-dev-workflow-security-guidelines.md) |

## 参考リンク

* Security checklist: <https://firebase.google.com/support/guides/security-checklist>
* GCP 索引: [`../cloud.google.com/0000-index.md`](../cloud.google.com/0000-index.md)
* API セキュリティ: 導入先バックエンドの API セキュリティ文書（存在すれば併読）
