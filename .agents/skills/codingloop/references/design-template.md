# {機能名の実装等のタイトル}

<!-- 
  このテンプレートは計画書作成のための雛形である。
  各セクションの説明に従って内容を記載すること。
  オプションセクションは、必要に応じて追加・削除する。
-->

## 要件

<!-- 
既存の要件ドキュメント.
-->

## 実装

提案ファイルツリー

<!--
必須

* 提案内容の全体像を把握するため、編集対象すべてのファイルをツリー構造で示す.
- 追加ファイルには`[New]`サフィックスを付ける
- 削除ファイルには`[Del]`サフィックスを付ける
- 変更ファイルは通常のファイル名のまま表示する（サフィックスなし）
  -->

```text
{ディレクトリ/ファイル構造}
├── {パッケージパス}/
│   ├── lib/
│   │   ├── {libraryファイル}.dart [Update]
│   │   └── src/
│   │       └── {ファイル名}.dart [New]
│   └── pubspec.yaml [Update]
```

<!-- 
例:

```text
├── app_packages/usecase/feature_x/
│   ├── lib/
│   │   ├── usecase_feature_x.dart [New]
│   │   └── src/
│   │       └── feature_x/
│   │           ├── feature_x_usecase.dart [New]
│   │           ├── feature_x_request.dart [New]
│   │           └── feature_x_result.dart [New]
│   └── pubspec.yaml [New]
├── app_packages/usecase/feature_x/_impl/
│   ├── lib/
│   │   ├── usecase_feature_x_impl.dart [New]
│   │   └── src/
│   │       └── feature_x_usecase_impl/
│   │           └── feature_x_usecase_impl.dart [New]
│   └── pubspec.yaml [New]
├── app_packages/screen/feature/feature_x2/
│   ├── lib/
│   │   ├── screen_feature_feature_x2.dart [New]
│   │   └── src/
│   │       ├── feature_x_screen_factory.dart [New]
│   │       ├── view/
│   │       │   └── feature_x_screen.dart [New]
│   │       └── viewmodel/
│   │           ├── feature_x_screen_view_model.dart [New]
│   │           └── state/
│   │               └── feature_x_screen_state.dart [New]
│   └── pubspec.yaml [New]
└── app_packages/old_feature_y/ [Del]
```

 -->

### {修正ファイル名}

<!-- 
必須

修正内容はサマリを記載すればよい.
修正対象のファイル全てに対し、修正内容のセクションを作成する.
 -->

* {実装内容のサマリ}

現在のコード

```dart
{修正箇所}
```

修正提案内容

```dart
{修正後の内容}
```

## 実装作業手順

<!-- 
必須

チェックリスト形式で、ステップごとにタスクを記載する。
-->

### ステップ{n}: {レイヤー名} - {作業内容}

<!-- 
必須

同様のフォーマットでステップ記載を続ける
-->

#### {n}.{n}: {作業名}

* [ ] {タスク1}: `{ファイルパス}`
  * [ ] AnalyzerとFormatterを実行し、共にSuccessすること
  * [ ] {詳細タスク}
* [ ] {タスク2}: `{ファイルパス}`
  * [ ] AnalyzerとFormatterを実行し、共にSuccessすること
* [ ] Unit Test作成: `{テストファイルパス}`
  * [ ] AnalyzerとFormatterを実行し、共にSuccessすること
  * [ ] 追加されたテストがすべてSuccessすること

## 参考情報

### 関連ドキュメント

* `{ドキュメントパス}`: {説明}
* `{ドキュメントパス}`: {説明}

### 既存実装の参考

* `{ファイルパス}`: {参考にする実装の説明}

### 実装範囲外

<!-- 
  オプション: 明示的に対象外とする事項を記載する。
-->

* {対象外とする事項}

### 実装後の確認事項

<!-- 
  オプション: 実装完了後に確認すべき事項を記載する。
-->

* {確認事項}

### 参考

<!-- 
  オプション: 外部リンク、既存コード、SKILL、ドキュメント等、参考情報へのリンクを記載する.
  全てのリンクは、絶対パスで記載する.
-->

* [{リンクテキスト}]({URI})
