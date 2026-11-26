-- 保存格式化统一由 LazyVim.format 管理：Conform 有对应 formatter 时优先用它，
-- 没有 formatter 时由 LazyVim 的 LSP provider 回退，避免这里再叠加第二个 BufWritePre。

-- Python 文件关闭 inlay hints（隐藏 -> None 等返回类型提示）
-- 注意：LspAttach 的 pattern 匹配的是「缓冲区文件名」而不是文件类型，
-- 所以这里用 callback 判断 filetype（原写法 pattern = "python" 永远不会命中）。
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.bo[args.buf].filetype == "python" then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
  desc = "Python: 关闭 inlay hints",
})

-- 启动时自动打开文件树
-- if vim.fn.argc() == 0 then
--   vim.schedule(function()
--     Snacks.explorer()
--   end)
-- end

if vim.fn.argc() == 0 then
  vim.schedule(function()
    Snacks.picker.smart({
      -- 强制只显示当前工作目录下的文件
      filter = { cwd = vim.fn.getcwd() },
    })
    -- Snacks.picker.smart({ root = false })
  end)
end
