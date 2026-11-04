---
source: https://mas.owasp.org/MASTG/0x06b-iOS-Security-Testing/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
---

# MASTG iOS Security Testing（章索引）

## 概要

MASTG の iOS 向け章（0x06a〜0x06j）を、DO / DO NOT 監査向けに蒸留した索引である。Knowledge と Tests の橋渡しとして使う。

* upstream: OWASP/mastg@d7fd7d4 `Document/0x06*.md`
* 関連: `knowledge/0000-index.md` / `tests/0000-index.md` / `android-testing/0000-index.md`

## 読み順

iOS テストは環境 → 領域別章 → 個別 Test の順で辿る。

### 読み順の補足

* 利点: Simulator と実機の差、jailbreak 前提を飛ばさない
* 注意点: 0x06d 以降の章本文は概要中心で、詳細は Knowledge/Tests に移っている
* 適用範囲: テスト計画、実装レビュー、オンボーディング
* 例外: なし

### 読み順の実装例

```text
1. 0001 0x06a Platform Overview
2. 0002 0x06b Security Testing（macOS / 実機 / jailbreak）
3. 領域章（0003〜0009）
4. tests/ios/{MASVS-*}/ の現行 Test を実施
```

## ナレッジベース

### DO: 領域変更のレビューで対応する 0x06 章と Test 索引をセットで添付する

```text
# 推奨
chapter: ios-testing/0006-0x06g-...
tests: tests/ios/MASVS-NETWORK/
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
| 0001 | [0x06a](https://mas.owasp.org/MASTG/0x06a-Platform-Overview/) | Platform Overview | [`0001-0x06a-platform-overview.md`](./0001-0x06a-platform-overview.md) |
| 0002 | [0x06b](https://mas.owasp.org/MASTG/0x06b-iOS-Security-Testing/) | iOS Security Testing | [`0002-0x06b-ios-security-testing.md`](./0002-0x06b-ios-security-testing.md) |
| 0003 | [0x06d](https://mas.owasp.org/MASTG/0x06d-Testing-Data-Storage/) | Data Storage | [`0003-0x06d-testing-data-storage.md`](./0003-0x06d-testing-data-storage.md) |
| 0004 | [0x06e](https://mas.owasp.org/MASTG/0x06e-Testing-Cryptography/) | Cryptography | [`0004-0x06e-testing-cryptography.md`](./0004-0x06e-testing-cryptography.md) |
| 0005 | [0x06f](https://mas.owasp.org/MASTG/0x06f-Testing-Local-Authentication/) | Local Authentication | [`0005-0x06f-testing-local-authentication.md`](./0005-0x06f-testing-local-authentication.md) |
| 0006 | [0x06g](https://mas.owasp.org/MASTG/0x06g-Testing-Network-Communication/) | Network Communication | [`0006-0x06g-testing-network-communication.md`](./0006-0x06g-testing-network-communication.md) |
| 0007 | [0x06h](https://mas.owasp.org/MASTG/0x06h-Testing-Platform-Interaction/) | Platform Interaction | [`0007-0x06h-testing-platform-interaction.md`](./0007-0x06h-testing-platform-interaction.md) |
| 0008 | [0x06i](https://mas.owasp.org/MASTG/0x06i-Testing-Code-Quality-and-Build-Settings/) | Code Quality and Build Settings | [`0008-0x06i-testing-code-quality-and-build-settings.md`](./0008-0x06i-testing-code-quality-and-build-settings.md) |
| 0009 | [0x06j](https://mas.owasp.org/MASTG/0x06j-Testing-Resiliency-Against-Reverse-Engineering/) | Resiliency Against Reverse Engineering | [`0009-0x06j-testing-resiliency-against-reverse-engineering.md`](./0009-0x06j-testing-resiliency-against-reverse-engineering.md) |

## 参考リンク

* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* Android 章索引: [`../android-testing/0000-index.md`](../android-testing/0000-index.md)
