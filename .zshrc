[[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

_ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

typeset -U fpath
fpath=("$_ZDOTDIR/functions" $fpath)
autoload -Uz extract sudo-command-line pac open zim-bootstrap-check

zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

for config_file in "$_ZDOTDIR/conf.d/"*.zsh(N.on); do
    source "$config_file"
done
unset config_file

[[ -f "$_ZDOTDIR/.p10k.zsh" ]] && source "$_ZDOTDIR/.p10k.zsh"