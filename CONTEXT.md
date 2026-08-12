# Zsh Configuration — Domain Model

## Architecture

**Utility module** — a shallow module providing stable, reusable helpers consumed by most other modules. Defined in `conf.d/00-util.zsh`. Its interface is small (one function), its implementation is minimal, but its leverage is high (20+ call sites). The `00-` prefix guarantees it loads before all other `conf.d/` modules.

**Orchestrator** — `.zshrc` owns the bootstrap sequence: autoload paths, ZLE widget bindings, and the `conf.d/` glob loop. It does not define runtime helpers.

## Module taxonomy

| Prefix | File | Responsibility |
|--------|------|---------------|
| `00-` | `util.zsh` | Utility functions (`command_is_available`) |
| `10-` | `options.zsh` | Shell options, keybindings, history, highlighting |
| `20-` | `env-tools.zsh` | Editor, pager, WSL2 environment |
| `30-` | `aliases.zsh` | Command aliases, fallbacks, conditional autoload |
| `99-` | `zim.zsh` | Zim framework bootstrap |

## Key concepts

- **command_is_available** — a predicate function `(( $+commands[$1] ))` used by all modules to conditionally enable features. Defined once in `conf.d/00-util.zsh`.
- **Autoloaded functions** — `extract`, `sudo-command-line`, `pac` live in `functions/` and are loaded on first invocation. They depend on `command_is_available` being already defined.
  - **Lazy-load ordering** — `.zshrc` registers these in `$fpath`/`autoload` *before* the `conf.d/` loop runs, but registration does not execute the body. `extract` and `pac` call `command_is_available` only at first invocation, by which point `00-util.zsh` has been sourced. `sudo-command-line` and `open` do not call it.