-- 文件、Git 工具插件。
local Keymaps = require("config.keymaps")

return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " => <committer-date> : <summary>",
      date_format = "%r [%Y/%m/%d]",
      virtual_text_column = 1,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = Keymaps.plugin_keys.yazi,
    opts = {
      open_for_directories = false,
      keymaps = { show_help = "<f1>" },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
