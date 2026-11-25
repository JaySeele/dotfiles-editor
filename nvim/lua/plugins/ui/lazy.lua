-- Lazy.nvim 自身的管理入口，归入 UI/插件管理领域。
return {
  {
    "folke/lazy.nvim",
    -- keys = { { "<leader>L", "<cmd>Lazy<cr>", desc = "插件管理（Lazy）" } },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.schedule(function()
            vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "插件管理（Lazy）" })
          end)
        end,
      })
    end,
  },
}
