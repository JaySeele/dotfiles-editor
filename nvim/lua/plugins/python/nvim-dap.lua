-- Python 调试：DAP、DAP UI、virtual text、dap-python 和 debugpy。
local uv = vim.uv or vim.loop

local function project_python()
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end
  local buf = vim.api.nvim_buf_get_name(0)
  local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.fn.getcwd()
  local venv = vim.fs.find({ ".venv", "venv" }, { path = start, upward = true, type = "directory" })[1]
  local exe = venv and (venv .. "/bin/python")
  if exe and uv.fs_stat(exe) then
    return exe
  end
  return "python3"
end

local function with_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  local args_str = type(args) == "table" and table.concat(args, " ") or args
  config = vim.deepcopy(config)
  config.args = function()
    return require("dap.utils").splitstr(vim.fn.expand(vim.fn.input("运行参数: ", args_str)))
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
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
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    keys = {
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
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    optional = true,
    opts = {},
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
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
    config = function()
      require("dap-python").setup(vim.fn.stdpath("data") .. "/debugpy-adapter/bin/python")
      require("dap-python").resolve_python = project_python
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = { handlers = { python = function() end } },
  },
}
