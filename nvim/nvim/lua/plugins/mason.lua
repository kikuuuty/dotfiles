return {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  -- コマンドを実行するまでロードしない
  cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
  opts = {},
}
