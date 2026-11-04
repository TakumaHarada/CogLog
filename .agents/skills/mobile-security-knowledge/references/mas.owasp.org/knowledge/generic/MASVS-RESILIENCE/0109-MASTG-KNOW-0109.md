---
source: https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0109/
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
mastg_know_id: MASTG-KNOW-0109
masvs_category: MASVS-RESILIENCE
platform: generic
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0109: Binary Patching

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Binary Patching」（共通（Android/iOS） / 耐タンパ・耐解析）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Patching is the process of changing the compiled app, e.g., changing code in binary executables, modifying Java bytecode, or tampering with resources. This process is known as _modding_ in the mobile game hacking scene. Patches can be applied in many ways, including editing binary files in a hex editor and decompiling, editing, and re-assembling an app.
* 要旨: Keep in mind that modern mobile operating systems strictly enforce code signing, so running modified apps is not as straightforward as it used to be in desktop environments. Security experts had a much easier life in the 90s! Fortunately, patching is not very difficult if you work on your own device. You simply have to re-sign the app or disable the default code signature verification facilities to run modified code.

* 正本: <https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0109/>
* 関連制御群: `MASVS-RESILIENCE`（耐タンパ・耐解析）

## Binary Patchingの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Binary Patchingの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-RESILIENCE）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: generic アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Binary Patchingの実装・監査観点の実装例

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
- 変更レビューで MASTG-KNOW-0109 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/generic/MASVS-RESILIENCE/MASTG-KNOW-0109/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-RESILIENCE`: <https://mas.owasp.org/MASVS/>
