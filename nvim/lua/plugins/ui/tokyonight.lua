return {
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
}
