-- LSP 配置（Mac / Debian 通用，不写死平台相关路径）
--
-- 说明：下面 servers 表里出现的服务器名，LazyVim 会自动收集并交给
-- mason-lspconfig 的 ensure_installed，所以新机器只要启动一次 nvim，
-- 缺失的服务器就会被 Mason 自动装好，不需要手动 :MasonInstall。
-- 想再加语言支持：把 nvim-lspconfig 的服务器名加进这张表即可。
local data_dir = vim.fn.stdpath("data")

-- cspell 拼写检查：只有本机 Mason 装过 cspell-lsp 时才启用。
-- node 路径动态探测（旧配置写死 /Users/soc/.nvm/versions/node/v22.14.0/bin/node，
-- 换 node 版本或在 Debian 上会启动失败并报 "language server ... failed"）。
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

-- Python LSP：Mac 装的是 basedpyright，Debian 装的是 pyright
-- （basedpyright 在 Debian 上走 Mason 的 pypi 安装器会失败，所以不强求统一）。
-- 这里按「本机实际装了哪个」自动二选一，另一个显式关掉：
-- 既避免两个 Python LSP 重复诊断，也不会让 Mason 反复尝试装不上的那个。
local has_basedpyright = vim.fn.isdirectory(data_dir .. "/mason/packages/basedpyright") == 1
local python_analysis = {
  diagnosticMode = "openFilesOnly",
  typeCheckingMode = "off", -- 只报错，不报 hint 警告
  inlayHints = {
    functionReturnTypes = false, -- 不显示 -> None 等返回类型
    callArgumentNames = false, -- 不显示参数名提示
    variableTypes = false, -- 不显示变量类型提示
  },
}

-- 补全引擎的 LSP 能力：blink.cmp 需要 server 在补全项里下发 detail / data，
-- 否则懒加载详情、自动导入信息这类需要 resolve 的内容拿不到。
-- Neovim 会把它和 make_client_capabilities() 深合并（client.lua 的 tbl_deep_extend），
-- 所以这里只给 blink 的增量片段；LazyVim 默认的 workspace.fileOperations 由 opts 合并保留。
-- pcall 兜底：插件还没装好（新机器首次启动 / 同步配置到 Debian 的第一天）时
-- 退回 Neovim 默认能力，不因为一个 require 失败把整个 LSP 配置带崩。
local blink_capabilities
do
  -- 整段包 pcall（而不是只包 require）：blink 跟的是 version="*"，升级改了 API 名时
  -- 调用会抛错，而这段代码在 lazy 收集 spec 的顶层执行，未捕获的错误会直接让 nvim 起不来。
  -- 拿不到就退回 Neovim 默认能力（只少 detail/data，补全照常工作）。
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
    keys = {
      -- 禁用 LazyVim 默认的 K = hover（K 已在 config/keymaps.lua 里全局改成「向上滚动 10 行」）
      { "K", false },
      -- 禁用 LazyVim 默认的 gr = references（它带 nowait）：gr 一旦是「完整映射」，
      -- 按 g r 就立刻弹引用列表，后面再按 n 已经晚了 —— grn / gra / gri / grt / grx
      -- 整个 gr* 家族都被它吃掉，which-key 也永远展开不出 gr 子菜单。
      -- 关掉后 gr 回到纯前缀，references 挪到 grr（见 plugins/ui/snacks.lua）。
      { "gr", false },
      -- 禁用 code lens 相关键位（Run Codelens / Refresh & Display Codelens）
      -- 原理：lazy 的 keys.resolve 遇到 rhs=false 会把同 mode:lhs 的默认项从列表里删掉
      { "<leader>cc", false, mode = { "n", "x" } },
      { "<leader>cC", false },
    },
  },

  -- ── Python ──────────────────────────────────────────────
  ruff = {
    enabled = true,
    autostart = true,
    init_options = {
      settings = {
        fixAll = true, -- 启用自动修复
        lint = { enabled = false }, -- 关键配置：禁用 Ruff 的 Lint 功能
      },
    },
  },

  -- ── 配置 / 脚本类文件 ────────────────────────────────────
  jsonls = {}, -- .json / .jsonc
  yamlls = { -- .yaml / .yml（docker compose 等）
    settings = {
      yaml = {
        schemaStore = { enable = false }, -- 关掉 schemastore 联网拉取，避免国内网络下卡住
        schemas = {},
      },
    },
  },
  taplo = {}, -- .toml
  bashls = { -- .sh / .bash / .zsh
    filetypes = { "bash", "sh", "zsh" },
  },
  vimls = {}, -- .vim
  dockerls = {}, -- Dockerfile

  -- ── 前端 / 文档 ─────────────────────────────────────────
  cssls = {}, -- .css / .scss
  html = {}, -- .html
  ts_ls = {}, -- .js / .ts / .tsx
  marksman = {}, -- .md（需要在 git 仓库或含 .marksman.toml 的目录里才会启动）

  -- 关掉历史遗留的重复服务器（装了但用不上，避免一个文件挂好几个 LSP）
  csskit = { enabled = false },
  css_variables = { enabled = false },
  cssmodules_ls = { enabled = false },

  -- 拼写检查（仅当本机已装 cspell-lsp 时生效）
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
      -- 禁用 LSP 进度提示（右下角不再弹 basedpyright 之类的进度）
      if vim.lsp.handlers then
        vim.lsp.handlers["$/progress"] = function() end
      end
    end,
    opts = {
      -- 覆盖 LazyVim 默认的诊断配置：只显示 error 和 warning，隐藏 hint
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
}
