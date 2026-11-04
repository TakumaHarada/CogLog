---
source: https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0022/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-knowledge
  - platform
updated_at: 2026-08-16
mastg_know_id: MASTG-KNOW-0022
masvs_category: MASVS-PLATFORM
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-KNOW-0022: Overlay Attacks

## 概要

* 本ドキュメントは OWASP MASTG Knowledge「Overlay Attacks」（Android / プラットフォーム連携）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細な API 説明は公式記事を正本とする。
* 要旨: Screen overlay attacks occur when a malicious application places itself on top of another application which continues to function normally in the foreground. The malicious app can create UI elements that mimic the appearance of the legitimate app or the Android system UI. The goal is typically to deceive users into believing they are interacting with the legitimate app to elevate privileges (for example, by gettin...
* 要旨: There are several types of overlay attacks affecting different Android versions:

* 正本: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0022/>
* 関連制御群: `MASVS-PLATFORM`（プラットフォーム連携）

## Overlay Attacksの実装・監査観点

本 Knowledge が扱う API・機構を、実装選択とレビュー観点として固定する。

### Overlay Attacksの実装・監査観点の補足

* 利点: プラットフォーム固有の落とし穴を、制御群（MASVS-PLATFORM）に紐づけて監査できる
* 注意点: Knowledge は解説記事であり、テスト手順の代替ではない（MASTG Tests と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が deprecated / placeholder の場合は新規採用しない

### Overlay Attacksの実装・監査観点の実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Tapjacking (historically affecting Android 6.0 (API level 23) and lower) exploits the screen overlay feature by listening for taps and intercepting information passed to underlying activities.
* Cloak & Dagger attacks affected apps targeting Android 5.0 (API level 21) to Android 7.1 (API level 25). They abused the SYSTEM_ALERT_WINDOW ("draw on top") and/or BIND_ACCESSIBILITY_SERVICE ("a11y...
* Toast Overlay was similar to Cloak & Dagger but did not require specific Android permissions from users. It was patched with CVE-2017-0752 in Android 8.0 (API level 26).
* HIDE_OVERLAY_WINDOWS permission and setHideOverlayWindows) (since API level 31): Declare this permission in the manifest and call the method on the window to hide all non-system overlay windows whi...
* android:filterTouchesWhenObscured attribute and setFilterTouchesWhenObscured) method: Set this layout attribute to true in XML or call the method programmatically to filter touch events when the vi...
```

## ナレッジベース

### DO: exported / URL scheme / WebView / IPC の攻撃面を最小化する

* カテゴリ標準の推奨である。記事固有の確認点と合わせて使う

```text
# 推奨
- exported / URL scheme / WebView / IPC の攻撃面を最小化する
- ディープリンク引数を検証しサーバでも再検証する
- 権限は最小・目的説明と一致させる
- Tapjacking (historically affecting Android 6.0 (API level 23) and lower) exploits the screen overlay feature by listening for taps and intercepting information passed to underlying activities.
- Cloak & Dagger attacks affected apps targeting Android 5.0 (API level 21) to Android 7.1 (API level 25). They abused the SYSTEM_ALERT_WINDOW ("draw on top") and/or BIND_ACCESSIBILITY_SERVICE ("a11y") permissions. When apps were installed from the Play Store, users did not need to explicitly grant these permissions and were not even notified.
- Toast Overlay was similar to Cloak & Dagger but did not require specific Android permissions from users. It was patched with CVE-2017-0752 in Android 8.0 (API level 26).
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
- 変更レビューで MASTG-KNOW-0022 を参照リンクとして残す
```

## 参考リンク

* 本 Knowledge: <https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0022/>
* MASTG Knowledge 一覧: <https://mas.owasp.org/MASTG/knowledge/>
* MASVS `MASVS-PLATFORM`: <https://mas.owasp.org/MASVS/>
