-- 補完: blink.cmp（nvim-cmp の後継、パフォーマンス重視）
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        -- Tab で補完選択・展開
        ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"]    = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]   = { "hide" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
      },
      fuzzy = {
        -- Rust製のfuzzy matcherを優先（なければLua実装にフォールバック）
        implementation = "prefer_rust_with_warning",
      },
    },
  },
}
