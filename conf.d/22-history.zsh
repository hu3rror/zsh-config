# ~/.config/zsh/conf.d/12-history.zsh - History Options & Storage

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