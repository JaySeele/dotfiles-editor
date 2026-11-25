# dotfiles-editor

nvim · yazi

## 安装 / 重建软链

在仓库根目录执行（路径无关，仓库放哪都行）：

```bash
./install.sh
```

仓库里的 `nvim/`、`yazi/` 会整体软链到 `~/.config/`，之后编辑仓库文件即等于改生效配置。

幂等：已存在的软链打印 `ok`，目标位置是真目录则打印 `skip`（不会覆盖）。

## 撤销

```bash
rm ~/.config/{nvim,yazi}
```
