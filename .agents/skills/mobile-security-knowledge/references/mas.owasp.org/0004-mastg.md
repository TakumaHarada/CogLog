---
source: https://mas.owasp.org/MASTG/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - security-testing
  - reverse-engineering
updated_at: 2026-08-16
---

# OWASP MASTG（Mobile Application Security Testing Guide）

## 概要

OWASP MASTG は、モバイルアプリのセキュリティテストとリバースエンジニアリングの包括マニュアルである。MASVS の制御を、MASWE で定義された弱点経由で検証するための技術プロセスを記述する。

* テストケース、技法、ツール、知識記事が構造化メタデータで連結される
* Knowledge 蒸留: `docs/security/mas.owasp.org/knowledge/0000-index.md`
* Best Practices 蒸留: `docs/security/mas.owasp.org/best-practices/0000-index.md`
* Tests 蒸留: `docs/security/mas.owasp.org/tests/0000-index.md`
* Android 章蒸留: `docs/security/mas.owasp.org/android-testing/0000-index.md`
* iOS 章蒸留: `docs/security/mas.owasp.org/ios-testing/0000-index.md`
* 関連: Testing Profiles（例: <https://mas.owasp.org/MASTG/0x03b-Testing-Profiles/>）

## MASVS / MASWE に対応するテスト証拠を残す

「実施した」だけでなく、どの制御・弱点に対するどのテストかを証拠化する。

### MASVS / MASWE に対応するテスト証拠を残すの補足

* 利点: 監査再現性と回帰確認が容易になる
* 注意点: MASTG v2 では静的成果物（PDF / 公式スプレッドシート）よりサイトとリポジトリが正本である
* 適用範囲: 手動テスト、動的解析、静的解析、リリース前ゲート
* 例外: 同等の社内手順がある場合は、MASTG テスト ID への対応表を用意する

### MASVS / MASWE に対応するテスト証拠を残すの実装例

```text
テスト記録テンプレート
* 対象ビルド: <flavor / version / commit>
* MASVS: MASVS-NETWORK-1
* MASWE: MASWE-0026, MASWE-0027
* MASTG 手順: <ページまたはテスト ID>
* 結果: pass / fail
* 証拠: スクショ、ログ、プロキシ結果（機微情報はマスク）
```

## Testing Profiles で検証の深さを定義する

MAS-L1（基本）、追加の Security / Privacy / Resilience プロファイルを脅威モデルに合わせて選ぶ。

### Testing Profiles で検証の深さを定義するの補足

* 利点: すべてのアプリに同一深度を強制せず、必須と追加を分けられる
* 注意点: L1 は「よく知られた必須対策」中心であり、高感度データでは不足しうる
* 適用範囲: テスト計画、受け入れ基準、外部委託の Scope of Work
* 例外: なし

### Testing Profiles で検証の深さを定義するの実装例

```text
MAS-L1 例
* TLS の利用
* OS / フレームワークのセキュアな既定値の遵守
* 実装コストに対して効果の大きい基本制御

追加検討
* L2: 高感度データ、ステップアップ認証、ピンニング等
* R: 改ざん耐性・解析耐性が設計目標の場合
* P: プライバシー制御がプロダクト要件の場合
```

## ナレッジベース

### DO: テスト計画にプロファイルと対象プラットフォームを明記する

* Android / iOS / 両方、エミュレータ可否実機、ビルド種別を固定する

```text
# 推奨
platform: android+ios
profile: L1 + P
build: release 相当（debug 専用フラグなし）
```

### DO NOT: 探索的テストだけで MAS 準拠を宣言する

* 理由: MASTG は一貫した結果のための手順とケースを提供する
* 理由: 場当たり的な確認では制御カバレッジが証明できない

```text
# DO NOT: 「ざっと触って問題なさそう」で完了にする

# DO: 制御 ID 単位の合否と再テスト条件を残す
```

## 参考リンク

* OWASP MASTG: <https://mas.owasp.org/MASTG/>
* MAS Testing Profiles: <https://mas.owasp.org/MASTG/0x03b-Testing-Profiles/>
* MASTG リポジトリ: <https://github.com/OWASP/mastg>
