return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", },
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
    },
    config = function()
        local diagnostic = vim.diagnostic
        local keymap = vim.keymap.set
        local lsp_buf = vim.lsp.buf

        -- Diagnostic keymaps
        --keymap("n", "<leader>e", diagnostic.open_float, { desc = "Show diagnostic" })
        --keymap("n", "<leader>q", diagnostic.setqflist, { desc = "Diagnostics to quickfix" })
        keymap("n", "[d", diagnostic.goto_prev, { desc = "Prev diagnostic" })
        keymap("n", "]d", diagnostic.goto_next, { desc = "Next diagnostic" })

        -- LSP jump keymaps
        --keymap("n", "gd", lsp_buf.definition, { desc = "Go to definition" })
        --keymap("n", "gD", lsp_buf.declaration, { desc = "Go to declaration" })
        --keymap("n", "gr", lsp_buf.references, { desc = "Go to references" })
        --keymap("n", "gt", lsp_buf.type_definition, { desc = "Go to type definition" })
        --keymap("n", "gi", lsp_buf.implementation, { desc = "Go to implementation" })

        keymap("n", "<leader>rn", lsp_buf.rename, { desc = "Rename" })

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

