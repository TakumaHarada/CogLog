# Eval fixtures

`files/` は gitignore 対象である（スパース大容量ファイルを含むため）。

## 生成

```bash
bash evals/generate_fixtures.sh
```

生成物:

* `evals/files/fake-home/` — HOME 相当サンドボックス
* `evals/files/docker-system-df.txt` — `templates/docker-system-df.txt` のコピー

コミット対象は `evals.json` / `generate_fixtures.sh` / `templates/` / `.gitignore` のみ。
