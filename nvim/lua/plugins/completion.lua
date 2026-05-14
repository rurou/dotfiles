-- 補完: blink.cmp（VSCode 風の挙動に調整）
--
-- 期待する挙動:
--   補完非表示時:
--     Ctrl+Space → 補完を表示(先頭は未選択)
--     Enter      → 改行
--   補完表示時(未選択):
--     Tab        → 先頭候補を選択
--     Enter      → 改行(候補は無視)
--     Esc/Ctrl+e → 補完を閉じる
--   補完表示時(選択あり):
--     Tab        → 次の候補へ
--     Shift+Tab  → 前の候補へ
--     Enter      → 候補を確定
--
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",

        -- 補完表示の手動トリガ
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

        -- Tab: 候補がある時のみ select_next、ない時は通常の Tab
        ["<Tab>"]   = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

        -- Enter: 「選択中の候補があれば確定、なければ改行」
        -- accept は選択中の候補がない場合に何もしないので、fallback に進む
        ["<CR>"] = { "accept", "fallback" },

        -- 補完を閉じる
        ["<C-e>"] = { "hide", "fallback" },
        ["<Esc>"] = { "hide", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        list = {
          selection = {
            -- 起動時に先頭候補を自動選択しない (VSCode 挙動の核)
            preselect = false,
            -- Tab/矢印を押すまで何も挿入されない
            auto_insert = false,
          },
        },
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
        implementation = "prefer_rust_with_warning",
      },
    },
  },
}
