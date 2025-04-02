-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  {
    "AstroNvim/astrocore",
    --@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["h"] = {"<insert>", desc = "insert"},
          ["i"] = {"<up>", desc = "up"},
          -- ["j"] = {"<left>", desc = "left"},
          -- ["k"] = {"<down>", desc = "down"},
          ["j"] = {
            function()
              vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<left>", true, false, true),
              "n",
              true
              )
            end,
            desc = "left"
          },
          ["k"] = {
            function()
              vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<down>", true, false, true),
              "n",
              true
              )
            end,
            desc = "down"
          },
          -- ["<Esc><Esc><Esc>"] = {
          --   ":nohlsearch<CR><Esc>", desc = "clear highlights"
          -- } 
          --second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<leader>bD"] = {
            function()
              require("astronvim.utils.status").heirline.buffer_picker(function(bufnr) require("astronvim.utils.buffer").close(bufnr) end)
            end,
            desc = "Pick to close",
          },
          -- tables with the `name` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<leader>b"] = { name = "Buffers" },
          -- quick save
          -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
        },
        v = {
          ["h"] = {"<insert>", desc = "insert"},
          ["i"] = {"<up>", desc = "up"},
          ["j"] = {
            function()
              vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<left>", true, false, true),
              "n",
              true
              )
            end,
            desc = "left"
          },
          ["k"] = {
            function()
              vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<down>", true, false, true),
              "n",
              true
              )
            end,
            desc = "down"
          },
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
}
