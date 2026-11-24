-- Rust 保存格式化：LazyVim Conform 统一管理保存 hook。
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = { formatters_by_ft = { rust = { "rustfmt" } } },
  },
}
