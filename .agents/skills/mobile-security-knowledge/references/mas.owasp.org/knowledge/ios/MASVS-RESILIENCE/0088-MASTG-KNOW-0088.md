---
source: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0088/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - resilience
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0088
masvs_category: MASVS-RESILIENCE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0088: iOS Simulator Detection

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「iOS Simulator Detection」（iOS / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: In the context of anti-reversing, the goal of emulator and virtual device detection is to increase the difficulty of running the app outside the expected device environment. This increased difficulty forces the reverse engineer to defeat the checks or use a physical device, thereby limiting the access required for large-scale device analysis.
* 要旨: Apple provides Simulator through Xcode. Simulator does not emulate the complete hardware of an iOS device. Instead, it runs apps built for a simulated device destination. On Apple silicon, simulator builds can also use the arm64 CPU architecture. However, CPU architecture alone does not make simulator and device builds interchangeable. An arm64 simulator binary is built for the iphonesimulator SDK, while an arm64 ...

* 正本: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0088/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## iOS Simulator Detectionの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### iOS Simulator Detectionの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: ios アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### iOS Simulator Detectionの実装・監査観点の実装例

```text
公式記事の API・設定説明を読み、次を確認する。
* 耐タンパは追加層としサーバ認可の代替にしない
* 脅威モデルで要否と深度を文書化する
* 検知結果はサーバ側判断と組み合わせる
* 公式記事内のコード例言語: swift
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
- 変更レビューで MASTG-KNOW-0088 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/ios/MASVS-RESILIENCE/MASTG-KNOW-0088/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
