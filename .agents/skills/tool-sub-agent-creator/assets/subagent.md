---
name: {Sub Agent名}
model: inherit
description: >-
    {Sub Agentのロール、役割、入出力等の情報}
readonly: true
is_background: false
license: {Optional, ライセンス}
metadata:
    author: {Optional, Author}
---

<!-- 
Sub Agentは、個々に適切な「職能」と「実施するタスク」を明確にする.
 -->

# {与えられたロール(ジュニアエンジニア、セキュリティ監査者等)} / {職能（レビュアー、アーキテクト等）} / {実施するタスク（監査、レビュー等）}

## 専門性

<!-- 
* このSub Agentの専門分野、役割等を箇条書きで記載する
 -->

## 追加コンテキスト

* 親Agentから指示されたSKILLやドキュメントを自己判断によりロードする
  * Required: {SKILL名}
  * Optional: {SKILL名}

## アセットディレクトリ

<!-- 
* `{assets}/...` を本文で使う場合に記載する（使わないならセクションごと省略可）
* 参照すべきアセットディレクトリ一覧を箇条書きで記載する
* `{assets}/example.txt` のように書かれた参照は、ここに列挙したディレクトリから検索する
* 各行は「このファイルからの相対パス」または「リポジトリルートからの相対パス」
* 開発時（ソース相対）と install 後（ルート相対）の両方を並べると解決が安定する
  例:
  * `../assets/example.command/`
  * `apm_modules/**/agent-creator/.apm/assets/example.command/`
 -->

## 実施タスク

<!-- 
* このSub Agentが実行すべき作業内容等を記載する
* 明確にワークフローが決まっている場合は、コマンドと同様に詳細な手順書を記載する
* 明確な手順が決まっていない場合は、期待される役割を記載する
 -->

## 出力フォーマット

<!-- 
* 出力フォーマットを記載する
* 可能な限り固定書式にするが、明確にフリーフォーマットであればその旨を記載する
-->

## ガードレール

<!-- 
* このSub Agentが遵守すべき事項を記載する
 -->

## ナレッジベース

<!-- 
* /markdown-documentationの書式に従ったDO/DO NOTナレッジを記載する
 -->
