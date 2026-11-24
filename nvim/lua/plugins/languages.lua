-- 语言与开发工具插件配置：LSP、Rust、DAP、格式化和安装器。
local Keymaps = require("config.keymaps")
local data_dir = vim.fn.stdpath("data")

-- cspell-lsp 仅在本机 Mason 已安装时启用；Node 路径动态探测，Mac/Debian 通用。
local cspell_ls
if vim.fn.isdirectory(data_dir .. "/mason/packages/cspell-lsp") == 1 then
  local node = vim.fn.exepath("node")
  cspell_ls = {
    cmd = {
      node ~= "" and node or "node",
      data_dir .. "/mason/packages/cspell-lsp/node_modules/@vlabo/cspell-lsp/dist/cspell-lsp.js",
      "--stdio",
    },
  }
end

-- Python LSP 按机器已有的 Mason 包二选一，避免重复诊断。
local has_basedpyright = vim.fn.isdirectory(data_dir .. "/mason/packages/basedpyright") == 1
local python_analysis = {
  diagnosticMode = "openFilesOnly",
  typeCheckingMode = "off",
  inlayHints = {
    functionReturnTypes = false,
    callArgumentNames = false,
    variableTypes = false,
  },
}

-- blink.cmp 的 LSP 增量能力；插件加载失败时退回 Neovim 默认能力。
local blink_capabilities
do
  local ok, caps = pcall(function()
    return require("blink.cmp").get_lsp_capabilities()
  end)
  if ok then
    blink_capabilities = caps
  end
end

local servers = {
  ["*"] = {
    capabilities = blink_capabilities,
    keys = Keymaps.disabled_defaults.lsp,
  },
  ruff = {
    enabled = true,
    autostart = true,
    init_options = { settings = { fixAll = true, lint = { enabled = false } } },
  },
  jsonls = {},
  yamlls = {
    settings = {
      yaml = {
        schemaStore = { enable = false },
        schemas = {},
      },
    },
  },
  taplo = {},
  bashls = { filetypes = { "bash", "sh", "zsh" } },
  vimls = {},
  dockerls = {},
  cssls = {},
  html = {},
  ts_ls = {},
  marksman = {},
  csskit = { enabled = false },
  css_variables = { enabled = false },
  cssmodules_ls = { enabled = false },
  rust_analyzer = { enabled = false }, -- rustaceanvim 是 Rust LSP 的唯一客户端
  cspell_ls = cspell_ls,
}

if has_basedpyright then
  servers.basedpyright = { settings = { basedpyright = { analysis = python_analysis } } }
  servers.pyright = { enabled = false }
else
  servers.pyright = { settings = { pyright = { analysis = python_analysis } } }
  servers.basedpyright = { enabled = false }
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      if vim.lsp.handlers then
        vim.lsp.handlers["$/progress"] = function() end
      end
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
      servers = servers,
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            Keymaps.attach.rust(bufnr)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true, buildScripts = { enable = true } },
              check = { command = "clippy", extraArgs = { "--no-deps" } },
              procMacro = { enable = true },
              files = {
                exclude = {
                  ".direnv",
                  ".git",
                  ".github",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                  ".venv",
                },
                watcher = "client",
              },
            },
          },
        },
      }
    end,
  },

  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = { enabled = true, actions = true, completion = true, hover = true },
      completion = { crates = { enabled = true } },
    },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust-analyzer", "codelldb" })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = { formatters_by_ft = { rust = { "rustfmt" } } },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = Keymaps.plugin_keys.dap,
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    keys = Keymaps.plugin_keys.dap_ui,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = Keymaps.plugin_keys.dap_python,
    config = function()
      require("dap-python").setup(vim.fn.stdpath("data") .. "/debugpy-adapter/bin/python")
      require("dap-python").resolve_python = Keymaps.python.project_python
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = { handlers = { python = function() end } },
  },

  -- LazyVim 默认只为 Fish 配置 lint；用户确认移除此插件。
  { "mfussenegger/nvim-lint", enabled = false },
}
