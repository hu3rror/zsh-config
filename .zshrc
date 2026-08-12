# ~/.config/zsh/.zshrc - Zsh Main Configuration

#zmodload zsh/zprof

# Powerlevel10k Instant Prompt Header
[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# Base Environment Variables
_ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

# Autoload Functions Setup
typeset -U fpath
fpath=("$_ZDOTDIR/functions" $fpath)
autoload -Uz command_is_available extract sudo-command-line pac open 

# ZLE Widget Bindings
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# zsh-autosuggestions Setup
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Load Modular Configurations from conf.d (Lexical Order using N.on)
for config_file in "$_ZDOTDIR/conf.d/"*.zsh(N.on); do
    source "$config_file"
done
unset config_file

# Powerlevel10k Theme Configuration
[[ -f "$_ZDOTDIR/.p10k.zsh" ]] && source "$_ZDOTDIR/.p10k.zsh"