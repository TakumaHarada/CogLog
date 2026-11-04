---
source: https://firebase.google.com/docs/projects/dev-workflows/general-security-guidelines
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

# Firebase 環境別セキュリティガイドライン

## 概要

本ドキュメントは [General security guidelines for different development workflow environments](https://firebase.google.com/docs/projects/dev-workflows/general-security-guidelines) を蒸留したものである。事前本番と本番で取るべき最低限の対策を分ける。

* 正本: <https://firebase.google.com/docs/projects/dev-workflows/general-security-guidelines>
* 詳細: [`0001-security-checklist.md`](./0001-security-checklist.md)
* 環境: 導入先の GCP / Firebase 環境ドキュメントや SKILL があれば併読する

## 事前本番はアクセス制限と Emulator を優先する

開発／ステージングを別プロジェクトにし、配布を限定する。個人や単機テストは Local Emulator Suite を優先し、クラウド上の事前本番にも本番同等の Security Rules を置く。

### 事前本番はアクセス制限と Emulator を優先するの補足

* 利点: 事前本番侵害が本番ユーザーデータに直結しない
* 注意点: Web の事前本番はドメイン制限や Hosting preview URL を検討する
* 適用範囲: 開発、CI、社内テスト配信
* 例外: なし（開発／本番の 2 系統を基本とする）

### 事前本番はアクセス制限と Emulator を優先するの実装例

```text
チェック
* モバイル: App Distribution 等で配布限定
* 単機: Emulator（localhost）
* Rules: 本番と同じ方針（パイプライン差分は意図的のみ）
* 本番プロジェクトへの広い人間アクセスを避ける
```

本番リリースで Emulator を有効にしない例である。

```dart
// App Check activation (example)
if (isProductionRelease) {
  throw UnsupportedError(
    "Firebase Emulator is not supported in production",
  );
}
```

## 本番は App Check 強制と堅牢な Rules を必須にする

対応プロダクトで App Check を登録・強制し、Firestore / Storage / RTDB に堅牢な Rules を置く。詳細は Checklist を併用する。

### 本番は App Check 強制と堅牢な Rules を必須にするの補足

* 利点: 正規アプリ以外からのバックエンド悪用を難しくできる
* 注意点: ローンチ前の導入が最も容易である
* 適用範囲: 本番 Firebase プロジェクトとカスタム API
* 例外: なし

### 本番は App Check 強制と堅牢な Rules を必須にするの実装例

```text
本番ゲート
* App Check: metrics → enforced
* Rules: deny default + CI
* IAM: 本番データアクセス最小化
* Checklist 全節を確認
```

## ナレッジベース

### DO: 開発と本番で Firebase／GCP プロジェクトを分離する

```text
# 推奨
projects: development, production
preprod: restricted distribution + Rules
prod: App Check enforced + Checklist
```

### DO NOT: 本番プロジェクトを開発者の日常 Emulator 代わりに使う

* 理由: 公式が環境分離と Emulator 優先を推奨している
* 理由: 本番データ漏洩・課金事故のリスクが高い

```text
# DO NOT: 本番 projectId をデバッグビルドの既定にする

# DO: 開発用プロジェクト + Emulator
```

## 参考リンク

* General security guidelines: <https://firebase.google.com/docs/projects/dev-workflows/general-security-guidelines>
* Security checklist: <https://firebase.google.com/support/guides/security-checklist>
* 環境 SKILL: 導入先の GCP / Firebase 環境ドキュメントや SKILL があれば併読する
