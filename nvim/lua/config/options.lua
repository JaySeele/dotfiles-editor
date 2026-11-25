-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- 主题 使用 tokyonight
vim.g.tokyonight_style = "moon" -- storm, moon, night, day
vim.g.tokyonight_transparent = true

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 软换行（长行自动折行显示，不修改实际内容）
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪ "

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")

-- 远程兜底：ssh 到 Debian 这类机器时，Neovim 的剪贴板 provider 不可用，
-- yy 只进 "0，yank 永远到不了系统剪贴板。这时改用 OSC 52：把内容编码成
-- ESC ] 52 ; c ; <base64> ESC \ 写进终端流，由本地终端（kitty）写进 Mac 的剪贴板，
-- 远端不需要装任何工具。Neovim 0.12 内置了这个 provider，官方开关就是
-- 把 g:clipboard 设成字符串 "osc52"。
--
-- ⚠️ 两个坑（都踩过）：
-- 1) 判断「有没有可用 provider」不要调 provider#clipboard#Executable()：那个 autoload
--    脚本结尾会执行一次探测并把 g:loaded_clipboard_provider 定成 0，之后即使再设
--    g:clipboard 也不生效（yy 照样不进剪贴板）。这里只查环境变量和可执行文件。
-- 2) 光看 WAYLAND_DISPLAY/DISPLAY 不够：Debian 的 zshrc 会自动扫描
--    $XDG_RUNTIME_DIR/wayland-* 并 export WAYLAND_DISPLAY，所以 ssh 会话里这个变量
--    也有值——但它指向的是服务器自己桌面（niri）的 socket，写进去的是服务器的剪贴板，
--    不是 Mac 的。因此「远程 + kitty」直接走 OSC 52，不看 display。
do
  local function env(name)
    local v = vim.env[name]
    return v ~= nil and v ~= ""
  end

  local function has_native_provider()
    if vim.fn.has("mac") == 1 then
      return true -- pbcopy
    end
    if env("WAYLAND_DISPLAY") then
      return vim.fn.executable("wl-copy") == 1 or vim.fn.executable("waycopy") == 1
    end
    if env("DISPLAY") then
      return vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1
    end
    return false
  end

  local in_kitty = env("KITTY_WINDOW_ID") or vim.env.TERM == "xterm-kitty"
  local remote = env("SSH_CONNECTION") or env("SSH_TTY")

  if (remote and in_kitty) or not has_native_provider() then
    vim.g.clipboard = "osc52"
  end
end

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 按键超时 (默认 1000ms)
opt.timeoutlen = 1000

-- 不区分大小写搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

-- gf (goto file): 智能打开光标下的文件路径
opt.suffixesadd:append({
  ".lua",
  ".ts",
  ".tsx",
  ".js",
  ".jsx",
  ".py",
  ".go",
  ".rs",
  ".c",
  ".h",
  ".cpp",
  ".hpp",
  ".css",
  ".scss",
  ".json",
  ".yaml",
  ".yml",
  ".toml",
  ".md",
  ".vim",
  ".sh",
  ".bash",
  ".zsh",
})
opt.path:append("**")
