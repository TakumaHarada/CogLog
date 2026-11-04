---
source: https://mas.owasp.org/MASTG/0x05b-Android-Security-Testing/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# MASTG Android Security Testing（章索引）

## 概要

MASTG の Android 向け章（0x05a〜0x05j）を、DO / DO NOT 監査向けに蒸留した索引である。Knowledge（用語・API）と Tests（手順・合否）の橋渡しとして使う。

* upstream: OWASP/mastg@d7fd7d4 `Document/0x05*.md`
* 関連: `knowledge/0000-index.md` / `tests/0000-index.md` / `ios-testing/0000-index.md`

## 読み順

Android テストを始めるときは、環境 → 領域別章 → 個別 Test の順で辿る。

### 読み順の補足

* 利点: 章の前提（プラットフォーム理解・ラボ）を飛ばさない
* 注意点: 0x05d 以降の章本文は概要が中心で、詳細は Knowledge/Tests に移っている
* 適用範囲: テスト計画、実装レビュー、オンボーディング
* 例外: なし

### 読み順の実装例

```text
1. 0001 0x05a Platform Overview … 攻撃面と OS 境界
2. 0002 0x05b Security Testing … 実機/AVD/root
3. 領域章（0003〜0009）… 保存/暗号/認証/通信/IPC/ビルド/耐タンパ
4. tests/android/{MASVS-*}/ … 現行 Test を実施
```

## ナレッジベース

### DO: 領域変更のレビューで対応する 0x05 章と Test 索引をセットで添付する

```text
# 推奨
chapter: android-testing/0006-0x05g-...
tests: tests/android/MASVS-NETWORK/
```

### DO NOT: 章概要だけ読んで個別 Test の Evaluation を省略する

* 理由: 章は導入、Test が合否基準である
* 理由: v2 では詳細が Knowledge/Tests へ分解されている

```text
# DO NOT: 「Data Storage 章を読んだ」で STORAGE 検証完了

# DO: 現行 MASTG-TEST を実施し証拠を残す
```

## 一覧

| No | Chapter | Title | Path |
| --- | --- | --- | --- |
| 0001 | [0x05a](https://mas.owasp.org/MASTG/0x05a-Platform-Overview/) | Platform Overview | [`0001-0x05a-platform-overview.md`](./0001-0x05a-platform-overview.md) |
| 0002 | [0x05b](https://mas.owasp.org/MASTG/0x05b-Android-Security-Testing/) | Android Security Testing | [`0002-0x05b-android-security-testing.md`](./0002-0x05b-android-security-testing.md) |
| 0003 | [0x05d](https://mas.owasp.org/MASTG/0x05d-Testing-Data-Storage/) | Data Storage | [`0003-0x05d-testing-data-storage.md`](./0003-0x05d-testing-data-storage.md) |
| 0004 | [0x05e](https://mas.owasp.org/MASTG/0x05e-Testing-Cryptography/) | Cryptography | [`0004-0x05e-testing-cryptography.md`](./0004-0x05e-testing-cryptography.md) |
| 0005 | [0x05f](https://mas.owasp.org/MASTG/0x05f-Testing-Local-Authentication/) | Local Authentication | [`0005-0x05f-testing-local-authentication.md`](./0005-0x05f-testing-local-authentication.md) |
| 0006 | [0x05g](https://mas.owasp.org/MASTG/0x05g-Testing-Network-Communication/) | Network Communication | [`0006-0x05g-testing-network-communication.md`](./0006-0x05g-testing-network-communication.md) |
| 0007 | [0x05h](https://mas.owasp.org/MASTG/0x05h-Testing-Platform-Interaction/) | Platform Interaction | [`0007-0x05h-testing-platform-interaction.md`](./0007-0x05h-testing-platform-interaction.md) |
| 0008 | [0x05i](https://mas.owasp.org/MASTG/0x05i-Testing-Code-Quality-and-Build-Settings/) | Code Quality and Build Settings | [`0008-0x05i-testing-code-quality-and-build-settings.md`](./0008-0x05i-testing-code-quality-and-build-settings.md) |
| 0009 | [0x05j](https://mas.owasp.org/MASTG/0x05j-Testing-Resiliency-Against-Reverse-Engineering/) | Resiliency Against Reverse Engineering | [`0009-0x05j-testing-resiliency-against-reverse-engineering.md`](./0009-0x05j-testing-resiliency-against-reverse-engineering.md) |

## 参考リンク

* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
