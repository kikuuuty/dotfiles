
return {
  "saghen/blink.cmp",
  version = "1.*", -- prebuilt バイナリ利用推奨
  dependencies = { "L3MON4D3/LuaSnip" },
  opts = {
    keymap = {
      preset = "none",
      ["<C-Space>"] = { "show" },
      ["<Tab>"]     = { "accept", "fallback" },
      ["<S-Tab>"]   = { "fallback" },
      ["<C-n>"]     = { "select_next", "show" },
      ["<C-p>"]     = { "select_prev", "show" },
      ["<Up>"]      = { "select_prev", "fallback" },
      ["<Down>"]    = { "select_next", "fallback" },
      ["<CR>"]      = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      menu = { auto_show = true },
      list = { selection = { preselect = false, auto_insert = false } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      ghost_text = {
        enabled = true,
        show_with_menu = true,
        show_without_menu = false,
      },
    },
    sources = {
      default = { "lsp", "buffer", "snippets", "path" },
    },
    fuzzy = {
      -- 常に完全一致を優先する
      sorts = { "exact", "score", "sort_text", },
      implementation = "prefer_rust_with_warning",
    },
    snippets = { preset = "luasnip" },
  },
}
