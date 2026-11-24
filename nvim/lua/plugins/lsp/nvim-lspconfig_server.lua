-- 与具体语言领域无关的 LSP server 配置。
local data_dir = vim.fn.stdpath("data")
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

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {},
        yamlls = {
          settings = { yaml = { schemaStore = { enable = false }, schemas = {} } },
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
        cspell_ls = cspell_ls,
      },
    },
  },
}
