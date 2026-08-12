# Zsh Config

[**English**](README.md) | [**中文**](README_zh-CN.md)

基于 [Zim](https://github.com/zimfw/zimfw) 的模块化 Zsh 配置，启动约 70ms，函数按需加载，支持 Linux 与 WSL2。

## 特性

- **命令提示符：** [Powerlevel10k](https://github.com/romkatv/powerlevel10k)，支持即时提示
- **补全：** [fzf-tab](https://github.com/Aloxaf/fzf-tab) 模糊补全，`zsh-completions` 补充定义
- **自动建议：** 基于历史命令
- **语法高亮：** Catppuccin Mocha 配色
- **导航：** [zoxide](https://github.com/ajeetdsouza/zoxide) 按使用频率跳转（`z`），`fzf` 模糊搜索
- **工具链：** [mise](https://mise.jdx.dev) 管理 Node、Python、Go、Bun 等运行时版本
- **自定义函数：** `extract`、`pac`、`sudo-command-line`、`open`（见下表）
- **WSL2：** 自动检测，启用 d3d12 GPU 加速，连接 Windows ssh-agent
- **模块化：** `conf.d/` 按字母序加载，不适用的模块自动跳过

## 前置要求

- Zsh ≥ 5.9
- [Zim](https://github.com/zimfw/zimfw)（首次启动自动安装）
- [Git](https://git-scm.com)
- 可选：`curl` 或 `wget`（用于首次下载 Zim）

## 安装

### 1. 克隆仓库

```zsh
git clone https://github.com/hu3rror/zsh-config.git ~/.config/zsh
```

### 2. 重定向 ZDOTDIR（必需）

Zsh 启动时最先读取 `~/.zshenv`。创建此文件，把 ZDOTDIR 指到配置目录：

```zsh
# ~/.zshenv
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
```

没有这行，Zsh 会读取默认的 `~/.zshrc`，永远找不到这个配置。

### 3. 启动 Zsh

```zsh
exec zsh
```

首次启动会自动下载 Zim 模块。

### 自定义函数

| 函数 | 说明 | 快捷键 |
|------|------|--------|
| `extract`（别名 `x`） | 自动识别并解压任何归档格式 | — |
| `sudo-command-line` | 在当前命令前切换 `sudo` 前缀 | `⎋ ⎋`（双击 Esc） |
| `pac` | pacman/paru 交互式包管理助手 | — |
| `open` | 用系统默认应用打开文件/目录 | — |

## 项目结构

```
~/.config/zsh/
├── .zshrc           # 入口：按字母序加载 conf.d/
├── .zshenv          # 环境变量、PATH 构建
├── .zimrc           # Zim 模块声明
├── .p10k.zsh        # Powerlevel10k 主题配置
├── conf.d/          # 模块化配置文件
│   ├── 00-util.zsh       # 工具函数（command_is_available）
│   ├── 10-wsl2.zsh       # WSL2 优化（其他环境跳过）
│   ├── 20-options.zsh    # Shell 选项 & 快捷键
│   ├── 22-history.zsh    # 历史记录设置
│   ├── 24-syntax-highlight.zsh  # 语法高亮样式
│   ├── 26-fzf-tab.zsh    # fzf-tab 补全界面
│   ├── 30-env-tools.zsh  # 编辑器 & 分页器默认值
│   ├── 40-aliases.zsh    # 命令别名
│   └── 99-zim.zsh        # Zim 框架启动
├── functions/       # 按需加载的函数
│   ├── extract
│   ├── open
│   ├── pac
│   └── sudo-command-line
└── CONTEXT.md       # 架构文档（面向 AI agent）
```

## 架构

模块划分与加载顺序见 [CONTEXT.md](CONTEXT.md)。

## 许可证

[MIT](LICENSE)