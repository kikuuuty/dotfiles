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
keymap({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
keymap({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
keymap({"i", "s"}, "<C-h>", function() ls.jump(-1) end, {silent = true})
keymap({"i", "s"}, "<C-e>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {silent = true})

-- Diagnostic keymaps
local diagnostic = vim.diagnostic
--keymap("n", "<leader>e", diagnostic.open_float, { desc = "Show diagnostic" })
--keymap("n", "<leader>q", diagnostic.setqflist, { desc = "Diagnostics to quickfix" })
keymap("n", "[d", diagnostic.goto_prev, { desc = "Prev diagnostic" })
keymap("n", "]d", diagnostic.goto_next, { desc = "Next diagnostic" })

-- LSP jump keymaps
local lsp_buf = vim.lsp.buf
--keymap("n", "gd", lsp_buf.definition, { desc = "Go to definition" })
--keymap("n", "gD", lsp_buf.declaration, { desc = "Go to declaration" })
keymap("n", "gr", lsp_buf.references, { desc = "Go to references" })
keymap("n", "gt", lsp_buf.type_definition, { desc = "Go to type definition" })
keymap("n", "gi", lsp_buf.implementation, { desc = "Go to implementation" })
keymap("n", "<C-r>n", lsp_buf.rename, { desc = "Rename" })

-- Telescope
local tb = require('telescope.builtin')
keymap("n", "<C-p>", tb.git_files, { desc = "Git files" })
keymap('n', '<leader>f', function() tb.live_grep({ cwd = get_root() }) end, { desc = 'Telescope live grep' })
keymap("n", "<leader>F", function() tb.grep_string({ cwd = get_root() }) end, { desc = "Grep string" })
keymap("n", "<leader>q", tb.diagnostics, { desc = "" })
keymap("n", "<leader>h", tb.help_tags, { desc = "" })
keymap("n", "gd", tb.lsp_definitions, { desc = "LSP Definitions" })
--keymap("n", "gD", tb.lsp_implementations, { desc = "LSP Implementations" })
keymap("n", "<leader>gr", tb.lsp_references, { desc = "LSP References" })
keymap("n", "<leader>gt", tb.lsp_type_definitions, { desc = "LSP Type Definitions" })
keymap("n", "<leader>gi", tb.lsp_incoming_calls, { desc = "LSP Incoming Calls" })
keymap("n", "<leader>go", tb.lsp_outgoing_calls, { desc = "LSP Outgoing Calls" })

