# Coding Standards

Rules for code written in this repository. Agent behavior rules live in `AGENTS.md`; trade-off rationale and rejected alternatives live in ADRs. Extend this file as the repo's conventions crystallize.

## Comments

- Default to no comments. Let names and structure make the code self-explanatory.
- Write comments only for reasons the code itself cannot express: hidden constraints, counterintuitive behavior, historical pitfalls, and special compatibility requirements.
- Put trade-off rationale and rejected alternatives in ADRs, not in code comments.

## Out of scope

- Updating or merging an existing standards file: the human decides what changes.
- Writing ADRs: rationale belongs in ADRs, and the doc points there.

## Repo conventions (verified)

- **Module layout**: shell configuration lives in `conf.d/` files, sourced in lexical order by `.zshrc` (see CONTEXT.md → Module taxonomy). Numbering reserves insertion slots: `10/20/30/40` primary tiers, `22/24/26` sub-concerns.
- **Self-guarding modules**: a module returns early when its environment precondition is unmet, making it a no-op elsewhere (`10-wsl2.zsh` is the canonical example). See CONTEXT.md.
- **Conditional features**: gate feature setup behind the `command_is_available` predicate (`(( $+commands[$1] ))`) instead of assuming a tool exists. See CONTEXT.md.
- **Zim module order**: keep `zmodule completion` before any module whose activation may trigger compinit/compdef (e.g. mise hook-env). See CONTEXT.md → Zim module ordering constraints.
- **Commit messages**: conventional-commit prefixes with Chinese descriptions, per repo history (e.g. `chore: 更新...`, `refactor: 统一...`).
- **Bilingual docs**: user-facing documentation ships as both `README.md` and `README_zh-CN.md`.
