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
| 3 | `.zshrc` | Sets up `fpath` and autoload, registers ZLE widgets, then sources `conf.d/` files in lexical order (`00-util.zsh` defines `command_is_available`). |
| 4 | `conf.d/` | Modular config files: shell options, history, highlighting, aliases, and finally Zim framework bootstrap. |

## Architecture

**Orchestrator** — `.zshrc` owns the bootstrap sequence: sets up autoload paths and ZLE widget bindings, then sources `conf.d/` files in lexical order. It is the single entry point for all configuration **within this directory**.

**Self-guarding module** — a module that returns early when its environment precondition is not met, so it is a no-op elsewhere. `10-wsl2.zsh` is the canonical example: on non-WSL systems the whole file is skipped.

## External dependency

- **`~/.zshenv`** — the only file outside `~/.config/zsh/`. Required for `ZDOTDIR` redirection. If someone clones this repo, they **must** create this file or the config won't load.

## Module taxonomy

| Prefix | File | Responsibility |
|--------|------|---------------|
| `00-` | `util.zsh` | `command_is_available` predicate; must stay lexically first — no consumer may precede it |
| `10-` | `wsl2.zsh` | WSL2-specific env (d3d12, ssh-agent); self-guards, no-op elsewhere |
| `20-` | `options.zsh` | Shell options, keybindings |
| `22-` | `history.zsh` | History options & file storage |
| `24-` | `syntax-highlight.zsh` | zsh-syntax-highlighting styles (styles are read by the module when Zim loads it in `99-zim.zsh`) |
| `26-` | `fzf-tab.zsh` | Fzf-tab completion UI |
| `30-` | `env-tools.zsh` | Editor, pager defaults |
| `40-` | `aliases.zsh` | Command aliases & fallbacks |
| `99-` | `zim.zsh` | Zim framework bootstrap |

Files are sourced in lexical order by `.zshrc`'s glob loop. Numbering leaves room for insertion: `00-util` is the utility tier, `10/20/30/40` are primary tiers, `22/24/26` are sub-concerns within the options tier.

## Key concepts

- **command_is_available** — a predicate function `(( $+commands[$1] ))` used by all modules and autoloaded functions to conditionally enable features. Defined once in `conf.d/00-util.zsh` (the utility tier, sourced first), available to everything that runs later. Semantics: probes PATH executables only — builtins, aliases and functions are not matched.
- **Autoloaded functions** — `extract`, `sudo-command-line`, `pac`, `open` live in `functions/` and are loaded on first invocation (unconditional registration in `.zshrc`).
  - **Lazy-load ordering** — `.zshrc` registers these in `$fpath`/`autoload` *before* the `conf.d/` loop runs, but registration does not execute the body. The function body runs only on first call, by which point `command_is_available` is already defined; `extract`, `open` and `pac` route all availability checks through it.
  - **`open` preconditions** — `open` guards its own `xdg-open` dependency at runtime (checks `command_is_available xdg-open` on first call). Registration is unconditional; the function self-guards.

## Zim module ordering constraints

`.zimrc` order is load-bearing: the `completion` module (compinit) must load **before** any module whose activation may trigger compinit/compdef. Keep `zmodule completion` early (currently right after `fzf`) and place any new tool-activation module **after** it.

**Why (2026-09 incident).** `hu3rror/zim-mise` sources `mise hook-env` output during activation. Newer mise versions inject usage-completion registration into that output:

```zsh
if ! (( $+functions[compdef] )); then autoload -Uz compinit; compinit -i; fi
```

With mise loading before `completion`, compinit ran early; the completion module then printed `warning: completion was already initialized ...` on every startup. That warning is console output during init, which also tripped Powerlevel10k's instant-prompt warning. Fix: move `zmodule completion` ahead of `zim-mise` (2026-09-25). Side benefit: compinit now runs exactly once, with the full fpath in place.

**Dumpfile.** The only compinit dumpfile is `$XDG_CACHE_HOME/zsh_dumpfile` (set in `99-zim.zsh`). The default `~/.config/zsh/.zcompdump` was written only by the premature mise compinit (no `-d` argument) and is now obsolete — it has been removed. If it ever reappears, some activation script is calling compinit without `-d` again.

**Disabled module.** `zsh-history-substring-search` is intentionally left commented out in `.zimrc`: it is a performance heavyweight (性能大户). Re-enable by uncommenting when the trade-off is acceptable.