# CogLog エージェント指示

作業に一致する文書だけを読む。一致しない文書は読まない。複数行に一致するときだけ、その行の文書をすべて読む。

| 作業 | 読む文書 |
| --- | --- |
| 機能の置き場所、レイヤー、依存方向、DI、Usecase、Repository、画面分割 | `docs/architecture.md` |
| ディレクトリ、パッケージの新設、ファイルの置き場所、生成物のパス | `docs/directory-layout.md` |
| Dart の実装・修正、コメント、可視性、ファイル分割 | `docs/coding.md` |
| 文言の追加・変更、CSV、多言語、文字列テスト | `docs/localization.md` |
| 画面・Widget・テーマ・Forui | `docs/ui.md` |
| 依存バージョン、secrets、フレーバー、生成コマンド、iOS 署名 | `docs/constraints.md` |
| プロダクトの目的、運動履歴、減量、ドメインの言葉 | `docs/product.md` |

文書に書いていないドメインの概念や画面は足さない。追加するときは、先に該当文書へ方針を書いてから実装する。
