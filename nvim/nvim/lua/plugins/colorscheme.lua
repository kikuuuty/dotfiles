
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        no_italic = true, -- colorscheme 側の italic をすべて消す
        integrations = {
          telescope = {
            enabled = true,
          },
        },
      })

      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
}
