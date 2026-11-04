---
source: https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0086/
scopes:
  - test
  - ios
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0086
masvs_category: MASVS-CODE
platform: ios
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0086: Memory Corruption Bugs

## 概要

* 本ドキュメントは OWASP MASTG Test「Memory Corruption Bugs」（iOS / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Are there native code parts? If so: check for the given issues in the general memory corruption section. Native code is a little harder to spot when compiled. If you have the sources then you can see that C files use .c source files and .h header files and C++ uses .cpp files and .h files. This is a little different from the .swift and the .m source files for Swift and Objective-C. These files can be part of the sources, or part of third party...
* メタ: profiles: L1, L2; deprecation_note: The associated weaknesses are best addressed during the development process. See @MASTG-KNOW-0060 for more details.
* 正本: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0086/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Memory Corruption Bugsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Memory Corruption Bugsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: ios のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Memory Corruption Bugsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] Are there native code parts? If so: check for the given issues in the general memory corruption section. Native code is a little harder to spot when compiled. If you have the sources then you can see that C f...
* [Static] For any managed code (Objective-C / Swift) in the project, check the following items:
* [Static] The doubleFree issue: when free is called twice for a given region instead of once.
* [Static] Retaining cycles: look for cyclic dependencies by means of strong references of components to one another which keep materials in memory.
* [Static] Using instances of UnsafePointer can be managed wrongly, which will allow for various memory corruption issues.
* [Dynamic] There are various tools provided which help to identify memory bugs within Xcode, such as the Debug Memory graph introduced in Xcode 8 and the Allocations and Leaks instrument in Xcode.
* [Dynamic] Next, you can check whether memory is freed too fast or too slow by enabling NSAutoreleaseFreedObjectCheckEnabled, NSZombieEnabled, NSDebugEnabled in Xcode while testing the application.
* [Dynamic] See MASTG-KNOW-0060 for more details on memory corruption bugs in iOS applications.
合否（Evaluation）の要点:
* Are there native code parts? If so: check for the given issues in the general memory corruption section. Native code is a little harder to spot when compiled. If you have the sources then you can see that C files use ...
* For any managed code (Objective-C / Swift) in the project, check the following items:
* Next, you can check whether memory is freed too fast or too slow by enabling NSAutoreleaseFreedObjectCheckEnabled, NSZombieEnabled, NSDebugEnabled in Xcode while testing the application.
```

## ナレッジベース

### DO: debuggable・依存脆弱性・デバッグ残留を確認する

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- debuggable・依存脆弱性・デバッグ残留を確認する
- 例外・ログに秘密が無いことを確認する

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
- MASTG-TEST-0086 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/ios/MASVS-CODE/MASTG-TEST-0086/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
