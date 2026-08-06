# ~/.config/zsh/conf.d/30-integrations.zsh - External Tool Integrations

if command_is_available zoxide; then
    local zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide_init.zsh"
    if [[ ! -f "$zoxide_cache" ]]; then
        mkdir -p "${zoxide_cache:h}"
        zoxide init zsh --cmd cd >! "$zoxide_cache"
    fi
    source "$zoxide_cache"
    unset zoxide_cache
fi

setopt glob_dots

zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ':completion:*:eza' sort false
zstyle ':completion:files' sort false

if command_is_available eza; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
fi
