-- 通用 LSP 能力、诊断显示和默认 LSP 键位覆盖。
local capabilities
local ok, caps = pcall(function()
  return require("blink.cmp").get_lsp_capabilities()
end)
if ok then
  capabilities = caps
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.lsp.handlers["$/progress"] = function() end
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspBaseKeymaps", { clear = true }),
        callback = function(args)
          vim.keymap.set("n", "K", "10k", { buffer = args.buf, desc = "向上移动10行" })
        end,
      })
    end,
    opts = {
      diagnostics = {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          severity = { min = vim.diagnostic.severity.WARN },
        },
      },
      servers = {
        ["*"] = {
          capabilities = capabilities,
          keys = {
            { "K", false },
            { "gr", false },
            -- { "<leader>cc", false, mode = { "n", "x" } },
            -- { "<leader>cC", false },
          },
        },
      },
      setup = {},
    },
  },
  -- LazyVim 默认的 lint 入口目前不使用，保留禁用覆盖但不再安装/锁定它。
  { "mfussenegger/nvim-lint", enabled = false },
}
