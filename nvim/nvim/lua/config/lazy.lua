
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import plugins
    { import = "plugins" },
  },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },
  -- automatically check for config file changes and reload the ui
  change_detection = {
    enabled = true,
    notify = false,
  },
})


local function lazy_log()
  -- ログファイルの場所（Windows なら %LOCALAPPDATA%/nvim-data/lazy-load.log になる）
  local log_file = vim.fn.stdpath("state") .. "/lazy-load.log"

  -- セッションヘッダを書いておく
  pcall(vim.fn.writefile, {
    ("=== Lazy load session %s ==="):format(os.date("%Y-%m-%d %H:%M:%S")),
  }, log_file, "a")

  -- lazy.nvim がプラグインをロードしたときに飛ぶ User イベントをフック
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",  -- docs に載っている公式イベント名
    callback = function(ev)
      -- ev.data にプラグイン名が入る（公式 docs に明記）:contentReference[oaicite:1]{index=1}
      local name = ev.data or "<?>"
      local line = ("%s  Loaded: %s"):format(os.date("%H:%M:%S"), name)
      pcall(vim.fn.writefile, { line }, log_file, "a")
    end,
  })
end

--lazy_log()
