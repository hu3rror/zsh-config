if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop && -z "$WSL_DISTRO_NAME" ]]; then
    return
fi

# The WSL boot console login shell inherits no TERM from Windows and zsh falls
# back to TERM=dumb; the Zim completion module then skips itself and mise's
# hook-env runs compinit without -d, dropping a stray .zcompdump into $ZDOTDIR
# on every boot. Promote to a real terminal so completion initializes normally
# (see CONTEXT.md → Zim module ordering constraints, 2026-09-26 incident).
if [[ ${TERM:-dumb} == dumb ]]; then
    export TERM=xterm-256color
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

if [[ -n "$WT_SESSION" ]]; then
    keep_current_path() {
        printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
fi