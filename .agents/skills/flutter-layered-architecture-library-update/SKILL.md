---
name: flutter-layered-architecture-library-update
description: >-
  Flutter Layered Architecture（dart workspace）向けの pub 依存更新 SKILL。
  ルート `pubspec.yaml` の `dependency_overrides` を軸に、`flutter pub outdated`
  （Resolvable 等）で候補を選び、`flutter pub get` と妥当性検証まで進める。
  「パッケージ更新」「outdated」「dependency_overrides を上げて」「依存を揃えて」
  では必ず使う。 Flutter SDK 自体の版調査は flutter-maintenance-check-latest-version、
  workspace 構造の把握だけは flutter-layered-architecture-workspace、
  アプリ起動／DTD は flutter-app-debug、Dart 規約のみは flutter-coding-rules では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter-Layered-Architecture / ライブラリ更新

workspace 全体の **pub パッケージ版**を、ルートの `dependency_overrides` 経由で揃えて更新する。
SDK（Flutter／Dart 本体）の版調査は対象外。コマンド例は `flutter` / `dart` 本体で示す（`mise` / `fvm` 等はリポジトリ規約に任せる）。

## いつ使うか

* `flutter pub outdated` で古くなった依存を洗い出すとき
* ルート `dependency_overrides` の版を上げる／揃えるとき
* 更新後の `pub get`・解析・テスト・ビルドで妥当性を確認するとき

## いつ使わないか

* Flutter SDK の最新版・CHANGELOG 調査 → `flutter-maintenance-check-latest-version`
* workspace の package 一覧・レイアウト把握だけ → `flutter-layered-architecture-workspace`
* アプリ起動・ランタイムデバッグ → `flutter-app-debug`
* 文言／L10n → `flutter-monolith-localization`
* extension type 等の言語規約だけ → `flutter-coding-rules`

## 前提（なぜ overrides か）

Layered Architecture の workspace では、各 package の `dependencies` は多く `any`（または緩い制約）にし、**実効バージョンはルート `dependency_overrides` で一括固定**する慣習が多い。
個別 package の `pubspec.yaml` だけを上げても全体が揃わないため、更新の主戦場はルート overrides である。

## 作業手順

1. **現状を把握する**
   * ルート `pubspec.yaml` の `dependency_overrides` と `environment`（sdk / flutter）を読む
   * 必要なら現在の解決結果（lock）も確認する

2. **更新候補を取得する**

   ```bash
   flutter pub outdated
   ```

   * 機械処理するなら `flutter pub outdated --json` も可
   * **Resolvable**（および Current / Upgradable / Latest の関係）を見て上げられる版を判断する
   * 互換性や制約で上がらないものはスキップし、理由を残す

3. **ルート `dependency_overrides` を更新する**

   ```yaml
   dependency_overrides:
     some_package: "^x.y.z"  # 必要に応じて更新
   ```

   * 子 package 側を `^…` に変えず、overrides を正とする（慣習が `any` の場合）
   * 壊れる見込みが大きいメジャー上げは、CHANGELOG／移行ガイドを見てから、またはユーザー確認後

4. **依存を再解決する**

   ```bash
   flutter pub get
   ```

   * アプリ package（多くは `app/`）がある場合は、そこでも `flutter pub get` する
   * iOS の CocoaPods 等は、リポジトリに手順があればそれに従う（無い場合は無理に `Podfile.lock` 削除を強要しない）

5. **妥当性を検証する**（失敗時は次節の切り戻し）

   * Analyzer が通る
   * 関連テストが通る
   * 必要なら対象プラットフォームのビルドが通る

6. **結果を報告する**（更新した／スキップした／検証したこと）

## 「妥当」の判断基準

* Analyzer が Success
* 各種テストが Success
* 最終的なプラットフォームアプリ（Android / iOS / Web 等）のビルドが Success（実施した場合）

## 問題が起きたときの対処順

1. 対象 package の README / CHANGELOG / 破壊的変更を確認する
2. コンパイルエラーを最小差分で直す
3. パッチ → マイナーの範囲で版を調整する
4. それでも無理なら **元の overrides に切り戻す**（無理な上げっぱなしにしない）

## ナレッジベース

### DO: 更新の軸はルート dependency_overrides

* workspace 全体の実効版を一箇所で揃えるため

### DO: Resolvable を見て上げ、上がらないものは理由付きスキップ

* Latest だけ見て無理に上げると解決不能や実行時破綻につながる

### DO: コマンドはプレーンな flutter / dart で示し、ラッパーはリポジトリ規約に従う

* SKILL に `mise` / `fvm` を埋め込まない

### DO NOT: Flutter SDK のアップグレードと pub 更新を混ぜる

* SDK 版調査は隣接 SKILL。本 SKILL は pub 依存が主目的

### DO NOT: 互換性未確認のメジャー上げを黙って全部適用する

* 壊れたら切り戻し可能な単位で進め、検証結果を残す
