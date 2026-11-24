-- Rust 调试器工具安装；rustaceanvim 会自动发现 codelldb 并注册 DAP adapter。
return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust-analyzer", "codelldb" })
    end,
  },
}
