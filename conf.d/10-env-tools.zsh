# ~/.config/zsh/conf.d/10-env-tools.zsh - Default Tools & Environment Settings


#  WSL2 Optimizations
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop || -n "$WSL_DISTRO_NAME" ]]; then
    # Hardware accelerated rendering (d3d12)
    if [ -f /usr/lib/dri/d3d12_dri.so ] || [ -f /usr/lib/x86_64-linux-gnu/dri/d3d12_dri.so ]; then
        export GALLIUM_DRIVER=d3d12
        export LIBVA_DRIVER_NAME=d3d12
    fi

    # (Optional) libedit hint for Intel GPU fallback
    if [ ! -f /usr/lib/libedit.so.2 ] && [ -f /usr/lib/libedit.so ]; then
        echo "Hint: If OpenGL uses llvmpipe on Intel GPU, create symlink:"
        echo "  sudo ln -s /usr/lib/libedit.so /usr/lib/libedit.so.2"
    fi

    # Bridge Windows ssh-agent
    if command_is_available wsl2-ssh-agent; then
        eval "$(wsl2-ssh-agent)"
    fi
fi

# Default Tools & Environment Settings
if command_is_available bat; then
    export PAGER="bat"
elif command_is_available less; then
    export PAGER="less"
fi

if [[ -n "$DISPLAY" && -z "$SSH_CONNECTION" ]]; then
    if command_is_available firefox-developer-edition; then
        export BROWSER=firefox-developer-edition
    elif command_is_available firefox; then
        export BROWSER=firefox
    elif command_is_available chromium; then
        export BROWSER=chromium
    fi
fi

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

if command_is_available fzf; then
    local fzf_paths=(
        "/usr/share/fzf"
        "/usr/share/doc/fzf/examples"
        "/usr/local/opt/fzf/shell"
    )
    for path_dir in "${fzf_paths[@]}"; do
        [[ -f "${path_dir}/completion.zsh" ]] && source "${path_dir}/completion.zsh"
        [[ -f "${path_dir}/key-bindings.zsh" ]] && source "${path_dir}/key-bindings.zsh"
    done
    unset fzf_paths path_dir

    export FZF_DEFAULT_COMMAND="fd --type f --follow --hidden --strip-cwd-prefix --exclude={.git,.idea,.sass-cache,node_modules,build}"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_COMPLETION_OPTS='--border --info=inline'
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
        --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
        --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
fi

# Wget configuration redirect
if [[ ! -f "$WGETRC" ]]; then
    mkdir -p "$(dirname "$WGETRC")"
    echo "hsts-file = $XDG_CACHE_HOME/wget-hsts" > "$WGETRC"
fi