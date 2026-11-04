---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0020/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0020
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0020: Inter-Process Communication (IPC) Mechanisms

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Inter-Process Communication (IPC) Mechanisms」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Every Android process runs in its own sandboxed address space. Inter-process communication (IPC) lets apps and the system exchange data and invoke functionality across these process boundaries. Instead of relying on traditional techniques such as shared files or network sockets, Android provides higher-level IPC mechanisms built on a common foundation. This article gives an overview of those mechanisms and links t...
* 要旨: Android's IPC is based on Binder, a custom kernel driver and framework derived from OpenBinder. Most Android system services and all high-level IPC mechanisms depend on it. The term _Binder_ refers to several related concepts:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0020/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Inter-Process Communication (IPC) Mechanismsの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Inter-Process Communication (IPC) Mechanismsの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Inter-Process Communication (IPC) Mechanismsの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Binder driver:: the kernel-level driver exposed as the /dev/binder character device.
* Binder protocol:: the low-level ioctl-based protocol used to communicate with the driver.
* IBinder interface:: the well-defined behavior that Binder objects implement.
* Binder object, service, and client:: the implementation exposing functionality and the objects that consume it.
* Starting an activity: by passing an intent to startActivity (see ).
* 公式記事内のコード例言語: bash
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Binder driver:: the kernel-level driver exposed as the /dev/binder character device.
- Binder protocol:: the low-level ioctl-based protocol used to communicate with the driver.
- IBinder interface:: the well-defined behavior that Binder objects implement.
```

### DO NOT: 不要な Deep Link を有効化する

* 理由: MASVS-PLATFORM の典型的な失敗モードにつながる
* 理由: 詳細な禁止・代替は公式 Knowledge を確認する

```text
# DO NOT
- 不要な Deep Link を有効化する
- 信頼できないコンテンツを WebView で無制限に開く

# DO
- 公式記事の現行 API / 設定に従い、非推奨経路を避ける
- 変更レビューで MASTG-KNOW-0020 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0020/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
