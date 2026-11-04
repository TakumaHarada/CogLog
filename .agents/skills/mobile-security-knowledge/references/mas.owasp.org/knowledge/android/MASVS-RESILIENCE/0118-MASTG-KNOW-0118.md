---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0118/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0118
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0118: Runtime Application Self-Protection (RASP)

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Runtime Application Self-Protection (RASP)」（Android / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Runtime Application Self-Protection (RASP) is a security technology embedded in mobile apps to detect and prevent real-time attacks. Unlike server-side or network-based security solutions, RASP integrates directly into the app's runtime environment, enabling the app to monitor its own execution and respond to threats from within the device.
* 要旨: RASP implementations typically include several defensive mechanisms:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0118/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Runtime Application Self-Protection (RASP)の実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Runtime Application Self-Protection (RASP)の実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Runtime Application Self-Protection (RASP)の実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Environment Detection: Identifying rooted devices, emulators, debuggers attached to the process, or the presence of hooking frameworks.
* Code Integrity Verification: Ensuring the app's code has not been modified at runtime, including detecting hooks on methods and functions.
* Anti-Tampering: Detecting modifications to the app's binary, resources, or configuration files.
* Anti-Debugging: Preventing or detecting when a debugger is attached to the app's process.
* Response Mechanisms: Taking action when threats are detected, such as terminating the app, clearing sensitive data, or alerting a backend server.
```

## ナレッジベース

### DO: 耐タンパは追加層としサーバ認可の代替にしない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 耐タンパは追加層としサーバ認可の代替にしない
- 脅威モデルで要否と深度を文書化する
- 検知結果はサーバ側判断と組み合わせる
- Environment Detection: Identifying rooted devices, emulators, debuggers attached to the process, or the presence of hooking frameworks.
- Code Integrity Verification: Ensuring the app's code has not been modified at runtime, including detecting hooks on methods and functions.
- Anti-Tampering: Detecting modifications to the app's binary, resources, or configuration files.
```

### DO NOT: 難読化だけで平文保存や cleartext を許容する

* 理由: MASVS-RESILIENCE の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 難読化だけで平文保存や cleartext を許容する
- クライアント検知成功 alone で権限を付与する

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0118 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-RESILIENCE/MASTG-KNOW-0118/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
