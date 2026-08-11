# ~/.config/zsh/conf.d/10-env-tools.zsh - Default Tools & Environment Settings

# WSL2 Optimizations
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop || -n "$WSL_DISTRO_NAME" ]]; then
    # Hardware accelerated rendering (d3d12)
    if [[ -f /usr/lib/dri/d3d12_dri.so || -f /usr/lib/x86_64-linux-gnu/dri/d3d12_dri.so ]]; then
        export GALLIUM_DRIVER=d3d12
        export LIBVA_DRIVER_NAME=d3d12
    fi

    # Libedit hint for Intel GPU fallback
    if [[ ! -f /usr/lib/libedit.so.2 && -f /usr/lib/libedit.so ]]; then
        echo "Hint: If OpenGL uses llvmpipe on Intel GPU, create symlink:"
        echo "  sudo ln -s /usr/lib/libedit.so /usr/lib/libedit.so.2"
    fi

    # Bridge Windows ssh-agent
    if command_is_available wsl2-ssh-agent && [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
        eval "$(wsl2-ssh-agent)"
    fi
fi

# Default Pager
if command_is_available bat; then
    export PAGER="bat"
elif command_is_available less; then
    export PAGER="less"
fi

# Default Editor & Visual Pager
if command_is_available nvim; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man! --cmd 'let paging=1'"
elif command_is_available vim; then
    export EDITOR="vim"
    export VISUAL="vim"
else
    export EDITOR="nano"
    export VISUAL="nano"
fi

# Default Browser
if [[ -n "$DISPLAY" && -z "$SSH_CONNECTION" ]]; then
    if command_is_available firefox-developer-edition; then
        export BROWSER="firefox-developer-edition"
    elif command_is_available firefox; then
        export BROWSER="firefox"
    elif command_is_available chromium; then
        export BROWSER="chromium"
    fi
fi

# FZF Configuration & Integration
if command_is_available fzf; then
    if command_is_available fd; then
        export FZF_DEFAULT_COMMAND="fd --type f --follow --hidden --strip-cwd-prefix --exclude={.git,.idea,.sass-cache,node_modules,build}"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    export FZF_COMPLETION_OPTS='--border --info=inline'
    export FZF_DEFAULT_OPTS=" \
            --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
            --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
            --color=selected-bg:#45475a"

    # Cached fzf initialization
    () {
        local fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf_init.zsh"
        if [[ ! -f "$fzf_cache" ]]; then
            mkdir -p "${fzf_cache:h}"
            fzf --zsh >! "$fzf_cache" 2>/dev/null
        fi
        [[ -f "$fzf_cache" ]] && source "$fzf_cache"
    }
fi

# Wget Configuration Redirect
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
if [[ ! -f "$WGETRC" ]]; then
    mkdir -p "${WGETRC:h}"
    echo "hsts-file = $XDG_CACHE_HOME/wget-hsts" > "$WGETRC"
fi