return {
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
      {
        "<leader>o",
        function()
          local outline = require("outline")
          if outline.is_open() then
            outline.close()
            return
          end
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.server_capabilities.documentSymbolProvider then
              outline.open_outline()
              return
            end
          end
          vim.defer_fn(function()
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
              if client.server_capabilities.documentSymbolProvider then
                require("outline").open_outline()
                return
              end
            end
            vim.notify("No LSP with document symbols available", vim.log.levels.WARN, { title = "Outline" })
          end, 1000)
        end,
        desc = "切换大纲视图",
      },
    },
    opts = {},
  },
}
