---
source: https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0112/
scopes:
  - test
  - android
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0112
masvs_category: MASVS-RESILIENCE
platform: generic
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0112: Emulation-based Dynamic Analysis

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Emulation-based Dynamic Analysis」（共通（Android/iOS） / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Emulation is an imitation of a certain computer platform or program being executed in different platform or within another program. The software or hardware performing this imitation is called an _emulator_. Emulators provide a much cheaper alternative to an actual device, where a user can manipulate it without worrying about damaging the device. There are multiple emulators available for Android, but for iOS ther...
* 要旨: The difference between a simulator and an emulator often causes confusion and leads to use of the two terms interchangeably, but in reality they are different, specially for the iOS use case. An emulator mimics both the software and hardware environment of a targeted platform. On the other hand, a simulator only mimics the software environment.

* 正本: <https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0112/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Emulation-based Dynamic Analysisの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Emulation-based Dynamic Analysisの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: generic アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Emulation-based Dynamic Analysisの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* 耐タンパは追加層としサーバ認可の代替にしない
* 脅威モデルで要否と深度を文書化する
* 検知結果はサーバ側判断と組み合わせる
```

## ナレッジベース

### DO: 耐タンパは追加層としサーバ認可の代替にしない

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- 耐タンパは追加層としサーバ認可の代替にしない
- 脅威モデルで要否と深度を文書化する
- 検知結果はサーバ側判断と組み合わせる

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
- 変更レビューで MASTG-KNOW-0112 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0112/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
