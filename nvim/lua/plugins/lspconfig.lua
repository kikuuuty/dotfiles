return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", },
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
    },
    config = function()
        local servers = {
            "clangd",
            "lua_ls",
        }

        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_enabled = false,
        })

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
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                },
            },
        })

        vim.lsp.enable(servers)
    end,
}

