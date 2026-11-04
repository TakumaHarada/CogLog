---
source: https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0040/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-best-practices
updated_at: 2026-08-16
mastg_best_id: MASTG-BEST-0040
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-BEST-0040: Preventing Overlay Attacks

## 概要

* 本ドキュメントは OWASP MASTG Best Practice「Preventing Overlay Attacks」（android）を、DO / DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。詳細手順・コード例は公式記事を正本とする。
* 要旨: Apps should protect sensitive user interactions from overlay attacks by implementing appropriate defensive mechanisms. Overlay attacks (including tapjacking) occur when malicious apps place deceptive UI elements over legitimate app interfaces to trick users into unintended act...

* 正本: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0040/>
* 関連 Knowledge: `MASTG-KNOW-0022`
* 索引: [`../0000-index.md`](../0000-index.md)

## Preventing Overlay Attacksを実装する

本 Best Practice が示す対策を、該当する実装・設定に適用する。

### Preventing Overlay Attacksを実装するの補足

* 利点: テスト失敗の予防策を、実装差分のレビュー観点として固定できる
* 注意点: Best Practice は予防策であり、Test の代替ではない（`docs/security/mas.owasp.org/tests/` と併用する）
* 適用範囲: android アプリ実装、設計レビュー、セキュリティテスト準備
* 例外: status が placeholder / deprecated の場合は新規採用の完了根拠にしない

### Preventing Overlay Attacksを実装するの実装例

```text
公式記事から抽出した実装・確認ポイントである。
* Apps should protect sensitive user interactions from overlay attacks by implementing appropriate defensive mechanisms. Overlay attacks (including tapjacking) occur when malicious apps place deceptive UI elements over legitimate app interfaces to trick users into unintended actions.
* Implement appropriate mechanisms to protect against overlay attacks. The following approaches are listed from most robust to least robust:
* Use HIDE_OVERLAY_WINDOWS permission and setHideOverlayWindows(true) (API level 31+): Declare the HIDE_OVERLAY_WINDOWS permission in the manifest and call setHideOverlayWindows(true)) on the window to hide all non-system overlay windows while the activity is in the foreground. This is the most robust solution as it prevents overlays entirely rather than just filtering touch events.
* Set android:filterTouchesWhenObscured="true" or call setFilterTouchesWhenObscured(true): Set the layout attribute android:filterTouchesWhenObscured="true" in XML for sensitive views, or call setFilterTouchesWhenObscured(true)) programmatically on sensitive views such as login buttons, payment confirmations, or permission requests. This filters touch events when the view is obscured by another visible window.
* Override onFilterTouchEventForSecurity: Override the onFilterTouchEventForSecurity) method for more granular control and to implement custom security policies based on your app's specific requirements.
* Check motion event flags such as FLAG_WINDOW_IS_OBSCURED (API level 9+) or FLAG_WINDOW_IS_PARTIALLY_OBSCURED (API level 29+) in touch event handlers to detect obscured windows and respond appropriately. Note that this approach requires custom implementation to decide how to handle detected overlays.
* Login and authentication screens
* Permission request dialogs
```

## ナレッジベース

### DO: Preventing Overlay Attacks を該当機能のレビュー必須にする

* 公式 BEST の推奨である。関連 Knowledge / Test と合わせて使う

```text
# 推奨
- Preventing Overlay Attacks を該当機能に適用する
- 関連 Knowledge（MASTG-KNOW-0022）と合わせてレビューする
- Apps should protect sensitive user interactions from overlay attacks by implementing appropriate defensive mechanisms. Overlay attacks (including tapjacking) occur when malicious apps place deceptive UI elements over legitimate app interfaces to trick users into unintended actions.
- Implement appropriate mechanisms to protect against overlay attacks. The following approaches are listed from most robust to least robust:
- Use HIDE_OVERLAY_WINDOWS permission and setHideOverlayWindows(true) (API level 31+): Declare the HIDE_OVERLAY_WINDOWS permission in the manifest and call setHideOverlayWindows(true)) on the window to hide all non-system overlay windows while the activity is in the foreground. This is the most robust solution as it prevents overlays entirely rather than just filtering touch events.
```

### DO NOT: MASTG-BEST-0040 を無視したまま機微機能を公開する

* 理由: MASTG Best Practices は Tests 失敗を防ぐための具体策である
* 理由: 詳細な禁止・代替は公式 BEST を確認する

```text
# DO NOT
- 機微操作 UI でオーバーレイ対策を省略する

# DO
- 公式記事の現行手順に従い、MASTG-BEST-0040 を参照リンクとして残す
- 変更レビューで関連 Knowledge / Test を併記する
```

## 参考リンク

* 本 Best Practice: <https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0040/>
* MASTG Best Practices 一覧: <https://mas.owasp.org/MASTG/best-practices/>
* MASTG Knowledge: <https://mas.owasp.org/MASTG/knowledge/>
* MASTG Tests: <https://mas.owasp.org/MASTG/tests/>
