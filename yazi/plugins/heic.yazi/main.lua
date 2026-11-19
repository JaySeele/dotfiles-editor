-- heic.yazi：把 macOS 解不了的 HEIC/HEIF 转成 JPEG 再交给 yazi 显示。
-- 转换结果写进 yazi 的缓存目录（ya.file_cache），原文件不修改；
-- 缓存随 `ya cache clear` 一起清理。

local M = {}

local function exists(path)
	local f = io.open(path, "rb")
	if not f then return false end
	-- 只有非空文件才算有效，避免 sips 中途失败留下 0 字节缓存
	local size = f:seek("end") or 0
	f:close()
	return size > 0
end

-- 用 macOS 自带的 sips 转码，避免额外依赖；
-- 输出质量固定 90，足够预览，体积也远小于原图。
local function convert(src, dst)
	Command("sips")
		:arg("-s"):arg("format"):arg("jpeg")
		:arg("-s"):arg("formatOptions"):arg("90")
		:arg(src)
		:arg("--out"):arg(dst)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
	return exists(dst)
end

local function render(job, text)
	ya.preview_widget(job, ui.Text.parse(text):area(job.area))
end

function M:peek(job)
	local cache = ya.file_cache { file = job.file }
	if not cache then
		return render(job, "HEIC 预览不可用：当前目录未允许缓存")
	end

	local src, dst = tostring(job.file.url), tostring(cache)
	if not exists(dst) and not convert(src, dst) then
		return render(job, "HEIC 转换失败：sips 无法解析该文件")
	end

	ya.image_show(cache, job.area)
end

-- 静态图片没有可滚动内容，占位即可（yazi 要求 previewer 实现 seek）
function M:seek() end

return M
