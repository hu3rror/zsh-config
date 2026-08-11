# ~/.config/zsh/conf.d/30-integrations.zsh - External Tool Integrations

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

# # Fzf-Tab Configurations
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