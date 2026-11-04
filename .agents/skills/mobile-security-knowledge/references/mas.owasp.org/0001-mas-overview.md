---
source: https://mas.owasp.org/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - security-review
  - implementation
updated_at: 2026-08-16
---

# OWASP Mobile Application Security（MAS）概要

## 概要

OWASP Mobile Application Security（MAS）は、モバイルアプリセキュリティの業界標準を定義するプロジェクトである。要件（MASVS）、弱点（MASWE）、テスト（MASTG）を一体で提供する。

* 実装プラクティスの詳細は制御・弱点・Knowledge・Tests ドキュメントへ分離する
* 関連: `0002-masvs.md`（実装）、`0003-maswe.md`（緩和）、`0004-mastg.md`（検証）、`knowledge/0000-index.md`（Knowledge）、`tests/0000-index.md`（Tests）、`android-testing/0000-index.md`（Android 章）、`ios-testing/0000-index.md`（iOS 章）

## 実装・監査は三層に役割分担する

コードレビューでは MASVS、失敗モードでは MASWE、証拠取得では MASTG を使う。

### 実装・監査は三層に役割分担するの補足

* 利点: 「方針だけの文書」と「実装チェック」が混線しない
* 注意点: 本概要だけでは実装完了とみなさない
* 適用範囲: 設計、実装 PR、セキュリティテスト
* 例外: なし

### 実装・監査は三層に役割分担するの実装例

```text
実装時の読み順
1. 0002-masvs.md … 何をどう実装するか（STORAGE/NETWORK/AUTH 等）
2. 0003-maswe.md … どの失敗を禁止するか（ログ漏洩、cleartext 等）
3. 0004-mastg.md … どう検証し証拠を残すか

アプリ側の具体例
* バックアップ無効: AndroidManifest allowBackup=false
* トークン非ログ: Google Sign-In 成功ログで idToken 非出力
* 正規クライアント補助: Firebase App Check（Play Integrity / App Attest）
* Deep Link 無効化: flutter_deeplinking_enabled=false
```

## 脅威モデルで Testing Profiles を選ぶ

全制御を一律適用せず、データ感度に応じて L1 / L2 / R / P の深さを決める。

### 脅威モデルで Testing Profiles を選ぶの補足

* 利点: 過剰な耐タンパ要件と、基本制御の欠落を同時に防げる
* 注意点: L1 相当（TLS、秘密の非平文保存、サーバ認可）を「後回し」にしない
* 適用範囲: リリース判定、外部テスト委託
* 例外: なし

### 脅威モデルで Testing Profiles を選ぶの実装例

```text
一般向け学習アプリの例
* 必須実装: HTTPS、トークン非平文、ログ秘匿、バックアップ方針、サーバ認可
* 追加: プライバシー申告一致、権限最小化
* 任意: 高度な難読化（設計目標がある場合のみ）
```

## ナレッジベース

### DO: 実装 PR で MASVS 制御 ID と具体変更（ファイル／設定）を対応づける

```text
# 推奨
MASVS-NETWORK-1: debug のみ cleartext。release から除去済み
MASVS-STORAGE-2: allowBackup=false
MASVS-AUTH-1: backend で ID Token / App Check 検証
```

### DO NOT: MAS 概要ページや「準拠予定」だけで実装レビューを通す

* 理由: 実装可否は制御ごとの具体プラクティスで判断する
* 理由: 概要は入口でありチェックリストの代替ではない

```text
# DO NOT: 「OWASP MAS を参考にしています」のみ

# DO: 0002/0003 の該当箇条と差分をレビューする
```

## 参考リンク

* OWASP MAS: <https://mas.owasp.org/>
* OWASP MAS プロジェクト: <https://owasp.org/www-project-mobile-app-security/>
