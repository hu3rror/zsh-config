# ~/.config/zsh/conf.d/30-integrations.zsh - External Tool Integrations

# Zoxide Integration
if command_is_available zoxide; then
    () {
        local zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zoxide_init.zsh"
        if [[ ! -f "$zoxide_cache" ]]; then
            mkdir -p "${zoxide_cache:h}"
            zoxide init zsh --cmd cd >! "$zoxide_cache"
        fi
        source "$zoxide_cache"
    }
fi

if command_is_available mise; then
    () {
        local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise_init.zsh"

        if [[ ! -f "$cache" ]]; then
            mkdir -p "${cache:h}"
            mise activate zsh >! "$cache"
        fi

        source "$cache"
    }
fi

# Completion Options
setopt glob_dots

# Completion Styles & Sorting
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ':completion:*:eza' sort false
zstyle ':completion:files' sort false

# Fzf-Tab Configurations
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0

if command_is_available eza; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
fi