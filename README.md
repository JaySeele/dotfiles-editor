# dotfiles-editor

nvim · yazi

## 安装 / 重建软链

```bash
~/dotfiles/editor/install.sh
```

幂等：已存在的软链打印 `ok`，目标位置是真目录则打印 `skip`（不会覆盖）。

## 撤销

```bash
rm ~/.config/{nvim,yazi}
```
