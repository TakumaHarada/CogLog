---
source: https://mas.owasp.org/checklists/
scopes:
  - test
  - android
  - ios
  - backend
  - mobile
  - assessment-tracking
  - security-review
updated_at: 2026-08-16
---

# OWASP MAS Checklist（現状と代替）

## 概要

旧来の OWASP MAS Checklist は、MASVS 制御と MASTG テストを対応付けた評価用スプレッドシートであった。MASTG v2.0.0 では公式リリース成果物としての Checklist は廃止され、`/checklists/` は廃止告知へ誘導される。

* 正本は MAS サイトとプロジェクトリポジトリ上の構造化データである
* 過去リリースのスプレッドシートは履歴用途として残りうるが、現行標準ではない

## 公式 Checklist を正本にしない

現行の DO 設計／監査では、廃止済み Checklist を唯一の準拠根拠にしない。

### 公式 Checklist を正本にしないの補足

* 利点: メンテ切れの静的成果物への依存を避け、最新の制御・弱点・テストに追従できる
* 注意点: 組織内トラッカー自体は有用である。ただしデータ源は MAS の構造化コンテンツにする
* 適用範囲: 監査計画、コンプライアンス証拠、外部委託報告書
* 例外: 契約で旧 Checklist が指定される場合は、現行 MASVS/MASWE/MASTG への対応表を併記する

### 公式 Checklist を正本にしないの実装例

```text
現行の追跡方法（推奨）
1. MASVS 制御を選定
2. 関連 MASWE を列挙
3. MASTG テストまたは同等手順を割当
4. 合否・証拠・残件を issue / シートへ記録（社内生成で可）
```

## 構造化データから組織用ビューを生成する

必要なスプレッドシートやダッシュボードは、公式静的ファイルの再配布ではなく、リポジトリデータを取り込み独自生成する。

### 構造化データから組織用ビューを生成するの補足

* 利点: 報告フォーマットを組織要件へ最適化できる
* 注意点: 生成物の更新日と元データの版を必ず記録する
* 適用範囲: 内部監査、AI 支援レビュー、継続的評価
* 例外: なし

### 構造化データから組織用ビューを生成するの実装例

```text
社内トラッカー列（例）
* masvs_id
* maswe_id
* mastg_test_id
* profile (L1/L2/R/P)
* status (pass/fail/na)
* evidence_uri
* reviewed_at
* source_revision
```

## ナレッジベース

### DO: MAS サイト／リポジトリを権威あるソースとして監査する

* Checklist URL がリダイレクトされても、廃止告知の内容に従い現行ソースへ切り替える

```text
# 推奨
source_of_truth: mas.owasp.org + OWASP/mastg 等のリポジトリ
artifact: 社内生成の追跡表（版付き）
```

### DO NOT: 旧 Checklist スプレッドシート単体で「現行 MAS 準拠」と宣言する

* 理由: MASTG v2 は公式 Checklist を成果物から外している
* 理由: 静的ファイルは制御再編（Profiles / MASWE）と乖離しやすい

```text
# DO NOT: 古い xlsx の全緑を根拠にリリース承認する

# DO: 現行 MASVS/MASWE/MASTG へのマッピング結果で承認する
```

## 参考リンク

* Checklists 経路（現行は廃止告知へ）: <https://mas.owasp.org/checklists/>
* MASTG v2 Checklist 廃止告知: <https://mas.owasp.org/news/2026/07/14/checklists-removal/>
* OWASP MASTG: <https://mas.owasp.org/MASTG/>
