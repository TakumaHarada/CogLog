---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0043/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - code
  - profile-l1
  - profile-l2
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0043
masvs_category: MASVS-CODE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0043: Memory Corruption Bugs

## 概要

* 本ドキュメントは OWASP MASTG Test「Memory Corruption Bugs」（Android / コード品質）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: There are various items to look for:
* メタ: profiles: L1, L2; deprecation_note: The associated weaknesses are best addressed during the development process. See @MASTG-KNOW-0005 for more details.
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0043/>
* 関連制御群: `MASVS-CODE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Memory Corruption Bugsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Memory Corruption Bugsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Memory Corruption Bugsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] There are various items to look for:
* [Static] Are there native code parts? If so: check for the given issues in the general memory corruption section. Native code can easily be spotted given JNI-wrappers, .CPP/.H/.C files, NDK or other native frameworks.
* [Static] Is there Java code or Kotlin code? Look for Serialization/deserialization issues, such as described in A brief history of Android deserialization vulnerabilities.
* [Static] Note that there can be Memory leaks in Java/Kotlin code as well. Look for various items, such as: BroadcastReceivers which are not unregistered, static references to Activity or View classes, Singleton classe...
* [Static] 9 ways to avoid memory leaks in Android
* [Dynamic] There are various steps to take:
* [Dynamic] In case of native code: use Valgrind or Mempatrol to analyze the memory usage and memory calls made by the code.
* [Dynamic] In case of Java/Kotlin code, try to recompile the app and use it with Squares leak canary.
合否（Evaluation）の要点:
* Are there native code parts? If so: check for the given issues in the general memory corruption section. Native code can easily be spotted given JNI-wrappers, .CPP/.H/.C files, NDK or other native frameworks.
* Note that there can be Memory leaks in Java/Kotlin code as well. Look for various items, such as: BroadcastReceivers which are not unregistered, static references to Activity or View classes, Singleton classes that ha...
* Check with the Memory Profiler from Android Studio for leakage.
* Check with the Android Java Deserialization Vulnerability Tester, for serialization vulnerabilities.
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
- MASTG-TEST-0043 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0043/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
