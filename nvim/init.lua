-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- leader は lazy より前に設定する必要がある
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("options")
require("keymaps")
require("lazy").setup("plugins", {
  install = { colorscheme = { "tokyonight", "habamax" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "netrwPlugin", "tarPlugin", "tohtml", "zipPlugin",
      },
    },
  },
})
