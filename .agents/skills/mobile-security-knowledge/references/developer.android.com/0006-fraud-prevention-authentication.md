---
source: https://developer.android.com/security/fraud-prevention/authentication
scopes:
  - test
  - android
  - backend
  - mobile
  - fraud-prevention
  - identity
  - authentication
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android Fraud Prevention: 安全なユーザー認証

## 概要

本ドキュメントは [安全なユーザー認証](https://developer.android.com/security/fraud-prevention/authentication) を蒸留したものである。パスワード偏重からの移行、生体認証、パスキー、アカウント再設定、SMS Retriever の位置づけを、盗難デバイス・フィッシング対策の観点でまとめる。

* 正本: <https://developer.android.com/security/fraud-prevention/authentication>
* 関連: `0004-fraud-prevention-environment.md`、`0005-fraud-prevention-activities.md`

## パスワード偏重をやめ、機微操作に再認証を求める

銀行・メール相当の機微アカウントはパスワード単体モデルからの移行を検討する。盗難・ロック解除端末を前提に、妥当な認証タイムアウト（例: 15 分）と機微操作前の追加認証を置く。

### パスワード偏重をやめ、機微操作に再認証を求めるの補足

* 利点: ショルダーサーフィン、盗難、フィッシング耐性が上がる
* 注意点: UX 摩擦とのトレードオフをプロダクトで明示する
* 適用範囲: ログイン、送金、権限昇格、アカウント変更
* 例外: 低リスク機能はタイムアウトを緩めてよいが根拠を残す

### パスワード偏重をやめ、機微操作に再認証を求めるの実装例

```text
方針例
* セッション再確認: 15 分など
* 送金・設定変更前に生体認証（明示的ユーザー操作）
* クラス 3 生体 + CryptoObject（金融相当）
* PIN フォールバックを機微操作で避ける（失敗時は待機 / 再ログイン / リセット）
```

## パスキーと Credential Manager を優先する

パスキーはフィッシング耐性が高く、多要素の摩擦を減らせる。Android では Credential Manager でパスキー・パスワード・フェデレーションを統合する。

### パスキーと Credential Manager を優先するの補足

* 利点: 登録サイト/アプリ以外では使えずフィッシングに強い。秘密鍵はデバイス側
* 注意点: タイムアウト再認証と組み合わせないと、盗難直後のロック解除端末を防げない
* 適用範囲: Android 9+（パスキー）。Digital Asset Links 計画が必要
* 例外: レガシー端末はパスワード / Sign in with Google 等のフォールバック

### パスキーと Credential Manager を優先するの実装例

```text
導入手順（要約）
1. Credential Manager Codelab
2. パスキー UX ガイドライン
3. Digital Asset Links
4. 作成・登録・認証フローをサーバと揃える
```

## アカウント再設定と SMS を「端末で取れる情報」だけにしない

リセットフローはメール/SMS OTP だけで完結させない。SMS Retriever は UX と権限削減に有用だが、ローカル不正アクセスの唯一確認にしてはならない。

### アカウント再設定と SMS を「端末で取れる情報」だけにしないの補足

* 利点: 盗難端末からのアカウント乗っ取りを抑えられる
* 注意点: SMS Retriever 成功は「端末で SMS を自動受信した」強いシグナルだが SIM クローン等は防げない
* 適用範囲: パスワードリセット、電話番号変更、新規デバイス登録
* 例外: なし

### アカウント再設定と SMS を「端末で取れる情報」だけにしないの実装例

```text
再設定に足す要素の例
* 生体認証（OTP に加えて）
* 知識質問 / 知識要素
* 身分証明書による確認

SMS Retriever
* RECEIVE_SMS / READ_SMS を避けられる
* 自動取得失敗 → 手動入力は不正の警告サインになり得る
* 唯一の確認手段にしない。可能なら生体を優先
```

## ナレッジベース

### DO: 機微操作はパスキーまたは生体（明示操作）+ サーバ側セッション方針で守る

```text
# 推奨
auth: passkey | biometric (class3 + CryptoObject for finance)
timeout: e.g. 15m
step_up: before transfer / account change
reset: not SMS/email alone
```

### DO NOT: SMS OTP や LSKF フォールバック alone で盗難・フィッシング対策完了とする

* 理由: 公式がローカル攻撃・ショルダーサーフィン・SIM 関連リスクを明示している
* 理由: リセットも端末上の OTP だけだと奪取後に突破される

```text
# DO NOT: SMS だけで送金・アカウントリセットを許可

# DO: パスキー / 生体 + 端末外要素をリセットに含める
```

## 参考リンク

* 安全なユーザー認証: <https://developer.android.com/security/fraud-prevention/authentication>
* 生体認証: <https://developer.android.com/identity/sign-in/biometric-auth>
* Credential Manager: <https://developer.android.com/identity/sign-in/credential-manager>
* Play Integrity: <https://developer.android.com/google/play/integrity>
