---
name: flutter-layered-architecture-workspace
description: >-
  Flutter Layered Architecture（dart workspace）のリポジトリ構造把握用 SKILL。
  ルート `pubspec.yaml` の `workspace:`・`app` ビルド慣習・子 package の
  `resolution: workspace` / `any` とルート `dependency_overrides` による版揃えの
  読み方を適用する。「workspace 構成」「package 一覧の見方」「overrides の役割」
  「どこで build する？」では必ず使う。 pub 依存の更新手順そのものは
  flutter-layered-architecture-library-update、機能コードの所在調査は
  code-search、レイヤー責務設計は design、SDK 版調査は
  flutter-maintenance-check-latest-version では使わない。
license: MIT License
metadata:
  author: "@eaglesakura"
---
# Flutter / ワークスペース構造

dart / Flutter の **workspace モノレポ**として、どの package があり、依存がどう揃い、どこでアプリをビルドするかを把握する。
コマンド例は `flutter` 本体で示す（`mise` / `fvm` 等はリポジトリ規約に任せる）。

## いつ使うか

* ルート `pubspec.yaml` の `workspace:` から package 一覧・配置を読むとき
* 子 package が `any` + `resolution: workspace` な理由／ルート overrides の役割を説明するとき
* 配布アプリのビルド入口（多くは `app/`）を確認するとき

## いつ使わないか

* `outdated` で版を上げる・検証する具体手順 → `flutter-layered-architecture-library-update`
* 「この機能のコードはどこ？」の探索レポート → `flutter-layered-architecture-code-search`
* レイヤー責務・DI の設計判断 → `flutter-layered-architecture-design`
* Flutter SDK の最新版調査 → `flutter-maintenance-check-latest-version`

## 作業手順

1. リポジトリルートの `pubspec.yaml` を開く
2. `workspace:` ブロックでローカル package 一覧を把握する
3. 必要なら `environment`（sdk / flutter）と `dependency_overrides` の役割を確認する
4. ビルド対象が `app`（または同等のアプリ package）かを確認する
5. 依存の **更新作業**に入るなら `library-update` へ引き継ぐ

## 原則（要約）

### workspace でローカル package を列挙する

* アプリ固有 package はルート `pubspec.yaml` の `workspace:` に載る
* ここからレイアウトを読み、レイヤー慣例（`screen_*` / `usecase_*` 等）と突き合わせて候補を絞る

```yaml
workspace:
  - app
  - app_packages/data/database
  # 以下、ローカル package が列挙される
```

### アプリは `app` package でビルドする（慣習）

* ユーザー向けアプリの入口は多くの場合 `app/`

```bash
cd app/
flutter build ...
```

### 実効依存はルート `dependency_overrides` で揃える

* 子 package は `publish_to: "none"` + `resolution: workspace`、依存は多く `any`
* 版の固定・揃えはルート overrides（**更新の手順詳細は library-update**）

```yaml
# ルート pubspec.yaml（例）
environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.44.0 <4.0.0"

dependency_overrides:
  some_package: "^1.0.0"
```

```yaml
# 子 package の pubspec.yaml（例）
publish_to: "none"
resolution: workspace

environment:
  sdk: ">=3.12.0 <4.0.0"
  flutter: ">=3.44.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  some_package: any
```

ディレクトリ名やプレフィックスはリポジトリにより違うが、**ルート workspace + overrides / 子は any** の形を優先して読み替える。

## 隣接 SKILL

| やりたいこと | 寄せ先 |
| --- | --- |
| overrides を実際に上げて検証 | `flutter-layered-architecture-library-update` |
| 機能・レイヤーのソース所在 | `flutter-layered-architecture-code-search` |
| レイヤー責務・依存方向 | `flutter-layered-architecture-design` |

## ナレッジベース

### DO: まずルート pubspec の workspace を読む

* ディスク全体を無秩序に探す前に、公式の package 一覧を得る

### DO: 構造の説明と依存更新手順を混ぜない

* 「なぜ overrides があるか」は本 SKILL、「どう上げるか」は library-update

### DO NOT: 子 package の制約だけ変えて workspace 全体が揃ったと思い込む

* 実効版はルート overrides 側を見る

### DO NOT: SDK アップグレードと workspace 構造把握を同一作業にする

* SDK は隣接のメンテナンス SKILL へ
