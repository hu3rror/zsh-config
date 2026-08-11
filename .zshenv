# ~/.config/zsh/.zshenv - Global Environment & PATH Configuration

# CLI & Language Environment Configurations
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"

# GPG TTY Configuration for Interactive Shells
if [[ -o interactive ]]; then
    export GPG_TTY="${TTY:-$(tty 2>/dev/null)}"
fi

# System PATH Construction (User local paths take precedence; auto-deduplicated)
typeset -U path PATH
path=(
    $HOME/bin(N-/)
    $HOME/.local/bin(N-/)
    ${CARGO_HOME:-$XDG_DATA_HOME/cargo}/bin(N-/)
    $HOME/.fly/bin(N-/)
    /mnt/g/Program\ Files/Microsoft\ VS\ Code/bin(N-/)
    /mnt/c/Windows/system32(N-/)
    /mnt/c/Windows(N-/)
    $path
)
export PATH