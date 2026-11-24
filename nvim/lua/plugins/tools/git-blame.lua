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
    keys = {
      { "<leader>gm", "<cmd>GitBlameEnable<cr>", desc = "开启GitBlame" },
      { "<leader>gM", "<cmd>GitBlameDisable<cr>", desc = "关闭GitBlame" },
    },
  },
}
