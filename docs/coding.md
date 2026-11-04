# コーディング規約

`*.dart` を追加・修正するときに従う。レイヤーの選択は `docs/architecture.md`、ファイルの置き場所は `docs/directory-layout.md` を見る。

## ファイル

- ファイル名は `snake_case.dart`。クラスファイルはクラス名を `snake_case` にしたものにする。
- public なクラスは 1 ファイルに 1 つ。
- 各パッケージは `lib/<パッケージ名>.dart` を持ち、公開 API だけを `export` する。
- ソースは `lib/src/` に置く。

## コメント

アクセスできるクラス、プロパティ、関数、コンストラクタには日本語のドキュメントコメントを付ける。private と `@internal` も対象にする。

- 宣言名を主語にして繰り返さない。役割、制約、副作用を書く。
- 関数とメソッドには、利用例の Example を入れる。
- ドキュメント内の `[symbol]` は、そのファイルから解決できるシンボルにする。
- 名前から読める説明は書かない。

## 可視性

- パッケージ外へ出さない型とメンバーは、private か `@internal` にする。`@internal` は `package:meta/meta.dart` から取る。
- テストのためだけに公開するものは `@visibleForTesting` にする。
- 継承先だけが使うメンバーは `@protected` にする。
- `lib/src/strings.dart` の `strings` は `@internal` とし、library ファイルから `export` しない。

## 検証

変更後に `dart format` と `dart analyze` を通す。生成ファイルの手修正で警告を消さない。
