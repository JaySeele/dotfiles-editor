local snacks_keys = {
  {
    "<leader><space>",
    function()
      Snacks.picker.smart()
    end,
    desc = "智能查找文件",
  },
  {
    "<leader>,",
    false,
    -- function()
    --   Snacks.picker.buffers()
    -- end,
    -- desc = "缓冲区列表",
  },
  {
    "<leader>/",
    false,
    -- function()
    --   Snacks.picker.grep()
    -- end,
    -- desc = "全局搜索",
  },
  {
    "<leader>:",
    false,
    -- function()
    --   Snacks.picker.command_history()
    -- end,
    -- desc = "命令历史",
  },
  {
    "<leader>n",
    false,
    -- function()
    --   Snacks.notifier.show_history()
    -- end,
    -- desc = "通知历史",
  },
  {
    "<leader>e",
    function()
      local cwd = vim.fn.expand("%:p:h")
      Snacks.explorer({ cwd = cwd ~= "" and cwd or nil })
    end,
    desc = "文件资源管理器",
  },
  {
    "<leader>fb",
    false,
    -- function()
    --   Snacks.picker.buffers()
    -- end,
    -- desc = "缓冲区列表",
  },
  {
    "<leader>fc",
    false,
    -- function()
    --   Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
    -- end,
    -- desc = "查找配置文件",
  },
  {
    "<leader>ff",
    false,
    -- function()
    --   Snacks.picker.files()
    -- end,
    -- desc = "查找文件",
  },
  {
    "<leader>fg",
    false,
    -- function()
    --   Snacks.picker.git_files()
    -- end,
    -- desc = "查找Git文件",
  },
  {
    "<leader>fp",
    false,
    -- function()
    --   Snacks.picker.projects()
    -- end,
    -- desc = "项目列表",
  },
  {
    "<leader>fr",
    false,
    -- function()
    --   Snacks.picker.recent()
    -- end,
    -- desc = "最近文件",
  },
  {
    "<leader>gb",
    false,
    -- function()
    --   Snacks.picker.git_branches()
    -- end,
    -- desc = "Git分支",
  },
  {
    "<leader>gl",
    false,
    function()
      Snacks.picker.git_log()
    end,
    desc = "Git日志",
  },
  {
    "<leader>gL",
    false,
    -- function()
    --   Snacks.picker.git_log_line()
    -- end,
    -- desc = "Git日志行",
  },
  {
    "<leader>gs",
    function()
      Snacks.picker.git_status()
    end,
    desc = "Git状态",
  },
  {
    "<leader>gS",
    false,
    -- function()
    --   Snacks.picker.git_stash()
    -- end,
    -- desc = "Git暂存",
  },
  {
    "<leader>gd",
    false,
    -- function()
    --   Snacks.picker.git_diff()
    -- end,
    -- desc = "Git差异",
  },
  {
    "<leader>gf",
    false,
    -- function()
    --   Snacks.picker.git_log_file()
    -- end,
    -- desc = "Git文件日志",
  },
  {
    "<leader>sb",
    false,
    -- function()
    --   Snacks.picker.lines()
    -- end,
    -- desc = "缓冲区行",
  },
  {
    "<leader>sB",
    false,
    -- function()
    --   Snacks.picker.grep_buffers()
    -- end,
    -- desc = "搜索打开的缓冲区",
  },
  {
    "<leader>sg",
    function()
      Snacks.picker.grep()
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
  {
    '<leader>s"',
    false,
    -- function()
    --   Snacks.picker.registers()
    -- end,
    -- desc = "寄存器",
  },
  {
    "<leader>s/",
    false,
    -- function()
    --   Snacks.picker.search_history()
    -- end,
    -- desc = "搜索历史",
  },
  {
    "<leader>sa",
    false,
    -- function()
    --   Snacks.picker.autocmds()
    -- end,
    -- desc = "自动命令",
  },
  {
    "<leader>sc",
    false,
    -- function()
    --   Snacks.picker.command_history()
    -- end,
    -- desc = "命令历史",
  },
  {
    "<leader>sC",
    false,
    -- function()
    --   Snacks.picker.commands()
    -- end,
    -- desc = "命令列表",
  },
  {
    "<leader>sd",
    false,
    -- function()
    --   Snacks.picker.diagnostics()
    -- end,
    -- desc = "诊断信息",
  },
  {
    "<leader>sD",
    false,
    -- function()
    --   Snacks.picker.diagnostics_buffer()
    -- end,
    -- desc = "缓冲区诊断",
  },
  {
    "<leader>sh",
    false,
    -- function()
    --   Snacks.picker.help()
    -- end,
    -- desc = "帮助页面",
  },
  {
    "<leader>sH",
    false,
    -- function()
    --   Snacks.picker.highlights()
    -- end,
    -- desc = "高亮组",
  },
  {
    "<leader>si",
    false,
    -- function()
    --   Snacks.picker.icons()
    -- end,
    -- desc = "图标",
  },
  {
    "<leader>sj",
    false,
    -- function()
    --   Snacks.picker.jumps()
    -- end,
    -- desc = "跳转列表",
  },
  {
    "<leader>sk",
    function()
      Snacks.picker.keymaps()
    end,
    desc = "快捷键",
  },
  {
    "<leader>sl",
    false,
    -- function()
    --   Snacks.picker.loclist()
    -- end,
    -- desc = "位置列表",
  },
  {
    "<leader>sm",
    false,
    -- function()
    --   Snacks.picker.marks()
    -- end,
    -- desc = "标记",
  },
  {
    "<leader>sM",
    false,
    -- function()
    --   Snacks.picker.man()
    -- end,
    -- desc = "手册页",
  },
  {
    "<leader>sp",
    false,
    -- function()
    --   Snacks.picker.lazy()
    -- end,
    -- desc = "搜索插件",
  },
  {
    "<leader>sq",
    false,
    -- function()
    --   Snacks.picker.qflist()
    -- end,
    -- desc = "快速修复列表",
  },
  {
    "<leader>sR",
    false,
    -- function()
    --   Snacks.picker.resume()
    -- end,
    -- desc = "恢复上次搜索",
  },
  {
    "<leader>su",
    false,
    -- function()
    --   Snacks.picker.undo()
    -- end,
    -- desc = "撤销历史",
  },
  {
    "<leader>uC",
    function()
      Snacks.picker.colorschemes()
    end,
    desc = "配色方案",
  },
  {
    "gd",
    false,
    -- function()
    --   Snacks.picker.lsp_definitions()
    -- end,
    -- desc = "跳转到定义",
  },
  {
    "gD",
    false,
    -- function()
    --   Snacks.picker.lsp_declarations()
    -- end,
    -- desc = "跳转到声明",
  },
  {
    "grr",
    false,
    -- function()
    --   Snacks.picker.lsp_references()
    -- end,
    -- desc = "引用",
  },
  {
    "gI",
    false,
    -- function()
    --   Snacks.picker.lsp_implementations()
    -- end,
    -- desc = "跳转到实现",
  },
  {
    "gy",
    false,
    -- function()
    --   Snacks.picker.lsp_type_definitions()
    -- end,
    -- desc = "跳转到类型定义",
  },
  {
    "gai",
    false,
    -- function()
    --   Snacks.picker.lsp_incoming_calls()
    -- end,
    -- desc = "传入调用",
  },
  {
    "gao",
    false,
    -- function()
    --   Snacks.picker.lsp_outgoing_calls()
    -- end,
    -- desc = "传出调用",
  },
  {
    "<leader>ss",
    false,
    -- function()
    --   Snacks.picker.lsp_symbols()
    -- end,
    -- desc = "LSP符号",
  },
  {
    "<leader>sS",
    false,
    -- function()
    --   Snacks.picker.lsp_workspace_symbols()
    -- end,
    -- desc = "LSP工作区符号",
  },
  {
    "<leader>z",
    false,
    -- function()
    --   Snacks.zen()
    -- end,
    -- desc = "切换禅模式",
  },
  {
    "<leader>Z",
    false,
    -- function()
    --   Snacks.zen.zoom()
    -- end,
    -- desc = "切换缩放",
  },
  {
    "<leader>.",
    false,
    -- function()
    --   Snacks.scratch()
    -- end,
    -- desc = "切换临时缓冲区",
  },
  {
    "<leader>S",
    false,
    -- function()
    --   Snacks.scratch.select()
    -- end,
    -- desc = "选择临时缓冲区",
  },
  {
    "<leader>bd",
    function()
      Snacks.bufdelete()
    end,
    desc = "关闭当前 buffer（保留窗口）",
  },
  {
    "<leader>gg",
    function()
      Snacks.lazygit()
    end,
    desc = "Lazygit",
  },
  {
    "<leader>dps",
    false,
    -- function()
    --   Snacks.profiler.scratch()
    -- end,
    -- desc = "性能分析临时缓冲",
  },
  {
    "<leader>un",
    false,
    -- function()
    --   Snacks.notifier.hide()
    -- end,
    -- desc = "关闭所有通知",
  },
  {
    "<leader>/",
    function()
      Snacks.terminal()
    end,
    desc = "切换终端",
  },
  {
    "<c-_>",
    false,
    -- function()
    --   Snacks.terminal()
    -- end,
    -- desc = "which_key_ignore",
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
    "[[",
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = "上一个引用",
    mode = "n",
  },
  {
    "<leader>N",
    false,
    -- function()
    --   Snacks.win({
    --     file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    --     width = 0.6,
    --     height = 0.6,
    --     wo = {
    --       spell = false,
    --       wrap = false,
    --       signcolumn = "yes",
    --       statuscolumn = " ",
    --       conceallevel = 3,
    --     },
    --   })
    -- end,
    -- desc = "Neovim更新日志",
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[


██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {},
      },
    },
    explorer = { enabled = true },
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
  keys = snacks_keys,
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

        -- 全局 toggle 映射统一由 config.keymaps.setup() 注册。
      end,
    })
  end,
}
