return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function(_, _)
    require("nvim-treesitter.configs").setup({
      -- パーサー名のリスト、または"all"
      ensure_installed = { "c", "cpp", "lua", "python", "json", },

      -- パーサーを同期的にインストールする (ensure_installedにのみ適用)
      sync_install = false,

      -- バッファを開いたときにパーサーを自動的にインストールするか
      -- tree-sitter-cliが必須 
      auto_install = false,

      highlight = {
        enable = true,                            	-- ハイライトを有効に
        additional_vim_regex_highlighting = false,	-- Vimの正規表現ベースのハイライト機能も有効にするか
      },

      indent = {
        enable = true,  -- インデントを有効に
      },
    })
  end,
}
