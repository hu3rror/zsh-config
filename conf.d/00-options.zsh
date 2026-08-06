# ~/.config/zsh/conf.d/00-options.zsh - Shell Options & Keybindings

bindkey -e
WORDCHARS='*?[]~=&;!#$%^(){}<>'

setopt auto_cd
setopt cd_silent
setopt auto_pushd
setopt pushdminus
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home

setopt no_case_glob
setopt no_nomatch
setopt extended_glob
setopt interactive_comments

setopt no_clobber
setopt long_list_jobs
setopt no_bg_nice
setopt no_check_jobs
setopt no_hup
setopt no_beep

setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/histfile"
[[ ! -f "$HISTFILE" ]] && mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=10000
SAVEHIST=20000

zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
unset key

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#cba6f7'
