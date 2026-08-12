# Zsh Configuration — Domain Model

## Bootstrap chain

This config lives in `~/.config/zsh/` but depends on a **one-liner in `~/.zshenv`** to redirect `ZDOTDIR`:

```zsh
# ~/.zshenv (the only file outside this directory)
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
```

Without this file, zsh reads its default `~/.zshrc` and never finds this config.

### Full bootstrap sequence

| Step | File | What happens |
|------|------|-------------|
| 1 | `~/.zshenv` | Zsh starts, reads `~/.zshenv` (default `ZDOTDIR` = `~`). Sets `ZDOTDIR` to `~/.config/zsh`, then sources `~/.config/zsh/.zshenv`. |
| 2 | `.zshenv` | Sets XDG env vars, constructs `PATH` (Linux + WSL paths), exports `GPG_TTY`. |
| 3 | `.zshrc` | Defines `command_is_available`, sets up `fpath` and autoload, registers ZLE widgets, then sources `conf.d/` files in lexical order. |
| 4 | `conf.d/` | Modular config files: shell options, history, highlighting, aliases, and finally Zim framework bootstrap. |

## Architecture

**Orchestrator** — `.zshrc` owns the bootstrap sequence: defines `command_is_available`, sets up autoload paths and ZLE widget bindings, then sources `conf.d/` files in lexical order. It is the single entry point for all configuration **within this directory**.

**Self-guarding module** — a module that returns early when its environment precondition is not met, so it is a no-op elsewhere. `10-wsl2.zsh` is the canonical example: on non-WSL systems the whole file is skipped.

## External dependency

- **`~/.zshenv`** — the only file outside `~/.config/zsh/`. Required for `ZDOTDIR` redirection. If someone clones this repo, they **must** create this file or the config won't load.

## Module taxonomy

| Prefix | File | Responsibility |
|--------|------|---------------|
| `10-` | `wsl2.zsh` | WSL2-specific env (d3d12, ssh-agent); self-guards, no-op elsewhere |
| `20-` | `options.zsh` | Shell options, keybindings |
| `22-` | `history.zsh` | History options & file storage |
| `24-` | `syntax-highlight.zsh` | zsh-syntax-highlighting styles |
| `26-` | `fzf-tab.zsh` | Fzf-tab completion UI |
| `30-` | `env-tools.zsh` | Editor, pager defaults |
| `40-` | `aliases.zsh` | Command aliases & fallbacks |
| `99-` | `zim.zsh` | Zim framework bootstrap |

Files are sourced in lexical order by `.zshrc`'s glob loop. Numbering leaves room for insertion: `10/20/30/40` are primary tiers, `22/24/26` are sub-concerns within the options tier.

## Key concepts

- **command_is_available** — a predicate function `(( $+commands[$1] ))` used by all modules to conditionally enable features. Defined once in `.zshrc` (the orchestrator), available to all `conf.d/` modules and autoloaded functions.
- **Autoloaded functions** — `extract`, `sudo-command-line`, `pac`, `open` live in `functions/` and are loaded on first invocation (unconditional registration in `.zshrc`).
  - **Lazy-load ordering** — `.zshrc` registers these in `$fpath`/`autoload` *before* the `conf.d/` loop runs, but registration does not execute the body. The function body runs only on first call, by which point `command_is_available` is already defined.
  - **`open` preconditions** — `open` guards its own `xdg-open` dependency at runtime (checks `command_is_available xdg-open` on first call). Registration is unconditional; the function self-guards.