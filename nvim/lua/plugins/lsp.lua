-- lua/plugins/lsp.lua
-- LSP: mason + nvim-lspconfig (Neovim 0.11+ の vim.lsp.config API を使用)
-- mason は mason-org に移転済み（2024年〜）

return {
  -- Mason: LSP/formatter/linter のインストーラ
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- mason-lspconfig: Mason と lspconfig の橋渡し
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",   -- Lua
        "pyright",  -- Python (型チェック)
        "ruff",     -- Python (linter/formatter)
        "nil_ls",   -- Nix
        -- JS/TSは必要になったら追加:
        -- "ts_ls",
        -- "eslint",
      },
      automatic_installation = true,
    },
  },

  -- nvim-lspconfig: 各 LSP サーバーのデフォルト設定を提供
  -- (require('lspconfig') は使わず vim.lsp.config / vim.lsp.enable を使う)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/lazydev.nvim",
    },
    config = function()
      -- LSP アタッチ時のキーバインド
      -- Neovim 0.11 からデフォルトで grn/gra/grr/gri が設定されるが
      -- 既存の操作感に合わせて明示的に定義する
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local buf = ev.buf
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end

          map("gd",         vim.lsp.buf.definition,      "Go to definition")
          map("gD",         vim.lsp.buf.declaration,     "Go to declaration")
          map("gr",         vim.lsp.buf.references,      "References")
          map("gi",         vim.lsp.buf.implementation,  "Go to implementation")
          map("gy",         vim.lsp.buf.type_definition, "Go to type definition")
          map("K",          vim.lsp.buf.hover,           "Hover docs")
          map("<leader>la", vim.lsp.buf.code_action,     "Code action")
          map("<leader>lr", vim.lsp.buf.rename,          "Rename")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("<leader>ls", vim.lsp.buf.signature_help,  "Signature help")
        end,
      })

      -- blink.cmp の capabilities を全サーバーにデフォルト適用
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Lua: lazydev と連携するための設定
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Python: pyright (型チェック)
      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            disableOrganizeImports = true, -- ruff が import 整理をするのでオフ
          },
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      })

      -- Python: ruff (linter + formatter) はデフォルト設定のまま使う
      -- Nix: nil_ls
      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = { command = { "nixfmt" } },
          },
        },
      })

      -- サーバーを有効化 (nvim-lspconfig がデフォルト設定を提供する)
      vim.lsp.enable({
        "lua_ls",
        "pyright",
        "ruff",
        "nil_ls",
      })

      -- 診断の表示設定
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },

  -- Neovim Lua API の補完強化
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
}

