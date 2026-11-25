return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- { "<leader>a", "<cmd>Yazi cwd<cr>", desc = "在nvim工作目录中打开文件管理器" },
      -- -- { "<leader>-", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "在当前文件中打开yazi" },
      -- { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "恢复上次yazi会话" },
    },
    opts = {
      open_for_directories = false,
      keymaps = { show_help = "<f1>" },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
