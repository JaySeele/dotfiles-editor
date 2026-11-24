-- Cargo.toml 依赖补全、hover 和版本操作。
return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = { enabled = true, actions = true, completion = true, hover = true },
      completion = { crates = { enabled = true } },
    },
  },
}
