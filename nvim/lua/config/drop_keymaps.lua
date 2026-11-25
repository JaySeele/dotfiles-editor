-- 要删掉的 LazyVim / 插件默认键位
-- 被 lua/config/keymaps.lua 引用；把 M.apply() 那行注释掉即可全部恢复。
-- 菜单里显示的中文名在 lua/plugins/ui/which-key.lua。
--
-- ⚠️ 时机说明（2026-11-25 实测修好的坑）：
--   LazyVim 的 <leader> 键位并不都在启动时注册：一部分在 VeryLazy 之后，
--   还有一部分要等插件真正被加载（lazy.nvim 的 keys 占位 / config 里 map）才出现。
--   只在启动时 vim.schedule 删一轮，实测 140 项里仍有 72 项活着（bb / sg / sw …），
--   而 pcall 会把“映射不存在”的错误吞掉，所以表现为“删了但没生效”。
--   现在改成：启动、VeryLazy、每次插件加载（LazyLoad）、BufWinEnter、LspAttach 各删一轮，
--   并在启动后 3s 兜底清一遍所有已加载 buffer 的本地键。
--
-- ⚠️ 这个列表里的键不要再在别处（keymaps.lua / 插件 keys）定义：
--    后面几轮 drop 会把它们一起删掉，表现为“我明明映射了却没反应”。
--
-- 注释来源：2026-11-25 从真实会话把每个键注册后的 desc 抓出来整理的（LSP/picker 类
-- 键是 buffer-local，当时会随插件加载出现）；标“旧残留”的是当前配置里已经查不到的。
-- 加/删键位时请顺手维护这条注释，方便判断还能不能删。
--
-- 排列规则：各板块内部按字母序（不分大小写；同一字母时小写在前，如 bp→bP、gi→gI）；
--           单键 / 符号段按 ASCII 排（符号 → 大写 → 小写），单字符这样更好读。

local M = {}

-- 只写 <leader> 后面的部分（不带 <leader> 前缀）
-- stylua: ignore
M.keys = {
    -- ── 单键 / 符号 ──────────────────────────────────────────────
    ",", -- 缓冲区列表
    -- "-", -- 在当前文件中打开 yazi（保留：yazi.lua 自己定义的键，不能删）
    "|", -- 垂直分屏
    ".", -- 切换临时缓冲区（scratch buffer）
    "/", -- 切换终端
    ":", -- 命令历史
    "E", -- 文件树（cwd）
    "K", -- Keywordprg：用 man 之类查光标下的词
    "N", -- ⚠️ 旧残留：当前配置里没有这个键
    "S", -- 选择临时缓冲区（从列表里挑一个 scratch）
    "Z", -- 切换缩放（zoom）
    "`", -- 在缓冲区之间切换
    "l", -- Lazy（插件管理器）
    "n", -- 通知历史
    "z", -- 切换禅模式（zen）

    -- ── 缓冲区 ───────────────────────────────────────────────────
    -- 注意：bd 不在列表里（保留，见 keymaps.lua）
    "bb", -- 在缓冲区之间切换
    "bD", -- 关闭缓冲区并关掉它的窗口
    "bi", -- 删除所有不可见缓冲区
    "bj", -- 从列表里挑一个缓冲区跳过去
    "bl", -- 删除左侧所有缓冲区
    "bo", -- 删除其它所有缓冲区
    "bp", -- 固定 / 取消固定当前缓冲区
    "bP", -- 只删除非固定（pinned）缓冲区
    "br", -- 删除右侧所有缓冲区

    -- ── 代码 / LSP ───────────────────────────────────────────────
    "ca", -- 代码操作（修复 / 重构）
    "cA", -- 一键执行 Source 类操作（整理 import 等）
    "cd", -- 当前行的诊断详情
    -- "cf", -- 格式化当前文件
    "cF", -- 格式化注入语言(如 md 里的代码块)
    "cl", -- Lsp Info
    "cR", -- 重命名当前文件（buf-local）
    "cs", -- 文档符号列表（Trouble）
    "cS", -- LSP 引用 / 定义列表（Trouble）
    -- "cw", -- 在 nvim 工作目录打开文件管理器

    -- ── 查找（picker） ───────────────────────────────────────────
    "fb", -- 缓冲区列表
    "fB", -- 缓冲区列表（全部）
    "fc", -- 查找配置文件
    "fe", -- 文件树（项目根）
    "fE", -- 文件树（cwd）
    "fF", -- 查找文件（cwd）
    "fg", -- 查找 Git 文件
    "fn", -- 新建文件
    "fp", -- 项目列表
    "fr", -- 最近文件
    "fR", -- 最近文件（cwd）
    "ft", -- 终端（项目根）
    "fT", -- 终端（cwd）

    -- ── Git ──────────────────────────────────────────────────────
    "gb", -- 当前行的 git blame
    "gd", -- Git 差异（文件 / hunk）
    "gD", -- 与 origin 的差异
    -- "gf", -- Pathfinder 接管 gf / <leader>gf，不再由 drop 删除
    -- "gg", -- Lazygit（已恢复使用，见 snacks.lua；留在清单会被启动时删掉）
    "gG", -- Lazygit（cwd）
    "gl", -- Git Log
    "gL", -- Git Log（cwd）
    -- "gs", -- Git 状态（保留：snacks.lua 自己定义的键，不能删）
    "gS", -- Git 暂存（stash）

    -- ── 搜索列表（sk 保留 = 快捷键查询器，不在本表） ──────────────
    's"', -- 寄存器列表
    "s/", -- 搜索历史
    "sa", -- 自动命令（autocmd）列表
    "sb", -- 当前缓冲区的行
    "sB", -- 搜索已打开的缓冲区
    "sc", -- 命令历史
    "sC", -- 命令列表
    "sd", -- 诊断信息
    "sD", -- 当前缓冲区的诊断
    -- "sG", -- 全局搜索 grep（cwd）
    "sh", -- 帮助页面
    "sH", -- 高亮组列表
    "si", -- 图标列表
    "sj", -- 跳转列表（jumplist）
    "sl", -- 位置列表（location list）
    "sm", -- 标记（marks）列表
    "sM", -- man 手册页
    "sp", -- 搜索插件 spec
    "sq", -- 快速修复列表（quickfix）
    "sr", -- 搜索替换（grug-far）
    "sR", -- 恢复上一次搜索
    "ss", -- 文档符号（LSP，buf-local）
    "sS", -- LSP 工作区符号（buf-local）
    "st", -- Todo 列表
    "sT", -- Todo/FIX/FIXME 搜索
    "su", -- 撤销历史（undotree）
    "sW", -- 用选中的内容 / 光标下的词搜索（cwd）

    -- ── 界面开关 ─────────────────────────────────────────────────
    "ua", -- 动画开关
    "uA", -- 标签栏显示开关
    "ub", -- 深色背景开关
    "uc", -- conceal 级别
    -- "uC", -- 配色方案（保留：snacks.lua 自己定义的键，不能删）
    "ud", -- 诊断显示开关
    "uD", -- 暗化非聚焦窗口
    "uf", -- 自动格式化开关（全局）
    "uF", -- 自动格式化开关（当前 buffer）
    "ug", -- 缩进参考线
    "uh", -- inlay hints（内联提示）
    "ui", -- 光标位置的语法节点信息
    "uI", -- 语法树（treesitter）查看器
    "ul", -- 行号开关
    "uL", -- 相对行号开关
    "un", -- 关闭所有通知
    "up", -- 自动括号（mini.pairs）
    "ur", -- 重绘 / 清除搜索高亮 / 更新 diff
    "us", -- 拼写检查开关
    "uS", -- 平滑滚动
    "uT", -- treesitter 高亮开关
    "uw", -- 自动换行开关
    "uz", -- 禅模式（zen）
    "uZ", -- 缩放模式（zoom）

    -- ── 窗口 ─────────────────────────────────────────────────────
    "wm", -- 缩放模式（与 uZ / Z 重复，属于多余项）
    "wq", -- ⚠️ 旧残留：当前配置里没有这个键

    -- ── 诊断 / 列表（Trouble 等） ────────────────────────────────
    "xl", -- 位置列表
    "xL", -- 位置列表（Trouble）
    "xq", -- 快速修复列表
    "xQ", -- 快速修复列表（Trouble）
    "xt", -- Todo（Trouble）
    "xT", -- Todo/FIX/FIXME（Trouble）
    "xx", -- 诊断列表（Trouble）
    "xX", -- 当前缓冲区的诊断（Trouble）

    -- ── 开发向 / 需要特定环境：Profiler、Noice、会话、标签页、GitHub ──
    "<Tab><Tab>", -- 新建标签页
    "<Tab>[", -- 上一个标签页
    "<Tab>]", -- 下一个标签页
    "<Tab>d", -- 关闭标签页
    "<Tab>f", -- 第一个标签页
    "<Tab>l", -- 最后一个标签页
    "<Tab>o", -- 关闭其它标签页
    "dph", -- profiler 高亮开关
    "dpp", -- 启动 / 停止 profiler
    "dps", -- profiler 临时缓冲区
    "gB", -- 在浏览器打开当前文件（Git Browse）
    "gi", -- GitHub issues（open）
    "gI", -- GitHub issues（all）
    "gp", -- GitHub PR（open）
    "gP", -- GitHub PR（all）
    "gY", -- 复制当前文件的浏览地址
    "qd", -- 不保存当前会话
    "ql", -- 恢复上一次会话
    "qs", -- 恢复会话
    "qS", -- 选择会话
    "sn", -- noice 子菜单
    "sna", -- noice 全部消息
    "snd", -- 关闭所有消息
    "snh", -- noice 历史
    "snl", -- 最后一条消息
    "snt", -- noice 消息选择器
}

local MODES = { "n", "v", "x", "t" }

-- 删一轮：buf 为 nil 时删全局映射，给 buf 时同时删该 buffer 的本地映射
local function drop(buf)
  for _, k in ipairs(M.keys) do
    local lhs = "<leader>" .. k
    for _, mode in ipairs(MODES) do
      pcall(vim.keymap.del, mode, lhs)
      if buf then
        pcall(vim.keymap.del, mode, lhs, { buffer = buf })
      end
    end
  end
end

-- 全局 + 当前 buffer（有些插件把 <leader> 键设成 buffer-local，比如 LSP 键 / picker 键）
local function drop_now()
  drop()
  drop(vim.api.nvim_get_current_buf())
end

-- 合并同一轮里的多次触发（启动时几十个插件会连续触发 LazyLoad）
local pending = false
local function drop_soon()
  if pending then
    return
  end
  pending = true
  vim.schedule(function()
    pending = false
    drop_now()
  end)
end

function M.apply()
  -- ① 启动时已经注册的，先删掉，别留可用窗口
  drop_soon()

  -- ② VeryLazy：LazyVim 大部分默认 <leader> 键位到这一刻才注册
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      drop_soon()
      vim.defer_fn(drop_now, 500) -- 覆盖 VeryLazy 之后紧跟着加载的插件
    end,
  })

  -- ③ 每次插件加载后再删一轮（lazy.nvim 的 keys 占位和插件 config 里的 map 都在这之后才出现）
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = drop_soon,
  })

  -- ④ 切到新 buffer 时补删它自己的本地键（LSP / 文件类型插件常在这里注册）
  vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = drop_soon,
  })

  -- ⑤ LSP 的 buffer 内键位在 attach 时才注册
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      drop(ev.buf)
    end,
  })

  -- ⑥ 兜底：启动后 3s 把所有已加载 buffer 的本地键也清一遍
  vim.defer_fn(function()
    drop()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(b) then
        drop(b)
      end
    end
  end, 3000)
end

return M
