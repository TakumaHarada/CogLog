---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0073/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - platform
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0073
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0073: Testing UIPasteboard

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing UIPasteboard」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: The systemwide general pasteboard can be obtained by using generalPasteboard, search the source code or the compiled binary for this method. Using the systemwide general pasteboard should be avoided when dealing with sensitive data.
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0276, MASTG-TEST-0277, MASTG-TEST-0278, MASTG-TEST-0279, MASTG-TEST-0280; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0073/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing UIPasteboardのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing UIPasteboardのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing UIPasteboardのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] The systemwide general pasteboard can be obtained by using generalPasteboard, search the source code or the compiled binary for this method. Using the systemwide general pasteboard should be avoided when deal...
* [Static] Custom pasteboards can be created with pasteboardWithName:create: or pasteboardWithUniqueName. Verify if custom pasteboards are set to be persistent as this is deprecated since iOS 10. A shared container shou...
* [Static] In addition, the following can be inspected:
* [Static] Check if pasteboards are being removed with removePasteboardWithName:, which invalidates an app pasteboard, freeing up all resources used by it (no effect for the general pasteboard).
* [Static] Check if there are excluded pasteboards, there should be a call to setItems:options: with the UIPasteboardOptionLocalOnly option.
* [Dynamic] Hook or trace the following:
* [Dynamic] generalPasteboard for the system-wide general pasteboard.
* [Dynamic] pasteboardWithName:create: and pasteboardWithUniqueName for custom pasteboards.
合否（Evaluation）の要点:
* The systemwide general pasteboard can be obtained by using generalPasteboard, search the source code or the compiled binary for this method. Using the systemwide general pasteboard should be avoided when dealing with ...
* Custom pasteboards can be created with pasteboardWithName:create: or pasteboardWithUniqueName. Verify if custom pasteboards are set to be persistent as this is deprecated since iOS 10. A shared container should be use...
* Check if pasteboards are being removed with removePasteboardWithName:, which invalidates an app pasteboard, freeing up all resources used by it (no effect for the general pasteboard).
* Check if there are excluded pasteboards, there should be a call to setItems:options: with the UIPasteboardOptionLocalOnly option.
* Check if there are expiring pasteboards, there should be a call to setItems:options: with the UIPasteboardOptionExpirationDate option.
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0276, MASTG-TEST-0277, MASTG-TEST-0278, MASTG-TEST-0279, MASTG-TEST-0280
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 未使用入口をテスト対象外のまま放置する

* 理由: MASVS-PLATFORM の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 未使用入口をテスト対象外のまま放置する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0073 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0073/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
