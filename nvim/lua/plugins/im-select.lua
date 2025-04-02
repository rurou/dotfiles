return {
  "keaising/im-select.nvim",
  config = function()
    require("im_select").setup({
      -- macOS
      default_im_select = "com.justsystems.inputmethod.atok34.Roman", 
      disable_auto_restore = false,
      default_command = "im-select",
    })
  end,
}
