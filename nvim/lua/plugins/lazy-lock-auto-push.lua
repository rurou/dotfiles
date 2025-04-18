return {
  "nvim-lua/plenary.nvim",
  lazy = false,

  config = function()
    local Job = require("plenary.job")
    local uv = vim.uv or vim.loop
    local config_path = vim.fn.stdpath("config")
    local config_realpath = uv.fs_realpath(config_path) or config_path

    -- デバッグ表示
    vim.notify("[auto-git] config path: " .. config_path, vim.log.levels.DEBUG)
    vim.notify("[auto-git] resolved path: " .. config_realpath, vim.log.levels.DEBUG)

    local function is_lazy_lock_changed()
      vim.notify("[auto-git] Checking for lazy-lock.json diff...", vim.log.levels.DEBUG)
      local result = Job:new({
        command = "git",
        args = { "diff", "--name-only" },
        cwd = config_realpath,
      }):sync()

      if result == nil or vim.tbl_isempty(result) then
        vim.notify("[auto-git] No files changed", vim.log.levels.DEBUG)
      else
        for _, file in ipairs(result) do
          vim.notify("[auto-git] git diff result: " .. file, vim.log.levels.DEBUG)
        end
      end

      for _, file in ipairs(result) do
        vim.notify("[auto-git] Changed file: " .. file, vim.log.levels.DEBUG)
        if vim.fn.fnamemodify(file, ":t") == "lazy-lock.json" then
          return true
        end
      end
      return false
    end

    local function git_add_commit_push()
      local function run_git_cmd(desc, cmd_args)
        vim.notify("[auto-git] Running: git " .. table.concat(cmd_args, " "), vim.log.levels.INFO)
        local result = Job:new({
          command = "git",
          args = cmd_args,
          cwd = config_realpath,
        }):sync()
        if #result > 0 then
          vim.notify("[auto-git][" .. desc .. "] Output:\n" .. table.concat(result, "\n"), vim.log.levels.DEBUG)
        end
      end

      run_git_cmd("add", { "add", "lazy-lock.json" })
      run_git_cmd("commit", { "commit", "-m", "update lazy-lock.json" })
      run_git_cmd("push", { "push" })
    end

    local function check_and_push()
      local ok = false
      local success, err = pcall(function()
        ok = is_lazy_lock_changed()
        if ok then
          vim.notify("[auto-git] lazy-lock.json has changed. Attempting push...", vim.log.levels.INFO)
          git_add_commit_push()
        else
          vim.notify("[auto-git] No changes to lazy-lock.json detected", vim.log.levels.DEBUG)
        end
      end)
      if not success then
        vim.notify("[auto-git] Error: " .. vim.inspect(err), vim.log.levels.ERROR)
      end
    end

    local group = vim.api.nvim_create_augroup("AutoGitPushLazy", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyUpdate",
      group = group,
      callback = check_and_push,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazySync",
      group = group,
      callback = check_and_push,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = group,
      callback = function()
        if not vim.g.lazy_did_update then
          check_and_push()
        end
      end,
    })
  end,
}
