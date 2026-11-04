---
source: https://mas.owasp.org/MASTG/0x05d-Testing-Data-Storage/
scopes:
  - test
  - android
  - backend
  - mobile
  - storage
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-STORAGE
---

# MASTG 0x05d: Android Data Storage

## 概要

本ドキュメントは MASTG「Android Data Storage」を蒸留したものである。認証トークンや PII など機微データのローカル保存リスクと、Android の保存機構ごとの確認観点を示す。詳細手順は MASVS-STORAGE の Tests / Knowledge を正とする。

* 正本: <https://mas.owasp.org/MASTG/0x05d-Testing-Data-Storage/>
* Tests: `docs/security/mas.owasp.org/tests/android/MASVS-STORAGE/`
* Knowledge: `docs/security/mas.owasp.org/knowledge/android/MASVS-STORAGE/`

## 機微データは保存しないことを第一候補にする

必要なら短命・失効可能なトークンに限り、分類（何が機微か）を先に決める。

### 機微データは保存しないことを第一候補にするの補足

* 利点: 端末取得・バックアップ・サイドチャネルの影響を最小化できる
* 注意点: UX のためのキャッシュも機微になりうる
* 適用範囲: ログイン、個人情報、決済関連
* 例外: オフライン必須機能（根拠を残す）

### 機微データは保存しないことを第一候補にするの実装例

```text
分類例
* 秘密: パスワード、リフレッシュトークン、鍵材料
* 機微: 氏名・連絡先・学習履歴等の PII
* 非機微: 公開コンテンツのキャッシュ

方針
* パスワードを端末保存しない
* トークンは SDK / Keystore 連携へ寄せる
* 外部ストレージへ秘密を書かない
```

## 保存機構ごとにテストケースを割り当てる

SharedPreferences / DB / 内部・外部ストレージ / Keystore / ログ / バックアップ / メモリ / キーボード / スクショを個別に見る。

### 保存機構ごとにテストケースを割り当てるの補足

* 利点: 「どこか一箇所見た」漏れを防げる
* 注意点: 入力元ストレージのデータも型検証・完全性（HMAC 等）を検討する
* 適用範囲: 静的・動的ストレージテスト
* 例外: なし

### 保存機構ごとにテストケースを割り当てるの実装例

```text
機構 → 確認
* SharedPreferences: 平文秘密の有無
* SQLite/Room/Realm/Firebase: 暗号化と配置場所
* Internal/External Storage: 外部への機微書き込み（例: MASTG-TEST-0200）
* Keystore: 鍵が TEE/StrongBox 側か
* Logs / Backup / Memory / Keyboard / Screenshots: 二次漏洩
```

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application android:allowBackup="false" android:fullBackupContent="false" ...>
```

## ナレッジベース

### DO: STORAGE 変更の PR で「保存場所・バックアップ・ログ」の3点をレビュー必須にする

```text
# 推奨
storage_path: ...
backup: excluded / allowBackup=false
logging: no token/PII
tests: [MASTG-TEST-02xx ...]
```

### DO NOT: 内部ストレージだから安全と一律判定する

* 理由: ルート端末・バックアップ・ログ・IPC で読める場合がある
* 理由: L2 相当では追加の鍵保護が求められることが多い

```text
# DO NOT: getFilesDir 配下なら平文トークン OK

# DO: 感度に応じ Keystore 保護または非保存を選ぶ
```

## 参考リンク

* Android Data Storage: <https://mas.owasp.org/MASTG/0x05d-Testing-Data-Storage/>
* Security tips (Storing Data): <https://developer.android.com/privacy-and-security/security-tips#StoringData>
