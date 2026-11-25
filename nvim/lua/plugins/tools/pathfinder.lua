-- Pathfinder 的 includeexpr：将 Lua / TypeScript 模块路径解析为实际文件。
-- 例如 require("a.b.c") -> a/b/c.lua 或 a/b/c.ts。
--
-- Vim 的 includeexpr 是 Ex 表达式字符串，不能直接传 Lua 局部函数；
-- 因此把函数挂到 Pathfinder 专用的全局入口，再由 includeexpr 调用。
_G.pathfinder_includeexpr = function()
  local file = vim.fn.expand("<cfile>")
  if file:match("%.") then
    local transformed = file:gsub("%.", "/")
    local full = vim.fn.findfile(transformed .. ".lua")
    if full ~= "" then
      return full
    end
    full = vim.fn.findfile(transformed .. ".ts")
    if full ~= "" then
      return full
    end
  end
  return file
end

return {
  {
    "HawkinsT/pathfinder.nvim",
    lazy = false,
    config = function()
      require("pathfinder").setup({
        -- 接管 gf / gF / gx，并启用 <leader>gf / <leader>gF / <leader>gx 选择器。
        remap_default_keys = true,
        -- 保留原 gf 对 Lua / TypeScript 模块路径的解析逻辑。
        -- includeexpr 是 Vim 选项，必须传 Ex 表达式字符串而不是 Lua 函数。
        includeexpr = "v:lua.pathfinder_includeexpr()",
        -- 多个同名目标出现时提供选择，而不是静默打开第一个。
        offer_multiple_options = true,
        -- 选择器允许扫描所有可见窗口。
        pick_from_all_windows = true,
      })
    end,
  },
}
