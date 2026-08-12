# Zsh Configuration — Domain Model

## Architecture

**Orchestrator** — `.zshrc` owns the bootstrap sequence: defines `command_is_available`, sets up autoload paths and ZLE widget bindings, then sources `conf.d/` files in lexical order. It is the single entry point for all configuration.

**Self-guarding module** — a module that returns early when its environment precondition is not met, so it is a no-op elsewhere. `10-wsl2.zsh` is the canonical example: on non-WSL systems the whole file is skipped.

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