-- git操作: lazygit を toggleterm の floating terminal で起動
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = [[<C-\>]],  -- Ctrl+\ でターミナルトグル
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 3,
      },
      shell = vim.o.shell,
    },
  },
}
-- lazygit の起動は keymaps.lua で定義（<leader>gg）
