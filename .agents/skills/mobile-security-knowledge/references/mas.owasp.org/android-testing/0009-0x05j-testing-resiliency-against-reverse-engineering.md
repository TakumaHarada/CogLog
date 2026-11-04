---
source: https://mas.owasp.org/MASTG/0x05j-Testing-Resiliency-Against-Reverse-Engineering/
scopes:
  - test
  - android
  - mobile
  - resilience
  - security-review
  - implementation
  - mastg-android-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-RESILIENCE
---

# MASTG 0x05j: Android Anti-Reversing Defenses

## 概要

本ドキュメントは MASTG「Android Anti-Reversing Defenses」を蒸留したものである。ルート検知・難読化・改ざん耐性などはクライアント耐性を上げる追加層であり、欠如そのものが直ちに脆弱性とは限らない。100% の阻止は期待できない。

* 正本: <https://mas.owasp.org/MASTG/0x05j-Testing-Resiliency-Against-Reverse-Engineering/>
* Knowledge / Tests: `MASVS-RESILIENCE` 配下
* 関連: `docs/security/mas.owasp.org/android-testing/0002-0x05b-android-security-testing.md`

## 耐タンパをサーバ認可の代替にしない

検知・難読化は遅延・抑止であり、権限・秘密の最終判定はサーバ（または暗号的制約）に置く。

### 耐タンパをサーバ認可の代替にしないの補足

* 利点: バイパス前提でも被害を限定できる
* 注意点: 公開アプリは攻撃者の完全制御端末で動く。デバッグ防止は事実上不可能と章が述べる
* 適用範囲: プロファイル R、高リスク機能
* 例外: なし

### 耐タンパをサーバ認可の代替にしないの実装例

```text
推奨
* 脅威モデルで R の要否を文書化
* 検知シグナルはサーバで評価（例: Play Integrity / App Check）
* STORAGE/NETWORK/AUTH の基本制御を先に満たす

非推奨
* 難読化があるから平文トークン保存を許容
* ルート検知成功だけで管理者権限をクライアント付与
```

```dart
// App Check activation (example)
// 正規クライアント補助の例（サーバ検証前提）
if (debugToken.isEmpty) {
  return const AndroidPlayIntegrityProvider();
}
```

## テスト時は検知無効ビルドの有無を計画する

典型的にはルート検知無効の debug ビルドで機能テストし、release で検知の有無を別評価する。

### テスト時は検知無効ビルドの有無を計画するの補足

* 利点: ラボでの検証可能性と本番耐性評価を分離できる
* 注意点: 検知バイパス手順の詳細を公開ナレッジ化しない
* 適用範囲: セキュリティテスト計画
* 例外: なし

### テスト時は検知無効ビルドの有無を計画するの実装例

```text
計画欄
* build_for_functional_sec_test: root-detection off
* build_for_resilience_eval: production-like
* success_criteria: バイパスコスト増加 / サーバ側拒否
```

## ナレッジベース

### DO: Resilience 要件を「必須の基本制御」と分けてプロファイル管理する

```text
# 推奨
must: L1 STORAGE/NETWORK/AUTH
optional_or_risk_based: R (obfuscation, root detection, ...)
```

### DO NOT: 耐タンパ欠如だけを Critical 脆弱性として基本制御不備より先に扱う

* 理由: 章の General Disclaimer が「欠如＝脆弱性ではない」と明記している
* 理由: 基本制御の欠落の方が実害に直結しやすい

```text
# DO NOT: 難読化未導入を最優先 Critical にする一方 cleartext を放置

# DO: まず NETWORK/STORAGE/AUTH を閉じ、R は脅威に応じて追加
```

## 参考リンク

* Android Anti-Reversing Defenses: <https://mas.owasp.org/MASTG/0x05j-Testing-Resiliency-Against-Reverse-Engineering/>
* Play Integrity: <https://developer.android.com/google/play/integrity>
