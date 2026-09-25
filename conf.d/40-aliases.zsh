alias se="sudoedit"
alias grep='grep --color=auto'
alias ':q'='exit'
alias '。。'='..'

alias x='extract'

if (( EZA_AVAILABLE )); then
    alias ls='eza --classify auto'
    alias l='ls --long'
    alias l1='l --oneline'
    alias ll='l --all --group'
    alias ll1='ll --oneline'
    alias lt='ll --tree'
    alias la='ll --grid --header --inode --group --links --time-style=long-iso'
else
    alias ls='ls -F'
    alias la='ls -Al'
    alias ll='ls -lh'
fi

if command_is_available git; then
    alias g='git'
    alias ga='git add'
    alias gaa='git add --all'
    alias gb='git branch'
    alias gc='git commit'
    alias gca='git commit --amend'
    alias gcfd='git clean -f -d'
    alias gco='git checkout'
    alias gd='git diff'
    alias gfa='git fetch --all'
    alias glog='git log --oneline --decorate --graph --all'
    alias glogg="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
    alias gloggg="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
    alias gp='git push'
    alias gpf='git push --force'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias gr='git reset'
    alias grh='git reset --hard'
    alias grs='git restore'
    alias gs='git status --short --branch --untracked-files --find-renames'
    alias gsh='git show'
fi

alias vi="$EDITOR" v="$EDITOR" edit="$EDITOR"
[[ $EDITOR == nvim ]] && alias vim="$EDITOR"

if command_is_available pacman; then
    alias sp='sudo pacman'
    alias spp='sudo pacman -Syu'
    command_is_available paru && alias p="paru"
fi

command_is_available systemctl && alias sc='systemctl'