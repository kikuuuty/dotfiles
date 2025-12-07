--require("config.path")
require("config.options")
require("config.lazy")
require("config.keymaps")

-- Neovide専用
if vim.g.neovide then
  require("config.neovide_config")
end

