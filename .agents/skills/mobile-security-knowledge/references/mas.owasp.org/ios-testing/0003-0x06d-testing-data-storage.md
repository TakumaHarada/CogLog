---
source: https://mas.owasp.org/MASTG/0x06d-Testing-Data-Storage/
scopes:
  - test
  - ios
  - backend
  - mobile
  - storage
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-STORAGE
---

# MASTG 0x06d: iOS Data Storage

## 概要

本ドキュメントは MASTG「iOS Data Storage」を蒸留したものである。機微データは可能な限り永続保存せず、必要な場合はハードウェア支援の Data Protection / Keychain を正しく使う。

* 正本: <https://mas.owasp.org/MASTG/0x06d-Testing-Data-Storage/>
* Tests: `docs/security/mas.owasp.org/tests/ios/MASVS-STORAGE/`
* Knowledge: `docs/security/mas.owasp.org/knowledge/ios/MASVS-STORAGE/`

## 機微データは非保存を第一候補にする

トークンや PII のローカル保存は最小化する。保存するなら保護クラスとバックアップ経路を設計する。

### 機微データは非保存を第一候補にするの補足

* 利点: 端末取得・バックアップ・サイドチャネルの影響を抑えられる
* 注意点: UX キャッシュも機微になりうる
* 適用範囲: 認証、個人情報、オフライン機能
* 例外: オフライン必須（根拠を残す）

### 機微データは非保存を第一候補にするの実装例

```text
方針
* パスワードを UserDefaults / ファイル平文へ置かない
* 短命トークン + サーバ失効を優先
* 必要時は Keychain + 適切な accessibility
* バックアップ対象外属性を検討する
```

## 保存機構ごとに Test / Knowledge を割り当てる

File System、UserDefaults、CoreData、Realm、ログ、バックアップ、メモリ、キーボード、スクショを個別確認する。

### 保存機構ごとに Test / Knowledge を割り当てるの補足

* 利点: 「Keychain を見れば十分」という漏れを防げる
* 注意点: Data Protection はパスコード有効が前提になる
* 適用範囲: STORAGE テスト計画
* 例外: なし

### 保存機構ごとに Test / Knowledge を割り当てるの実装例

```text
機構例 → Knowledge
* UserDefaults: MASTG-KNOW-0093
* Keychain: MASTG-KNOW-0057 / 0126
* File System / Sandbox: MASTG-KNOW-0091 / 0108
* Logs / Backup / Screenshots / Keyboard: 0101 / 0102 / 0099 / 0100
```

## ナレッジベース

### DO: STORAGE 変更 PR で「保存場所・保護クラス・バックアップ・ログ」を必須確認する

```text
# 推奨
location: Keychain | none
accessibility: WhenUnlockedThisDeviceOnly ...
backup: excluded
logging: no secrets
```

### DO NOT: UserDefaults 平文を「アプリ専用だから安全」とみなす

* 理由: jailbreak・バックアップ・共有面で読める場合がある
* 理由: 章はハードウェア支援 API の正しい利用を前提にしている

```text
# DO NOT: UserDefaults に refresh token

# DO: Keychain または非保存
```

## 参考リンク

* iOS Data Storage: <https://mas.owasp.org/MASTG/0x06d-Testing-Data-Storage/>
* Developer Security: <https://developer.apple.com/security/>
