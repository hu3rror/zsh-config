# ~/.config/zsh/.zshrc - Zsh Main Configuration

#zmodload zsh/zprof

# Powerlevel10k Instant Prompt Header
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Base Environment & Helper Functions
_ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# Autoload Functions Setup
typeset -U fpath
fpath=("${_ZDOTDIR}/functions" $fpath)
autoload -Uz command_is_available extract sudo-command-line pac

# ZLE Widget Bindings
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# Aliases for Autoload Functions
alias x='extract'

# zsh-autosuggestions Setup
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Load Modular Configurations from conf.d (Lexical Order using N.on)
for config_file in "${_ZDOTDIR}/conf.d/"*.zsh(N.on); do
    source "$config_file"
done
unset config_file

# Zim Framework Setup
ZIM_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/zim"
ZIM_CONFIG_FILE="${_ZDOTDIR}/.zimrc"

# Zim Module Options & Completion Cache Settings
zstyle ':zim:zmodule' use 'degit'
zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME:-$HOME/.cache}/zsh_dumpfile"
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zcompcache"
zstyle ':zim' disable-version-check yes

# Automatic zimfw Binary Download
if [[ ! -e "${ZIM_HOME}/zimfw.zsh" ]]; then
    if command_is_available curl; then
        curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
            https://fastly.jsdelivr.net/gh/zimfw/zimfw@master/zimfw.zsh
    elif command_is_available wget; then
        mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
            https://fastly.jsdelivr.net/gh/zimfw/zimfw@master/zimfw.zsh
    fi
fi

# Automatic Zim Script Compilation
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZIM_CONFIG_FILE}" ]]; then
    source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# Load Zim Modules
[[ -f "${ZIM_HOME}/init.zsh" ]] && source "${ZIM_HOME}/init.zsh"

# Powerlevel10k Theme Configuration
[[ -f "${_ZDOTDIR}/.p10k.zsh" ]] && source "${_ZDOTDIR}/.p10k.zsh"