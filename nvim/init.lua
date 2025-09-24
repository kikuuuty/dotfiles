
-- コア設定
--require("config.path")
require("config.options")
require("config.keymaps")
require("config.lazy")

-- Neovide専用
if vim.g.neovide then
    require("config.neovide_config")
end

