return {
  "kylechui/nvim-surround",
  version = "*",  -- 最新バージョンを使用
  event = "VeryLazy", -- 遅延読み込み（Neovimの起動を早くする）
  config = function()
    require("nvim-surround").setup({})
  end,
}
