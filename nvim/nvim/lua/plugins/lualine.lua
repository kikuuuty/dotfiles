
-- gitのブランチ名を取得する
local function update_git_branch()
  local file_dir = vim.fn.expand("%:p:h")
  if file_dir == "" then
    vim.b.git_branch_cached = "untracked"
    return
  end

  local out = vim.fn.systemlist({ "git", "-C", file_dir, "branch", "--show-current" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
    -- Git 管理外の場合はプレースホルダー
    vim.b.git_branch_cached = "untracked"
    return
  end

  local branch = out[1]
  if branch == "HEAD" then
    local sha = vim.fn.systemlist({ "git", "-C", file_dir, "rev-parse", "--short", "HEAD" })[1] or ""
    branch = sha ~= "" and ("detached@" .. sha) or "untracked"
  end
  vim.b.git_branch_cached = branch
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
      callback = update_git_branch,
    })
    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = { left = "|", right = ""},
        section_separators = { left = "", right = ""},
      },
      sections = {
        lualine_a = { "filename", },
        lualine_b = {
          { function() return vim.b.git_branch_cached or "" end, icon = "", separator = "", },
          { "diff", separator = "", },
        },
        lualine_c = { "diagnostics", },
        lualine_x = {
          { "lsp_status", separator = "|", padding = { left = 1, right = 1 }, },
          { "encoding",   separator = "|", padding = { left = 1, right = 1 }, },
          { "fileformat", separator = "|", padding = { left = 1, right = 1 }, },
        },
        lualine_y = {
          { "location", separator = "", },
        },
        lualine_z = {
          { "progress", separator = "", },
        },
      },
    })
  end,
}
