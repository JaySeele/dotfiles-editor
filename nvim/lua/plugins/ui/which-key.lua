-- which-key 只管菜单显示：分组名（group）、显示名覆盖（desc）、隐藏（hidden = true）。
-- 键位的建立 / 删除在 snacks.lua / drop_keymaps.lua，与本文件的声明解耦。
-- 排列规则：分 <leader> 与模式键两段，段内按字母序（不分大小写、同字母小写在前；符号按 ASCII）。
return {
  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      delay = 0,
      spec = {
        -- <leader>：分组名 / desc 覆盖 / hidden
        { "<leader><tab>", group = "标签页" },
        { "<leader>b", group = "缓冲区" },
        { "<leader>c", group = "代码" },
        -- { "<leader>cf", hidden = true, desc = "格式化当前文件" },
        { "<leader>cF", hidden = true, desc = "格式化注入语言（如 md 里的代码块）" },
        { "<leader>cm", desc = "Mason（LSP / 工具安装器）" },
        -- LazyVim 的 <leader>cr 直接指向内置函数 vim.lsp.buf.rename（desc 是英文 Rename），
        -- 这里只覆盖菜单里显示的 desc，不动映射本身（映射照样只在有 rename 能力的 LSP 时出现）
        { "<leader>cr", desc = "重命名字符" },
        { "<leader>d", group = "调试" },
        { "<leader>f", group = "文件 / 查找" },
        { "<leader>g", group = "Git" },
        { "<leader>gF", desc = "选择文件并跳到行" },
        { "<leader>gf", desc = "选择文件" },
        { "<leader>gh", hidden = true, group = "hunks" },
        { "<leader>gx", desc = "选择 URL / Git 仓库" },
        { "<leader>l", group = "lazygit" },
        { "<leader>m", group = "Markdown" },
        { "<leader>q", group = "退出 / 会话" },
        { "<leader>s", group = "搜索" },
        -- { "<leader>t", group = "终端" },
        { "<leader>u", hidden = true },
        { "<leader>w", group = "窗口" },
        { "<leader>wd", desc = "关闭当前窗口 / 分屏" },
        { "<leader>x", group = "诊断 / 列表" },
        { "<leader>y", group = "路径 / 文件管理" },
        { "<leader>|", hidden = true, desc = "垂直分屏（右）" },
        { "<leader>-", hidden = true, desc = "水平分屏（下）" },
        { "<leader>?", desc = "? Which-key ?" },

        -- 模式键分组
        { "[", group = "上一个" },
        { "]", group = "下一个" },
        { "g", group = "跳转" },
        { "g'", hidden = true, group = "标记" },
        { "g`", hidden = true, group = "标记" },
        { "gc", group = "注释开关" },
        { "gr", group = "引用 / 重构" },
        { "gs", hidden = true, group = "包围" },
        { "z", hidden = true, group = "折叠" },
      },
    },
  },
}
