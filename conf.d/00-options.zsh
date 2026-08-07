# ~/.config/zsh/conf.d/00-options.zsh - Shell Options & Keybindings

# Keybindings & Line Editor
bindkey -e
WORDCHARS='*?[]~=&;!#$%^(){}<>'

# Directory Navigation Options
setopt auto_cd
setopt cd_silent
setopt auto_pushd
setopt pushdminus
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home

# Globbing & Expansion Options
setopt no_case_glob
setopt no_nomatch
setopt extended_glob
setopt interactive_comments

# General Shell Behavior
setopt no_clobber
setopt long_list_jobs
setopt no_bg_nice
setopt no_check_jobs
setopt no_hup
setopt no_beep

# History Options
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# History File Configuration
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/histfile"
[[ ! -f "$HISTFILE" ]] && mkdir -p "${HISTFILE:h}"
HISTSIZE=10000
SAVEHIST=20000

# History Substring Search Keybindings
zmodload -F zsh/terminfo +p:terminfo
local -a key_up=('^[[A' '^P')
local -a key_down=('^[[B' '^N')
[[ -n "${terminfo[kcuu1]}" ]] && key_up+=("${terminfo[kcuu1]}")
[[ -n "${terminfo[kcud1]}" ]] && key_down+=("${terminfo[kcud1]}")

for key in "${key_up[@]}"; do
    bindkey "${key}" history-substring-search-up
done
for key in "${key_down[@]}"; do
    bindkey "${key}" history-substring-search-down
done
unset key key_up key_down

# Syntax Highlighting Custom Styles
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#cba6f7'