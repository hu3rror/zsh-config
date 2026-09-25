# 调研：/home/hue/.config/zsh 中已过时/废弃的设置与可用的现代 zsh 语法

> 调研时间：2026-09（系统当前时间）。**所有结论绑定到本机实际安装的 zsh 版本：5.9.2**（`zsh --version`；Arch 包 `zsh 5.9.2-1`）。
>
> 主来源（primary sources）：
> - **zsh 手册 5.9.2** = https://zsh.sourceforge.net/Doc/Release/ （主页明确标注 “Version 5.9.2, Updated July 12, 2026”）。下文按章节文件引用，如 `zshoptions.html`、`Completion-System.html`、`Zsh-Modules.html`、`Conditional-Expressions.html`、`Expansion.html`、`User-Contributions.html`、`Shell-Builtin-Commands.html`。
> - **本地 help** = `/usr/share/zsh/5.9.2/help/{autoload,hash,...}`（Arch 未装完整 man 页，仅 per-command help；完整手册用在线版）。
> - **zsh 官方仓库** = `github.com/zsh-users/zsh`（`master/NEWS`、tag `zsh-5.9.2` 的 `README`/`NEWS`、tags API）。
> - **zimfw** = 本机 `$XDG_CACHE_HOME/zim/zimfw.zsh`、`modules/*/init.zsh`；官方文档 https://zimfw.sh/docs/{modules,settings,FAQ}/ 与 https://raw.githubusercontent.com/zimfw/zimfw/master/README.md。
> - **powerlevel10k** = 本机模块 `$XDG_CACHE_HOME/zim/modules/powerlevel10k/`（`README.md`、`internal/p10k.zsh`）。

---

## 0. 最重要的一个事实：不存在「zsh 13.x/14.x」

**0.1 前提不成立**：zsh 从未发布 13.x/14.x；**当前最新稳定版就是本机安装的 5.9.2**。
- 证据：本机 `zsh --version` → `zsh 5.9.2 (x86_64-pc-linux-gnu)`；`pacman -Q zsh` → `zsh 5.9.2-1`。
- 证据：GitHub tags API（`api.github.com/repos/zsh-users/zsh/tags`）最新 release 标签为 **`zsh-5.9.2`**（该标签提交日期 2026-07-12，来自对应 commit 的 committer date）。无任何 13.x/14.x 标签。
- 证据：在线手册首页自身即 “Version 5.9.2, Updated July 12, 2026”。zsh.org 首页亦显示 “current release (5.9)”。

**0.2 5.9.2 之后仅存在未发布的 5.10（开发版），其新特性在本机不可用**。
- 证据：`master/NEWS` 首节 “Changes since 5.9 —— zsh 5.10 is dedicated to the memory of Sebastian Gniazdowski…”，新特性包括 `nameref`（zsh/ksh93 模块）、参数展开标旗 `!`（命名引用名）、`ZSH_EXEPATH`、`region_highlight`/`zle_highlight` 支持 italic/faint、默认 keymap 改为 emacs。这些均不在 5.9.2。

**0.3 因此任务清单里的「=~、repeat、${(j: :)array}、zstyle 新特性、zmv、autoload 目录函数、hash -d、条件表达式」全都不是 13.x/14.x 新语法**，它们早已存在且全部有 5.9.2 手册文档（详见 §2.5 逐条核对）。本报告大量篇幅用于纠正这一误解。

---

## 1. 逐文件清点：所有 setopt / completion / zle / emulate / prompt 相关设置及其状态

用户全部 setopt 在本机 5.9.2 上实测一次执行成功（无 “no such option” 报错）。

### 1.1 `.zshrc`
| 设置 | 状态 | 证据 |
|---|---|---|
| 顶部 instant prompt 源行 | 现行推荐写法（细节见 §2.8/§4） | p10k `README.md` `#instant-prompt` 节给出同款片段：`if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]…`，并强调 “copy the lines verbatim” |
| `typeset -U fpath` + `fpath=(… $fpath)` | 现行 | — |
| `autoload -Uz extract sudo-command-line pac open zim-bootstrap-check` | 现行，`-z` 非必需但为推荐约定（§2.1） | 本地 `help/autoload` |
| `zle -N sudo-command-line` + `bindkey "\e\e" …` | 现行 | — |
| `ZSH_AUTOSUGGEST_MANUAL_REBIND=1` | 现行 zsh-autosuggestions 设置 | 该模块 README “Manual rebind” |
| `conf.d/*.zsh(N.on)` 循环 | `N`（nullglob）有用；`on`（按名排序）是默认行为、冗余但无害（§2.8） | `Expansion.html` glob 限定符节 |
| `unset config_file` | 现行 | — |

### 1.2 `.zshenv`
全部为 `export` + `typeset -U path PATH` + 数组赋值 + `(N-/)` 目录 glob 限定符 + `[[ -o interactive ]]`（`zshoptions.html`：`-o` 查询选项状态）。均为现行写法，无废弃项。

### 1.3 `conf.d/20-options.zsh`
| 设置 | 状态 |
|---|---|
| `bindkey -e` | 现行；5.9.2 默认即 emacs keymap（5.10-dev 起该句将冗余但无害，见 master NEWS “The default keymap is now emacs”） |
| `setopt auto_cd cd_silent auto_pushd pushdminus pushd_ignore_dups pushd_silent pushd_to_home no_case_glob no_nomatch extended_glob interactive_comments glob_dots no_clobber long_list_jobs no_bg_nice no_check_jobs no_hup no_beep` | **全部为 5.9.2 合法现行选项名，无一项废弃/改名**（zshoptions.html；本机实测 setopt 成功） |
| 选项命名约定 | §2.2：大小写不敏感、忽略下划线、`no_` 前缀取反 —— 官方语法，非旧写法 |
| 整个手册中唯一标记 obsolete 的选项 | `KSH_TYPESET`（“This option is now obsolete…”），**用户未使用** |

### 1.4 `conf.d/22-history.zsh`
`hist_find_no_dups / hist_ignore_all_dups / hist_ignore_space / hist_verify / share_history` 全部现行（zshoptions.html）。`HISTSIZE`/`SAVEHIST`、`HISTFILE` 至 `$XDG_STATE_HOME`、`mkdir -p "${HISTFILE:h}"` 均为现行写法。

### 1.5 `conf.d/24-syntax-highlight.zsh`
zsh-syntax-highlighting 的 `ZSH_HIGHLIGHT_*` 键名（command/alias/path/…）为该模块当前文档用法，无废弃项。

### 1.6 `conf.d/26-fzf-tab.zsh`
`zstyle ':completion:*:…'` 与 `zstyle ':fzf-tab:…'` 均为 zsh 新补全系统（`Completion-System.html`）与 fzf-tab 的现行 API。`zstyle` 本身（`-s/-t/-e/-d/-g`）现行（`Zsh-Modules.html` zsh/zutil 节）。无废弃项。

### 1.7 `conf.d/28-title.zsh` / `conf.d/10-wsl2.zsh`
`precmd_functions`/`preexec_functions`、`print -Pnr`、`print -rn`、`$'\e]0;…\a'`、glob 限定符、`(( $+commands[cmd] ))`（00-util.zsh）均为现行现代 zsh 用法。

### 1.8 `conf.d/99-zim.zsh`
| 项 | 状态 | 证据 |
|---|---|---|
| `zstyle ':zim:zmodule' use 'degit'` | 现行、官方文档化 | zimfw.sh/docs/settings/：“…you can set `zstyle ':zim:zmodule' use 'degit'`”；zimfw.zsh 源码中 degit 甚至是默认工具（“otherwise 'degit' will be used”），仅支持 GitHub |
| `zstyle ':zim:completion' dumpfile "$XDG_CACHE_HOME/zsh_dumpfile"` | 现行，与本机模块源码读取的键一致 | 本机 `modules/completion/init.zsh`：`zstyle -s ':zim:completion' dumpfile 'zdumpfile' || zdumpfile=…/.zcompdump` |
| `zstyle ':zim' disable-version-check yes` | 现行、官方文档化 | zimfw.sh/docs/settings/：“By default, zimfw will check…every 30 days…`zstyle ':zim' disable-version-check yes`”；zimfw.zsh 行 1152 `zstyle -t ':zim' disable-version-check` |
| `zim-bootstrap-check` 守卫（completion 须先于 mise、.zcompdump 残留警告） | 仓库自定义逻辑（配套 `tests/run.zsh`），非 Zim 废弃项 | 本仓库 `functions/` 与 `CONTEXT.md` |

### 1.9 `.zimrc`
| 模块 | 状态 |
|---|---|
| `input`、`fzf`、`completion` | **官方现行模块**（zimfw.sh/docs/modules/ 列表包含三者）；`completion` 的排序约束（先于 mise，防重复 compinit）是本仓库自守卫，与 Zim 官方 “completion is not working” 处理方向一致 |
| `romkatv/powerlevel10k --use degit` | **正是 zimfw README 官方示例**：`zmodule romkatv/powerlevel10k --use degit`（“A module with a big git repository”） |
| `hu3rror/zim-mise`、`hu3rror/zim-zoxide` | 用户自有 fork；Zim 官方社区模块列有 `joke/zim-mise`、`antoineco/zim-zoxide`，说明该类别受支持；fork 属用户自主选择，非废弃 |
| `zsh-users/zsh-completions --fpath src`、`Aloxaf/fzf-tab`、`zsh-users/zsh-autosuggestions`、`zsh-users/zsh-syntax-highlighting` | 现行第三方模块 |

### 1.10 `functions/`（extract、open、pac、sudo-command-line、zim-bootstrap-check）
- **全部以 `emulate -L zsh` 开头** —— 正是 zsh 手册 autoload 节推荐的现代写法（本地 `help/autoload` 原文示例 `emulate zsh -c 'autoload -Uz func'`）。无废弃语法。
- 内部用到的 `${file:l}`、`${(f)…}`、`${(j:…)…}`、`local -a`、`print -P`、`read -r "var?prompt"`、`&!`、glob 限定符 `(N)` 均现行。
- **一个真实隐患**：`functions/pac.zsh` 多处用 `${(j:\n:)pkgs}` 拼换行 —— 实测该写法产出**字面 `\n`**（§2.6），仅因外层 `print` 解释反斜杠才显示换行；建议换 `${(F)pkgs}`。

### 1.11 `.p10k.zsh`
- **没有任何 `PROMPT=`/`RPROMPT=` 直接赋值**（grep 仅命中注释）。prompt 由 p10k 内部构建；文件底部是官方生成的当前内容（`(( ! $+functions[p10k] )) || p10k reload`、`POWERLEVEL9K_CONFIG_FILE=…`、`setopt ${p10k_config_opts[@]}`）。不存在“应改为 `p10k configure`”的问题——该文件本就是 `p10k configure` 生成的（§2.7）。
- 全文件无 “deprecated/obsolete/legacy” 字样（grep 0 命中）。
- `POWERLEVEL9K_TRANSIENT_PROMPT=always`、`POWERLEVEL9K_INSTANT_PROMPT=verbose`、`POWERLEVEL9K_DISABLE_HOT_RELOAD=true` 均为 p10k 现行文档化选项（README 相应节）。

---

## 2. 逐条核对任务点名的疑似过时点

### 2.1 `autoload -Uz` 是否需要 `-z`；compinit 旧写法
- **`-z` 不是必需**（KSH_AUTOLOAD 默认未设），**但正确且是通行约定**；本地 `help/autoload` 原文：“The flags `-z` and `-k` mark the function to be autoloaded using the zsh or ksh style, as if the option KSH_AUTOLOAD were unset or were set, respectively.” zimfw 源码自身也用 `autoload -Uz is-at-least`。**保留即可，不算过时。**
- **`compinit -d <dumpfile>` 是现行推荐写法，不是旧写法**。`Completion-System.html` 原文：默认 dump 为 `.zcompdump`（$ZDOTDIR/$HOME），“alternatively, an explicit file name can be given by `compinit -d dumpfile`”。用户通过 `zstyle ':zim:completion' dumpfile` 交给 Zim completion 模块（其执行 `compinit -C -d ${dumpfile}` 并 `zcompile` dump），正是把 `.zcompdump` 移出 $ZDOTDIR 的现代做法；本仓库 `zim-bootstrap-check` 检测残留 `.zcompdump` 也是基于此约定。
- `autoload -Uz compinit && compinit`（裸调用）不是废弃写法，只是不如带 `-C -d` 的快；“lazy compinit”（首次 Tab 才 init）是性能取舍而非标准，Zim 模块已用 dump+`-C` 达成类似目的。

### 2.2 传统 `compctl` vs `compdef`
- **`compctl` 已废弃。** `Zsh-Modules.html` “The zsh/compctl Module” 原文：“`compctl` is the **old, deprecated** way to control completions for ZLE.” `Completion-Using-compctl.html` 章首同样称其为 “the **older** compctl command”，对比“newer and more powerful system based on shell functions”（即 `compdef`/`compinit`）。
- **用户配置中没有 `compctl`**（grep 无命中）。新补全系统（`compdef`）已是用户/框架实际使用的。无需任何改动。

### 2.3 setopt 命名约定（`alwaystoend`、`no_` 前缀）
- `zshoptions.html` “Specifying Options” 原文：“These names are case insensitive and underscores are ignored. For example, `allexport` is equivalent to `A__lleXP_ort`.” → **`alwaystoend` 与 `ALWAYS_TO_END`/`always_to_end` 完全等价，不存在改名/废弃**。
- 同节原文：“The sense of an option name may be inverted by preceding it with `no`, so `setopt No_Beep` is equivalent to `unsetopt beep`.” → 用户配置里大量 `setopt no_clobber`/`no_case_glob` 等就是**官方规范写法**。
- 全手册唯一 obsolete 选项为 `KSH_TYPESET`，用户未使用；`ALWAYS_TO_END` 且被 Zim completion 模块自身使用（本机 `modules/completion/init.zsh` 有 `setopt ALWAYS_TO_END`）。

### 2.4 “13.x/14.x 新增语法”逐条核对（结论：全非新版新增，5.9.2 全可用）
| 被疑“新”语法 | 5.9.2 上的真实状态（主来源） |
|---|---|
| `repeat` | 保留字/内置，古已有。5.9 新增 `SHORT_REPEAT` 一行写法（NEWS：“The option SHORT_REPEAT was added…for the repeat command only”）——可用但非必须 |
| `=~` 运算符 | 现行，`Conditional-Expressions.html`：`string =~ regexp`（`RE_MATCH_PCRE` 时用 zsh/pcre）；本机实测 `[[ abc =~ ^a ]]` 成功 |
| `${(j: :)array}` | 现行，`Expansion.html` flags 节 `j:STRING:`：“Join the words of arrays together using string as a separator” |
| `zstyle` 新特性 | `zstyle`（zsh/zutil）的 `-s/-e/-t/-d/-g` 均现行；5.9 NEWS 未对 zstyle 改动。用户的 zstyle 用法为系统补全与 fzf-tab 现行 API |
| `zmv` | 现行函数，`User-Contributions.html`：`zmv [-finqQsvwW] …` |
| `autoload` 目录函数（`$fpath`） | 现行机制，本地 `help/autoload`：“The fpath parameter will be searched to find the function definition when the function is first referenced.” |
| `hash -d` | 现行，`Shell-Builtin-Commands.html`：`hash [-Ldfmrv] …`，“with the option the named directory hash table is used” |
| 条件表达式 `[[ ]]` | 现行（`Conditional-Expressions.html`） |

### 2.5 数组/参数展开现代写法（`P`、`b`、`(F)` 等）
- **`(j:\n:)` 不是换行拼接的稳健写法；现代写法是 `(F)`。**
  - 证据（手册）：`Expansion.html` flags 节 `F`：“Join the words of arrays together using newline as a separator. This is a shorthand for `pj:\n:`.”
  - 证据（实测 5.9.2）：`x="${(j:\n:)a}"` 经 `od -c` 输出为字面 `a\`n`b\`n`c`；`y=${(F)a}` 输出真实换行。用户 `pac.zsh` 的 `(j:\n:)` 依赖外层 `print` 解释反斜杠才显示换行，属脆弱写法。
- `(P)` 与 `(b)` 均为现行文档化标旗，**不是**“新写法替换老写法”的关系，用户无需改动：
  - `Expansion.html` `P`：“forces the value of the parameter name to be interpreted as a further parameter name, whose value will be used”；
  - `Expansion.html` `b`：“Quote with backslashes only characters that are special to pattern matching… useful when the contents … tested using GLOB_SUBST”。

### 2.6 Zim 框架废弃模块/设置
- 用户所用官方模块（`input`、`fzf`、`completion`）均在当前官方模块列表（zimfw.sh/docs/modules/）中，**无任何 Zim 模块被标 deprecated**（文档全页无 “deprecat” 字样）。
- 用户三个 zstyle（`:zim:zmodule` use、`:zim:completion` dumpfile、`:zim` disable-version-check）与 zimfw 1.20.1 源码/官方文档一一对应（§1.8），无废弃。
- 结论：Zim 侧**没有**需要迁移的废弃项。

### 2.7 powerlevel10k 状态与 `.p10k.zsh`
- **仍是 Zim 生态下的推荐 prompt 主题**：zimfw README 官方示例即 `zmodule romkatv/powerlevel10k --use degit`，用户照做。
- **如实提醒**：p10k README 顶部自声明 “**THE PROJECT HAS VERY LIMITED SUPPORT / NO NEW FEATURES ARE IN THE WORKS / MOST BUGS WILL GO UNFIXED / HELP REQUESTS WILL BE IGNORED**”—— 不是“废弃”，但表示项目进入维护收尾、无新特性规划。继续使用是合理的。
- `.p10k.zsh` 无废弃项；`POWERLEVEL9K_` 前缀是**官方命名而非旧前缀**：README FAQ “What is the relationship…”：“Names of all parameters in Powerlevel10k start with `POWERLEVEL9K_` for consistency”及“committed to maintaining backward compatibility with all configs indefinitely”。→ **不要改成 `POWERLEVEL10K_`，无需重跑 `p10k configure`**（文件本身就是它生成的）。
- 无 `PROMPT=`/`RPROMPT=` 直接赋值（§1.11）。

### 2.8 其他细节发现
- `.zshrc` instant prompt 源行用了裸 `$XDG_CACHE_HOME`，p10k README 标准片段是 `${XDG_CACHE_HOME:-$HOME/.cache}`。因 `.zshenv` 已 export XDG_CACHE_HOME，功能正常，但补回退更稳（低风险可选改）。
- `conf.d/*.zsh(N.on)`：`Expansion.html` glob 限定符节：“The default sorting is `n` (by name) unless the `Y` glob qualifier is used” → `on` 冗余但无害。
- 5.9 新增且可能值得知道的选项：`SHORT_REPEAT`、`CLOBBER_EMPTY`、`CASE_PATHS`（控制 `NO_CASE_GLOB` 是否作用于路径组件；zshoptions.html CASE_PATHS 节）、`TYPESET_TO_UNSET`、`compinit -w`（NEWS “Changes from 5.8.1 to 5.9”）；5.9.2 相对 5.9 的不兼容项：“PCRE support is now PCRE2”（tag `zsh-5.9.2` 的 README）。

---

## 3. 版本绑定（task 3）

- 本机：**zsh 5.9.2**（`zsh --version`；Arch `zsh 5.9.2-1`）。
- 上游最新稳定：**5.9.2**（tag `zsh-5.9.2`，2026-07-12）；5.10 仅存在于 master，未发布。
- 所有“最新语法可用性”结论一律以 5.9.2 为准：
  - **可用**（全部经本机实测或 5.9.2 手册确认）：`=~`、`[[ ]]`、glob 限定符、`(j)`/`(F)`/`(P)`/`(b)` 等标旗、`repeat`（含 `SHORT_REPEAT`）、`zmv`、`zstyle`、`hash -d`、`autoload`+`$fpath`、`emulate -L`。
  - **不可用**（5.10-dev 特性）：`nameref`/命名空间（zsh/ksh93）、参数标旗 `!`、`ZSH_EXEPATH`、`region_highlight` italic/faint、默认 emacs keymap 的变更。

---

## 4. 按优先级排序的行动建议（task 4）

**P0 — 唯一明确废弃、但用户已规避的点**
1. `compctl` 已废弃（Zsh-Modules.html “old, deprecated”）——用户配置零使用，无需动作；新代码一律 `compdef`/`compinit`。

**P1 — 可直接改、低风险**
2. `functions/pac.zsh`：把 `${(j:\n:)pkgs}` 等换行拼接全部换成 `${(F)pkgs}`（§2.5，实测差异；改后 `print -r`/变量场景不再产出字面 `\n`）。改完跑 `zsh -n functions/pac.zsh` 与手动抽查各子命令输出。
3. `.zshrc` instant prompt 源行补 `${XDG_CACHE_HOME:-$HOME/.cache}` 回退（§2.8，纯加回退，无行为变化）。

**P2 — 可选、需小测**
4. `conf.d/*.zsh(N.on)` 去掉冗余的 `on`（默认即按名排序）；不改也完全无害。
5. 20-options.zsh 的多行 `setopt` 可合并为单次调用（启动略快、风格统一；属风格而非废弃，需确认无拼写错误）。
6. 若用 `no_case_glob` 且希望路径组件也大小写不敏感，了解 5.9 的 `CASE_PATHS` 语义（zshoptions.html；默认不设，`CASE_GLOB` 影响所有组件）——一般无需动作。

**P3 — 建议保留（常见误解，勿动）**
7. `autoload -Uz`（`-z` 是防御性约定）；`compinit -d` 与 Zim dumpfile zstyle；全部 setopt 命名（`no_` 前缀、下划线、`alwaystoend` 等价写法）；`(P)`/`(b)` 标旗；`zmv`/`hash -d`/`repeat`/`=~`/`[[ ]]`/fpath 目录函数。
8. `.zimrc` 的 `input`/`fzf`/`completion` 与三个 zstyle；`romkatv/powerlevel10k --use degit`（官方示例）。
9. `.p10k.zsh` 的 `POWERLEVEL9K_` 前缀与 instant/transient/hot-reload 选项——官方命名，非废弃；不要改名、不要“改回” `PROMPT=`（p10k 内部管理，无 `PROMPT=` 待改项）。
10. `functions/*` 的 `emulate -L zsh`（官方推荐模式）。

**P4 — 不要做**
11. 不要按“13.x/14.x 新语法”做任何迁移（该版本不存在）；不要引入 5.10-dev 特性。
12. 不要因 p10k “limited support” 声明而急于更换主题（若在意可另行调研 starship 等，但本次调研范围内 p10k 仍是被官方示例支持的推荐项）。

---

## 5. 总结清单

| # | 结论 | 状态 |
|---|---|---|
| 1 | 不存在 zsh 13.x/14.x；最新稳定 = 5.9.2 = 本机版本 | 前提纠错 |
| 2 | 任务点名的新语法（=~、repeat、j 标旗、zstyle、zmv、fpath、hash -d、[[ ]]）全部早已存在，5.9.2 全可用 | 误解纠正 |
| 3 | `compctl` 已废弃；用户未使用 | 无需动作 |
| 4 | `autoload -Uz` 的 `-z` 非必需但保留 | 未过时 |
| 5 | `compinit -d`/自定义 dumpfile 是现行推荐；Zim 模块用法正确 | 未过时 |
| 6 | setopt 命名（no_、下划线、大小写）全部现行；全手册唯一 obsolete 是 KSH_TYPESET，未使用 | 未过时 |
| 7 | `(P)`、`(b)`、`(j)`、`(F)` 均现行文档标旗；`(F)` 是现代换行拼接写法 | 建议改用 `(F)` |
| 8 | Zim 模块 input/fzf/completion 与三个 zstyle 均官方现行 | 未过时 |
| 9 | p10k 仍是官方推荐主题；README 有 “limited support” 声明；`.p10k.zsh` 无废弃项 | 未过时（有提醒） |
| 10 | `.p10k.zsh` 无 `PROMPT=` 直接赋值；`POWERLEVEL9K_` 前缀是官方命名 | 未过时 |
| 11 | 具体可改进：`pac.zsh` 的 `(j:\n:)`→`(F)`；instant prompt 回退；`(N.on)` 的 `on` 冗余 | 行动项 |
| 12 | 5.10-dev 特性（nameref、ZSH_EXEPATH 等）本机不可用 | 不可用 |

---

## 6. 来源清单

- 本机：`zsh --version`、`pacman -Q zsh`、`/usr/share/zsh/5.9.2/help/{autoload,hash,setopt,…}`、`$XDG_CACHE_HOME/zim/{zimfw.zsh,init.zsh,modules/completion/init.zsh,modules/powerlevel10k/*}`、本仓库 `{CONTEXT.md,conf.d/*,functions/*,.zimrc,.p10k.zsh,tests/run.zsh}`。
- 在线：zsh 手册 5.9.2（`zsh.sourceforge.io/Doc/Release/`，章节：Options、Shell-Builtin-Commands、Completion-System、Completion-Using-compctl、Zsh-Modules、Conditional-Expressions、Expansion、User-Contributions）；zsh 官方 GitHub（`master/NEWS`、tag `zsh-5.9.2`、tags API）；zimfw.sh/docs/{modules,settings,FAQ}、zimfw README；zsh.org。
- 实测记录：5.9.2 上 `(j:\n:)`→字面 `\n` vs `(F)`→真实换行；`=~` 匹配成功；用户全部 setopt 一次性执行成功。
