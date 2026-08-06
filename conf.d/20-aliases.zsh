# ~/.config/zsh/conf.d/20-aliases.zsh - Command Aliases & Fallbacks

check_cmd_or_warn() {
    if command_is_available "$1"; then
        return 0
    else
        [[ -o interactive ]] && print -P "%F{yellow}[zsh-warn]%f %U$1%u not found. $2"
        return 1
    fi
}

alias se="sudoedit"
alias grep='grep --color=auto'
alias ':q'='exit'
alias '。。'='..'

if check_cmd_or_warn eza "Falling back to standard ls."; then
    alias ls='eza --classify'
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
    alias gcl='git clone'
    alias gcld='git clone --depth=1'
    alias gcm='git commit --message'
    alias gcma='git commit --all --message'
    alias gcn='git clean -f -d'
    alias gco='git checkout'
    alias gd='git diff'
    alias gf='git fetch --all'
    alias gfp='git fetch --all --prune'
    alias gl='git log --oneline --decorate --graph --all'
    alias gll="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
    alias glll="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
    alias gp='git push'
    alias gpf='git push --force'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias gpls='git pull --autostash'
    alias gr='git reset'
    alias grh='git reset --hard'
    alias grm='git rm'
    alias grmc='git rm --cached'
    alias grs='git restore'
    alias gs='git status --short --branch --untracked-files --find-renames'
    alias gsw='git show'
fi

if command_is_available nvim; then
    alias vi='nvim'
    alias v='nvim'
    alias vim='nvim'
    alias edit='nvim'
elif command_is_available vim; then
    alias vi='vim'
    alias v='vim'
    alias edit='vim'
else
    alias vi='nano'
    alias v='nano'
    alias edit='nano'
fi

if command_is_available pacman; then
    alias sp='sudo pacman'
    alias spf='sudo pacman -F'
    alias spfy='sudo pacman -Fy'
    alias spi='sudo pacman -Sii'
    alias spl='sudo pacman -Sl'
    alias spp='sudo pacman -S --needed'
    alias spq='sudo pacman -Q'
    alias spqi='sudo pacman -Qii'
    alias spqk='sudo pacman -Qkk'
    alias spql='sudo pacman -Ql'
    alias spqo='sudo pacman -Qo'
    alias spqs='sudo pacman -Qs'
    alias spr='sudo pacman -Rns'
    alias sprr='sudo pacman -Qtdq | sudo pacman -Rns -'
    alias sps='sudo pacman -Ss'
    alias spu='sudo pacman -Syu'

    command_is_available paru && alias p="paru"
fi

command_is_available systemctl && alias sc='systemctl'

if command_is_available xdg-open; then
    open() {
        xdg-open "$1" >/dev/null 2>&1 &
    }
fi

if [[ -n "$DISPLAY" && -z "$SSH_CONNECTION" ]]; then
    command_is_available nvidia-settings && alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"
fi
