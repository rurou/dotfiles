-- 現在の設定から移植: IME自動切替 + lazy-lock.json 自動push
return {
  -- IME自動切替（ATOK用、現在の設定そのまま移植）
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({
        default_im_select  = "com.justsystems.inputmethod.atok34.Roman",
        disable_auto_restore = false,
        default_command    = "im-select",
      })
    end,
  },

  -- lazy-lock.json が変わったら自動で git push（現在の設定そのまま移植）
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      local Job = require("plenary.job")
      local uv = vim.uv or vim.loop
      local config_path = vim.fn.stdpath("config")
      local config_realpath = uv.fs_realpath(config_path) or config_path

      local function is_lazy_lock_changed()
        local result = Job:new({
          command = "git",
          args = { "diff", "--name-only" },
          cwd = config_realpath,
        }):sync()

        for _, file in ipairs(result or {}) do
          if vim.fn.fnamemodify(file, ":t") == "lazy-lock.json" then
            return true
          end
        end
        return false
      end

      local function git_add_commit_push()
        local function run(args)
          Job:new({ command = "git", args = args, cwd = config_realpath }):sync()
        end
        run({ "add", "lazy-lock.json" })
        run({ "commit", "-m", "update lazy-lock.json" })
        run({ "push" })
      end

      local function check_and_push()
        local ok, err = pcall(function()
          if is_lazy_lock_changed() then
            vim.notify("[auto-git] lazy-lock.json changed, pushing...", vim.log.levels.INFO)
            git_add_commit_push()
          end
        end)
        if not ok then
          vim.notify("[auto-git] Error: " .. vim.inspect(err), vim.log.levels.ERROR)
        end
      end

      local group = vim.api.nvim_create_augroup("AutoGitPushLazy", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = { "LazyUpdate", "LazySync" },
        group = group,
        callback = check_and_push,
      })
    end,
  },
}
