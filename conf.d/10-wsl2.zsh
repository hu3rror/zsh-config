if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop && -z "$WSL_DISTRO_NAME" ]]; then
    return
fi

if [[ -f /usr/lib/dri/d3d12_dri.so || -f /usr/lib/x86_64-linux-gnu/dri/d3d12_dri.so ]]; then
    export GALLIUM_DRIVER=d3d12
    export LIBVA_DRIVER_NAME=d3d12
fi

if [[ ! -f /usr/lib/libedit.so.2 && -f /usr/lib/libedit.so ]]; then
    echo "Hint: If OpenGL uses llvmpipe on Intel GPU, create symlink:"
    echo "  sudo ln -s /usr/lib/libedit.so /usr/lib/libedit.so.2"
fi

if command_is_available wsl2-ssh-agent && [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
    eval "$(wsl2-ssh-agent)"
fi