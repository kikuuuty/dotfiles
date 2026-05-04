# AGENTS.md

## リポジトリ概要
- これは Windows 向けの個人 dotfiles リポジトリで、アプリではない。package manifest、テスト、lint/typecheck、CI はない。
- インストーラは `mklink` でシンボリックリンクを作る batch ファイル。コピーに置き換えず、権限のある Command Prompt から実行する。
- `nvim/install.bat` は `nvim/nvim` を `%LOCALAPPDATA%\nvim` にリンクする。`vim/install.bat` は `.vimrc`、`.gvimrc`、`.vim`、`git/install.bat` は `.gitconfig` をリンクする。
- 各サブディレクトリの README (`nvim/README.md`、`vim/README.md`、`git/README.md`) に現在の運用メモがある。設定変更時は必要なら README も更新する。

## Neovim 設定
- エントリポイントは `nvim/nvim/init.lua`。`config.options`、`config.lazy`、`config.keymaps` を読み込み、`vim.g.neovide` がある場合だけ `config.neovide_config` を読む。
- プラグイン定義は `nvim/nvim/lua/plugins/*.lua`。`nvim/nvim/lua/config/lazy.lua` から lazy.nvim 経由で読み込まれる。
- `lazy-lock.json` は `.gitignore` で無視されており、現状は追跡対象ではない。プラグイン lockfile を追加する場合は明示的な意図を確認する。
- README と設定上の Windows 前提ツールは Git、Neovim、LLVM/Clang/clangd、CMake、ripgrep、fd、任意で Ninja。Treesitter parser 更新には `tree-sitter-cli` も必要。
- Mason は `clangd` と `lua_ls` を管理するが、`automatic_enable = false`。LSP は `nvim-lspconfig.lua` で手動有効化している。
- Treesitter は `c`、`cpp`、`lua`、`python`、`json` だけを対象にし、`auto_install = false`。C/C++ の indent は Treesitter ではなく標準 `cindent` を使うため、`disable = { "c", "cpp" }` を安易に外さない。
- Telescope grep 系 keymap は `autochdir` 対策で Git repository root を `cwd` に指定している。`path_display` は `filename.ext (path/to/parent/)` 形式で括弧内を薄く表示する。
- `telescope-fzf-native.nvim` には Windows 用の独自 build 関数がある。古い `cmake_minimum_required` を補正し、`libfzf.dll` を期待位置へ移すため、安易に単純化しない。
- 補完は `blink.cmp` と LuaSnip。`config/keymaps.lua` は lazy setup 後に `luasnip` と `telescope.builtin` を require するため、起動時に使えなくする変更は keymaps も合わせて直す。

## 検証
- リポジトリ全体の自動テストはない。Neovim Lua を変更したら、repo root から `nvim --headless -u nvim/nvim/init.lua "+qa"` で smoke load する。新規環境では plugin bootstrap や native build が走ることがある。
- Vim 設定を変更したら、repo root から `vim -Nu vim/.vimrc -n -es -c "qa!"` で読み込み確認できる。
- 実行時依存の確認には、この設定が前提にしている Neovim コマンド `:Lazy`、`:Mason`、`:TSUpdate` を使う。

## 編集メモ
- Windows/Japanese 前提を保つ。設定は DOS 改行、UTF-8 BOM、日本語コメント、Windows パスを好む。
- 旧 Vim のエントリポイントは `vim/.vimrc`。`vim/install.bat` は `.vimrc_local` をリンクしないが、HOME 側に存在する場合は `.vimrc` の最後で source する。GUI 専用設定は `vim/.gvimrc` にある。
- Vim の `ftdetect` は `glsl`、`hlsl`、`ispc`、`lua` だけ。`BUILD`、`WORKSPACE`、`bzl`、`cg`、`shaderlab` の自動検出は削除済み。
- `git/.gitconfig` には個人 identity、editor、pager、LFS filter、alias が入っている。明示依頼なしに identity や個人ツールパスを変更しない。
