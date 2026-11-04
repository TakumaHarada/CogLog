---
source: https://mas.owasp.org/MASTG/0x06j-Testing-Resiliency-Against-Reverse-Engineering/
scopes:
  - test
  - ios
  - mobile
  - resilience
  - security-review
  - implementation
  - mastg-ios-testing
updated_at: 2026-08-16
upstream_revision: d7fd7d4
masvs_category: MASVS-RESILIENCE
---

# MASTG 0x06j: iOS Anti-Reversing Defenses

## 概要

本ドキュメントは MASTG「iOS Anti-Reversing Defenses」を蒸留したものである。jailbreak 検知・難読化・改ざん耐性は追加層であり、欠如そのものが直ちに脆弱性とは限らない。基本の MASVS 制御の代替にしてはならない。

* 正本: <https://mas.owasp.org/MASTG/0x06j-Testing-Resiliency-Against-Reverse-Engineering/>
* Knowledge / Tests: `MASVS-RESILIENCE`（iOS）
* 関連: `docs/security/mas.owasp.org/ios-testing/0002-0x06b-ios-security-testing.md`

## 耐タンパをサーバ認可の代替にしない

検知は抑止・遅延である。権限と秘密の最終判定はサーバ（または暗号的制約）に置く。App Attest もサーバ検証とセットである。

### 耐タンパをサーバ認可の代替にしないの補足

* 利点: バイパス前提でも被害を限定できる
* 注意点: 公開アプリは攻撃者制御端末で動く。デバッグ防止は事実上不可能と章が述べる
* 適用範囲: プロファイル R、高リスク機能
* 例外: なし

### 耐タンパをサーバ認可の代替にしないの実装例

```text
推奨
* 脅威モデルで R の要否を文書化
* 複数手法の組み合わせ（単独検知に依存しない）
* 検知結果をサーバへ伝え HTTP 保護と併用
* STORAGE/NETWORK/AUTH を先に満たす

非推奨
* 難読化があるから UserDefaults 平文を許容
* jailbreak 検知成功だけでクライアント管理者権限
```

```dart
// App Check activation (example)
if (debugToken.isEmpty) {
  return const AppleAppAttestProvider();
}
```

## テスト時は検知無効ビルドの有無を計画する

機能検証用と耐性評価用のビルドを分ける。公開手順の詳細なバイパス PoC は docs に置かない。

### テスト時は検知無効ビルドの有無を計画するの補足

* 利点: ラボ検証と本番耐性評価を混同しない
* 注意点: オープンな検知手法は既知ツールで回避されやすい
* 適用範囲: セキュリティテスト計画
* 例外: なし

### テスト時は検知無効ビルドの有無を計画するの実装例

```text
計画欄
* build_for_sec_func_test: jailbreak-detection off (optional)
* build_for_resilience_eval: production-like
* success: cost increase + server-side rejection
```

## ナレッジベース

### DO: Resilience を必須基本制御と分けてプロファイル管理する

```text
# 推奨
must: L1 STORAGE/NETWORK/AUTH (+ Privacy as needed)
optional_or_risk_based: R
```

### DO NOT: 耐タンパ欠如を Critical とし基本制御不備より先に扱う

* 理由: 章の Disclaimer が「欠如＝脆弱性ではない」と明記している
* 理由: cleartext / 平文保存 / サーバ未検証の方が実害に直結しやすい

```text
# DO NOT: 難読化未導入を最優先 Critical、ATS 例外は放置

# DO: 基本制御を先に閉じ、R は脅威に応じて追加
```

## 参考リンク

* iOS Anti-Reversing Defenses: <https://mas.owasp.org/MASTG/0x06j-Testing-Resiliency-Against-Reverse-Engineering/>
* App Attest: <https://developer.apple.com/documentation/devicecheck>
