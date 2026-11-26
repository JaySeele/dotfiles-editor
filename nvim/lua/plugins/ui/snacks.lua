return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    image = {},
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[


██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
██║     ██╔══██╗ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔██║
███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {},
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          sort = function(a, b)
            local function naturalize(s)
              return (s or ""):gsub("(%d+)", function(d)
                return string.format("%010d", tonumber(d))
              end)
            end
            return naturalize(a.sort) < naturalize(b.sort)
          end,
          win = {
            list = {
              keys = {
                H = false, -- 禁用 Shift+H 切换隐藏文件
              },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  keys = {
    -- 排列规则：Top 单键段按 ASCII；其余板块名按字母序（find → git → Grep → LSP → Other → search），
    -- 板块内键位不分大小写按字母序、同字母小写在前。false = 关闭该默认键，desc 仅作说明。

    -- Top Pickers & Explorer
    {
      "<leader><space>",
      function()
        -- 全局查找文件
        Snacks.picker.smart({ cwd = LazyVim.root() })
      end,
      desc = "查找文件",
    },
    {
      "<leader>f",
      function()
        Snacks.picker.smart({
          -- 强制只显示当前工作目录下的文件
          filter = { cwd = vim.fn.getcwd() },
        })
      end,
      desc = "查找当前路径文件",
    },
    { "<leader>,", false, desc = "缓冲区列表" },
    { "<leader>/", false, desc = "切换终端（并一并禁用官方默认 Grep）" },
    { "<leader>:", false, desc = "命令历史" },
    { "<leader>E", false, desc = "Explorer Snacks(cwd)" },
    { "<leader>K", false, desc = "Keywordprg" },
    { "<leader>`", false, desc = "switch to other buffer" },
    { "<leader>a", "<cmd>Yazi cwd<cr>", desc = "yazi" },
    {
      "<leader>e",
      function()
        local cwd = vim.fn.expand("%:p:h")
        Snacks.explorer({ cwd = cwd ~= "" and cwd or nil })
      end,
      desc = "文件资源管理器",
    },
    { "<leader>n", false, desc = "通知历史" },
    {
      "<leader>cc",
      function()
        local path = vim.fn.expand("%:p")
        vim.fn.setreg("+", path)
        vim.notify("pwd: " .. path)
      end,
      desc = "拷贝文件绝对路径",
    },
    {
      "<leader>cf",
      function()
        local path = vim.fn.expand("%:p:h")
        vim.fn.setreg("+", path)
        vim.notify("pwd: " .. path)
      end,
      desc = "拷贝文件路径",
    },
    {
      "<leader>t",
      function()
        Snacks.terminal(nil, { cwd = LazyVim.root() })
      end,
      desc = "Terminal",
    },

    -- find
    { "<leader>fb", false, desc = "缓冲区列表" },
    { "<leader>fc", false, desc = "查找配置文件" },
    { "<leader>ff", false, desc = "查找文件" },
    { "<leader>fg", false, desc = "查找Git文件" },
    { "<leader>fp", false, desc = "项目列表" },
    { "<leader>fr", false, desc = "最近文件" },

    -- git
    { "<leader>gb", false, desc = "Git分支" },
    { "<leader>gd", false, desc = "Git差异" },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    { "<leader>gh", false, desc = "hunks" },
    { "<leader>gl", false, desc = "Git日志" },
    { "<leader>gL", false, desc = "Git日志行" },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git状态",
    },
    { "<leader>gS", false, desc = "Git暂存" },

    -- Grep
    { "<leader>sb", false, desc = "缓冲区行" },
    { "<leader>sB", false, desc = "搜索打开的缓冲区" },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep({
          cwd = LazyVim.root(),
        })
      end,
      desc = "全局搜索",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "搜索选中或光标单词",
      mode = { "n", "x" },
    },

    -- LSP
    { "gai", false, desc = "传入调用" },
    { "gao", false, desc = "传出调用" },
    { "gd", false, desc = "跳转到定义" },
    { "gD", false, desc = "跳转到声明" },
    { "gI", false, desc = "跳转到实现" },
    { "grr", false, desc = "引用" },
    { "gy", false, desc = "跳转到类型定义" },
    { "<leader>ss", false, desc = "LSP符号" },
    { "<leader>sS", false, desc = "LSP工作区符号" },

    -- Other
    { "<leader>.", false, desc = "切换临时缓冲区" },
    { "<c-_>", false, desc = "切换终端（c-/ 的隐藏写法）" },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "上一个引用",
      mode = "n",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "下一个引用",
      mode = "n",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "关闭当前 buffer（保留窗口）",
    },
    { "<leader>dps", false, desc = "性能分析临时缓冲" },
    { "<leader>N", false, desc = "Neovim更新日志" },
    { "<leader>S", false, desc = "选择临时缓冲区" },
    { "<leader>un", false, desc = "关闭所有通知" },
    { "<leader>z", false, desc = "切换禅模式" },
    { "<leader>Z", false, desc = "切换缩放" },

    -- search
    { '<leader>s"', false, desc = "寄存器" },
    { "<leader>s/", false, desc = "搜索历史" },
    { "<leader>sa", false, desc = "自动命令" },
    { "<leader>sc", false, desc = "命令历史" },
    { "<leader>sC", false, desc = "命令列表" },
    { "<leader>sd", false, desc = "诊断信息" },
    { "<leader>sD", false, desc = "缓冲区诊断" },
    { "<leader>sh", false, desc = "帮助页面" },
    { "<leader>sH", false, desc = "高亮组" },
    { "<leader>si", false, desc = "图标" },
    { "<leader>sj", false, desc = "跳转列表" },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "快捷键",
    },
    { "<leader>sl", false, desc = "位置列表" },
    { "<leader>sm", false, desc = "标记" },
    { "<leader>sM", false, desc = "手册页" },
    { "<leader>sp", false, desc = "搜索插件" },
    { "<leader>sq", false, desc = "快速修复列表" },
    { "<leader>sR", false, desc = "恢复上次搜索" },
    { "<leader>su", false, desc = "撤销历史" },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "配色方案",
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        -- 全局 toggle 映射（官方示例的 us/uw/uL/uT 等）不启用：
        -- 对应键位已在 drop_keymaps.lua 中删除，这里不再注册（免得建了又删）。
      end,
    })
  end,
}
