---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0046/
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
mastg_test_id: MASTG-TEST-0046
masvs_category: MASVS-RESILIENCE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0046: Testing Anti-Debugging Detection

## 概要

* 本ドキュメントは OWASP MASTG Test「Testing Anti-Debugging Detection」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: There's no generic way to bypass anti-debugging: the best method depends on the particular mechanism(s) used to prevent or detect debugging and the other defenses in the overall protection scheme. For example, if there are no integrity checks or you've already deactivated them, patching the app might be the easiest method. In other cases, a hooking framework or kernel modules might be preferable. The following methods describe different approa...
* メタ: profiles: R; covered_by: MASTG-TEST-0046-1, MASTG-TEST-0046-2; deprecation_note: "New version available in MASTG V2"
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0046/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Testing Anti-Debugging Detectionのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Testing Anti-Debugging Detectionのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Testing Anti-Debugging Detectionのテスト実施の実装例

```text
公式記事の Overview / Static / Dynamic を読み、再現可能な手順へ落とす。
合否（Evaluation）の要点:
* There's no generic way to bypass anti-debugging: the best method depends on the particular mechanism(s) used to prevent or detect debugging and the other defenses in the overall protection scheme. For example, if ther...
* At first glance, the code looks like the prior challenge. A class called CodeCheck is responsible for verifying the code entered by the user. The actual check appears to occur in the bar method, which is declared as a...
* public class CodeCheck {
* Check for anti-debugging mechanisms, including the following criteria:
* Attaching jdb and ptrace-based debuggers fails or causes the app to terminate or malfunction.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 後継: MASTG-TEST-0046-1, MASTG-TEST-0046-2
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
- MASTG-TEST-0046 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0046/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
