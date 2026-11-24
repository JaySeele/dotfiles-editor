-- 按领域导入插件；每个领域内部再按“一个插件/模块一个文件”维护。
return {
  { import = "plugins.rust" },
  { import = "plugins.python" },
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.ui" },
  { import = "plugins.tools" },
  { import = "plugins.markdown" },
  { import = "plugins.notes" },
  { import = "plugins.syntax" },
}
