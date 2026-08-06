# ~/.config/zsh/.zshenv - Global Environment & PATH Configuration

# ------------------------------------------------------------------------------
# 1. XDG Base Directory Specification
# ------------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ------------------------------------------------------------------------------
# 2. WSL2 Optimizations
# ------------------------------------------------------------------------------
if grep -qi microsoft /proc/version 2>/dev/null; then
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
    if command -v wsl2-ssh-agent >/dev/null 2>&1; then
        eval "$(wsl2-ssh-agent)"
    fi
fi

# ------------------------------------------------------------------------------
# 3. CLI & Language Environment Configurations
# ------------------------------------------------------------------------------
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GPG_TTY="${TTY:-$(tty 2>/dev/null)}"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Wget configuration redirect
WGETRC="$XDG_CONFIG_HOME/wgetrc"
if [ ! -f "$WGETRC" ]; then
    HSTS_FILE="$XDG_CACHE_HOME/wget-hsts"
    echo "hsts-file = $HSTS_FILE" > "$WGETRC"
fi
export WGETRC

# Xorg configuration redirect
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"

# ------------------------------------------------------------------------------
# 4. PATH Construction
# Rule: User local paths take precedence over system paths; auto-deduplicate (-U)
# ------------------------------------------------------------------------------
typeset -U path PATH
path=(
    $HOME/bin
    $HOME/.local/bin
    ${CARGO_HOME:-$XDG_DATA_HOME/cargo}/bin
    $HOME/.detaspace/bin
    $HOME/.fly/bin
    $HOME/.local/share/bob/nvim-bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin
    /sbin
    $path
)
export PATH