local rainbow_enabled = true
local palette = {
  Blue = "#82aaff",
  Orange = "#ff966c",
  Green = "#c3e88d",
  Violet = "#c099ff",
  Cyan = "#86e1fc",
  Yellow = "#ffc777",
  Red = "#ff757f",
}
local order = { "Blue", "Orange", "Green", "Violet", "Cyan", "Yellow", "Red" }

local function apply_rainbow_colors()
  local groups = {}
  for i, name in ipairs(order) do
    local group = "RainbowDelimiter" .. name
    vim.api.nvim_set_hl(0, group, { fg = palette[name] })
    groups[i] = group
  end
  return groups
end

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        blacklist = { "markdown", "markdown_inline", "rst", "text", "help", "vimdoc", "gitcommit", "gitrebase" },
        condition = function()
          return rainbow_enabled
        end,
        highlight = apply_rainbow_colors(),
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply_rainbow_colors,
        desc = "彩虹括号：换主题后重新套 tokyonight 的颜色",
      })
      local function set_enabled(state)
        rainbow_enabled = state
        local rainbow = require("rainbow-delimiters")
        local rb_config = require("rainbow-delimiters.config")
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
            if not state then
              rainbow.disable(buf)
            else
              local ft = vim.bo[buf].ft
              local lang = ft ~= "" and vim.treesitter.language.get_lang(ft) or nil
              if lang and rb_config.enabled_for(lang) then
                rainbow.enable(buf)
              end
            end
          end
        end
      end
      require("snacks")
        .toggle({
          id = "rainbow_brackets",
          name = "彩虹括号",
          get = function()
            return rainbow_enabled
          end,
          set = set_enabled,
          wk_desc = { enabled = "关闭", disabled = "开启" },
          notify = function(state)
            vim.notify("彩虹括号：" .. (state and "开启" or "关闭"), vim.log.levels.INFO)
          end,
        })
        :map("<leader>uR", { desc = "彩虹括号开关" })
    end,
  },
}
