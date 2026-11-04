---
source: https://developer.android.com/privacy-and-security/about
scopes:
  - test
  - android
  - backend
  - mobile
  - privacy
  - permissions
  - identifiers
  - security-review
  - implementation
updated_at: 2026-08-16
---

# Android プライバシー ガイドライン

## 概要

本ドキュメントは [プライバシー ガイドライン](https://developer.android.com/privacy-and-security/about) を蒸留したものである。権限・位置情報・データ処理・識別子・ユーザー向けプライバシー機能のチェックリストを、実装と DO NOT 監査へ落とす。

* 正本: <https://developer.android.com/privacy-and-security/about>
* 関連: `0002-security-tips.md`、Play データセーフティ申告

## 権限リクエストを最小化する

機能に必要な最小権限だけを、必要なタイミングで説明付きで要求する。拒否時はグレースフルデグラデーションする。

### 権限リクエストを最小化するの補足

* 利点: 信頼と採用率を上げ、攻撃面を減らす
* 注意点: SDK が要求する危険な権限もアプリに帰属して見える
* 適用範囲: マニフェスト、実行時権限、依存 SDK
* 例外: なし

### 権限リクエストを最小化するの実装例

```text
チェック
* 大きな変更時に権限一覧を見直す
* 権限不要な代替 API（写真ピッカー等）を優先
* 起動時一括要求を避け、文脈付きで要求する
* 複数回拒否を尊重する（再ダイアログ連打禁止）
* 不要になった実行時権限アクセスを更新で削除
* SDK の権限とその理由を把握する
```

## 位置情報の使用を最小化する

使わない設計を第一候補とし、使う場合は精度・フォアグラウンド・説明可能性を制限する。

### 位置情報の使用を最小化するの補足

* 利点: センシティブデータの収集を抑えられる
* 注意点: バックグラウンド位置は特に高リスク
* 適用範囲: 位置 API、Bluetooth/Wi-Fi 近接
* 例外: ジオフェンス等で BG が必須（ユーザー認識可能な実装）

### 位置情報の使用を最小化するの実装例

```text
チェック
* 常時アクセス無しでもグレースフルデグラデーション
* 近接は Companion Device Manager を検討（位置権限不要な場合）
* 可能な限りおおよその位置で足りるか確認
* UI 表示中に取得する
* BG からフォアグラウンドサービスを開始しない（通知経由等を検討）
```

## データを安全に処理し、リセット可能な識別子を使う

監査・対象範囲別ストレージ・明示的 Intent・ログ秘匿・データセーフティ申告を揃える。永続端末 ID に依存しない。

### データを安全に処理し、リセット可能な識別子を使うの補足

* 利点: 漏洩影響とトラッキングリスクを抑えられる
* 注意点: Android 10+ で IMEI/シリアル取得は SecurityException
* 適用範囲: 保存、IPC、分析、広告、ログインレス状態共有
* 例外: なし

### データを安全に処理し、リセット可能な識別子を使うの実装例

```text
データ処理
* データアクセス監査（API 30+）
* パッケージ公開設定の宣言
* 対象範囲別ストレージ
* 認識しやすい開示と同意
* Play Console データセーフティを実装と一致
* 他アプリへは明示 Intent + 必要ならワンタイム権限
* Logcat / ログファイルにセンシティブデータを出さない

識別子
* IMEI / シリアルにアクセスしない
* 広告・プロファイル作成は広告 ID（トラッキング設定尊重）
* 非広告はアプリ私有 GUID
* 自社アプリ間のログアウト状態共有は SSAID 等の公式推奨を確認
```

## ナレッジベース

### DO: 権限・位置・識別子・データセーフティを機能差分のレビュー必須項目にする

```text
# 推奨
permissions: minimized + rationale
location: none | approximate | fg-only
ids: app GUID / ads id policy
data_safety: matches implementation
```

### DO NOT: 永続端末識別子やログへの PII 出力で「簡単に一意化」する

* 理由: 公式が明示禁止・非推奨としている
* 理由: Play ポリシーとユーザ信頼に直結する

```text
# DO NOT: IMEI をユーザ ID にする / トークンを Logcat に出す

# DO: アプリ私有 GUID + ログマスク
```

## 参考リンク

* プライバシー ガイドライン: <https://developer.android.com/privacy-and-security/about>
* Security ハブ: <https://developer.android.com/security>
* 一意の識別子のベストプラクティス: <https://developer.android.com/training/articles/user-data-ids>
