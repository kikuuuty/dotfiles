return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "clangd", "lua_ls", },
        automatic_enable = false, -- 手動で有効化する
      },
    },
  },
  config = function()
    -- LSP rename のデフォルト値を消す
    local orig = vim.ui.input
    vim.ui.input = function(opts, on_confirm)
      if opts and opts.prompt == "New Name: " then
        opts.default = ""
      end
      orig(opts, on_confirm)
    end

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--query-driver=**/cl.exe;**/clang*.exe;**/clang++.exe",
      },
      root_markers = { ".clangd", "compile_commands.json" },
      filetypes = { "c", "cpp" }
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" }, },
        },
      },
    })

    vim.lsp.enable({ "clangd", "lua_ls" })
  end,
}

