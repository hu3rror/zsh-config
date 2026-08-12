# ~/.config/zsh/conf.d/10-options.zsh - Shell Options & Keybindings

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