---
source: https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0114/
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
mastg_know_id: MASTG-KNOW-0114
masvs_category: MASVS-RESILIENCE
platform: generic
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0114: Debugging and Tracing

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Debugging and Tracing」（共通（Android/iOS） / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: In the traditional sense, debugging is the process of identifying and isolating problems in a program as part of the software development life cycle. The same tools used for debugging are valuable to reverse engineers even when identifying bugs is not the primary goal. Debuggers enable program suspension at any point during runtime, inspection of the process' internal state, and even register and memory modificati...
* 要旨: Tracing refers to passive logging of information about the app's execution (such as API calls). Tracing can be done in several ways, including debugging APIs, function hooks, and Kernel tracing facilities. See "Anatomy of a code tracer" by Ole André Vadla Ravnås for more details.

* 正本: <https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0114/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Debugging and Tracingの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Debugging and Tracingの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: generic アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Debugging and Tracingの実装・監査観点の実装例

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
- 変更レビューで MASTG-KNOW-0114 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0114/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
