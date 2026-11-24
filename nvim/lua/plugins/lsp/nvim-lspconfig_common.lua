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
      local function has_rename()
        return #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/rename" }) > 0
      end
      local function replace_word(word)
        word = vim.trim(word or "")
        if word == "" then
          vim.notify("grn: 光标下没有可取的内容", vim.log.levels.WARN)
          return
        end
        require("grug-far").open({
          transient = true,
          prefills = { search = word, paths = vim.fn.expand("%") },
        })
      end
      vim.keymap.set("n", "grn", function()
        if has_rename() then
          return vim.lsp.buf.rename()
        end
        replace_word(vim.fn.expand("<cword>"))
      end, { desc = "重命名（无 LSP 时退回当前文件替换）" })
      vim.keymap.set("x", "grn", function()
        if has_rename() then
          return vim.lsp.buf.rename()
        end
        local saved = vim.fn.getreg("v")
        vim.cmd('noau normal! "vy')
        local text = vim.fn.getreg("v")
        vim.fn.setreg("v", saved)
        replace_word(text)
      end, { desc = "重命名（无 LSP 时退回当前文件替换）" })
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
            { "<leader>cc", false, mode = { "n", "x" } },
            { "<leader>cC", false },
          },
        },
      },
      setup = {},
    },
  },
  -- LazyVim 默认的 lint 入口目前不使用，保留禁用覆盖但不再安装/锁定它。
  { "mfussenegger/nvim-lint", enabled = false },
}
