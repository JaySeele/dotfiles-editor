-- 补全引擎：blink.cmp
--
-- 它本身不需要在这里「安装」——LazyVim v16 的默认 extra 机制发现 spec 里声明了
-- saghen/blink.cmp，就会把 lua/lazyvim/plugins/extras/coding/blink.lua 作为默认补全
-- extra 自动挂上（`LazyVim.config.get_default("cmp")` 返回 origin = "default"）。
-- 判定依据是 checks.cmp 里「装了哪个补全引擎」，16.0.2 里 vim.g.lazyvim_cmp 已无人读取。
-- sources 的 lsp/snippets/path/buffer 默认值、lazydev 源、friendly-snippets 依赖都来自那里。
--
-- ⚠️ 不要再写自定义 config = function(_, opts) require("blink.cmp").setup(opts) end：
-- 那会整个顶掉 extra 的 config 函数，而后者负责
--   1) 把 sources.compat 置 nil —— 否则每次启动弹
--      "blink.cmp sources → compat Unexpected field in configuration!"
--   2) 把 snippets.expand 换成 LazyVim.cmp.expand —— 带 snippet 容错兜底
-- 只在这里覆盖 opts 字段即可，setup 交给 extra。
return {
  {
    "saghen/blink.cmp",
    dependencies = { "xzbdmw/colorful-menu.nvim", opts = {} },
    completion = {
      -- xzbdmw/colorful-menu.nvim 美化blink配置
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
      trigger = {
        -- 进入插入模式立即触发补全请求，预热 LSP
        show_on_insert = true,
        -- 退格回到关键词内时重新触发补全
        show_on_backspace_in_keyword = true,
      },
    },
    sources = {
      providers = {
        -- buffer 即时补全给高分，确保输入 1-2 字符就有反馈
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 5,
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            -- 注意：blink.cmp 1.x 的字段名是 show_hidden_files_by_default，
            -- 写成 show_hidden 会被它的配置校验拒绝并提示
            -- "sources → providers → path → show_hidden Unexpected field in configuration!"
            show_hidden_files_by_default = false,
          },
        },
      },
      per_filetype = {
        kitty = { "path", "buffer", "snippets" },
        conf = { "path", "buffer", "snippets" },
      },
      opts = {
        keymap = {
          preset = "enter",
          ["<CR>"] = { "accept", "fallback" },

          ["<Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            "snippet_forward",
            "fallback",
          },

          ["<S-Tab>"] = { "snippet_backward", "fallback" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        },
      },
    },
  },
}
