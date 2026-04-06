# terminal-style

macOS 终端环境一键配置：Ghostty + Zsh + Starship + MesloLGS Nerd Font

## 包含内容

| 组件 | 说明 |
|------|------|
| Ghostty | 终端模拟器 + green-eye-care 护眼主题 |
| Zsh | Shell + autosuggestions + syntax-highlighting + completions |
| Starship | 提示符 (Catppuccin Mocha 主题) |
| MesloLGS NF | Nerd Font 字体 |
| CLI 工具 | fzf, zoxide, bat, lsd, fd, ripgrep, jq |

## 一键安装

```bash
git clone git@github.com:kurosakisora/terminal-style.git
cd terminal-style
chmod +x setup.sh
./setup.sh
```

预览模式（不做任何修改）：

```bash
./setup.sh --dry-run
```

## 同步配置

修改配置后推送：

```bash
cd terminal-style
git add -A && git commit -m "update configs" && git push
```

另一台机器拉取并重新部署：

```bash
cd terminal-style && git pull && ./setup.sh
```
