# 画面遷移(Navigation)

## 概要

このプロジェクトでは、画面遷移に `go_router` を使用している。画面遷移は、以下のインターフェースを通じて行う。

`go_router` に直接依存しているのは `screen_navigation_impl` packageのみであり、その他のpackageはルーティングライブラリの詳細を知ることはない。

* **`AppRouterFactory`**: アプリ全体のルーティングを管理するインターフェース
  * 実装は `screen_navigation_impl` packageに隠蔽される
* **`${画面名}Factory`**: 画面のWidgetを構築するインターフェース
  * 実装は各 `screen_feature_${画面名}2` packageに隠蔽される
* **`${画面名}Launcher`**: 画面遷移を実行するインターフェース
  * 実装は `screen_navigation_impl` packageに隠蔽される
* **`${画面名}Finisher`**: 画面の終了と結果の返却を行うインターフェース
  * 実装は `screen_navigation_impl` packageに隠蔽される
* **`${画面名}Proxy`**: ルーティングライブラリのルート定義とFactoryを接続するWidget
  * 実装は `screen_navigation_impl` packageに隠蔽される
* **`AlertDialogLauncher`**: アラートダイアログの表示を行うインターフェース
  * 実装は `screen_navigation_impl` packageに隠蔽される

## パッケージ構成

画面遷移は2つのパッケージで構成される。

### `screen_navigation`（インターフェース層）

画面遷移のインターフェースとデータモデルを定義する。ルーティングライブラリに依存しない。

```text
screen_navigation/lib/
├── src/
│   ├── app/
│   │   ├── app_navigator.dart
│   │   ├── app_router_factory.dart
│   │   └── app_router_request.dart
│   ├── dialog/
│   │   └── alert/
│   │       ├── alert_dialog_launcher.dart
│   │       ├── alert_dialog_request.dart
│   │       └── alert_dialog_result.dart
│   └── screen/
│       ├── home/
│       │   ├── home_screen_factory.dart
│       │   ├── home_screen_input.dart
│       │   ├── home_screen_launcher.dart
│       │   ├── home_screen_request.dart
│       │   └── home_screen_tab.dart
│       ├── login/
│       │   ├── login_screen_factory.dart
│       │   ├── login_screen_finisher.dart
│       │   ├── login_screen_launcher.dart
│       │   └── login_screen_navigation_result.dart
│       ├── eula/
│       │   ├── eula_screen_factory.dart
│       │   ├── eula_screen_launcher.dart
│       │   └── eula_screen_navigation_result.dart
│       ├── settings/
│       │   ├── settings_screen_factory.dart
│       │   └── settings_screen_launcher.dart
│       ├── debug/
│       │   ├── debug_screen_factory.dart
│       │   └── debug_screen_launcher.dart
│       ├── kanji_practice/
│       │   └── kanji_practice_screen_factory.dart
│       ├── kanji_kanamajiri/
│       │   └── kanji_kanamajiri_screen_factory.dart
│       └── school_grade/
│           └── school_grade_screen_factory.dart
└── screen_navigation.dart
```

### `screen_navigation_impl`（実装層）

ルーティングライブラリ（本プロジェクトでは `go_router`）を用いた画面遷移の実装を提供する。Proxy・Launcher実装・ルーティング設定・依存注入が含まれる。

```text
screen_navigation/_impl/lib/
├── src/
│   ├── dialog/
│   │   └── alert_dialog_launcher_impl.dart
│   ├── feature/
│   │   ├── home/
│   │   │   ├── home_screen_launcher_impl.dart
│   │   │   ├── home_screen_proxy.dart
│   │   │   ├── kanji_practice_outlet_proxy.dart
│   │   │   ├── school_grade_outlet_proxy.dart
│   │   │   └── kanji_kanamajiri_outlet_proxy.dart
│   │   ├── login/
│   │   │   ├── login_screen_launcher_impl.dart
│   │   │   ├── login_screen_finisher_impl.dart
│   │   │   └── login_screen_proxy.dart
│   │   ├── eula/
│   │   │   ├── eula_screen_launcher_impl.dart
│   │   │   └── eula_screen_proxy.dart
│   │   ├── settings/
│   │   │   ├── settings_screen_launcher_impl.dart
│   │   │   └── settings_screen_proxy.dart
│   │   └── debug/
│   │       ├── debug_screen_launcher_impl.dart
│   │       └── debug_screen_proxy.dart
│   ├── injection/
│   │   └── screen_navigation_injection.dart
│   ├── internal/
│   │   └── build_context_extensions.dart
│   ├── router/
│   │   ├── app_router_factory_impl.dart
│   │   └── delegate/
│   │       └── routing_redirect_delegate.dart
│   └── workaround/
│       └── go_router_workaround_navigator_observer.dart
└── screen_navigation_impl.dart
```

## AppRouterFactory

`AppRouterFactory` は、アプリ全体のルーティングを管理するインターフェースである。`main()` 関数から呼び出され、`MaterialApp.router` 相当の Widget を構築する。

### AppRouterFactoryのインターフェース定義

```dart
/// アプリの画面遷移を管理するグラフ.
/// 画面遷移のルートを管理する.
abstract class AppRouterFactory {
  static final provider = Provider<AppRouterFactory>((ref) {
    throw UnimplementedError("$AppRouterFactory is not implemented");
  });

  const AppRouterFactory();

  /// アプリのトップレベルルータを構築する.
  /// アプリのmain()関数から呼び出され、各Screenにルーティングされる.
  /// [MaterialApp.router] 相当のWidgetを期待される.
  Widget build(
    BuildContext context,
    AppRouterRequest request,
  );
}
```

### AppRouterRequest

`AppRouterFactory.build()` に渡すリクエストオブジェクト。ロケール情報などアプリ全体の設定を含む。

```dart
@freezed
abstract class AppRouterRequest with _$AppRouterRequest {
  const factory AppRouterRequest({
    required Iterable<Locale> supportedLocales,
    required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  }) = _AppRouterRequest;

  const AppRouterRequest._();
}
```

### 実装（AppRouterFactoryImpl）

`AppRouterFactoryImpl` は `go_router` の `GoRouter` インスタンスを管理し、アプリ全体のルーティング設定を行う。

主な構成要素:

* **`GoRouter`**: ルーティング定義（`GoRoute`、`StatefulShellRoute`）
* **`redirect`**: ルートアクセス時のリダイレクト処理（`RoutingRedirectDelegate` に委譲）
* **`observers`**: `RouteLifecycleDetector`、`FirebaseAnalyticsObserver` 等のオブザーバー

## ${画面名}Factory

`${画面名}Factory` は、画面のWidgetを構築するインターフェースである。

### ${画面名}Factoryのインターフェース定義

```dart
/// ホーム画面へのルーティングを行うインターフェース.
abstract interface class HomeScreenFactory {
  static final provider = Provider<HomeScreenFactory>((ref) {
    throw UnimplementedError("$HomeScreenFactory is not implemented");
  });

  const HomeScreenFactory();

  /// ホーム画面を構築する
  Widget build(BuildContext context);
}
```

### Factoryの補足

* `${画面名}Factory` は画面の Widget を構築する責務のみを持つ。
* `build()` メソッドで画面用の Widget を生成する。
* **全ての画面**に必ず Factory が存在する（Launcher を持たないタブ内コンテンツ画面含む）。
* Factoryのみを持つ画面（例: `KanjiPracticeScreenFactory`, `SchoolGradeScreenFactory`）は、他の画面（例: Home画面のタブ）から埋め込まれる形で使用される。

## ${画面名}Launcher

`${画面名}Launcher` は、画面遷移を実行するインターフェースである。

### 遷移メソッドの種類

`${画面名}Launcher` は、画面遷移の方法に応じて以下のメソッドを持つ。

* **`launch()`**: 画面スタックをリセットして宣言的遷移する
  * 実装は `GoRouter.go()` 相当となる
* **`push()`**: 画面スタックに積んで遷移する
  * 実装は `GoRouter.push()` 相当となる

### launch() メソッド

画面スタックをリセットして遷移する。主にホーム画面などのルート画面への遷移に使用される。

```dart
/// ホーム画面への遷移を行うインターフェース.
abstract class HomeScreenLauncher {
  static final provider = Provider<HomeScreenLauncher>(
    (ref) => throw UnimplementedError(
      "$HomeScreenLauncher is not implemented",
    ),
  );

  const HomeScreenLauncher._();

  /// ホーム画面へ遷移する.
  /// 遷移後、画面スタックがリセットされる.
  void launch(BuildContext context, {HomeScreenRequest? request});
}
```

`HomeScreenRequest` により、遷移先のタブを指定できる。

```dart
@freezed
sealed class HomeScreenRequest with _$HomeScreenRequest {
  /// デフォルトのタブを表示する.
  const factory HomeScreenRequest.defaultTab() = HomeScreenRequestDefaultTab;

  /// 指定したタブを表示する.
  const factory HomeScreenRequest.selectedTab({
    required HomeScreenTab tab,
  }) = HomeScreenRequestSelectedTab;

  const HomeScreenRequest._();
}
```

### push() メソッド（結果あり）

現在の画面の上に新しい画面を積んで遷移する。遷移結果を `${画面名}NavigationResult` として受け取る。

```dart
/// ログイン画面への遷移を行うインターフェース.
abstract class LoginScreenLauncher {
  static final provider = Provider<LoginScreenLauncher>(
    (ref) => throw UnimplementedError(
      "$LoginScreenLauncher is not implemented",
    ),
  );

  const LoginScreenLauncher._();

  /// ログイン画面を表示し、結果を受け取る.
  Future<LoginScreenNavigationResult> push(BuildContext context);
}
```

### push() メソッド（結果なし）

結果を返す必要がない `push()` も存在する。

```dart
/// 設定画面への遷移を行うインターフェース.
abstract class SettingsScreenLauncher {
  static final provider = Provider<SettingsScreenLauncher>(
    (ref) => throw UnimplementedError(
      "$SettingsScreenLauncher is not implemented",
    ),
  );

  const SettingsScreenLauncher._();

  /// 設定画面を表示する.
  Future<void> push(BuildContext context);
}
```

### Launcher実装の共通パターン

Launcher の実装は `screen_navigation_impl` パッケージに存在し、安全な遷移拡張メソッド (`safeGoNamed`, `safePushNamed`) を使用する。

#### launch() の実装例

```dart
@internal
class HomeScreenLauncherImpl implements HomeScreenLauncher {
  static const name = "home";
  static const path = "/";

  static final provider = Provider<HomeScreenLauncherImpl>((ref) {
    ref.keepAlive();
    return const HomeScreenLauncherImpl._();
  });

  const HomeScreenLauncherImpl._();

  @override
  Future<void> launch(
    BuildContext context, {
    HomeScreenRequest? request,
  }) async {
    final tab = switch (request) {
      HomeScreenRequestSelectedTab(tab: final tab) => tab,
      HomeScreenRequestDefaultTab() || null => HomeScreenTab.kanjiPractice,
    };
    await context.safeGoNamed(
      tab.name,
      onNavigationFailed: (lifecycle) {
        return;
      },
    );
  }
}
```

#### push() の実装例

```dart
@internal
class LoginScreenLauncherImpl implements LoginScreenLauncher {
  static const name = "login";

  static final provider = Provider<LoginScreenLauncherImpl>((ref) {
    return const LoginScreenLauncherImpl._();
  });

  const LoginScreenLauncherImpl._();

  @override
  Future<LoginScreenNavigationResult> push(BuildContext context) async {
    return await context.safePushNamed(
          LoginScreenLauncherImpl.name,
          onNavigationFailed: (lifecycle) {
            return const LoginScreenNavigationResult.canceled();
          },
        ) ??
        const LoginScreenNavigationResult.canceled();
  }
}
```

## ${画面名}Finisher

`${画面名}Finisher` は、画面の終了と結果の返却を行うインターフェースである。画面側から遷移を完了させる必要がある場合に使用する。

### ${画面名}Finisherのインターフェース定義

```dart
/// ログイン画面の終了を行うインターフェース.
abstract interface class LoginScreenFinisher {
  static final provider = Provider<LoginScreenFinisher>(
    (ref) =>
        throw UnimplementedError("$LoginScreenFinisher is not implemented"),
  );

  const LoginScreenFinisher._();

  /// ログイン画面を終了する.
  ///
  /// NOTE.
  /// 現在のスタックや戻り値によって、遷移先は変化する.
  void finish(
    BuildContext context, {
    required LoginScreenNavigationResult result,
  });
}
```

### Finisher の補足

* `Finisher` は `Launcher` とは逆方向の責務を持つ。`Launcher` が「画面を開く」のに対し、`Finisher` は「画面を閉じて結果を返す」。
* 結果の種類に応じて遷移先を分岐できる（例: 認証成功ならホームへ `go`、キャンセルなら `pop`）。
* 全ての画面に必要なわけではなく、画面側から能動的に終了制御を行う必要がある場合にのみ定義する。

### ${画面名}Finisherの実装例

```dart
@internal
class LoginScreenFinisherImpl implements LoginScreenFinisher {
  static final provider = Provider<LoginScreenFinisherImpl>((ref) {
    return const LoginScreenFinisherImpl._();
  });

  const LoginScreenFinisherImpl._();

  @override
  void finish(
    BuildContext context, {
    required LoginScreenNavigationResult result,
  }) {
    switch (result) {
      case LoginScreenNavigationResultAuthenticated():
        // 認証完了したら、強制でhomeへ行く
        context.safeGoNamed(
          HomeScreenTab.kanjiPractice.name,
          onNavigationFailed: (lifecycle) {
            return const LoginScreenNavigationResult.canceled();
          },
        );
      case LoginScreenNavigationResultCanceled():
        // キャンセルされたら、画面スタックによって戻り先を変える
        if (context.canPop()) {
          context.safePop(result);
        } else {
          context.safeGoNamed(
            HomeScreenTab.kanjiPractice.name,
            onNavigationFailed: (lifecycle) {
              return const LoginScreenNavigationResult.canceled();
            },
          );
        }
    }
  }
}
```

## NavigationResult

`push()` メソッドで画面遷移を行う場合、遷移結果を `${画面名}NavigationResult` として受け取る。

### NavigationResultの実装例

```dart
/// ログイン画面の実行結果.
@freezed
sealed class LoginScreenNavigationResult with _$LoginScreenNavigationResult {
  /// 認証された.
  const factory LoginScreenNavigationResult.authenticated({
    required PkAccount account,
  }) = LoginScreenNavigationResultAuthenticated;

  /// キャンセルされた.
  const factory LoginScreenNavigationResult.canceled() =
      LoginScreenNavigationResultCanceled;

  const LoginScreenNavigationResult._();
}
```

### NavigationResult の設計方針

* `freezed sealed class` で実装し、型安全なパターンマッチを可能にする。
* 最低限 `canceled()` ファクトリを持ち、ユーザーが画面を閉じた場合のデフォルト値として使用する。

## Proxy パターン

`${画面名}Proxy` は、ルーティングライブラリのルート定義と `${画面名}Factory` を接続する Widget である。実装層（`screen_navigation_impl`）にのみ存在する。

### 基本的な Proxy

`ConsumerWidget` を継承し、`ref.watch` で Factory を取得して `build()` を呼び出す。

```dart
@internal
class LoginScreenProxy extends ConsumerWidget {
  const LoginScreenProxy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(LoginScreenFactory.provider);
    return Builder(
      builder: (context) {
        return router.build(context);
      },
    );
  }
}
```

### HomeScreenProxy（シェルナビゲーション用）

ホーム画面の Proxy は特殊で、`StatefulShellRoute` の `StatefulNavigationShell` を受け取り、タブ管理情報を `HomeScreenInput` として提供する。

```dart
@internal
class HomeScreenProxy extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreenProxy({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factory = ref.watch(HomeScreenFactory.provider);
    final tabIndex = navigationShell.currentIndex;
    const allTabs = HomeScreenTab.values;
    final selectedTab = allTabs[tabIndex];
    // ... タブの表示制御ロジック ...

    return ProviderScope(
      overrides: [
        HomeScreenInput.provider.overrideWithValue(
          HomeScreenInput(
            bodyBuilder: (context) => navigationShell,
            currentTab: selectedTab,
            tabs: selectableTabs,
            onTabSelected: (context, tab) {
              navigationShell.goBranch(
                tab.index,
                initialLocation: tab == selectedTab,
              );
            },
          ),
        ),
      ],
      child: factory.build(context),
    );
  }
}
```

### Proxyの役割

* **DIの接続点**: `go_router` の `builder` コールバックから `Factory.provider` を経由して画面を構築する。
* **画面パラメータの橋渡し**: `HomeScreenProxy` のように、ルーティング情報を画面固有のデータモデル（`HomeScreenInput`）に変換して提供する。
* **ルーティング名称の管理**: Proxy が `static const name` としてルーティング名称を保持する。

## タブナビゲーション（HomeScreenTab / HomeScreenInput）

ホーム画面はタブ付きシェルナビゲーションで構成される。`go_router` の `StatefulShellRoute.indexedStack` を使用する。

### HomeScreenTab

アプリ内のタブを定義する enum。

```dart
enum HomeScreenTab {
  kanjiPractice(name: "home-kanji-practice", isAiFeature: false),
  schoolGrade(name: "home-school-grade", isAiFeature: false),
  kanjiKanamajiri(name: "home-kanji-kanamajiri", isAiFeature: true),
  ;

  final String name;
  final bool isAiFeature;

  const HomeScreenTab({required this.name, required this.isAiFeature});
}
```

### HomeScreenInput

ホーム画面に対して、タブ管理情報を Provider 経由で提供するデータモデル。`HomeScreenProxy` が `ProviderScope.overrides` で注入する。

```dart
@freezed
abstract class HomeScreenInput with _$HomeScreenInput {
  static final provider = Provider<HomeScreenInput>((ref) {
    throw UnimplementedError("HomeScreenInput is not implemented");
  });

  const factory HomeScreenInput({
    required Widget Function(BuildContext) bodyBuilder,
    required HomeScreenTab currentTab,
    required List<HomeScreenTab> tabs,
    required void Function(BuildContext context, HomeScreenTab selected) onTabSelected,
  }) = _HomeScreenInput;

  const HomeScreenInput._();
}
```

### ルーティング構成（StatefulShellRoute）

```dart
// ホーム画面 (Shell)
StatefulShellRoute.indexedStack(
  parentNavigatorKey: _rootNavigatorKey,
  builder: (context, state, navigationShell) {
    return HomeScreenProxy(navigationShell: navigationShell);
  },
  branches: [
    // 漢字練習タブ
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: KanjiPracticeOutletProxy.name,
          path: "/${KanjiPracticeOutletProxy.name}",
          builder: (context, state) => const KanjiPracticeOutletProxy(),
        ),
      ],
    ),
    // 習う学年タブ
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: SchoolGradeOutletProxy.name,
          path: "/${SchoolGradeOutletProxy.name}",
          builder: (context, state) => const SchoolGradeOutletProxy(),
        ),
      ],
    ),
    // 漢字仮名交じりタブ
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: KanjiKanamajiriOutletProxy.name,
          path: "/${KanjiKanamajiriOutletProxy.name}",
          builder: (context, state) => const KanjiKanamajiriOutletProxy(),
        ),
      ],
    ),
  ],
),
```

## AlertDialogLauncher

アプリ内の一般的なアラートダイアログの表示を行うインターフェースである。

### AlertDialogLauncherのインターフェース定義

```dart
abstract class AlertDialogLauncher {
  static final provider = Provider<AlertDialogLauncher>(
    (ref) =>
        throw UnimplementedError("$AlertDialogLauncher is not implemented"),
  );

  Future<AlertDialogResult> show(
    BuildContext context,
    AlertDialogRequest request,
  );
}
```

### AlertDialogRequest

```dart
@freezed
abstract class AlertDialogRequest with _$AlertDialogRequest {
  const factory AlertDialogRequest({
    String? title,
    required String message,
    required String positiveText,
    String? negativeText,
    String? neutralText,
    @Default(true) bool cancelable,
  }) = _AlertDialogRequest;

  const AlertDialogRequest._();
}
```

### AlertDialogResult

```dart
enum AlertDialogResult {
  positive,
  negative,
  neutral,
  canceled,
}
```

## RoutingRedirectDelegate

ルートアクセス時のリダイレクト処理を担当するデリゲート。`AppRouterFactoryImpl` の `GoRouter.redirect` から呼び出される。

```dart
@internal
class RoutingRedirectDelegate {
  final FirstLoginTutorialUsecase firstLoginTutorialUsecase;

  const RoutingRedirectDelegate({
    required this.firstLoginTutorialUsecase,
  });

  Future<String?> execute(GoRouterState state) async {
    if (state.matchedLocation == "/") {
      // 初回ログインチュートリアルが完了していない場合はログイン画面へリダイレクト
      // 完了している場合はホーム画面へリダイレクト
    }
    return null;
  }
}
```

## 安全な画面遷移（Safe Navigation）

`screen_navigation_impl` パッケージでは、`BuildContext` の拡張メソッドとしてライフサイクル安全な遷移メソッドを提供する。これらは `route_lifecycle_detector` パッケージを使用して、画面のライフサイクル状態をチェックしてから遷移を実行する。

### 提供メソッド

| メソッド | 用途 | 遷移方式 |
| --- | --- | --- |
| `safeGoNamed()` | ルート遷移（スタックリセット） | `GoRouter.goNamed()` のラップ |
| `safePushNamed()` | スタック積み上げ遷移 | `GoRouter.pushNamed()` のラップ |
| `safePop()` | 前の画面に戻る | `GoRouter.pop()` のラップ |

### ライフサイクルチェック

遷移前に `RouteLifecycle` を確認し、遷移可能な状態（`RouteLifecycleActive`）でない場合は `onNavigationFailed` コールバックを呼び出してデフォルト値を返す。

```dart
// safePushNamed() の使用例
await context.safePushNamed(
  LoginScreenLauncherImpl.name,
  onNavigationFailed: (lifecycle) {
    // 遷移できない場合のデフォルト値
    return const LoginScreenNavigationResult.canceled();
  },
);
```

### pushNamed の Workaround

`go_router` には `pushNamed()` 実行後に `go()` を実行した際、`pushNamed()` の Future が永遠に解決されないバグがある。これに対応するため、`pushNamedWorkaround()` メソッドが `BuildContext` が破棄されたタイミングで Future を解決するように実装されている。

## 依存注入

### ScreenNavigationInjection

画面遷移に関する全ての依存注入は `screen_navigation_impl` パッケージの `ScreenNavigationInjection` で一元管理される。`DependencyBuilder` を使用してインターフェースと実装を紐付ける。

```dart
// screen_navigation_impl
class ScreenNavigationInjection {
  static Future<void> inject(DependencyBuilder builder) async {
    // ダイアログ
    builder.inject(
      AlertDialogLauncher.provider,
      AlertDialogLauncherImpl.provider,
    );
    // 画面遷移
    builder.inject(LoginScreenFinisher.provider, LoginScreenFinisherImpl.provider);
    builder.inject(EulaScreenLauncher.provider, EulaScreenLauncherImpl.provider);
    builder.inject(LoginScreenLauncher.provider, LoginScreenLauncherImpl.provider);
    builder.inject(HomeScreenLauncher.provider, HomeScreenLauncherImpl.provider);
    builder.inject(SettingsScreenLauncher.provider, SettingsScreenLauncherImpl.provider);
    // ルーター
    builder.inject(AppRouterFactory.provider, AppRouterFactoryImpl.provider);
  }
}
```

### 注入パターン

* インターフェースの `provider`（`UnimplementedError` を投げる）と実装の `provider` を `DependencyBuilder.inject()` で紐付ける。
* Factory の注入は `screen_injection` パッケージ側で行われる（各画面パッケージが担当）。
* Launcher / Finisher の注入は `ScreenNavigationInjection` が担当する。

## ナレッジベース

### DO: Factory と Launcher を分離する

* Factory は画面 Widget の構築のみを担当する
* Launcher は画面遷移の実行のみを担当する

```dart
abstract interface class HomeScreenFactory {
  Widget build(BuildContext context);
}

abstract class HomeScreenLauncher {
  void launch(BuildContext context, {HomeScreenRequest? request});
}
```

### DO: 画面遷移は Safe Navigation メソッドを使う

* `safeGoNamed()` / `safePushNamed()` / `safePop()` を使用する
* ライフサイクルチェックにより画面破棄後の不正遷移を防ぐ

```dart
await context.safePushNamed(
  LoginScreenLauncherImpl.name,
  onNavigationFailed: (lifecycle) {
    return const .canceled();
  },
);
```

### DO: 画面終了は Finisher で結果に応じた遷移を行う

* 画面側から能動的に終了制御が必要な場合に定義する
* 結果の種類に応じて `go` や `pop` を分岐する

```dart
void finish(
  BuildContext context, {
  required LoginScreenNavigationResult result,
}) {
  switch (result) {
    case LoginScreenNavigationResultAuthenticated():
      context.safeGoNamed(HomeScreenTab.kanjiPractice.name, ...);
    case LoginScreenNavigationResultCanceled():
      if (context.canPop()) {
        context.safePop(result);
      }
  }
}
```

### DO: go_router のルート定義では Proxy 経由で Factory に接続する

* `Proxy` が `Factory.provider` を `ref.watch` で取得する
* ルーティング名称は Proxy の `static const name` で管理する

```dart
GoRoute(
  name: LoginScreenProxy.name,
  path: "/${LoginScreenProxy.name}",
  builder: (context, state) => const LoginScreenProxy(),
),
```

### DO: Launcher / Finisher は ScreenNavigationInjection で一元管理する

* Factory の注入は `screen_injection` パッケージが担当する
* Launcher / Finisher の注入は `ScreenNavigationInjection` が担当する

```dart
builder.inject(LoginScreenLauncher.provider, LoginScreenLauncherImpl.provider);
builder.inject(LoginScreenFinisher.provider, LoginScreenFinisherImpl.provider);
builder.inject(AppRouterFactory.provider, AppRouterFactoryImpl.provider);
```

### DO: push() の結果は NavigationResult（最低限 canceled）で受け取る

* `freezed sealed class` で型安全に表現する
* ユーザーが画面を閉じた場合のデフォルトとして `canceled()` を持つ

```dart
const factory LoginScreenNavigationResult.canceled() =
    LoginScreenNavigationResultCanceled;
```

### DO NOT: Navigator / GoRouter / goNamed / pushNamed / pop を直接呼び出す

* 理由: ルーティングライブラリ詳細が feature に漏れる
* 理由: ライフサイクル安全な遷移が保証されない

```dart
// DO NOT
context.go("/login");
context.goNamed("login");
context.pushNamed("login");
context.pop();
Navigator.push(context, ...);
```

```dart
// DO: Launcher / Finisher または Safe Navigation を経由する
await context.safePushNamed(LoginScreenLauncherImpl.name, ...);
```

### DO NOT: Factory と Launcher の責務を混在させる

* 理由: 画面構築と遷移ロジックが結合し、テストと再利用が困難になる
* 理由: ルーティングライブラリ詳細が feature 層に漏れる

```dart
// DO NOT: Factory 内で画面遷移を行う
class HomeScreenFactoryImpl {
  Widget build(BuildContext context) {
    context.go("/settings");
  }
}
```

### DO NOT: go_router のルート定義内で Factory を直接呼び出す

* 理由: DI 接続点が分散し、ルーティング名称の管理が不統一になる
* 理由: 画面パラメータの橋渡し（`HomeScreenInput` 等）が Proxy で行えなくなる

```dart
// DO NOT
builder: (context, state) => ref.watch(LoginScreenFactory.provider).build(context),

// DO: Proxy を経由する
builder: (context, state) => const LoginScreenProxy(),
```

### DO NOT: ルーティングパスをハードコードする

* 理由: パス変更時の修正漏れが起きやすい
* 理由: Proxy の `name` や `HomeScreenTab.name` との一貫性が崩れる

```dart
// DO NOT
context.safeGoNamed("home-kanji-practice");
```

```dart
// DO
context.safeGoNamed(HomeScreenTab.kanjiPractice.name);
```
