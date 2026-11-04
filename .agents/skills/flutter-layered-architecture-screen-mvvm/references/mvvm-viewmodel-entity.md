# ViewModel レイヤー / ScreenEntity と State to Entity 変換

## 概要

ScreenEntity は、View（Screen）が直接消費する UI 表示専用の状態オブジェクトである。
ViewModel が保持する ScreenState（ビジネスロジック用の内部状態）は、View には公開せず、State→Entity 変換を経て ScreenEntity としてのみ View に提供する。
この変換は、**常に** 専用の StateToEntityDelegate クラスに委譲する。
Golden Test により State / Entity / 見た目の統合テストを行うため、変換経路を Delegate に固定する。

## ScreenEntity

### ScreenEntity の補足

ScreenEntity は表示に必要なプロパティのみを持ち、ScreenState の内部構造やビジネス都合を View から隠蔽する。
Freezed により不変に保ち、State の型が sealed の場合は Entity も sealed で対応する場合がある。

### ScreenEntity の定義の補足

* **名前**: `{画面名}ScreenEntity`
* **配置場所**: `lib/src/viewmodel/entity/{画面名}_screen_entity.dart`
* **特徴**:
  * Freezed Class で実装する（`abstract class` または `sealed class`）。
  * `ScreenState` から StateToEntityDelegate を介して冪等に生成され、View が直接参照する。
  * 表示に必要なプロパティのみを持つ。必要に応じて `@internal` を付与する。
  * 重複・非正規化されたデータを許容する

### ScreenEntity の実装例

単一形（abstract class）の例:

```dart
// screen_feature_login2, login_screen_entity.dart
@freezed
@internal
abstract class LoginScreenEntity with _$LoginScreenEntity {
  const factory LoginScreenEntity({
    required String appName,
    required bool canClickSignInButton,
    required bool canClickSkipButton,
    required bool canClickEulaButton,
    required bool eulaAgreed,
  }) = _LoginScreenEntity;

  const LoginScreenEntity._();
}
```

状態が分岐する場合（sealed class）の例:

```dart
// screen_feature_eula, eula_screen_entity.dart
@internal
@freezed
sealed class EulaScreenEntity with _$EulaScreenEntity {
  const factory EulaScreenEntity.loading() = EulaScreenEntityLoading;
  const factory EulaScreenEntity.loaded({required String text}) = EulaScreenEntityLoaded;
  const factory EulaScreenEntity.error({required String message}) = EulaScreenEntityError;
  const EulaScreenEntity._();
}
```

## State→Entity 変換

**State→Entity 変換は、常に StateToEntityDelegate に切り出す。** 配置は `delegate/` とする。

StateToEntityDelegate は、ScreenState を ScreenEntity に変換する責務のみを持つ。
ViewModel の外に切り出すことで、ViewModel の肥大化を防ぎ、変換ロジックを単体テストしやすくする。
あわせて、Golden Test により State / Entity / 見た目の統合テストを行うため、変換経路を Delegate に固定する。
副作用を持たない純粋な変換にし、画面固有のため同一パッケージ内では DI せずに直接インスタンスを生成する。

### StateToEntityDelegate の配置の補足

* **配置場所**: `lib/src/viewmodel/delegate/`
* **特徴**: Delegate のベストプラクティスに従う。

### StateToEntityDelegate の実装例

シンプルな変換の例:

```dart
// screen_feature_kanji_kanamajiri, usecase/screen_state_to_entity_delegate.dart
/// 漢字仮名交じり文変換画面の State を Entity に変換する Delegate.
@internal
class ScreenStateToEntityDelegate {
  const ScreenStateToEntityDelegate();

  /// [state] を [KanjiKanamajiriScreenEntity] に変換する.
  KanjiKanamajiriScreenEntity execute(
    KanjiKanamajiriScreenState state,
  ) {
    return KanjiKanamajiriScreenEntity(
      resultSection: _buildResultSection(state),
      inputSection: _buildInputSection(state),
      userActionSection: _buildUserActionSection(state),
    );
  }
  // ...
}
```

複雑な変換（中間データ構造 TemporaryState を用いる）の例:

```dart
// screen_feature_school_grade, usecase/school_grade_screen_state_to_entity_delegate.dart
@internal
class SchoolGradeScreenStateToEntityDelegate {
  const SchoolGradeScreenStateToEntityDelegate();

  SchoolGradeScreenEntity execute(SchoolGradeScreenState state) {
    return switch (state) {
      SchoolGradeScreenStateLoading() =>
        const .loading(),
      SchoolGradeScreenStateLoaded loaded => _buildEntity(loaded),
    };
  }

  SchoolGradeScreenEntity _buildEntity(SchoolGradeScreenStateLoaded loaded) {
    final temporaryStates = _buildTemporaryStates(loaded);
    final sortedTemporaryStates = _sortTemporaryStates(
      sortType: loaded.sortType,
      temporaryStates: temporaryStates,
    );
    return _buildEntityFromTemporaryStates(
      sortedTemporaryStates: sortedTemporaryStates,
      sortType: loaded.sortType,
    );
  }
  // ... TemporaryState を用いた段階的な変換 ...
}
```

## ViewModel からの Entity 公開

ViewModel は、View に生の ScreenState を公開せず、必ず ScreenEntity のストリームを提供する。

* **Entity の公開**: `StateStream<ScreenEntity> get entity => state.map(stateToEntityDelegate.execute);`

例:

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen_view_model.dart
StateStream<KanjiKanamajiriScreenEntity> get entity =>
    state.map(stateToEntityDelegate.execute);
```

## ディレクトリ構成

```text
lib/src/viewmodel/
├── entity/
│   └── {画面名}_screen_entity.dart      # ScreenEntity
└── delegate/
    └── {画面名}_screen_state_to_entity_delegate.dart   # StateToEntityDelegate（必須）
```

## ナレッジベース

### DO: View には必ず ScreenEntity を渡す

* ScreenState を View に直接公開せず、Entity に変換してから渡す。
* ViewModel は `StateStream<ScreenEntity> get entity` で公開する。

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen_view_model.dart
StateStream<KanjiKanamajiriScreenEntity> get entity =>
    state.map(stateToEntityDelegate.execute);
```

### DO: State→Entity 変換は常に StateToEntityDelegate に切り出す

* 変換の複雑さに関わらず、常に StateToEntityDelegate へ切り出す。
* Golden Test により State / Entity / 見た目の統合テストを行うため、変換経路を Delegate に固定する。
* 副作用を持たない変換のため、Delegate は `const` コンストラクタで生成する。
* ViewModel は `state.map(stateToEntityDelegate.execute)` で Entity を公開する。

```dart
// screen_feature_kanji_kanamajiri, usecase/screen_state_to_entity_delegate.dart
@internal
class ScreenStateToEntityDelegate {
  const ScreenStateToEntityDelegate();

  KanjiKanamajiriScreenEntity execute(
    KanjiKanamajiriScreenState state,
  ) {
    return KanjiKanamajiriScreenEntity(
      resultSection: _buildResultSection(state),
      inputSection: _buildInputSection(state),
      userActionSection: _buildUserActionSection(state),
    );
  }
}
```

### DO NOT: ScreenState を View に直接公開する

* 理由: View にビジネスロジック用の内部状態が露出し、関心の分離が崩れる
* 理由: 表示専用の ScreenEntity を介することで、State の構造変更が View に波及しにくくなる

```dart
// 非推奨パターン
// DO NOT: ScreenState の直接公開
StateStream<ScreenState> get stateForView => state;
```

```dart
// 推奨される書き換えパターン
// DO: ScreenEntity として公開する
StateStream<ScreenEntity> get entity =>
    state.map(stateToEntityDelegate.execute);
```

### DO NOT: ViewModel に State→Entity 変換ロジックを直接書く

* 理由: 変換経路が分散すると、Golden Test による State / Entity / 見た目の統合テストが困難になる
* 理由: 変換は肥大化しやすく、ViewModel の責務が混在する
* 理由: 常に StateToEntityDelegate に切り出し、`execute` で一括してテストする

### DO NOT: Extension の private メソッドや ViewModel part 内メソッドで State→Entity 変換する

* 理由: Extension / part 内 private メソッドは単体テストしづらく、ViewModel と密結合になりやすい
* 理由: Golden Test 向けに変換経路を StateToEntityDelegate に固定する
* 理由: StateToEntityDelegate クラスのみを使う
