return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        -- 取 lualine 的 auto 主题并清除分段底色，适配透明背景。
        theme = function()
          local theme = require("lualine.utils.loader").load_theme("auto")
          local function bright(color)
            if type(color) ~= "string" or not color:match("^#%x%x%x%x%x%x$") then
              return nil
            end
            local r = tonumber(color:sub(2, 3), 16)
            local g = tonumber(color:sub(4, 5), 16)
            local b = tonumber(color:sub(6, 7), 16)
            return (r * 2 + g * 3 + b) / 6 / 256
          end
          for _, sections in pairs(theme) do
            for name, section in pairs(sections) do
              if type(section) == "table" then
                local fg, bg = bright(section.fg), bright(section.bg)
                if name == "a" and fg and bg and bg > fg then
                  section.fg = section.bg
                end
                section.bg = nil
              end
            end
          end
          return theme
        end,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      },
    },
  },
}
