return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                layout_strategy = "vertical",
                layout_config = {
                    vertical = {
                        height = 0.90,
                        preview_cutoff = 40,
                        prompt_position = "bottom",
                        width = 0.85,
                    }
                },
                border = true,
                borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },

                path_display = function(_, path)
                    -- パス表示は filename.ext (path/to/parent/) 形式
                    local tail = require("telescope.utils").path_tail(path)
                    local macchiato_text = string.format("%s (%s)", tail, path)
                    local tail_len = #tail
                    local path_start = tail_len + 1
                    -- 親ディレクトリパスは少しグレーアウトさせる
                    return macchiato_text, {
                        { { path_start, #macchiato_text }, "Comment" },
                    }
                end,

                sorting_strategy = "ascending",
                --find_command = {
                --    "fd",
                --    "--type", "f",
                --    --"--hidden", -- 隠しファイル/ディレクトリも含める
                --    "--follow", -- シンボリックリンクを辿る
                --    "--strip-cwd-prefix",
                --    "--exclude", ".git",
                --},
                file_ignore_patterns = {
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        },
        config = function(_, opts)
            -- git リポジトリのルートディレクトリを取得する
            local function get_root()
                local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
                if vim.v.shell_error == 0 then
                    return git_root
                end
                return vim.loop.cwd()
            end

            local function setup_keymaps()
                local tb = require('telescope.builtin')
                local keymap = vim.keymap.set

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
            end

            local function setup_highlights()
                -- とりあえず catppuccin のカラーコードでハードコーディング
                -- todo: colorscheme に合わせて適当に切り替わるようにしたい
                local text = "#cdd6f4"
                local blue = "#98b4fa"
                local mantle = "#1e1e2e"
                local crust = "#181825"
                vim.api.nvim_set_hl(0, "TelescopeNormal",       { bg = crust, fg = text })
                vim.api.nvim_set_hl(0, "TelescopeBorder",       { bg = crust, fg = crust })
                vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = crust })
                vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = crust, fg = crust })
                vim.api.nvim_set_hl(0, "TelescopePromptTitle",  { bg = crust, fg = blue })
                vim.api.nvim_set_hl(0, "TelescopeResultsNormal",{ bg = mantle })
                vim.api.nvim_set_hl(0, "TelescopeResultsBorder",{ bg = mantle, fg = mantle })
                vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = mantle, fg = blue })
                vim.api.nvim_set_hl(0, "TelescopePreviewNormal",{ bg = crust })
                vim.api.nvim_set_hl(0, "TelescopePreviewBorder",{ bg = crust, fg = crust })
                vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = crust, fg = blue })
            end

            require('telescope').setup(opts)
            setup_keymaps()
            setup_highlights()
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = function()
            local plugin_dir = vim.fn.stdpath("data") .. "/lazy/telescope-fzf-native.nvim"
            local cmakelists = plugin_dir .. "/CMakeLists.txt"
            local build_dir  = plugin_dir .. "/build"
            local dll_path   = build_dir .. "/libfzf.dll"

            -- CMake 4.x系が3.5未満の互換性を切ったためfzf-nativeのCMakeLists.txtのバージョン指定をパッチする
            if vim.fn.filereadable(cmakelists) == 1 then
                -- 念のため cmake_minimum_required 行を検索する
                local lines = vim.fn.readfile(cmakelists)
                for i, line in ipairs(lines) do
                    local v = line:match("^%s*cmake_minimum_required%s*%(%s*VERSION%s*([%d%.]+)")
                    if v then
                        local function ver_lt(a,b)
                            local function split(s) local t={} for n in s:gmatch("%d+") do t[#t+1]=tonumber(n) end return t end
                            local A,B=split(a),split(b)
                            for k=1,math.max(#A,#B) do local x,y=A[k] or 0,B[k] or 0 if x~=y then return x<y end end
                            return false
                        end
                        -- 3.5未満の場合のみ書き換え
                        if ver_lt(v, "3.5") then
                            lines[i] = "cmake_minimum_required(VERSION 3.16)"
                            vim.fn.writefile(lines, cmakelists)
                        end
                        break
                    end
                end
            end

            -- 古いキャッシュを削除
            vim.fn.delete(build_dir, "rf")

            -- CMakeの生成とビルド
            local out_cfg = vim.fn.system({
                "cmake",
                "-S", plugin_dir,
                "-B", build_dir,
                "-DCMAKE_BUILD_TYPE=Release",
            })
            if vim.v.shell_error ~= 0 then
                error("CMake configure failed: \n" .. out_cfg)
            end
            local out_build = vim.fn.system({
                "cmake",
                "--build", build_dir,
                "--config", "Release" -- Visual Studio のマルチコンフィグ用
            })
            if vim.v.shell_error ~= 0 then
                error("CMake build failed: \n" .. out_build)
            end

            -- build/Release/libfzf.dll に出力されるため、想定されるディレクトリにコピーする
            if vim.fn.filereadable(dll_path) == 0 then
                local candidates = vim.fn.glob(build_dir .. "/**/*fzf*.dll", false, true)
                for _, src in ipairs(candidates) do
                    -- 期待名にリネームして配置
                    vim.fn.mkdir(build_dir, "p")
                    vim.fn.delete(dll_path) -- 既存を消しておく
                    vim.fn.rename(src, dll_path)
                    break
                end
            end
            if vim.fn.filereadable(dll_path) == 0 then
                error("libfzf.dll not found at: " .. dll_path .. "\nBuild output:\n" .. out_build)
            end
        end,
        config = function()
            -- 初回ビルドが失敗しても Neovim 起動を止めないように
            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
                vim.notify("telescope-fzf-native: load_extension failed:\n"..tostring(err), vim.log.levels.WARN)
            end
        end,
    },
}
