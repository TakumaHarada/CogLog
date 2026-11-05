# CogLog

CogLog is a Flutter application that records exercise history from stationary bikes and supports weight loss.

## Setup

Dart workspace のルートで依存を解決し、Flutter Monolith の生成物を作る。

```bash
flutter pub get
dart run monolith_runner:define
dart run monolith_runner:localization
```

`define` は `secrets/dart-define/` にフレーバー JSON を出す。このディレクトリは git 管理外なので、テストの前にもう一度 `define` を実行する。秘密情報は `op inject` で `secrets/monolith.yaml` に注入してから `dart run monolith_runner:install` する。

UI は Forui。設定の初期化とテーマの再生成は `app/` で行う。

```bash
cd app
dart run forui init
dart run forui theme create
```

`dart run forui theme create` は `app/lib/theme/` を上書きする。調整済みのテーマがあるときは実行しない。

開発ビルド:

```bash
cd app
flutter run --dart-define-from-file=../secrets/dart-define/development.json
```

iOS の XcodeGen (`dart run monolith_runner:xcodegen`) は、Bundle Identifier、Provisioning Profile、Team ID が揃ってから行う。

Firebase のクライアント設定は次に置く。制約は `docs/constraints.md` を参照する。

- Android: `app/android/app/google-services.json`
- iOS: `app/ios/Runner/GoogleService-Info.plist`
