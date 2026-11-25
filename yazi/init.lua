-- 引用各插件配置文件
-- 不写死绝对路径：依次尊重 YAZI_CONFIG_HOME / XDG_CONFIG_HOME，最后回落 ~/.config
-- 这样同一份配置在 macOS（/Users/soc）与 Debian（/home/soc）都能用
local config_dir = os.getenv("YAZI_CONFIG_HOME")
if config_dir == nil or config_dir == "" then
	config_dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/yazi"
end

dofile(config_dir .. "/cfg-full-border.lua")
dofile(config_dir .. "/cfg-relative-motions.lua")
dofile(config_dir .. "/cfg-yatline.lua")
dofile(config_dir .. "/cfg-git.lua")
