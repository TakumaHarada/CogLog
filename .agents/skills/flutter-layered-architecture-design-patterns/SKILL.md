---
name: flutter-layered-architecture-design-patterns
description: >-
  Flutter Layered Architecture の Usecase / Repository 実装パターン用 SKILL。
  1 interface = 1 機能、`execute()` + Request/Result、`{動詞}{カテゴリ}Usecase` 命名、
  `{機能グループ}Repository`、interface/impl 分離、Repository↔Usecase の相互 IF 依存と
  クラス循環回避では必ず使う。「Usecase を追加」「Repository の IF 設計」「Request/Result」
  「Provider.dependencies」でもロードし、該当 `references/` だけ追加で読む。
  レイヤー責務の地図だけは flutter-layered-architecture-design、画面 MVVM は screen-mvvm、
  所在調査は code-search、Dart 言語規約のみは flutter-coding-rules では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter-Layered-Architecture / デザインパターン

Usecase 層・Data（Repository）層の **定番実装パターン** を適用する。
レイヤー全体の地図は `flutter-layered-architecture-design`、本 SKILL はパターン詳細。

## いつ使うか

* Usecase / Repository のインターフェース・実装を新規作成・改修するとき
* Request / Result（必要なら sealed Request）の形を決めるとき
* Repository と Usecase の相互依存を設計するとき

## いつ使わないか

* どのレイヤーに置くかだけ → `flutter-layered-architecture-design`
* 画面 MVVM の実装手順 → `flutter-layered-architecture-screen-mvvm`
* 既存コードの所在調査 → `flutter-layered-architecture-code-search`
* extension type / コメント規約など言語面だけ → `flutter-coding-rules`

## 作業手順

1. 対象が Usecase か Repository かを決める
2. 下の原則で IF / 命名 / Request・Result を決める
3. 詳細は対応する `references/` だけ読む
4. Riverpod の `Provider.dependencies` でクラス循環を避ける

## Usecase パターン（要約）

* **1 インターフェース = 1 機能**。メソッドは原則 `execute()` のみ（他名は例外扱い）
* 命名は新規 `{動詞}{カテゴリ}Usecase`（例: `SearchKanjiUsecase`）
* 入出力は Request / Result。複数引数パターンは sealed Request
* **ステートレス**（状態は Repository / Datasource 側）
* interface と実装は別 package。Riverpod Provider で結線

詳細 → [references/usecase-pattern.md](./references/usecase-pattern.md)

## Repository パターン（要約）

* 名称は `{機能グループ名}Repository`
* **同一機能グループなら複数メソッド可**（Usecase の 1 機能原則とは違う）
* Read/Write・監視（`watch` / `Stream`）を窓口として抽象化してよい
* 入出力は Request / Result を基本とする
* interface / 実装は別 package。注入は DataInjection 等で一元化することが多い

詳細 → [references/repository-pattern.md](./references/repository-pattern.md)

## Repository ↔ Usecase の依存

* usecase と data は同レベルのため、**相互のインターフェース依存は可**
* **クラス循環は不可**。`Provider.dependencies` を把握して組む
* 実装 package 同士の密結合や、公開 IF への SDK リークを避ける

## 追加ドキュメント

| 参照 | 使うとき |
| --- | --- |
| [usecase-pattern.md](./references/usecase-pattern.md) | Usecase IF・実装・Request/Result・package internal Usecase |
| [repository-pattern.md](./references/repository-pattern.md) | Repository IF・実装・監視・命名・テスト差し替え |

## ナレッジベース

### DO: Usecase は細かく切る、Repository は機能グループでまとめる

* Usecase を肥大化させず、Repository にデータ操作を寄せすぎない／散らしすぎないバランスを取る
* Repository / 画面の Delegate 共通処理は package internal Usecase に切る（Delegate in Delegate 禁止）

### DO: 公開面は interface、詳細は実装 package

* テスト差し替えと循環防止のため

### DO NOT: 新規 Usecase で勝手に `search()` 等のメソッド名を増やす

* 原則 `execute(Request)`。例外にするなら理由を設計に残す
