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
autoload -Uz command_is_available extract sudo-command-line pac zsh-flush-cache

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

# Powerlevel10k Theme Configuration
[[ -f "${_ZDOTDIR}/.p10k.zsh" ]] && source "${_ZDOTDIR}/.p10k.zsh"