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
}
