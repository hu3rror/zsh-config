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
