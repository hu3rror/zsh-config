ZIM_HOME="$XDG_CACHE_HOME/zim"
ZIM_CONFIG_FILE="$_ZDOTDIR/.zimrc"

zim-bootstrap-check "$ZIM_CONFIG_FILE" "$_ZDOTDIR"

zstyle ':zim:zmodule' use 'degit'
zstyle ':zim:completion' dumpfile "$XDG_CACHE_HOME/zsh_dumpfile"
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/zcompcache"
zstyle ':zim' disable-version-check yes

if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
    if command_is_available curl; then
        curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
            https://fastly.jsdelivr.net/gh/zimfw/zimfw@master/zimfw.zsh
    elif command_is_available wget; then
        mkdir -p "$ZIM_HOME" && wget -nv -O "$ZIM_HOME/zimfw.zsh" \
            https://fastly.jsdelivr.net/gh/zimfw/zimfw@master/zimfw.zsh
    fi
fi

if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
    source "$ZIM_HOME/zimfw.zsh" init -q
fi

[[ -f "$ZIM_HOME/init.zsh" ]] && source "$ZIM_HOME/init.zsh"