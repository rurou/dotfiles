-- 行番号
vim.opt.number = true
vim.opt.relativenumber = true

-- インデント
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 見た目
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- 分割
vim.opt.splitright = true
vim.opt.splitbelow = true

-- undo の永続化
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- クリップボード
vim.opt.clipboard = "unnamedplus"

-- 補完
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- その他
vim.opt.spell = false
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
