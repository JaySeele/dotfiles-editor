-- 界面与导航插件配置；动作键位和 which-key 文案统一来自 config.keymaps。
local Keymaps = require("config.keymaps")

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
local rainbow_order = { "Blue", "Orange", "Green", "Violet", "Cyan", "Yellow", "Red" }

local function apply_rainbow_colors()
  local groups = {}
  for i, name in ipairs(rainbow_order) do
    local group = "RainbowDelimiter" .. name
    vim.api.nvim_set_hl(0, group, { fg = palette[name] })
    groups[i] = group
  end
  return groups
end

return {
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = Keymaps.plugin_keys.outline,
    opts = {},
  },

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

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = true,
      terminal_colors = true,
    },
    init = function()
      local groups = {
        "NormalFloat",
        "NormalSB",
        "FloatBorder",
        "FloatTitle",
        "FloatFooter",
        "FloatShadow",
        "FloatShadowThrough",
        "Pmenu",
        "PmenuMatch",
        "StatusLine",
        "StatusLineNC",
        "WinBar",
        "WinBarNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "MsgArea",
        "MsgSeparator",
        "BlinkCmpMenu",
        "BlinkCmpMenuBorder",
        "BlinkCmpDoc",
        "BlinkCmpDocBorder",
        "BlinkCmpSignatureHelp",
        "BlinkCmpSignatureHelpBorder",
        "SnacksPickerBoxBorder",
        "SnacksPickerListBorder",
        "SnacksPickerInputBorder",
        "SnacksPickerBoxTitle",
        "SnacksPickerListTitle",
        "SnacksPickerInputTitle",
        "SnacksTitle",
        "WhichKeyNormal",
        "TroubleNormal",
        "SignColumnSB",
        "LspInfoBorder",
      }
      local prefixes = { "^lualine_", "^TroubleStatusline" }
      local function wanted(name)
        for _, prefix in ipairs(prefixes) do
          if name:match(prefix) then
            return true
          end
        end
        return vim.tbl_contains(groups, name)
      end
      local function bg_as_fg(name)
        return name == "TabLineSel" or (name:match("^lualine_a_") and name ~= "lualine_a_inactive")
      end
      local function strip_ui_bg()
        for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
          if wanted(name) and hl.bg then
            if bg_as_fg(name) then
              hl.fg = hl.bg
              hl.ctermfg = nil
            end
            hl.bg = "NONE"
            hl.ctermbg = nil
            hl.default = nil
            vim.api.nvim_set_hl(0, name, hl)
          end
        end
      end
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.schedule(strip_ui_bg)
        end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(strip_ui_bg)
        end,
      })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(strip_ui_bg)
        end,
      })
    end,
  },

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
      Keymaps.attach.rainbow_toggle(function()
        return rainbow_enabled
      end, set_enabled)
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",
    opts = {},
  },

  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      delay = 0,
      spec = Keymaps.which_key.spec,
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    opts = {},
  },
}
