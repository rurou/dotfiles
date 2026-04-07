local map = vim.keymap.set

-- ============================================================
-- HJKL → IJKL リマップ（現在の設定から移植）
-- h = insert mode (← Insert キー相当)
-- i = up
-- j = left
-- k = down
-- ============================================================
map({ "n", "v" }, "h", "<Insert>", { desc = "Insert mode" })
map({ "n", "v" }, "i", "<Up>",     { desc = "Up" })
map({ "n", "v" }, "j", "<Left>",   { desc = "Left" })
map({ "n", "v" }, "k", "<Down>",   { desc = "Down" })

-- l はそのまま右移動なので触らない

-- ============================================================
-- ウィンドウ操作（IJKL ベースに合わせて Ctrl+IJKL）
-- ============================================================
map("n", "<C-i>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-k>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-j>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ============================================================
-- バッファ操作
-- ============================================================
map("n", "<leader>bn", "<cmd>tabnew<cr>",   { desc = "New tab" })
map("n", "]b",         "<cmd>bnext<cr>",    { desc = "Next buffer" })
map("n", "[b",         "<cmd>bprev<cr>",    { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>",  { desc = "Delete buffer" })

-- ============================================================
-- ファイル操作
-- ============================================================
map("n", "<leader>w", "<cmd>w<cr>",  { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>",  { desc = "Quit" })

-- ============================================================
-- ハイライト消去
-- ============================================================
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- ============================================================
-- telescope（plugins/ui.lua でプラグインが入ってから有効になる）
-- ============================================================
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })

-- ============================================================
-- ファイラー（neo-tree）
-- ============================================================
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- ============================================================
-- lazygit（toggleterm 経由）
-- ============================================================
map("n", "<leader>gg", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
  lazygit:toggle()
end, { desc = "Lazygit" })

-- ============================================================
-- LSP（lsp の on_attach で上書きされるが、fallback として定義）
-- ============================================================
map("n", "gd",        vim.lsp.buf.definition,     { desc = "Go to definition" })
map("n", "gD",        vim.lsp.buf.declaration,    { desc = "Go to declaration" })
map("n", "gr",        vim.lsp.buf.references,     { desc = "References" })
map("n", "K",         vim.lsp.buf.hover,          { desc = "Hover doc" })
map("n", "<leader>rn", vim.lsp.buf.rename,        { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action,   { desc = "Code action" })
map("n", "[d",        vim.diagnostic.goto_prev,   { desc = "Prev diagnostic" })
map("n", "]d",        vim.diagnostic.goto_next,   { desc = "Next diagnostic" })
