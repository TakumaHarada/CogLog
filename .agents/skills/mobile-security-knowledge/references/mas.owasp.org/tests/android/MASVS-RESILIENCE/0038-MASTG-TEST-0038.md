---
source: https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0038/
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
mastg_test_id: MASTG-TEST-0038
masvs_category: MASVS-RESILIENCE
platform: android
status: deprecated
upstream_revision: d7fd7d4
---

# MASTG-TEST-0038: Making Sure that the App is Properly Signed

## 概要

* 本ドキュメントは OWASP MASTG Test「Making Sure that the App is Properly Signed」（Android / 耐タンパ・耐解析）を、テストナレッジ／DO NOT 監査向けに蒸留したものである。
* 公式ステータスは deprecated である。可能なら covered_by の後継テストを優先する。
* 要旨: Ensure that the release builds are properly signed to safeguard their integrity and protect them from tampering. Android has evolved its signing schemes over time to enhance security, with newer versions offering more robust mechanisms.
* メタ: profiles: R; covered_by: MASTG-TEST-0224, MASTG-TEST-0225; deprecation_note: New version available in MASTG V2
* 正本: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0038/>
* 関連制御群: `MASVS-RESILIENCE`
* 関連 Knowledge 索引: `docs/security/mas.owasp.org/knowledge/0000-index.md`

## Making Sure that the App is Properly Signedのテスト実施

テスト目的・手順・合否基準を固定し、実装レビューとセキュリティテストで再利用する。

### Making Sure that the App is Properly Signedのテスト実施の補足

* 利点: MASVS 制御と MASWE 弱点を、再現可能な手順で検証できる
* 注意点: 蒸留は要約である。詳細コマンド・ツールは公式 Test / Techniques を確認する
* 適用範囲: android のセキュリティテスト、CI 手動ゲート、リリース前監査
* 例外: deprecated は後継 Test を優先。placeholder は参考止まりとする

### Making Sure that the App is Properly Signedのテスト実施の実装例

```text
公式テストの実施ステップ（要約）である。
* [Static] APK signatures can be verified with the apksigner tool. It is located at [SDK-Path]/build-tools/[version]/apksigner.
* [Static] $ apksigner verify --verbose example.apk
* [Static] Verified using v1 scheme (JAR signing): false
* [Static] Verified using v2 scheme (APK Signature Scheme v2): true
* [Static] Verified using v3 scheme (APK Signature Scheme v3): true
* [Dynamic] Static analysis should be used to verify the APK signature.
合否（Evaluation）の要点:
* Ensure that the release builds are properly signed to safeguard their integrity and protect them from tampering. Android has evolved its signing schemes over time to enhance security, with newer versions offering more...
* Avoid using the v1 signature scheme (JAR signing) unless absolutely necessary for backward compatibility with Android 6.0 (API level 23) and below as it is considered insecure. For example, it is affected by the Janus...
* You should also ensure that the APK's code-signing certificate is valid and belongs to the developer.
```

## ナレッジベース

### DO: 耐タンパはプロファイル R 等の方針に従い深度を決める

* カテゴリ標準のテスト方針である。本 Test の Steps / Evaluation と併用する

```text
# 推奨
- 耐タンパはプロファイル R 等の方針に従い深度を決める
- 検知をサーバ認可の代替にしない
- 後継: MASTG-TEST-0224, MASTG-TEST-0225
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
- MASTG-TEST-0038 の合否を Evaluation に照らして記録する
- 失敗時は関連 MASWE / 修正方針 / 再テスト条件を起票する
```

## 参考リンク

* 本 Test: <https://mas.owasp.org/MASTG/tests/android/MASVS-RESILIENCE/MASTG-TEST-0038/>
* MASTG Tests 一覧: <https://mas.owasp.org/MASTG/tests/>
* MASVS: <https://mas.owasp.org/MASVS/>
