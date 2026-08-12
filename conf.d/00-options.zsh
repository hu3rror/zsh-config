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
setopt glob_dots

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
HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
[[ ! -f "$HISTFILE" ]] && mkdir -p "${HISTFILE:h}"
HISTSIZE=10000
SAVEHIST=20000

# zsh-syntax-highlighting Setup
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Syntax Highlighting Custom Styles (Catppuccin Mocha)
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#cba6f7,underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fab387,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'

# Fzf-Tab Configurations
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:eza' sort false
zstyle ':completion:files' sort false
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0

if command_is_available eza; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
fi