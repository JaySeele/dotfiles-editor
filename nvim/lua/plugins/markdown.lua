-- Markdown 渲染、表格编辑和图片显示。
return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    -- image.nvim 自带 rockspec；使用 magick_cli，不触发 hererocks 构建。
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "quarto" },
        },
      },
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,
    },
  },

  {
    "Kicamon/markdown-table-mode.nvim",
    config = function()
      require("markdown-table-mode").setup()
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    ft = { "markdown", "quarto" },
    enabled = true,
    opts = {
      render_modes = true,
      lsp = { enabled = true },
      coq = { enabled = true },
      heading = { position = "inline" },
      paragraph = {
        enabled = true,
        render_modes = false,
        left_margin = 0,
        indent = 0,
        min_width = 0,
      },
      code = { sign = false },
      dash = {
        enabled = true,
        render_modes = false,
        icon = "─",
        width = "full",
        left_margin = 0,
        priority = nil,
        highlight = "RenderMarkdownDash",
      },
      bullet = {
        enabled = true,
        render_modes = false,
        icons = { "●", "○", "◆", "◇" },
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value)
          local index = tonumber(value:sub(1, #value - 1))
          return ("%d."):format(index > 1 and index or ctx.index)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = "RenderMarkdownBullet",
        scope_highlight = {},
        scope_priority = nil,
      },
      checkbox = {
        unchecked = { icon = "✘ " },
        checked = { icon = "✔ " },
        custom = { todo = { rendered = "◯ " } },
      },
      quote = {
        enabled = true,
        render_modes = false,
        icon = "▋",
        repeat_linebreak = false,
        highlight = {
          "RenderMarkdownQuote1",
          "RenderMarkdownQuote2",
          "RenderMarkdownQuote3",
          "RenderMarkdownQuote4",
          "RenderMarkdownQuote5",
          "RenderMarkdownQuote6",
        },
      },
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo", category = "github" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess", category = "github" },
        important = {
          raw = "[!IMPORTANT]",
          rendered = "󰅾 Important",
          highlight = "RenderMarkdownHint",
          category = "github",
        },
        warning = {
          raw = "[!WARNING]",
          rendered = "󰀪 Warning",
          highlight = "RenderMarkdownWarn",
          category = "github",
        },
        caution = {
          raw = "[!CAUTION]",
          rendered = "󰳦 Caution",
          highlight = "RenderMarkdownError",
          category = "github",
        },
        abstract = {
          raw = "[!ABSTRACT]",
          rendered = "󰨸 Abstract",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        summary = {
          raw = "[!SUMMARY]",
          rendered = "󰨸 Summary",
          highlight = "RenderMarkdownInfo",
          category = "obsidian",
        },
        tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo", category = "obsidian" },
        info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo", category = "obsidian" },
        todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo", category = "obsidian" },
        hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess", category = "obsidian" },
        success = {
          raw = "[!SUCCESS]",
          rendered = "󰄬 Success",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        check = {
          raw = "[!CHECK]",
          rendered = "󰄬 Check",
          highlight = "RenderMarkdownSuccess",
          category = "obsidian",
        },
        done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess", category = "obsidian" },
        question = {
          raw = "[!QUESTION]",
          rendered = "󰘥 Question",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn", category = "obsidian" },
        faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn", category = "obsidian" },
        attention = {
          raw = "[!ATTENTION]",
          rendered = "󰀪 Attention",
          highlight = "RenderMarkdownWarn",
          category = "obsidian",
        },
        failure = {
          raw = "[!FAILURE]",
          rendered = "󰅖 Failure",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError", category = "obsidian" },
        missing = {
          raw = "[!MISSING]",
          rendered = "󰅖 Missing",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        danger = {
          raw = "[!DANGER]",
          rendered = "󱐌 Danger",
          highlight = "RenderMarkdownError",
          category = "obsidian",
        },
        error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError", category = "obsidian" },
        bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError", category = "obsidian" },
        example = {
          raw = "[!EXAMPLE]",
          rendered = "󰉹 Example",
          highlight = "RenderMarkdownHint",
          category = "obsidian",
        },
        quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote", category = "obsidian" },
        cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote", category = "obsidian" },
      },
      link = {
        enabled = true,
        render_modes = false,
        footnote = {
          enabled = true,
          icon = "󰯔 ",
          body = function(ctx)
            return ctx.text
          end,
          superscript = true,
          prefix = "",
          suffix = "",
        },
        image = "󰥶 ",
        image_custom = true,
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
        highlight_title = "RenderMarkdownLinkTitle",
        wiki = {
          enabled = true,
          icon = "󱗖 ",
          conceal_destination = true,
          body = function()
            return nil
          end,
          highlight = "RenderMarkdownWikiLink",
          scope_highlight = nil,
        },
        custom = {
          web = { icon = "󰖟 ", pattern = "^http" },
          apple = { icon = " ", pattern = "apple%.com", kind = "url" },
          discord = { icon = "󰙯 ", pattern = "discord%.com", kind = "url" },
          github = { icon = "󰊤 ", pattern = "github%.com", kind = "url" },
          gitlab = { icon = "󰮠 ", pattern = "gitlab%.com", kind = "url" },
          google = { icon = "󰊭 ", pattern = "google%.com", kind = "url" },
          hackernews = { icon = " ", pattern = "ycombinator%.com", kind = "url" },
          linkedin = { icon = "󰌻 ", pattern = "linkedin%.com", kind = "url" },
          microsoft = { icon = " ", pattern = "microsoft%.com", kind = "url" },
          neovim = { icon = " ", pattern = "neovim%.io", kind = "url" },
          reddit = { icon = "󰑍 ", pattern = "reddit%.com", kind = "url" },
          slack = { icon = "󰒱 ", pattern = "slack%.com", kind = "url" },
          stackoverflow = { icon = "󰓌 ", pattern = "stackoverflow%.com", kind = "url" },
          steam = { icon = " ", pattern = "steampowered%.com", kind = "url" },
          twitter = { icon = " ", pattern = "twitter%.com", kind = "url" },
          wikipedia = { icon = "󰖬 ", pattern = "wikipedia%.org", kind = "url" },
          x = { icon = " ", pattern = "x%.com", kind = "url" },
          youtube = { icon = "󰗃 ", pattern = "youtube[^.]*%.com", kind = "url" },
          youtube_short = { icon = "󰗃 ", pattern = "youtu%.be", kind = "url" },
        },
      },
      sign = { enabled = true, priority = nil, highlight = "RenderMarkdownSign" },
      indent = {
        enabled = false,
        render_modes = false,
        per_level = 2,
        skip_level = 1,
        skip_heading = false,
        icon = "▎",
        priority = 0,
        highlight = "RenderMarkdownIndent",
      },
    },
  },
}
