---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0352/
scopes:
  - test
  - android
  - mobile
  - security-review
  - implementation
  - mastg-tests
  - resilience
  - profile-r
updated_at: 2026-08-16
mastg_test_id: MASTG-TEST-0352
masvs_category: MASVS-RESILIENCE
platform: android
status: current
upstream_revision: d7fd7d4
---

# MASTG-TEST-0352: References to Debugging Detection APIs

## 概要

* 本ドキュメントは OWASP MASTG Test「References to Debugging Detection APIs」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは current である。検証手順の正本は公式記事とする。
* 要旨: Apps can implement debugging detection at the Java/Kotlin level using APIs such as Debug.isDebuggerConnected()), or at the native level using mechanisms such as ptrace calls, TracerPid checks in /proc/self/status, or inlined syscalls. If these checks are absent or not applied in security-relevant code paths, an attacker can attach a debugger undetected and use it to inspect or modify runtime state, extract sensitive data, or bypass security co...
* メタ: type: static, code, manual; profiles: R; weakness: MASWE-0064; knowledge: MASTG-KNOW-0007, MASTG-KNOW-0028
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0352/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## References to Debugging Detection APIsのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### References to Debugging Detection APIsのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### References to Debugging Detection APIsのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* Use MASTG-TECH-0013 to reverse engineer the app.
* Use MASTG-TECH-0014 to look for Java/Kotlin debugging detection APIs.
* Use MASTG-TECH-0157 to extract the native libraries from the app package.
* Use MASTG-TECH-0018 to look for native debugging detection patterns in the extracted libraries, such as calls to ptrace, reads of /proc/self/status, or checks for the TracerPid field.
合否（Evaluation）の要点:
* The test case fails if the app contains no debugging detection patterns in either its Java/Kotlin code or its native libraries. However, note that static analysis may not detect all debugging detection mechanisms, esp...
* If debugging detection patterns are found, this is a positive sign, but you should still evaluate their effectiveness using MASTG-TEST-0353.
* Further Validation Required:
* Inspect each reported code location using MASTG-TECH-0023 to determine whether the detected check is applied correctly:
* Determine whether the check is called in release builds and not only in debug configurations.
* Determine whether the app takes a security-relevant action when a debugger is detected (for example, process termination or feature restriction).
* 観測期待: The output should contain a list of locations in the Java/Kotlin code and/or native libraries where debugging detection patterns are found.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 関連弱点 MASWE-0064 の有無をチケットへ併記する
- 結果にビルド識別子・手順・合否・証拠（マスク済み）を残す
```

### DO NOT: 難読化有無だけでセキュリティ完了とする

* 理由: MASVS-RESILIENCE の検証抜けにつながる
* 理由: Evaluation を満たさない合否は監査再現性が無い

```text
# DO NOT
- 難読化有無だけでセキュリティ完了とする
- 公式 Steps を実施せず「問題なさそう」で pass にする

# DO
- MASTG-TEST-0352 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0352/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
