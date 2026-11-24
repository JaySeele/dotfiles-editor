-- Neovim 动作键位唯一注册表。
--
-- 约定：
--   * 全局/缓冲区动作键、Lazy.nvim 插件快捷键、which-key 描述和禁用默认键位都在此维护。
--   * 插件 spec 只引用 M.plugin_keys 中的列表，不能再复制 lhs/rhs/desc。
--   * 插件自己的弹窗/补全菜单/文件管理器内部按键仍留在各自 opts 中。
--   * Lazy 收集 spec 时本模块只暴露数据和 helper；全局映射要等 VeryLazy 后再应用，
--     保证用户映射覆盖 LazyVim 默认映射。LspAttach hook 则提前安装，避免错过早期 attach。
local M = {}

local function with_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  local args_str = type(args) == "table" and table.concat(args, " ") or args
  config = vim.deepcopy(config)
  config.args = function()
    local value = vim.fn.expand(vim.fn.input("运行参数: ", args_str))
    return require("dap.utils").splitstr(value)
  end
  return config
end

local function project_python()
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  local buf = vim.api.nvim_buf_get_name(0)
  local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.fn.getcwd()
  local venv = vim.fs.find({ ".venv", "venv" }, { path = start, upward = true, type = "directory" })[1]
  local exe = venv and (venv .. "/bin/python")
  if exe and (vim.uv or vim.loop).fs_stat(exe) then
    return exe
  end
  return "python3"
end

M.python = {
  project_python = project_python,
}

-- Lazy.nvim action shortcuts. Keep these as the only definitions; plugin specs reference them.
M.plugin_keys = {
  snacks = {
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "智能查找文件",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "缓冲区列表",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "全局搜索",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "命令历史",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "通知历史",
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
      function()
        Snacks.picker.buffers()
      end,
      desc = "缓冲区列表",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "查找配置文件",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "查找文件",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "查找Git文件",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "项目列表",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "最近文件",
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git分支",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git日志",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git日志行",
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
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git暂存",
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git差异",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git文件日志",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "缓冲区行",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "搜索打开的缓冲区",
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
      function()
        Snacks.picker.registers()
      end,
      desc = "寄存器",
    },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "搜索历史",
    },
    {
      "<leader>sa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "自动命令",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.command_history()
      end,
      desc = "命令历史",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "命令列表",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "诊断信息",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "缓冲区诊断",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "帮助页面",
    },
    {
      "<leader>sH",
      function()
        Snacks.picker.highlights()
      end,
      desc = "高亮组",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "图标",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "跳转列表",
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
      function()
        Snacks.picker.loclist()
      end,
      desc = "位置列表",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "标记",
    },
    {
      "<leader>sM",
      function()
        Snacks.picker.man()
      end,
      desc = "手册页",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.lazy()
      end,
      desc = "搜索插件",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "快速修复列表",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "恢复上次搜索",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "撤销历史",
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
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "跳转到定义",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "跳转到声明",
    },
    {
      "grr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "引用",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "跳转到实现",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "跳转到类型定义",
    },
    {
      "gai",
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = "传入调用",
    },
    {
      "gao",
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = "传出调用",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP符号",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP工作区符号",
    },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "切换禅模式",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "切换缩放",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "切换临时缓冲区",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "选择临时缓冲区",
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
      function()
        Snacks.profiler.scratch()
      end,
      desc = "性能分析临时缓冲",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "关闭所有通知",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "切换终端",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
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
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
      desc = "Neovim更新日志",
    },
  },
  yazi = {
    { "<leader>-", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "在当前文件中打开yazi" },
    { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "在nvim工作目录中打开文件管理器" },
    { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "恢复上次yazi会话" },
  },
  outline = {
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
      mode = "n",
      desc = "切换大纲视图",
    },
  },
  dap = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "切换断点",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("断点条件: "))
      end,
      desc = "条件断点（满足表达式才停）",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "启动 / 继续",
    },
    {
      "<leader>da",
      function()
        require("dap").continue({ before = with_args })
      end,
      desc = "带参数运行",
    },
    {
      "<leader>dC",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "运行到光标处",
    },
    {
      "<leader>dg",
      function()
        require("dap").goto_()
      end,
      desc = "跳到指定行（不执行）",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "单步进入（钻进函数）",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "单步跳出（出当前函数）",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_over()
      end,
      desc = "单步跳过（整行执行）",
    },
    {
      "<leader>dj",
      function()
        require("dap").down()
      end,
      desc = "下一层栈帧",
    },
    {
      "<leader>dk",
      function()
        require("dap").up()
      end,
      desc = "上一层栈帧",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "重新运行上次调试",
    },
    {
      "<leader>dP",
      function()
        require("dap").pause()
      end,
      desc = "暂停",
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "调试 REPL（实时求值）",
    },
    {
      "<leader>ds",
      function()
        require("dap").session()
      end,
      desc = "当前会话信息",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "结束调试",
    },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "悬停查看变量",
    },
  },
  dap_ui = {
    {
      "<leader>du",
      function()
        require("dapui").toggle({})
      end,
      desc = "调试面板开关",
    },
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      mode = { "n", "x" },
      desc = "求值（光标处 / 选中）",
    },
  },
  dap_python = {
    {
      "<leader>dp",
      ft = "python",
      function()
        local file = vim.fn.expand("%:p")
        if file == "" then
          vim.notify("当前 buffer 没有文件路径，先存盘", vim.log.levels.WARN)
          return
        end
        require("dap").run({
          type = "python",
          request = "launch",
          name = "调试当前 Python 文件",
          program = file,
          cwd = vim.fn.fnamemodify(file, ":h"),
          pythonPath = project_python(),
          console = "integratedTerminal",
          justMyCode = true,
        })
      end,
      desc = "调试当前 Python 文件（自动用项目 venv）",
    },
  },
  rainbow = {
    id = "rainbow_brackets",
    name = "彩虹括号",
    lhs = "<leader>uR",
    desc = "彩虹括号开关",
    wk_desc = { enabled = "关闭", disabled = "开启" },
  },
}

M.disabled_defaults = {
  leader = {
    ",",
    "-",
    ".",
    "/",
    ":",
    "E",
    "K",
    "N",
    "S",
    "Z",
    "`",
    "l",
    "n",
    "z",
    "bD",
    "bP",
    "bb",
    "bi",
    "bj",
    "bl",
    "bo",
    "bp",
    "br",
    "cS",
    "cd",
    "cs",
    "cw",
    "fB",
    "fE",
    "fF",
    "fR",
    "fT",
    "fb",
    "fc",
    "fe",
    "fg",
    "fn",
    "fp",
    "fr",
    "ft",
    "gD",
    "gG",
    "gL",
    "gS",
    "gb",
    "gd",
    "gf",
    "gg",
    "gl",
    "gs",
    's"',
    "s/",
    "sB",
    "sC",
    "sD",
    "sG",
    "sH",
    "sM",
    "sR",
    "sS",
    "sT",
    "sa",
    "sb",
    "sc",
    "sd",
    "sh",
    "si",
    "sj",
    "sl",
    "sm",
    "sp",
    "sq",
    "sr",
    "ss",
    "st",
    "su",
    "uA",
    "uC",
    "uD",
    "uF",
    "uI",
    "uL",
    "uS",
    "uT",
    "uZ",
    "ua",
    "ub",
    "uc",
    "ud",
    "uf",
    "ug",
    "uh",
    "ui",
    "ul",
    "un",
    "up",
    "ur",
    "us",
    "uw",
    "uz",
    "wm",
    "wq",
    "xL",
    "xQ",
    "xT",
    "xX",
    "xl",
    "xq",
    "xt",
    "xx",
    "dpp",
    "dps",
    "dph",
    "sn",
    "sna",
    "snd",
    "snh",
    "snl",
    "snt",
    "qs",
    "qS",
    "ql",
    "qd",
    "<Tab><Tab>",
    "<Tab>[",
    "<Tab>]",
    "<Tab>d",
    "<Tab>f",
    "<Tab>l",
    "<Tab>o",
    "gi",
    "gI",
    "gp",
    "gP",
    "gB",
    "gY",
  },
  lsp = {
    { "K", false },
    { "gr", false },
    { "<leader>cc", false, mode = { "n", "x" } },
    { "<leader>cC", false },
  },
}

M.which_key = {
  spec = {
    { "<leader>c", group = "代码" },
    { "<leader>d", group = "调试" },
    { "<leader>f", group = "文件 / 查找" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "lazygit" },
    { "<leader>m", group = "Markdown" },
    { "<leader>q", group = "退出 / 会话" },
    { "<leader>s", group = "搜索" },
    { "<leader>t", group = "终端" },
    { "<leader>w", group = "窗口" },
    { "<leader>b", group = "缓冲区" },
    { "<leader>x", group = "诊断 / 列表" },
    { "<leader>y", group = "路径 / 文件管理" },
    { "<leader><tab>", group = "标签页" },
    { "g", group = "跳转" },
    { "gs", group = "包围" },
    { "z", group = "折叠" },
    { "[", group = "上一个" },
    { "]", group = "下一个" },
    { "<leader>u", hidden = true },
    { "<leader><space>", desc = "智能查找文件" },
    { "<leader>?", desc = "当前缓冲区的键位" },
    { "<leader>cf", desc = "格式化当前文件" },
    { "<leader>cF", desc = "格式化注入语言（如 md 里的代码块）" },
    { "<leader>cm", desc = "Mason（LSP / 工具安装器）" },
    { "<leader>qq", desc = "退出全部" },
    { "<leader>sW", desc = "搜索选中 / 光标词（当前目录）" },
    { "<leader>wd", desc = "关闭当前窗口 / 分屏" },
    { "<leader>|", desc = "垂直分屏（右）" },
    { "gd", desc = "跳转到定义" },
    { "gD", desc = "跳转到声明" },
    { "gI", desc = "跳转到实现" },
    { "gy", desc = "跳转到类型定义" },
    { "gO", desc = "显示当前文件的大纲" },
    { "gr", group = "引用 / 重构" },
    { "gra", desc = "代码操作" },
    { "grn", desc = "重命名（无 LSP 时退回当前文件替换）" },
    { "grr", desc = "引用列表" },
    { "gri", desc = "跳转到实现" },
    { "grt", desc = "跳转到类型定义" },
    { "grx", desc = "运行 Codelens" },
    { "ge", desc = "上一个词尾" },
    { "gf", desc = "打开光标下的文件" },
    { "gg", desc = "文件首行" },
    { "gi", desc = "上次插入的位置" },
    { "gn", desc = "向下搜索并选中" },
    { "gN", desc = "向上搜索并选中" },
    { "gt", desc = "下一个标签页" },
    { "gT", desc = "上一个标签页" },
    { "gu", desc = "转小写" },
    { "gU", desc = "转大写" },
    { "gv", desc = "上次可视选择" },
    { "gw", desc = "格式化" },
    { "gx", desc = "用系统程序打开" },
    { "g%", desc = "跳到匹配的另一半" },
    { "g,", desc = "较新的修改位置" },
    { "g;", desc = "较旧的修改位置" },
    { "g[", desc = "向左移动到 around" },
    { "g]", desc = "向右移动到 around" },
    { "g~", desc = "切换大小写" },
    { "gc", group = "注释开关" },
    { "g'", group = "标记" },
    { "g`", group = "标记" },
  },
  lsp = function(bufnr)
    local specs = {
      { "<leader>ca", desc = "代码操作（Code Action）", buffer = bufnr },
      { "<leader>cA", desc = "源码操作（Source Action）", buffer = bufnr },
      { "<leader>cl", desc = "LSP 信息", buffer = bufnr },
      { "<leader>cr", desc = "重命名", buffer = bufnr },
    }
    if vim.bo[bufnr].filetype == "rust" then
      vim.list_extend(specs, {
        { "<leader>r", group = "Rust", buffer = bufnr },
        { "<leader>rc", desc = "Rust 代码动作（import / borrow 修复）", buffer = bufnr },
        { "<leader>re", desc = "解释当前错误", buffer = bufnr },
        { "<leader>rm", desc = "展开宏", buffer = bufnr },
        { "<leader>ro", desc = "打开 Cargo.toml", buffer = bufnr },
        { "<leader>rd", desc = "Rust 可调试目标", buffer = bufnr },
      })
    end
    return specs
  end,
}

M.attach = {}

function M.attach.rust(bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map("<leader>rc", function()
    vim.cmd.RustLsp("codeAction")
  end, "Rust 代码动作")
  map("<leader>re", function()
    vim.cmd.RustLsp("explainError")
  end, "解释当前错误")
  map("<leader>rm", function()
    vim.cmd.RustLsp("expandMacro")
  end, "展开宏")
  map("<leader>ro", function()
    vim.cmd.RustLsp("openCargo")
  end, "打开 Cargo.toml")
  map("<leader>rd", function()
    vim.cmd.RustLsp("debuggables")
  end, "Rust 可调试目标")
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

function M.attach.rainbow_toggle(get_enabled, set_enabled)
  local spec = M.plugin_keys.rainbow
  require("snacks")
    .toggle({
      id = spec.id,
      name = spec.name,
      get = get_enabled,
      set = set_enabled,
      wk_desc = spec.wk_desc,
      notify = function(state)
        vim.notify("彩虹括号：" .. (state and "开启" or "关闭"), vim.log.levels.INFO)
      end,
    })
    :map(spec.lhs, { desc = spec.desc })
end

function M.attach.lsp_which_key(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    pcall(function()
      require("which-key").add(M.which_key.lsp(bufnr))
    end)
  end)
end

function M.install_early()
  if M._early_installed then
    return
  end
  M._early_installed = true
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserKeymapsLspAttach", { clear = true }),
    callback = function(args)
      vim.keymap.set("n", "K", "10k", { buffer = args.buf, desc = "向上移动10行" })
      M.attach.lsp_which_key(args.buf)
    end,
  })
end

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

  map("i", "jk", "<Esc>", "退出插入模式")
  map("i", "<D-v>", '<C-o>"+p', "粘贴")
  map("n", "<D-v>", '"+p', "粘贴")
  map("v", "<D-c>", '"+y', "复制")
  map("n", "cw", "ciw", "改写整个单词")
  map("n", "vw", "viw", "选中整个单词")
  map("n", "yw", "yiw", "复制整个单词")
  map("n", "J", "10j", "向下移动10行")
  map("n", "K", "10k", "向上移动10行")
  map("n", "<leader>sv", "<C-w>v", "垂直分屏（左右）")
  map("n", "<leader>wd", "<C-w>c", "关闭当前窗口 / 分屏")
  map("n", "<leader>bd", function()
    Snacks.bufdelete()
  end, "关闭当前 buffer（保留窗口）")
  map("n", "<leader>yf", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("cp: " .. path)
  end, "拷贝当前文件路径")
  map("n", "<leader>yp", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    vim.notify("cp: " .. dir)
  end, "拷贝当前路径")

  local function grn_has_lsp()
    return #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/rename" }) > 0
  end
  local function grn_replace(word)
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
  map("n", "grn", function()
    if grn_has_lsp() then
      return vim.lsp.buf.rename()
    end
    grn_replace(vim.fn.expand("<cword>"))
  end, "重命名（无 LSP 时退回当前文件替换）")
  map("x", "grn", function()
    if grn_has_lsp() then
      return vim.lsp.buf.rename()
    end
    local saved = vim.fn.getreg("v")
    vim.cmd('noau normal! "vy')
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", saved)
    grn_replace(text)
  end, "重命名（无 LSP 时退回当前文件替换）")

  map("n", "<D>h", "<C-w>h", "焦点移到左侧文件树")
  map("n", "<D>l", "<C-w>l", "焦点移到右侧Outline")
  map("n", "<leader>lg", "<cmd>LazyGit<cr>", "LazyGit")
  map("n", "<leader>L", "<cmd>Lazy<cr>", "插件管理（Lazy）")
  map("n", "<leader>ya", "<cmd>Yazi cwd<cr>", "打开nvim工作目录中的文件管理器")
  map("n", "<leader>mv", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.b[vim.api.nvim_win_get_buf(win)].md_render then
        if #vim.api.nvim_list_wins() > 1 then
          vim.api.nvim_win_close(win, true)
        end
        return
      end
    end
    vim.cmd("vert MdRender split")
  end, "侧边Markdown预览（竖向分屏）")
  map("n", "<leader>mp", "<cmd>MdRender float<cr>", "浮动Markdown预览")
  map("n", "<leader>gf", "<C-w>gf", "新标签打开引用文件")

  -- Snacks 的全局开关快捷键集中在此；picker/弹窗内部按键仍留在 snacks.lua opts。
  local toggle = Snacks.toggle
  toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  toggle.diagnostics():map("<leader>ud")
  toggle.line_number():map("<leader>ul")
  toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
  toggle.treesitter():map("<leader>uT")
  toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
  toggle.inlay_hints():map("<leader>uh")
  toggle.indent():map("<leader>ug")
  toggle.dim():map("<leader>uD")

  -- 可恢复的默认键位禁用清单；统一在 LazyVim/插件映射注册后执行。
  vim.schedule(function()
    for _, key in ipairs(M.disabled_defaults.leader) do
      for _, mode in ipairs({ "n", "v", "x", "t" }) do
        pcall(vim.keymap.del, mode, "<leader>" .. key)
      end
    end
  end)
end

return M
