---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0069/
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
mastg_test_id: MASTG-TEST-0069
masvs_category: MASVS-PLATFORM
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0069: Testing App Permissions

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing App Permissions」（iOS / プラットフォーム連携）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Since iOS 10, these are the main areas which you need to inspect for permissions:
* メタ: profiles: L1, L2; covered_by: MASTG-TEST-0360, MASTG-TEST-0361, MASTG-TEST-0362, MASTG-TEST-0363; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0069/>
* 関連制御群: `MASVS-PLATFORM`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing App Permissionsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing App Permissionsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing App Permissionsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Since iOS 10, these are the main areas which you need to inspect for permissions:
* [Static] Purpose Strings in the Info.plist File
* [Static] Code Signing Entitlements File
* [Static] Embedded Provisioning Profile File
* [Static] Entitlements Embedded in the Compiled App Binary
* [Dynamic] With help of the static analysis you should already have a list of the included permissions and app capabilities in use. However, as mentioned in "Source Code Inspection", spotting the sensitive data and API...
* [Dynamic] Following an approach like the one presented below should help you spotting the mentioned sensitive data and APIs:
* [Dynamic] Consider the list of permissions / capabilities identified in the static analysis (e.g. NSLocationWhenInUseUsageDescription).
合否（Evaluation）の要点:
* For each purpose string in the Info.plist file, check if the permission makes sense.
* It should be suspicious that a regular solitaire game requests this kind of resource access as it probably does not have any need for accessing the camera nor a user's health-records.
* Apart from simply checking if the permissions make sense, further analysis steps might be derived from analyzing purpose strings e.g. if they are related to storage sensitive data. For example, NSPhotoLibraryUsageDesc...
* When you do not have the original source code, you should analyze the IPA and search inside for the _embedded provisioning profile_ that is usually located in the root app bundle folder (Payload/.app/) under the name ...
* If you only have the app's IPA or simply the installed app on a jailbroken device, you normally won't be able to find .entitlements files. This could also be the case for the embedded.mobileprovision file. Still, you ...
```

## ナレッジベース

### DO: exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- exported / WebView / Deep Link / IPC の攻撃面を手順どおり行使する
- 入力・URL・Intent extra を検証不足なら fail とする
- 後継: MASTG-TEST-0360, MASTG-TEST-0361, MASTG-TEST-0362, MASTG-TEST-0363
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
- MASTG-TEST-0069 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0069/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
