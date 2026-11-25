-- Neovim 原生与系统级基础键位。
--
-- 插件/语言专属键位必须放在对应的 plugins/<domain>/ 模块里：
-- Rust → plugins/rust，Python → plugins/python，UI → plugins/ui。
-- 这样本文件保持短小，只负责用户日常的基础编辑和窗口行为。
local M = {}

function M.setup()
  if M._setup then
    return
  end
  M._setup = true
  vim.g.mapleader = " "

  local function map(mode, lhs, rhs, desc, opts)
    opts = vim.tbl_extend("force", opts or {}, { desc = desc })
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- 插入 / 剪贴板
  map("i", "jk", "<Esc>", "退出插入模式")
  map("i", "<D-v>", '<C-o>"+p', "粘贴")
  map("n", "<D-v>", '"+p', "粘贴")
  map("v", "<D-c>", '"+y', "复制")

  -- 基础编辑
  map("n", "cw", "ciw", "改写整个单词")
  map("n", "vw", "viw", "选中整个单词")
  map("n", "yw", "yiw", "复制整个单词")
  map("n", "J", "10j", "向下移动10行")
  map("n", "K", "10k", "向上移动10行")

  -- 基础窗口 / buffer
  map("n", "<leader>sv", "<C-w>v", "垂直分屏（左右）")
  map("n", "<leader>wd", "<C-w>c", "关闭当前窗口 / 分屏")
  map("n", "<D>h", "<C-w>h", "焦点移到左侧文件树")
  map("n", "<D>l", "<C-w>l", "焦点移到右侧Outline")

  -- 路径复制
  map("n", "<leader>yf", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("cp: " .. path)
  end, "拷贝文件路径")
  map("n", "<leader>yp", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    vim.notify("cp: " .. dir)
  end, "拷贝当前路径")
end

return M
