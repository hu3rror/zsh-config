# Zsh Config

[**English**](README.md) | [**中文**](README_zh-CN.md)

A modular Zsh configuration built on [Zim](https://github.com/zimfw/zimfw). Starts in ~70ms, lazy-loads its functions, and runs on Linux, including WSL2.

## Features

- **Prompt:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k) with instant prompt
- **Completion:** fuzzy completion via [fzf-tab](https://github.com/Aloxaf/fzf-tab), extra definitions from `zsh-completions`
- **Autosuggestions:** suggestions from your command history
- **Syntax highlighting:** Catppuccin Mocha color scheme
- **Navigation:** [zoxide](https://github.com/ajeetdsouza/zoxide) for frequency-ranked jumps (`z`), `fzf` for fuzzy search
- **Tools:** [mise](https://mise.jdx.dev) manages runtimes (Node, Python, Go, Bun, and more)
- **Custom functions:** `extract`, `pac`, `sudo-command-line`, `open` (see table below)
- **WSL2:** auto-detected; d3d12 GPU acceleration and Windows ssh-agent support
- **Modular:** `conf.d/` loads in lexical order; modules that don't apply skip themselves

## Prerequisites

- Zsh ≥ 5.9
- [Zim](https://github.com/zimfw/zimfw) (installed automatically on first shell start)
- [Git](https://git-scm.com)
- Optional: `curl` or `wget` (for initial Zim download)

## Installation

### 1. Clone the repo

```zsh
git clone https://github.com/hu3rror/zsh-config.git ~/.config/zsh
```

### 2. Redirect ZDOTDIR (required)

Zsh reads `~/.zshenv` before anything else. Create this file to point ZDOTDIR at the config directory:

```zsh
# ~/.zshenv
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
```

Without this line, Zsh reads its default `~/.zshrc` and never finds this config.

### 3. Start Zsh

```zsh
exec zsh
```

Zim downloads its modules on first run.

### Custom functions

| Function | Description | Key binding |
|----------|-------------|-------------|
| `extract` (alias `x`) | Extract any archive format automatically | — |
| `sudo-command-line` | Toggle `sudo` prefix on the current command | `⎋ ⎋` (double Escape) |
| `pac` | Interactive pacman/paru package helper | — |
| `open` | Open files/directories with the system default app | — |

## Project structure

```
~/.config/zsh/
├── .zshrc           # Entry point: loads conf.d/ in order
├── .zshenv          # Environment variables, PATH construction
├── .zimrc           # Zim module declarations
├── .p10k.zsh        # Powerlevel10k theme configuration
├── conf.d/          # Modular configuration files
│   ├── 00-util.zsh       # Utility functions (command_is_available)
│   ├── 10-wsl2.zsh       # WSL2 optimizations (skips elsewhere)
│   ├── 20-options.zsh    # Shell options & keybindings
│   ├── 22-history.zsh    # History options
│   ├── 24-syntax-highlight.zsh  # Syntax highlighting styles
│   ├── 26-fzf-tab.zsh    # fzf-tab completion UI
│   ├── 30-env-tools.zsh  # Editor & pager defaults
│   ├── 40-aliases.zsh    # Command aliases
│   └── 99-zim.zsh        # Zim framework bootstrap
├── functions/       # Autoloaded, loaded on first use
│   ├── extract
│   ├── open
│   ├── pac
│   └── sudo-command-line
└── CONTEXT.md       # Architecture documentation (agent-facing)
```

## Architecture

Module layout and load order: [CONTEXT.md](CONTEXT.md).

## License

[MIT](LICENSE)