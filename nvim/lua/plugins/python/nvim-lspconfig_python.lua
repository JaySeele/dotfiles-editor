-- Python basedpyright：仅在 Mason 已安装时启用。
local data_dir = vim.fn.stdpath("data")
local enabled = vim.fn.isdirectory(data_dir .. "/mason/packages/basedpyright") == 1
-- Python pyright：basedpyright 不存在时作为兼容后备。
local has_basedpyright = vim.fn.isdirectory(data_dir .. "/mason/packages/basedpyright") == 1

local analysis = {
  diagnosticMode = "openFilesOnly",
  typeCheckingMode = "off",
  inlayHints = {
    functionReturnTypes = false,
    callArgumentNames = false,
    variableTypes = false,
  },
}

-- Python Ruff LSP：提供自动修复，不启用重复的 Ruff lint 诊断。
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = enabled and { settings = { basedpyright = { analysis = analysis } } } or { enabled = false },
        pyright = has_basedpyright and { enabled = false } or { settings = { pyright = { analysis = analysis } } },
        ruff = {
          enabled = true,
          autostart = true,
          init_options = { settings = { fixAll = true, lint = { enabled = false } } },
        },
      },
    },
  },
}
