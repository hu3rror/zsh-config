# Zsh Configuration — Domain Model

## Architecture

**Utility module** — a shallow module providing stable, reusable helpers consumed by most other modules. Defined in `conf.d/00-util.zsh`. Its interface is small (one function), its implementation is minimal, but its leverage is high (20+ call sites). The `00-` prefix guarantees it loads before all other `conf.d/` modules.

**Orchestrator** — `.zshrc` owns the bootstrap sequence: autoload paths, ZLE widget bindings, and the `conf.d/` glob loop. It does not define runtime helpers.

## Module taxonomy

| Prefix | File | Responsibility |
|--------|------|---------------|
| `00-` | `util.zsh` | Utility functions (`command_is_available`) |
| `05-` | `wsl2.zsh` | WSL2-specific env (d3d12, ssh-agent); self-guards, no-op elsewhere |
| `10-` | `options.zsh` | Shell options, keybindings |
| `12-` | `history.zsh` | History options & file storage |
| `14-` | `syntax-highlight.zsh` | zsh-syntax-highlighting styles |
| `16-` | `fzf-tab.zsh` | Fzf-tab completion UI |
| `20-` | `env-tools.zsh` | Editor, pager defaults |
| `30-` | `aliases.zsh` | Command aliases, fallbacks |
| `99-` | `zim.zsh` | Zim framework bootstrap |

**Self-guarding module** — a module that returns early when its environment precondition isn't met, so it is a no-op elsewhere. `05-wsl2.zsh` is the canonical example: on non-WSL systems the whole file is skipped.

## Key concepts

## Key concepts

- **command_is_available** — a predicate function `(( $+commands[$1] ))` used by all modules to conditionally enable features. Defined once in `conf.d/00-util.zsh`.
- **Autoloaded functions** — `extract`, `sudo-command-line`, `pac`, `open` live in `functions/` and are loaded on first invocation (unconditional registration in `.zshrc`). They depend on `command_is_available` being already defined.
  - **Lazy-load ordering** — `.zshrc` registers these in `$fpath`/`autoload` *before* the `conf.d/` loop runs, but registration does not execute the body. `extract` and `pac` call `command_is_available` only at first invocation, by which point `00-util.zsh` has been sourced. `sudo-command-line` does not call it.
  - **`open` preconditions** — `open` guards its own `xdg-open` dependency at runtime (checks `command_is_available xdg-open` on first call). Registration is unconditional; the function self-guards.