# ~/.config/zsh/.zshrc - Zsh Main Configuration

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

_ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

command_is_available() {
    (( $+commands[$1] ))
}

# Autoload Functions Setup
fpath=("${_ZDOTDIR}/functions" $fpath)
autoload -Uz extract sudo-command-line

# ZLE Widget Bindings
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# Aliases for autoload functions
alias x='extract'

ZIM_HOME="${XDG_CACHE_HOME:-$HOME/.cache}/zim"
ZIM_CONFIG_FILE="${_ZDOTDIR}/.zimrc"

zstyle ':zim:zmodule' use 'degit'
zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME:-$HOME/.cache}/zsh_dumpfile"
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zcompcache"
zstyle ':zim' disable-version-check yes

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    if command_is_available curl; then
        curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
            https://fastly.jsdelivr.net/gh/zimfw/zimfw@master/zimfw.zsh
    elif command_is_available wget; then
        mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
            https://fastly.jsdelivr.net/gh/zimfw/zimfw@master/zimfw.zsh
    fi
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE} ]]; then
    source "${ZIM_HOME}/zimfw.zsh" init -q
fi

[[ -f "${ZIM_HOME}/init.zsh" ]] && source "${ZIM_HOME}/init.zsh"

# Load Modular Configurations from conf.d (Lexical Order using N.on)
for config_file in "${_ZDOTDIR}/conf.d/"*.zsh(N.on); do
    source "$config_file"
done
unset config_file

if [[ -f "${_ZDOTDIR}/functions/p10k.zsh" ]]; then
    source "${_ZDOTDIR}/functions/p10k.zsh"
elif [[ -f "${_ZDOTDIR}/funtions/p10k.zsh" ]]; then
    source "${_ZDOTDIR}/funtions/p10k.zsh"
elif [[ -f "${_ZDOTDIR}/.p10k.zsh" ]]; then
    source "${_ZDOTDIR}/.p10k.zsh"
fi
