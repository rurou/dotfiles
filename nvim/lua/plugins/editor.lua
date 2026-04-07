-- エディタ機能: treesitter・surround・rainbow・autopairs・gitsigns
return {
  -- シンタックスハイライト
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "python", "bash",
        "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "nix",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- surround操作（現在の設定から移植）
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- 括弧の色分け（現在の設定から移植）
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rainbow = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = { [""] = rainbow.strategy["global"] },
        query    = { [""] = "rainbow-delimiters" },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- 自動括弧
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- git サイン表示（変更行の左端マーク）
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.blame_line,   "Blame line")
      end,
    },
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- TODO コメントのハイライト
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- カーソル下の単語をハイライト
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}
