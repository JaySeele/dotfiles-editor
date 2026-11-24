-- Rust LSP 与 Rust buffer-local 键位。
return {
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { rust_analyzer = { enabled = false } } },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
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
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                require("which-key").add({
                  { "<leader>r", group = "Rust", buffer = bufnr },
                  { "<leader>rc", desc = "Rust 代码动作（import / borrow 修复）", buffer = bufnr },
                  { "<leader>re", desc = "解释当前错误", buffer = bufnr },
                  { "<leader>rm", desc = "展开宏", buffer = bufnr },
                  { "<leader>ro", desc = "打开 Cargo.toml", buffer = bufnr },
                  { "<leader>rd", desc = "Rust 可调试目标", buffer = bufnr },
                })
              end
            end)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true, buildScripts = { enable = true } },
              check = { command = "clippy", extraArgs = { "--no-deps" } },
              procMacro = { enable = true },
              files = {
                exclude = { ".direnv", ".git", ".github", "bin", "node_modules", "target", "venv", ".venv" },
                watcher = "client",
              },
            },
          },
        },
      }
    end,
  },
}
