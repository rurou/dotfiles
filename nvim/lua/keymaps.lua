local map = vim.keymap.set

-- ============================================================
-- HJKL → IJKL リマップ
-- h = Insert mode 突入, i = up, j = left, k = down, l = right (元のまま)
-- ============================================================
map("n", "h", "<Insert>", { desc = "Insert mode" })
map("n", "i", "<Up>",     { desc = "Up" })
map("n", "j", "<Left>",   { desc = "Left" })
map("n", "k", "<Down>",   { desc = "Down" })
map("v", "k", "<Down>",   { desc = "Down" })

-- ============================================================
-- Window 操作: <C-w> + IJKL を再マップ
-- <C-w>i は元々 jump-to-declaration だが LSP の gd で代替可能なので潰す
-- <C-w>h は Vim 標準 (左移動) のまま残す (Vim 文化互換性)
-- <C-w>w / <C-w>W / <C-w>p などの cycle 系は Vim 標準のまま使える
-- ============================================================
map("n", "<C-w>i", "<C-w>k", { desc = "Window: upper (IJKL)" })
map("n", "<C-w>j", "<C-w>h", { desc = "Window: left (IJKL)" })
map("n", "<C-w>k", "<C-w>j", { desc = "Window: lower (IJKL)" })
-- <C-w>l は Vim 標準 (右移動) と一致するのでリマップ不要
-- <C-w>h は Vim 標準のまま (左移動)

-- ============================================================
-- <leader>w プレフィックス: Window 操作 + Save 系を統合
-- 移動系は <C-w>+IJKL と機能重複するが、leader 経由が好みの場面用
-- 保存系は :wq の手癖を維持
-- ============================================================
-- Window 移動
map("n", "<leader>wi", "<C-w>k", { desc = "Window: upper" })
map("n", "<leader>wk", "<C-w>j", { desc = "Window: lower" })
map("n", "<leader>wj", "<C-w>h", { desc = "Window: left" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window: right" })
-- Window 分割・閉じる
map("n", "<leader>ws", "<C-w>s", { desc = "Window: horizontal split" })
map("n", "<leader>wv", "<C-w>v", { desc = "Window: vertical split" })
map("n", "<leader>wc", "<C-w>c", { desc = "Window: close" })
map("n", "<leader>wo", "<C-w>o", { desc = "Window: only (close others)" })
map("n", "<leader>w=", "<C-w>=", { desc = "Window: equalize" })
-- 保存系 (window グループに混ぜる、:w/:wq の手癖維持)
map("n", "<leader>ww", "<cmd>w<cr>",   { desc = "Save" })
map("n", "<leader>wq", "<cmd>wq<cr>",  { desc = "Save and quit" })
map("n", "<leader>wa", "<cmd>wa<cr>",  { desc = "Save all" })
map("n", "<leader>wQ", "<cmd>wqa<cr>", { desc = "Save all and quit" })

map("n", "<leader>q",  "<cmd>q<cr>",   { desc = "Quit" })

-- ============================================================
-- Buffer 操作
-- ============================================================
map("n", "<leader>bn", "<cmd>tabnew<cr>",   { desc = "New tab" })
map("n", "]b",         "<cmd>bnext<cr>",    { desc = "Next buffer" })
map("n", "[b",         "<cmd>bprev<cr>",    { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>",  { desc = "Delete buffer" })
-- VSCode <leader>J/K に対応
map("n", "<leader>J",  "<cmd>bnext<cr>",    { desc = "Next buffer (VSCode style)" })
map("n", "<leader>K",  "<cmd>bprev<cr>",    { desc = "Prev buffer (VSCode style)" })

-- ============================================================
-- コメントトグル (VSCode <leader>k 相当、gcc は nvim 0.10+ ビルトイン)
-- ============================================================
map("n", "<leader>k", "gcc", { desc = "Toggle comment line", remap = true })
map("x", "<leader>k", "gc",  { desc = "Toggle comment selection", remap = true })

-- ============================================================
-- fold/unfold (VSCode <leader>m/o 相当)
-- ============================================================
map("n", "<leader>m", "zM", { desc = "Fold all" })
map("n", "<leader>o", "zR", { desc = "Unfold all" })

-- ============================================================
-- ハイライト消去
-- ============================================================
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- ============================================================
-- telescope: quickopen / command palette (VSCode <leader>p/P 相当)
-- ============================================================
map("n", "<leader>p",  "<cmd>Telescope find_files<cr>", { desc = "Quick open files" })
map("n", "<leader>P",  "<cmd>Telescope commands<cr>",   { desc = "Command palette" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "Help tags" })

-- ============================================================
-- ファイラー (neo-tree)
-- ============================================================
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- ============================================================
-- lazygit (toggleterm 経由)
-- ============================================================
map("n", "<leader>gg", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
  lazygit:toggle()
end, { desc = "Lazygit" })

-- ============================================================
-- LSP fallback (LspAttach の on_attach で個別に上書きされる)
-- nvim 0.11+ デフォルトの grr/gra/grn/gri/grt/grx を尊重し、
-- VSCode 互換の <leader>系のみ追加
-- ============================================================
map("n", "gd",         vim.lsp.buf.definition,   { desc = "Go to definition" })
map("n", "gD",         vim.lsp.buf.declaration,  { desc = "Go to declaration" })
map("n", "K",          vim.lsp.buf.hover,        { desc = "Hover doc" })
map("n", "<leader>h",  vim.lsp.buf.hover,        { desc = "Hover (VSCode style)" })
map("n", "<leader>f",  function() vim.lsp.buf.format({ async = true }) end, { desc = "Format" })
map("n", "<leader>rn", vim.lsp.buf.rename,       { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action,  { desc = "Code action" })
map("n", "[d",         vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next, { desc = "Next diagnostic" })
