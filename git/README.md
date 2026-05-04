# Git 設定

このフォルダは Windows 環境向けの個人 Git 設定です。`install.bat` を実行すると、`git/.gitconfig` をユーザー HOME の `.gitconfig` としてシンボリックリンクします。

## インストール

権限のある Command Prompt で、このフォルダの `install.bat` を実行します。

```bat
install.bat
```

既に `%HOMEDRIVE%%HOMEPATH%\.gitconfig` が存在する場合、`mklink` は失敗します。必要なら既存ファイルを退避してから実行してください。

## 主な設定

- `user.name` / `user.email`: 個人 identity。
- `core.autocrlf = false`: Git による改行コード自動変換を無効化。
- `core.quotepath = false`: 日本語などの非 ASCII パスをエスケープせず表示。
- `core.ignorecase = false`: ファイル名の大文字小文字を区別する前提で扱う。
- `core.editor`: Neovide を Git editor として使用。
- `core.pager = LESSCHARSET=utf-8 less -S`: UTF-8 前提で `less` を使い、長い行を折り返さない。
- `filter.lfs`: Git LFS の clean/smudge/process filter。
- `alias.st`: `git status` の短縮形。
- `alias.lg`: graph 付き log 表示。
- `alias.alias`: 登録済み alias の一覧表示。

## 前提ツール

- Git for Windows。
- Git LFS。`filter.lfs.required = true` のため、未導入環境では LFS を使うリポジトリで失敗する可能性があります。
- `less`、`sed`、`sort`。通常は Git for Windows に含まれる Unix tools を PATH から利用します。
- Neovide。`core.editor` が `C:/Program Files/Neovide/neovide.exe` を指しています。

## 注意

- この設定には個人 identity と個人ツールパスが含まれます。共有用や別ユーザー用に流用する場合は先に見直してください。
- Windows の通常のファイルシステムは大文字小文字を区別しないため、`core.ignorecase = false` は case-only rename や大小違いの同名ファイルで注意が必要です。
