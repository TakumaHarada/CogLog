# View レイヤー / Widget 実装

## 概要

本ドキュメントは、MVVM における **View（Widget）層の実装方針** を定義する。
画面のルート Widget（`*Screen`）が ViewModel のライフサイクルとイベント購読を担い、見た目の構築は `*ScreenImpl` 以下に分離する。子 Widget は Entity のみを watch し、ユーザー操作時に `ref.read()` で依存を取得する。

Riverpod の利用原則（`ref.watch` / `ref.read`、`ScreenProviders`、sealed Entity の分割など）は View レイヤーの Widget 設計ドキュメントを参照する。

## 基本設計

| # | ルール | 理由 |
| - | -- | -- |
| 1 | 画面のルート Widget は `{画面名}Screen` とし、**public** とする | 画面 Factory やナビゲーションからの入口を明確にする |
| 2 | `{画面名}Screen` で `ref.watch(ViewModel.provider)` し、ViewModel の初期化・ライフサイクル管理を行う | Provider による DI と autoDispose のスコープを画面ルートに集約する |
| 3 | 非同期初期化が必要なときは `{画面名}Screen` の `useEffect()` で `viewModel.onInitialize()` を呼ぶ | 初期化タイミングをルートに限定する |
| 4 | イベント購読が必要なときは `{画面名}Screen` の `useEffect()` または `useEventStream()` 等で開始する | ワンショットイベントの処理をルートに集約する |
| 5 | ルートレベルは初期化と購読のみとし、見た目の構築は `{画面名}ScreenImpl` に分離する | 責務分離と Golden Test のしやすさ |
| 6 | `{画面名}ScreenImpl` 配下では **Entity のみ** を watch する | UI を表示状態（Entity）への純粋な関数として保つ |
| 7 | タップ等のハンドリングでは `onTap()` コールバック内で `ref.read()` して依存を取得する | build 時に ViewModel を watch せず、見た目テスト（Golden Test）を容易にする |

## 構成コンポーネント

### `{画面名}Screen`（ルート Widget）

* **継承**: `HookConsumerWidget`
* **可視性**: **public**（`@internal` を付与しない）
* **配置**: `lib/src/view/{画面名}_screen.dart`
* **責務**:
  * `ref.watch({画面名}ScreenViewModel.provider)` による ViewModel の生成・保持
  * 必要に応じた `useEffect()` による `onInitialize()` 呼び出し
  * `useEventStream()` 等による `event` ストリームの購読とハンドリング
  * `const {画面名}ScreenImpl()` の返却

```dart
// screen_feature_settings2, settings_screen.dart
class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(SettingsScreenViewModel.provider);

    useEventStream(() => viewModel.event, (event) async {
      await _onEvent(context, ref, event);
    });

    return const SettingsScreenImpl();
  }
}
```

```dart
// screen_feature_kanji_kanamajiri, kanji_kanamajiri_screen.dart
class KanjiKanamajiriScreen extends HookConsumerWidget {
  const KanjiKanamajiriScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(KanjiKanamajiriScreenViewModel.provider);

    useEffect(() {
      viewModel.onInitialize();
      return null;
    }, [viewModel]);

    useEventStream(() => viewModel.event, (event) async {
      await _onEvent(context, ref, event);
    });

    return const KanjiKanamajiriScreenImpl();
  }
}
```

### `{画面名}ScreenImpl`（UI 実装 Widget）

* **継承**: `StatelessWidget` または `HookConsumerWidget`（子 Widget へ Entity を渡す場合）
* **可視性**: `@internal`
* **配置**: `lib/src/view/{画面名}_screen_impl.dart`（1クラス1ファイル）
* **責務**: Scaffold 等の画面骨格と、Body 等の子 Widget への委譲。**ViewModel を watch しない。**

```dart
// screen_feature_settings2, settings_screen_impl.dart
@internal
class SettingsScreenImpl extends StatelessWidget {
  const SettingsScreenImpl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.foundation_resources_settings),
      ),
      body: const AppSettingsBody(),
    );
  }
}
```

### `{画面名}ScreenProviders`（Entity 公開）

* ViewModel の `entity` を `StateStreamProvider` 経由で公開する。
* `{画面名}ScreenImpl` 配下の Widget は、原則として `{画面名}ScreenProviders.entity` のみを `ref.watch` する。

```dart
// screen_feature_settings2, settings_screen_providers.dart
@internal
class SettingsScreenProviders {
  static final entity = StateStreamProvider.autoDispose.stateBy(
    SettingsScreenViewModel.provider,
    (viewModel) => viewModel.entity,
  );

  const SettingsScreenProviders._();
}
```

### 子 Widget（Body / Section 等）

* **配置**: `lib/src/view/body/` 等
* **責務**: Entity を watch して UI を構築する。ユーザー操作はコールバック内で `ref.read()` する。

```dart
// screen_feature_settings2, app_settings_body.dart
class AppSettingsBody extends HookConsumerWidget {
  const AppSettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(SettingsScreenProviders.entity);
    // entity に基づき UI を構築
  }
}

// タップハンドラ内で ref.read()
onPressed: (context) async {
  final viewModel = ref.read(SettingsScreenViewModel.provider);
  await viewModel.onRequestLogout();
},
```

## 処理フロー

```text
ScreenFactory
  │  const SettingsScreen()   ← public ルート
  ▼
{画面名}Screen (HookConsumerWidget)
  │  ref.watch(ViewModel.provider)     … ライフサイクル管理
  │  useEffect → onInitialize()       … 非同期初期化（必要時）
  │  useEventStream → event ハンドラ   … ワンショットイベント（必要時）
  ▼
{画面名}ScreenImpl (@internal)
  │  Scaffold 等の骨格のみ（Entity / ViewModel を watch しない）
  ▼
Body / Section 等
  │  ref.watch(ScreenProviders.entity) … 表示状態のみ監視
  │  onTap 内 ref.read(ViewModel)      … 操作時のみ依存取得
  ▼
viewModel.onXXXX()
```

## ファイルレイアウト

```text
lib/src/view/
├── {画面名}_screen.dart              # {画面名}Screen（public・ルート）
├── {画面名}_screen_impl.dart         # {画面名}ScreenImpl（@internal）
├── {画面名}_screen_providers.dart    # Entity 用 Provider 群（@internal）
└── body/
    └── {部位名}.dart                 # Entity のみ watch する子 Widget
```

## 初期化とイベント購読

### 非同期初期化（`onInitialize`）

画面表示時にデータ取得等が必要な場合、`{画面名}Screen` の `useEffect()` で一度だけ呼ぶ。

```dart
useEffect(() {
  viewModel.onInitialize();
  return null;
}, [viewModel]);
```

`onInitialize()` は ViewModel アクション設計に従う（`onXXXX()` 拡張メソッド）。

* ViewModel のコンストラクタや `provider` コールバックから非同期初期化・watch 開始を呼んではならない。
* ViewModel は Widget ライフサイクルに紐づくため、初期化は Action として扱い、Unit Test では `onInitialize()` を明示呼び出しできる。

### イベント購読

Snackbar 表示・画面遷移等のワンショットイベントは、`{画面名}Screen` で購読する。`useEventStream()` の利用を推奨する。

```dart
useEventStream(() => viewModel.event, (event) async {
  await _onEvent(context, ref, event);
});
```

`useEffect()` + `stream.listen` でもよいが、購読の開始・解除をルート Widget に閉じる。

## Golden Test 向けの `ref.read()` 原則

子 Widget の `build()` では **Entity のみ** を `ref.watch` する。ViewModel や Launcher 等は `build()` 時に watch しない。
一般的な `ref.watch` / `ref.read` の原則は [mvvm-view-design.md](./mvvm-view-design.md) を参照する。

| タイミング | 操作 | 用途 |
| -- | -- | -- |
| `build()` | `ref.watch(ScreenProviders.entity)` | 表示状態の反映 |
| `onTap()` / `onPressed()` 等 | `ref.read(ViewModel.provider)` | アクション呼び出し |
| `onTap()` / `onPressed()` 等 | `ref.read(Launcher.provider)` 等 | 画面遷移・ダイアログ表示 |

これにより、Entity を固定注入した Golden Test で見た目を検証しやすくなる。操作の結合テストは Widget Test または統合テストで行う。
ViewModel の依存解決を `build()` に乗せる問題を避けるためである。

## ナレッジベース

### DO: ルート Widget を public の Screen とし、見た目は ScreenImpl に分離する

* `{画面名}Screen` で `ref.watch(ViewModel.provider)` と初期化・イベント購読を担う。
* Scaffold 等の UI 構築は `@internal` の `{画面名}ScreenImpl` に委譲する。

```dart
// screen_feature_settings2, settings_screen.dart
class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(SettingsScreenViewModel.provider);
    useEventStream(() => viewModel.event, (event) async {
      await _onEvent(context, ref, event);
    });
    return const SettingsScreenImpl();
  }
}
```

### DO: 子 Widget は Entity のみ watch し、操作時は ref.read() する

* `build()` では `ref.watch(ScreenProviders.entity)` のみとする。
* タップ等のコールバック内で `ref.read(ViewModel.provider)` して `onXXXX()` を呼ぶ。

```dart
final entity = ref.watch(SettingsScreenProviders.entity);

onPressed: (context) async {
  final viewModel = ref.read(SettingsScreenViewModel.provider);
  await viewModel.onRequestLogout();
},
```

### DO: イベント購読と onInitialize はルート Screen に集約する

* `useEventStream()` または `useEffect` + `listen` で購読し、Body 等の子に分散させない。
* 非同期初期化は `useEffect` 内で `viewModel.onInitialize()` を呼ぶ。

### DO NOT: 子 Widget の build() で ViewModel を watch する

* 理由: Golden Test の際に、ViewModel の依存解決が必要になる問題を回避するためである
* 理由: Entity のみ watch し、操作時は `ref.read()` する
* 一般原則は [mvvm-view-design.md](./mvvm-view-design.md) のナレッジベースを参照する

```dart
// 非推奨パターン
// DO NOT: 子 Widget build 内での ViewModel watch
final viewModel = ref.watch(SettingsScreenViewModel.provider);
```

```dart
// 推奨される書き換えパターン
// DO: Entity のみ watch、操作時に read
final entity = ref.watch(SettingsScreenProviders.entity);
onPressed: () {
  ref.read(SettingsScreenViewModel.provider).onSomeAction();
};
```

### DO NOT: Screen に @internal を付与する

* 理由: 画面 Factory やナビゲーションからの入口が不明確になる
* 理由: `{画面名}Screen` は public、`ScreenImpl` / `ScreenProviders` / 子 Widget は `@internal` とする

### DO NOT: 子 Widget の build() で viewModel.onXXXX() を直接呼ぶ

* 理由: build 副作用となり、再描画で意図しない呼び出しが起きうる
* 理由: `onTap()` 等のコールバック内で呼ぶ

### DO NOT: ViewModel の非同期初期化処理をコンストラクタや Provider からコールする

* 理由: Provider 生成時に初期化を始めると、Unit Test で初期化待ち・明示開始ができずテストの確実性が下がる
* 理由: ViewModel は Widget ライフサイクルに紐づく。初期化は `onInitialize()` 等の Action とし、ルート Screen の `useEffect` から呼ぶ
* 対応: `useEffect(() { viewModel.onInitialize(); return null; }, [viewModel]);`

```dart
// 非推奨パターン
// DO NOT: provider 内で初期化を開始する
(ref) {
  final vm = AccountScreenViewModel._(...);
  unawaited(vm.onInitialize());
  return vm;
}
```

```dart
// 推奨される書き換えパターン
// DO: Screen の useEffect から呼ぶ
useEffect(() {
  viewModel.onInitialize();
  return null;
}, [viewModel]);
```

### DO NOT: StatefulWidget を作成する

* 理由: 画面 Widget はすべて Stateless とし、ローカル UI 状態は Hooks（`useState` / `useTextEditingController` 等）、画面ドメイン状態は ViewModel の ScreenState に寄せる
* 理由: `ConsumerStatefulWidget` / `StatefulWidget` を増やすと、MVVM の状態の所在が二重化し Golden・Unit Test が難しくなる
* 対応: ルートは `HookConsumerWidget`、Entity のみ watch する子は `ConsumerWidget` / `HookWidget` 等

```dart
// 非推奨パターン
// DO NOT: ConsumerStatefulWidget でコントローラやフラグを持つ
class _BodyState extends ConsumerState<_Body> {
  late final TextEditingController _controller;
  bool _edited = false;
}
```

```dart
// 推奨される書き換えパターン
// DO: Hooks でローカル UI 状態を持つ
class AccountScreenBody extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: entity.nicknameInput);
    final isUserEdited = useState(false);
    // ...
  }
}
```
