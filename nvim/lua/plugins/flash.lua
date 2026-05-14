-- flash.nvim: EasyMotion 相当のジャンプ
-- VSCode の EasyMotion (f キー)に対応する nvim 側の実装
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- ラベル候補(EasyMotion の easymotionKeys に相当)
      labels = "fjrutygheidkws",
      modes = {
        -- f/F/t/T を強化(行内検索を画面全体ジャンプに拡張)
        char = {
          enabled = true,
          jump_labels = true,
          -- IJKL 配列なのでデフォルトの ;/, は維持(repeat 用)
        },
        -- /検索もラベル付き
        search = {
          enabled = true,
        },
      },
    },
    keys = {
      -- メインのジャンプ (VSCode の "f → leader leader leader bdw" 相当)
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,        desc = "Flash" },

      -- TreeSitter ノード単位の選択
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,  desc = "Flash Treesitter" },

      -- リモート操作 (オペレータ後にジャンプ先指定)
      { "r", mode = "o",               function() require("flash").remote() end,      desc = "Remote Flash" },

      -- 検索モード内でのジャンプ切替
      { "<c-s>", mode = { "c" },       function() require("flash").toggle() end,      desc = "Toggle Flash Search" },
    },
  },
}
