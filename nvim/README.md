# Neovim 設定 (Windows)

このフォルダは Windows 環境向けの Neovim 設定です。`nvim/install.bat` を実行すると、`nvim/nvim` を `%LOCALAPPDATA%\nvim` にシンボリックリンクします。

## 前提ツール

| 用途 | winget コマンド |
| ---- | --------------- |
| Neovim 本体 | `winget install -e --id Neovim.Neovim` |
| Git | `winget install -e --id Git.Git` |
| LLVM / Clang / clangd | `winget install -e --id LLVM.LLVM` |
| CMake | `winget install -e --id Kitware.CMake` |
| ripgrep | `winget install -e --id BurntSushi.ripgrep` |
| fd | `winget install -e --id sharkdp.fd` |
| Ninja (任意) | `winget install -e --id Ninja-build.Ninja` |
| Neovide (任意) | `winget install -e --id Neovide.Neovide` |

Treesitter parser 更新には `tree-sitter-cli` も必要です。C/C++ LSP と native plugin build のため、`clangd`、C/C++ compiler、`cmake` が PATH から使える状態にしてください。Neovide や lualine のアイコン表示には Nerd Font があると見やすくなります。

## インストール

権限のある Command Prompt で `nvim/install.bat` を実行します。

```bat
nvim\install.bat
```

初回起動時に `nvim/nvim/lua/config/lazy.lua` が lazy.nvim を取得し、`nvim/nvim/lua/plugins/*.lua` の plugin spec を読み込みます。

## 構成

- `nvim/nvim/init.lua`: エントリポイント。`config.options`、`config.lazy`、`config.keymaps` を読み込み、Neovide の時だけ `config.neovide_config` を読み込みます。
- `nvim/nvim/lua/config/options.lua`: Windows/Japanese 前提の基本オプション。UTF-8、DOS 改行、BOM、`autochdir` などを設定します。
- `nvim/nvim/lua/config/lazy.lua`: lazy.nvim の bootstrap と plugin 読み込み設定。
- `nvim/nvim/lua/config/keymaps.lua`: window 移動、検索移動、LuaSnip、Diagnostic、LSP、Telescope、Visual sort の keymap。
- `nvim/nvim/lua/config/neovide_config.lua`: Neovide 専用の表示・入力設定。
- `nvim/nvim/lua/plugins/*.lua`: lazy.nvim で読み込む plugin 設定。
- `nvim/nvim/after/ftplugin/lua.lua`: Lua ファイルだけ indent 幅を 2 にします。
- `nvim/nvim/after/ftplugin/cpp.lua`: C++ で標準 `cindent` と `cinoptions` を設定し、`[[nodiscard]]` などの属性指定子の直後だけインデントを補正します。

## UI

- colorscheme は `catppuccin-macchiato` です。colorscheme 側の italic は無効化しています。
- statusline は `lualine.nvim` です。filename、Git branch、diff、diagnostics、LSP status、encoding、fileformat、location、progress を表示します。
- Neovide の時だけ `neovide_config.lua` を読み込みます。既定フォントは `FiraMono Nerd Font Mono:h12` です。

## 補完

- 補完は `blink.cmp` と LuaSnip を使います。
- `blink.cmp` は入力中に補完メニューを自動表示します。`<C-Space>` でも手動表示できます。
- 候補移動は `<Tab>` / `<C-n>` / `<Down>` と `<S-Tab>` / `<C-p>` / `<Up>`、候補確定は `<CR>` です。
- `preselect = false`、`auto_insert = true` です。最初の候補は事前選択せず、候補選択中は選択候補を本文へ反映します。
- ghost text は無効です。
- documentation は候補選択中に 200ms 後に自動表示します。
- 補完 source は `lsp`、`buffer`、`snippets`、`path` です。fuzzy sort は完全一致を優先します。

## LSP

- Mason は `clangd` と `lua_ls` を管理します。
- `mason-lspconfig.nvim` は `automatic_enable = false`。LSP は `nvim-lspconfig.lua` で `vim.lsp.enable({ "clangd", "lua_ls" })` により手動有効化しています。
- `clangd` は `--background-index`、`--clang-tidy`、`--header-insertion=iwyu`、`--completion-style=detailed`、`--function-arg-placeholders`、`--fallback-style=llvm`、`--query-driver=**/cl.exe;**/clang*.exe;**/clang++.exe` を指定しています。
- `clangd` の root marker は `.clangd` と `compile_commands.json`、対象 filetype は `c` / `cpp` です。
- `lua_ls` は `vim` global を diagnostic の既知 symbol として扱います。
- LSP rename の入力欄は既存名を初期値にせず、空欄から入力します。

## Treesitter

- 対象 parser は `c`、`cpp`、`lua`、`python`、`json` です。
- `auto_install = false` のため、parser 更新は必要に応じて `:TSUpdate` を実行します。
- highlight は Treesitter を使います。
- indent は Treesitter を有効にしていますが、`c` / `cpp` は無効化して標準の `cindent` を使います。C++ では `after/ftplugin/cpp.lua` で `cinoptions = 'g0,N-s,:0'` を指定し、属性指定子の直後だけ追加補正しています。

## Telescope

- `<C-p>` は Git 管理ファイル検索です。
- `<leader>f` は Git repository root 全体を live grep します。`autochdir` 有効時に、開いているファイルの子ディレクトリだけを検索しないためです。
- `<leader>g` はカーソル下の単語を repository root 全体で grep します。
- `<leader>gy` は yank したテキストを grep します。
- `<leader>g*` はクリップボードのテキストを grep します。
- `<leader>/` は現在 buffer 内を fuzzy 検索します。
- `<leader>b`、`<leader>o`、`<leader>q`、`<leader>h`、`<leader>k` は buffer、recent file、diagnostic、help、keymap の一覧です。
- `<leader>gd`、`<leader>gr`、`<leader>gt`、`<leader>gi`、`<leader>gI`、`<leader>go` は Telescope 経由の LSP 一覧です。
- `path_display` は `filename.ext (path/to/parent/)` 形式で表示し、括弧内を薄く表示します。
- `telescope-fzf-native.nvim` は smart case の fuzzy sorter として使います。
- `telescope-fzf-native.nvim` は Windows 用の独自 build 関数を持ち、CMake configure/build 後に `libfzf.dll` を期待位置へ移します。

## よく使う Keymap

- `<C-p>`: Telescope で Git 管理ファイルを検索。
- `<leader>f`: repository 全体を live grep。
- `<leader>g`: カーソル下の単語を repository 全体で grep。
- `<leader>gy`: yank したテキストを grep。
- `<leader>g*`: クリップボードのテキストを grep。
- `<leader>/`: 現在 buffer 内を fuzzy 検索。
- `<leader>b`: buffer 一覧。
- `<leader>o`: 最近開いたファイル。
- `<leader>q`: Telescope で diagnostic 一覧。
- `<leader>h`: help 検索。
- `<leader>k`: keymap 一覧。
- Visual mode の `<leader>s`: 選択範囲をアルファベット順にソート。`#include` 行の整理に使います。
- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>`: window 移動。
- `n` / `N`: 検索結果へ移動して画面中央に表示。
- `gd` / `gD` / `gr` / `gt` / `gi`: LSP の定義、宣言、参照、型定義、実装へ移動。
- `<leader>gd` / `<leader>gr` / `<leader>gt` / `<leader>gi` / `<leader>gI` / `<leader>go`: Telescope 経由の LSP jump / 一覧。
- `[d` / `]d`: 前後の diagnostic へ移動。
- `<leader>e`: 現在位置の diagnostic を表示。
- `<leader>rn`: LSP rename。
- Insert mode の `<C-K>`: LuaSnip snippet を展開。
- Insert / Select mode の `<C-l>` / `<C-h>`: LuaSnip の次 / 前の位置へ jump。
- Insert / Select mode の `<C-e>`: LuaSnip の choice を切り替え。

## 確認

設定の読み込み確認は repo root から実行します。

```bat
nvim --headless -u nvim/nvim/init.lua "+qa"
```

実行時依存の確認には `:Lazy`、`:Mason`、`:TSUpdate` を使います。
