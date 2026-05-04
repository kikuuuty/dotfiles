# Vim 設定

このフォルダは Windows 環境向けの Vim / GVim 設定です。`install.bat` を実行すると、ユーザー HOME に `.vimrc`、`.gvimrc`、`.vim` のシンボリックリンクを作ります。

## インストール

権限のある Command Prompt で、このフォルダの `install.bat` を実行します。

```bat
install.bat
```

既に `%HOMEDRIVE%%HOMEPATH%\.vimrc`、`.gvimrc`、`.vim` が存在する場合、`mklink` は失敗します。必要なら既存ファイルを退避してから実行してください。

## エントリポイント

- `vim/.vimrc`: Vim のメイン設定。
- `vim/.gvimrc`: GVim 専用設定。
- `vim/.vimrc_local`: フォント、colorscheme、ウィンドウサイズなど環境依存設定の置き場所。
- `vim/.vim`: filetype 検出、syntax、colorscheme、plugin を置く runtime ディレクトリ。

## 主な設定

- 文字コードは UTF-8、判定候補は `utf-8`、`cp932`、`euc-jp`。
- 改行コードは DOS を既定にし、`dos`、`unix`、`mac` を自動判定。
- tab は space 展開、基本インデント幅は 4。
- C/C++ のみ `cindent` と `cinoptions=:0,g0` を有効化。
- `$HOME/.vimrc_local` が存在する場合は `.vimrc` の最後で source する。

## Filetype / Syntax

- `ftdetect` は `glsl`、`hlsl`、`ispc`、`lua` のみ残しています。
- Lua ファイルは buffer-local に `tabstop=2`、`softtabstop=2`、`shiftwidth=2` を設定します。
- shader 系 syntax として `cg`、`glsl`、`hlsl`、`ispc`、`shaderlab` が残っていますが、`cg` と `shaderlab` の自動 filetype 検出は削除済みです。
- C/C++ の追加 syntax は `vim/.vim/after/syntax/c.vim` と `cpp.vim` にあります。

## 注意

- `install.bat` は `.vimrc_local` をリンクしません。環境依存設定として使う場合は、必要に応じて HOME 側に用意してください。
- `*.fs` と `*.vs` は現在 `glsl` として検出されます。F# など別用途で使う場合は `vim/.vim/ftdetect/glsl.vim` を見直してください。
- `set bomb` により UTF-8 BOM 付き保存を好む設定です。BOM 非対応ツール向けファイルを作る時は注意してください。

## 確認

設定の読み込み確認は repo root から次のように実行できます。

```bat
vim -Nu vim/.vimrc -n -es -c "qa!"
```
