# Neovim 設定 (Windows)

このフォルダには Windows 環境向けの Neovim 設定が入っています。`install.bat` を実行すると `%LOCALAPPDATA%\nvim` にシンボリックリンクを張り、この設定で Neovim を起動できます。

この README は Codex (GPT-5.1-Codex-Max) によって作成されています。

## 事前にインストールしておくソフトウェア (winget)

> すべて「コマンド プロンプト」を管理者として起動し、以下のコマンドを順番に実行してください。

| 用途 | winget コマンド |
| ---- | --------------- |
| Neovim 本体 | `winget install -e --id Neovim.Neovim` |
| Git (lazy.nvim のブートストラップで使用) | `winget install -e --id Git.Git` |
| Clang/clangd (C++ LSP と C/C++ ビルドに使用) | `winget install -e --id LLVM.LLVM` |
| CMake (telescope-fzf-native のビルドに使用) | `winget install -e --id Kitware.CMake` |
| ripgrep (Telescope の live grep に使用) | `winget install -e --id BurntSushi.ripgrep` |
| fd (Telescope のファイル検索に使用) | `winget install -e --id sharkdp.fd` |
| Ninja (オプションだがビルドを高速化) | `winget install -e --id Ninja-build.Ninja` |

## インストール手順

1. 依存ソフトを上記 winget コマンドでインストールする。
2. このリポジトリをクローン (または取得) し、`nvim/install.bat` をダブルクリックまたは コマンド プロンプト で実行する。
3. 初回起動時に lazy.nvim が自動で取得され、プラグインがインストールされる。

## プラグインごとのセットアップ

### LSP (clangd / lua_ls)
- `mason.nvim` と `mason-lspconfig.nvim` で `clangd` と `lua_ls` を管理しています【F:nvim/nvim/lua/plugins/lspconfig.lua†L4-L60】。
- C++ 用には `clangd` を使用します。上記の LLVM パッケージで導入済みなら `:Mason` を開いてインストール状態を確認してください。Mason から導入する場合はウィンドウで `clangd` を選択して Enter でインストールできます。
- `clangd` は `--query-driver=**/cl.exe;**/clang*.exe;**/clang++.exe` など LLVM ドライバを自動検出するよう設定済みです【F:nvim/nvim/lua/plugins/lspconfig.lua†L39-L50】。
- Lua 言語サーバは `lua_ls` を使用します。必要に応じて `:Mason` でインストールしてください。

### Treesitter
- `nvim-treesitter` を `:TSUpdate` で自動更新する設定です【F:nvim/nvim/lua/plugins/treesitter.lua†L2-L16】。
- `ensure_installed` に `c`, `cpp`, `lua`, `python`, `json` が登録されています【F:nvim/nvim/lua/plugins/treesitter.lua†L6-L14】。
- パーサーのビルドには C コンパイラと `cmake` が必要です。LLVM/Clang をインストールした上で `:TSUpdate` を実行し、パーサーをビルドしてください。

### Telescope + fzf
- `telescope-fzf-native.nvim` は CMake でビルドします【F:nvim/nvim/lua/plugins/telescope.lua†L106-L174】。CMake と LLVM/Clang (C++ コンパイラ) がセットアップされていればインストール時に自動ビルドされます。
- `live_grep` / `grep_string` には `ripgrep` が必要で、ファイル検索には `fd` を使います (いずれも上記 winget のコマンドで導入)【F:nvim/nvim/lua/plugins/telescope.lua†L58-L73】。
- ビルドが失敗した場合でも Neovim の起動は止まりませんが、`<leader>f` などのファジー検索を高速化するために成功しているか確認してください。

## よく使うコマンド
- `:Mason` … LSP サーバ・ツールのインストール/アップデート UI を開く。
- `:TSUpdate` … Treesitter パーサーを更新する。
- `<C-p>` / `<leader>f` … Telescope で Git ファイル検索 / ライブグレップ。

## C++ 向け補足
- LLVM/Clang を標準の C/C++ ツールチェーンとして利用します。`clangd` による補完と、Treesitter・telescope-fzf-native のビルドに必要です。
- `cmake` と `ninja` が PATH 上にあることを確認してください。
- LSP 補完 (clangd) と Treesitter の両方が C++ ソース解析に利用されます。両者のビルドが通ることを確認するため、初回は `:Mason` と `:TSUpdate` を実行するのがおすすめです。
