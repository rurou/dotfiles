return {
  dir = vim.fn.stdpath("config") .. "/lua/plugins/",
  name = "lazy-lock-auto-push",
  lazy = false,
  config = function()
    local Job = require("plenary.job")

    local function push_lazy_lock_if_changed()
      local repo_dir = os.getenv("HOME") .. "/dotfiles"
      local lock_path = "config/nvim/lazy-lock.json"

      -- git add
      Job:new({
        command = "git",
        args = { "add", lock_path },
        cwd = repo_dir,
        on_exit = function()
          -- check if there are staged changes
          Job:new({
            command = "git",
            args = { "diff", "--cached", "--quiet" },
            cwd = repo_dir,
            on_exit = function(_, code)
              if code ~= 0 then
                -- commit
                Job:new({
                  command = "git",
                  args = { "commit", "-m", "chore: update lazy-lock.json" },
                  cwd = repo_dir,
                  on_exit = function()
                    -- push
                    Job:new({
                      command = "git",
                      args = { "push" },
                      cwd = repo_dir,
                      on_exit = function()
                        vim.schedule(function()
                          vim.notify("lazy-lock.json has been pushed to GitHub ✅", vim.log.levels.INFO, { title = "Git Auto Push" })
                        end)
                      end,
                    }):start()
                  end,
                }):start()
              end
            end,
          }):start()
        end,
      }):start()
    end

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = push_lazy_lock_if_changed,
      desc = "Push lazy-lock.json to GitHub if changed",
    })
  end,
}
