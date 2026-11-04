# MVVM-Viewレイヤー / Widget設計

## 概要

View レイヤーは、ViewModel から提供される状態（Entity）に基づいて UI を構築し、ユーザーからの操作を受け付けて ViewModel に伝達する役割を持つ。
`UI=f(State)` の原則に従い、宣言的 UI として実装される。
本ドキュメントでは、View の責務・構成に加え、View および Provider まわりで **Riverpod** を利用する際の原則（const・ref.watch/read・select・Provider スコープ・sealed class entity など）をまとめる。
表示状態は `ref.watch`、ViewModel 操作はコールバック内の `ref.read` とし、Golden Test での依存解決コストを抑える。
ルート Screen のライフサイクル管理は [mvvm-widget.md](./mvvm-widget.md) を参照する。

## 責務

* **UI の構築**: ViewModel の `entity` ストリームを監視し、画面を描画する。
* **ユーザー操作の受付**: タップや入力などのユーザー操作を検知し、ViewModel のアクションメソッドを呼び出す。
* **イベントのハンドリング**: ViewModel からのイベント（画面遷移、スナックバー表示など）を監視し、処理する。
* **ビジネスロジックを持たない**: 状態管理や複雑なロジックは ViewModel に委譲し、View は表示に専念する。

## 構成コンポーネント

### 1. Screen (`{画面名}Screen`)

画面のルート Widget。`HookConsumerWidget` を継承して実装する。

* **配置場所**: `lib/src/view/{画面名}_screen.dart`
* **特徴**:
  * ViewModel のライフサイクル管理・初期化・イベント購読を担う（詳細は [mvvm-widget.md](./mvvm-widget.md)）。
  * 見た目の構築は `{画面名}ScreenImpl` 以下の子 Widget に委譲する。

### 2. ScreenProviders (`ScreenProviders`)

画面固有の派生プロバイダを集約したクラス。

* **配置場所**: `lib/src/view/{画面名}_screen_providers.dart`
* **特徴**:
  * ViewModel の `entity` を `StateStreamProvider.autoDispose.stateBy` で公開する。
  * UI 構築 Widget は原則としてこの Provider（または派生 Provider）を `ref.watch` する。
  * 必要に応じて、Entity から特定の値を切り出した `Provider` や、sealed な状態ごとの `Provider` を定義する。
  * `@internal` でパッケージ外への公開を抑える。

#### ScreenProviders（entity のみ）の実装例

ViewModel の entity ストリームをそのまま公開する場合。

```dart
// screen_feature_login2, login_screen_providers.dart
import "package:meta/meta.dart";
import "package:screen_feature_login2/src/viewmodel/login_screen_view_model.dart";
import "package:state_stream_riverpod/state_stream_riverpod.dart";

@internal
final class LoginScreenProviders {
  /// UiStateを取得するプロバイダー.
  static final entity = StateStreamProvider.autoDispose.stateBy(
    LoginScreenViewModel.provider,
    (vm) => vm.entity,
  );
}
```

#### ScreenProviders（sealed class Entity の状態分割）の実装例

Entity が sealed class のとき、状態型ごとに Provider を分割すると、Widget 側で型安全に参照できる。

```dart
// screen_feature_eula, eula_screen_providers.dart
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:meta/meta.dart";
import "package:screen_feature_eula/src/viewmodel/entity/eula_screen_entity.dart";
import "package:screen_feature_eula/src/viewmodel/eula_screen_view_model.dart";
import "package:state_stream_riverpod/state_stream_riverpod.dart";

/// EULA画面のプロバイダー.
@internal
final class EulaScreenProviders {
  /// Entityストリーム.
  static final entity = StateStreamProvider.autoDispose.stateBy(
    EulaScreenViewModel.provider,
    (viewModel) => viewModel.entity,
  );

  /// Loading 状態.
  static final loading = Provider.autoDispose(
    (ref) => ref.watch(
      entity.select((e) => e as EulaScreenEntityLoading),
    ),
    dependencies: [entity],
  );

  /// Loaded 状態.
  static final loaded = Provider.autoDispose(
    (ref) => ref.watch(
      entity.select((e) => e as EulaScreenEntityLoaded),
    ),
    dependencies: [entity],
  );

  /// Error 状態.
  static final error = Provider.autoDispose(
    (ref) => ref.watch(
      entity.select((e) => e as EulaScreenEntityError),
    ),
    dependencies: [entity],
  );

  const EulaScreenProviders._();
}
```

## 実装パターン

### UI 構築 Widget の基本実装構造

見た目を構築する Widget（`ScreenImpl`・Body・子 Widget）は、**表示状態を `ref.watch` し、ViewModel は操作コールバック内で `ref.read` する**。

```dart
// screen_feature_login2, login_body.dart（抜粋）
Widget _buildSkipButton(BuildContext context) {
  final theme = Theme.of(context);
  return Consumer(
    builder: (context, ref, _) {
      final isEnabled = ref.watch(
        LoginScreenProviders.entity.select(
          (value) => value.canClickSkipButton,
        ),
      );
      return TextButton(
        onPressed: isEnabled
            ? () => ref.read(LoginScreenViewModel.provider).onSkipLogin()
            : null,
        child: Text(
          strings.screen_feature_login2_skip_login,
          style: DesignkitTextStyle.weakText(
            theme.textTheme.bodyLarge,
          ),
        ),
      );
    },
  );
}
```

```dart
// screen_feature_kanji_practice2, passage_input_field.dart（抜粋）
onChanged: (newText) {
  final viewModel = ref.read(KanjiPracticeScreenViewModel.provider);
  viewModel.onInputText(newText);
},
```

ルート Screen における ViewModel の `ref.watch`・初期化・イベント購読は、ライフサイクル管理のための例外であり、詳細は [mvvm-widget.md](./mvvm-widget.md) を参照する。

### イベント監視

ViewModel から通知されるワンショットのイベント（画面遷移、エラーダイアログ、スナックバーなど）の購読は、**ルート Screen** に集約する。
`useEventStream()` または `useEffect` + `listen` を用い、dispose 時に購読を解除する。詳細は [mvvm-widget.md](./mvvm-widget.md) および [mvvm-viewmodel-event.md](./mvvm-viewmodel-event.md) を参照する。

## Widget の基本設計

View レイヤーで Widget を構築する際の基本方針である。状態管理ライブラリに依存しない、Widget そのものの設計原則とする。

### const の原則

* Widget のコンストラクタは可能な限り `const` として定義する。
* `const` Widget はリビルド時に再生成されないため、パフォーマンスが向上する。
* 子 Widget を `const` として配置することで、親のリビルドが子に伝播しない。

```dart
@internal
class KanjiPracticeScreen extends HookConsumerWidget {
  const KanjiPracticeScreen({super.key});
  // ...
}
```

```dart
children: [
  const SizedBox(height: 24),
  const LoginGuideArea(),
  const Spacer(),
  _buildSignInButtons(context),
],
```

## Riverpod の利用原則

本プロジェクトでは状態管理に **Riverpod** を採用している。View および Provider を記述する際は以下の原則に従う。

**Riverpod のコード生成（`@riverpod` や `@Riverpod(keepAlive: true)` 等）は非推奨である。** Provider はクラスの `static final` メンバーとして `Provider.autoDispose<...>(...)` を明示的に定義し、`dependencies` で依存を列挙する。

### ref.watch() と ref.read()

#### ref.watch() と ref.read() の補足

* **build() 内では表示状態を ref.watch() する**: `ScreenProviders.entity` や派生 Provider など、UI に反映する値は `ref.watch()` とし、変更時に自動でリビルドされるようにする。
* **ViewModel はハンドリングコールバック内で ref.read() する**: タップ・入力・ページ切替などの操作時にのみ `ref.read(ViewModel.provider)` でインスタンスを取得し、`onXXXX()` を呼ぶ。
* **build() 内で ViewModel を ref.watch() しない**: ViewModel への依存が `build()` に乗ると、Golden Test で ViewModel の依存解決が必要になり、見た目検証が困難になる。
* **表示状態を build() 内で ref.read() しない**: Entity 等を `ref.read()` すると状態変更時にリビルドされず UI が古いままになる。

ルート Screen のライフサイクル管理（ViewModel の生成・イベント購読）だけが例外であり、[mvvm-widget.md](./mvvm-widget.md) を参照する。

#### ref.watch() と ref.read() の実装例

```dart
// screen_feature_login2, login_body.dart（抜粋）
// DO: build 相当の builder 内では Entity（表示状態）を watch する
final isEnabled = ref.watch(
  LoginScreenProviders.entity.select(
    (value) => value.canClickSkipButton,
  ),
);

// DO: ViewModel はハンドリングコールバック内で read する
onPressed: isEnabled
    ? () => ref.read(LoginScreenViewModel.provider).onSkipLogin()
    : null,
```

```dart
// screen_feature_kanji_practice2, passage_input_field.dart（抜粋）
onChanged: (newText) {
  final viewModel = ref.read(KanjiPracticeScreenViewModel.provider);
  viewModel.onInputText(newText);
},
```

### select と watchBy

* **select で監視範囲を絞る**: 大きな状態オブジェクトから必要なプロパティのみを監視し、該当プロパティが変わったときだけリビルドする。
* **Collection の場合は ref.watchBy() を使う**: Riverpod の `select` は List/Set/Map 等を参照比較するため、内容が同じでも別インスタンスだとリビルドされる。`flutter_riverpod_watch_plus` の `ref.watchBy()` で Deep Equals 比較し、不要なリビルドを防ぐ。

```dart
final eulaAgreed = ref.watch(
  LoginScreenProviders.entity.select((value) => value.eulaAgreed),
);
```

```dart
// screen_feature_kanji_practice2, passage_view.dart（抜粋）
final tokens = ref.watchBy(
  KanjiPracticeScreenProviders.entity,
  (uiState) => uiState.tokens,
);
```

### Provider スコープ

* **グローバルスコープの Provider は非推奨**: トップレベルの `final` 変数として定義するグローバル Provider は使わない。依存の追跡とテスタビリティを保つため、関連クラスの `static final` メンバーとして定義する。
* **dependencies を明示する**: `Provider.autoDispose` 等では `dependencies` パラメータで依存 Provider を列挙する。

```dart
@internal
final class KanjiPracticeScreenViewModel {
  static final provider = Provider.autoDispose<KanjiPracticeScreenViewModel>(
    (ref) {
      final passageParseUsecase = ref.watch(PassageParseUsecase.provider);
      final result = KanjiPracticeScreenViewModel._(
        state: MutableStateStream(KanjiPracticeScreenState.initial()),
        passageParseUsecase: passageParseUsecase,
      );
      ref.onDisposeAsync(result._close);
      return result;
    },
    dependencies: [PassageParseUsecase.provider],
  );
  // ...
}
```

### sealed class Entity と ScreenProviders

Entity が sealed class の場合は、状態ごとに派生 Provider を分割すると型安全に扱える。

* 各状態型（Loading / Loaded / Error など）ごとに `Provider.autoDispose` を定義し、`entity.select((e) => e as EulaScreenEntityLoaded)` のようにキャストして利用する。
* これにより、特定の状態のときだけ有効な UI コンポーネントをコンパイル時に保証できる。

```dart
@internal
final class EulaScreenProviders {
  static final entity = StateStreamProvider.autoDispose.stateBy(
    EulaScreenViewModel.provider,
    (viewModel) => viewModel.entity,
  );

  static final loading = Provider.autoDispose(
    (ref) => ref.watch(entity.select((e) => e as EulaScreenEntityLoading)),
    dependencies: [entity],
  );

  static final loaded = Provider.autoDispose(
    (ref) => ref.watch(entity.select((e) => e as EulaScreenEntityLoaded)),
    dependencies: [entity],
  );

  const EulaScreenProviders._();
}
```

## テスタビリティ

* **Widget（View）のテスト**: UI の複雑さや外部依存の多さからコストが高く、必須ではない。Widget はテストしづらいことを受け入れる。
* **Golden Test**: `build()` で Entity のみを監視し ViewModel を watch しないことで、Entity を固定注入した見た目検証が可能になる。ViewModel の依存解決は見た目テストに持ち込まない。
* **ViewModel / Model**: Provider で依存を注入するため、テスト時にモックを差し替えやすく、単体テストを重視する。ビジネスロジックは ViewModel・Usecase・StateModifier に分離し、Fake や Mock でテストする。

## ナレッジベース

### DO: build() 内では ref.watch() を使用する

* UI に反映する表示状態（`ScreenProviders.entity` や派生 Provider）は `ref.watch()` とし、状態変更時に UI を自動更新する。
* 必要なプロパティのみを `select` で監視し、Collection は `ref.watchBy()` で Deep Equals 比較する。
* ViewModel 自体は監視対象にしない（後述の DO / DO NOT を参照する）。

```dart
// screen_feature_login2, login_body.dart（抜粋）
final isEnabled = ref.watch(
  LoginScreenProviders.entity.select(
    (value) => value.canClickSkipButton,
  ),
);
```

```dart
final eulaAgreed = ref.watch(
  LoginScreenProviders.entity.select((value) => value.eulaAgreed),
);
```

### DO: ViewModelインスタンスは、Widgetのハンドリングコールバック内でref.read()を使用する

* タップ・入力・ページ切替などの操作コールバック内でのみ `ref.read(ViewModel.provider)` する。
* Golden Test の際に、ViewModel の依存解決が必要になる問題を回避するためである。
* Entity を固定注入した見た目検証と、操作の結合テストを分離できる。

```dart
// screen_feature_kanji_practice2, passage_input_field.dart（抜粋）
onChanged: (newText) {
  final viewModel = ref.read(KanjiPracticeScreenViewModel.provider);
  viewModel.onInputText(newText);
},
```

```dart
// screen_feature_login2, login_body.dart（抜粋）
onPressed: isEnabled
    ? () => ref.read(LoginScreenViewModel.provider).onSkipLogin()
    : null,
```

### DO: Provider をクラスの static final として定義し dependencies を明示する

* グローバルなトップレベル Provider は使わず、所有者クラスの `static final` とする。
* `dependencies` で依存 Provider を列挙する。

```dart
@internal
final class KanjiPracticeScreenViewModel {
  static final provider = Provider.autoDispose<KanjiPracticeScreenViewModel>(
    (ref) {
      // ...
    },
    dependencies: [PassageParseUsecase.provider],
  );
}
```

### DO: const Widget を活用し、ビジネスロジックは View に書かない

* Widget コンストラクタと子配置を可能な限り `const` にする。
* `build` 内の複雑な条件分岐・計算は ViewModel の `entity` に寄せ、View は表示に専念する。

### DO NOT: ViewModelをbuild()内部でref.watch()する

* 理由: Golden Test の際に、ViewModel の依存解決が必要になる問題を回避するためである
* 理由: 表示状態は Entity 経由で監視し、操作時のみ `ref.read()` で ViewModel を取得する
* 例外: ルート Screen のライフサイクル管理は [mvvm-widget.md](./mvvm-widget.md) を参照する

```dart
// 非推奨パターン
// DO NOT: UI 構築 Widget の build() 内で ViewModel を watch する
Widget build(BuildContext context, WidgetRef ref) {
  final viewModel = ref.watch(LoginScreenViewModel.provider);
  // ...
}
```

```dart
// 推奨される書き換えパターン
// DO: Entity を watch し、ViewModel はコールバック内で read する
// screen_feature_login2, login_body.dart（抜粋・構造）
final isEnabled = ref.watch(
  LoginScreenProviders.entity.select(
    (value) => value.canClickSkipButton,
  ),
);
return TextButton(
  onPressed: isEnabled
      ? () => ref.read(LoginScreenViewModel.provider).onSkipLogin()
      : null,
  child: Text(strings.screen_feature_login2_skip_login),
);
```

### DO NOT: Riverpod のコード生成（@riverpod 等）を使用する

* 理由: Provider の定義と依存が生成コードに隠れ、追跡とテストが困難になる
* 理由: 互換性の問題発生リスクに対し、本アーキテクチャへの恩恵が希薄である

```dart
// 非推奨パターン
// DO NOT: @riverpod / @Riverpod(keepAlive: true) によるコード生成
```

```dart
// 推奨される書き換えパターン
// DO: static final provider = Provider.autoDispose<...>(...) を明示定義する
static final provider = Provider.autoDispose<ExampleViewModel>(
  (ref) => ExampleViewModel._(...),
  dependencies: [...],
);
```

### DO NOT: build() 内で表示状態を ref.read() する

* 理由: 状態変更時にリビルドされず、UI が古いままになる
* 理由: 表示状態（Entity 等）は `ref.watch()`、ViewModel はコールバック内の `ref.read()` に限定する

```dart
// 非推奨パターン
// DO NOT: build() 内で表示状態を ref.read() する
Widget build(BuildContext context, WidgetRef ref) {
  final entity = ref.read(LoginScreenProviders.entity);
  // ...
}
```

```dart
// 推奨される書き換えパターン
// DO: 表示状態は watch、ViewModel はコールバック内で read
Widget build(BuildContext context, WidgetRef ref) {
  final isEnabled = ref.watch(
    LoginScreenProviders.entity.select((value) => value.canClickSkipButton),
  );
  return TextButton(
    onPressed: isEnabled
        ? () => ref.read(LoginScreenViewModel.provider).onSkipLogin()
        : null,
    child: const Text("スキップ"),
  );
}
```

### DO NOT: グローバルスコープの Provider を定義する

* 理由: 依存追跡とテスタビリティを損なう
* 理由: 所有者クラスが不明確になり、`dependencies` の管理が難しくなる

```dart
// 非推奨パターン
// DO NOT: トップレベルの final Provider
final exampleProvider = Provider.autoDispose((ref) => ...);
```

```dart
// 推奨される書き換えパターン
// DO: 関連クラスの static final として定義する
@internal
final class ExampleScreenProviders {
  static final entity = StateStreamProvider.autoDispose.stateBy(...);
}
```

### DO NOT: StatefulWidget を作成する

* 理由: 画面 Widget は Stateless（`HookConsumerWidget` / `ConsumerWidget` / `HookWidget` 等）とし、ローカル UI 状態は Hooks、画面ドメイン状態は ViewModel の ScreenState に寄せる
* 理由: `StatefulWidget` / `ConsumerStatefulWidget` は状態の所在を二重化し、Golden・Unit Test を難しくする
* 対応の詳細は [mvvm-widget.md](./mvvm-widget.md)

## 参考リンク

* flutter_riverpod（状態管理）: <https://pub.dev/packages/flutter_riverpod>
* flutter_riverpod_watch_plus（Collection の Deep Equals 対応）: <https://pub.dev/packages/flutter_riverpod_watch_plus>
* Riverpod 公式ドキュメント: <https://riverpod.dev/>
