# ~/.config/zsh/.zshenv - Global Environment & PATH Configuration

# ------------------------------------------------------------------------------
# 1. XDG Base Directory Specification
# ------------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ------------------------------------------------------------------------------
# 2. CLI & Language Environment Configurations
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
# 3. PATH Construction
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