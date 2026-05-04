-- leader key を' ' に 
vim.g.mapleader = ' '

local keymap = vim.keymap.set

-- git リポジトリのルートディレクトリを取得する
local function get_root()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 then
    return git_root
  end
  return vim.loop.cwd()
end

-- ウィンドウ移動（Ctrl + hjkl）
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- 検索結果を中央に
keymap('n', 'n', 'nzz')
keymap('n', 'N', 'Nzz')

-- スニペット
local ls = require("luasnip")
keymap({"i"}, "<C-K>", function() ls.expand() end, { silent = true, desc = "LuaSnip: スニペットを展開" })
keymap({"i", "s"}, "<C-l>", function() ls.jump( 1) end, { silent = true, desc = "LuaSnip: 次の位置へジャンプ" })
keymap({"i", "s"}, "<C-h>", function() ls.jump(-1) end, { silent = true, desc = "LuaSnip: 前の位置へジャンプ" })
keymap({"i", "s"}, "<C-e>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = "LuaSnip: 選択肢を切り替え" })

-- Diagnostic keymaps
local diagnostic = vim.diagnostic
keymap("n", "[d", diagnostic.goto_prev, { desc = "Diagnostic: 前の診断へ移動" })
keymap("n", "]d", diagnostic.goto_next, { desc = "Diagnostic: 次の診断へ移動" })
--keymap("n", "<leader>q", diagnostic.setqflist, { desc = "Diagnostic: 診断をQuickFixへ送る" }) -- Telescope側を利用
keymap("n", "<leader>e", diagnostic.open_float, { desc = "Diagnostic: 現在位置の診断を表示" })

-- LSP jump keymaps
local lsp_buf = vim.lsp.buf
keymap("n", "gd", lsp_buf.definition, { desc = "LSP: 定義へ移動" })
keymap("n", "gD", lsp_buf.declaration, { desc = "LSP: 宣言へ移動" })
keymap("n", "gr", lsp_buf.references, { desc = "LSP: 参照へ移動" })
keymap("n", "gt", lsp_buf.type_definition, { desc = "LSP: 型定義へ移動" })
keymap("n", "gi", lsp_buf.implementation, { desc = "LSP: 実装へ移動" })
keymap("n", "<leader>rn", lsp_buf.rename, { desc = "LSP: シンボル名を変更" })

-- Telescope
local tb = require('telescope.builtin')
keymap("n", "<C-p>", tb.git_files, { desc = "Telescope: Git管理ファイルを検索" })
keymap("n", "<leader>b", tb.buffers, { desc = "Telescope: バッファ一覧を表示" })
keymap("n", "<leader>o", tb.oldfiles, { desc = "Telescope: 最近開いたファイルを検索" })
keymap('n', '<leader>f', function() tb.live_grep({ cwd = get_root() }) end, { desc = 'Telescope: リポジトリ内をgrep検索' })
keymap("n", "<leader>g", function() tb.grep_string({ cwd = get_root() }) end, { desc = "Telescope: カーソル下の単語をgrep検索" })
keymap("n", "<leader>/", tb.current_buffer_fuzzy_find, { desc = "Telescope: 現在バッファ内を検索" })
keymap("n", "<leader>gd", tb.lsp_definitions, { desc = "Telescope: 定義へ移動" })
keymap("n", "<leader>gr", tb.lsp_references, { desc = "Telescope: 参照一覧を表示" })
keymap("n", "<leader>gt", tb.lsp_type_definitions, { desc = "Telescope: 型定義へ移動" })
keymap("n", "<leader>gi", tb.lsp_implementations, { desc = "Telescope: 実装へ移動" })
keymap("n", "<leader>gI", tb.lsp_incoming_calls, { desc = "Telescope: 呼び出し元一覧を表示" })
keymap("n", "<leader>go", tb.lsp_outgoing_calls, { desc = "Telescope: 呼び出し先一覧を表示" })
keymap("n", "<leader>q", tb.diagnostics, { desc = "Telescope: 診断一覧を表示" })
keymap("n", "<leader>h", tb.help_tags, { desc = "Telescope: ヘルプを検索" })
keymap("n", "<leader>k", tb.keymaps, { desc = "Telescope: キーマップ一覧を表示" })

