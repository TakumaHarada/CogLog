---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0384/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0384
masvs_category: MASVS-CODE
platform: ios
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0384: Runtime Use of Enforced Updating APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「Runtime Use of Enforced Updating APIs」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: On iOS, apps implementing enforced updating typically read the app version, for example CFBundleShortVersionString via Bundle.main.infoDictionary, and send it to a backend that returns a minimum version policy. Apps may also read CFBundleVersion when the backend policy is based on build numbers. Alternatively, they may query the App Store using the iTunes Search API, for example <https://itunes.apple.com/lookup?bundleId=> or <https://itunes.apple>...
* メタ: type: dynamic, network, hooks, manual; profiles: L2; weakness: MASWE-0043; knowledge: MASTG-KNOW-0074
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0384/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Runtime Use of Enforced Updating APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Runtime Use of Enforced Updating APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Runtime Use of Enforced Updating APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0056 to install the app.
* Use MASTG-TECH-0062 to capture the app traffic.
* Use MASTG-TECH-0095 to hook the relevant APIs.
* Exercise the app extensively to trigger as many flows as possible and enter sensitive data wherever you can.
合否（Evaluation）の要点:
* The test case fails if the app does not perform a runtime update check, or if the update is not enforced at runtime.
* Further Validation Required:
* Using the backtraces from the hook output, inspect the code locations using MASTG-TECH-0076:
* Determine whether the update check executes before access to protected functionality or backend services and cannot be bypassed.
* For backend-gated flows, determine whether modifying the version value in network requests, for example lowering version, versionCode, or build, results in an update-required response that the app properly enforces.
* For App Store lookup flows, determine whether stubbing the iTunes lookup response to advertise a higher results[0].version results in update enforcement, for example by blocking usage and redirecting to the App Store ...
* 観測期待: The output should contain:
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する
- 関連弱点 MASWE-0043 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: ビルド設定を見ずにコードレビューだけで完了する

* 理由: MASVS-CODE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- ビルド設定を見ずにコードレビューだけで完了する
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0384 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0384/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
