# ~/.config/zsh/conf.d/20-env-tools.zsh - Default Tools & Environment Settings

# Default Pager
if command_is_available bat; then
    export PAGER="bat"
elif command_is_available less; then
    export PAGER="less"
fi

# Default Editor & Visual Pager
if command_is_available nvim; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man! --cmd 'let paging=1'"
elif command_is_available vim; then
    export EDITOR="vim"
    export VISUAL="vim"
else
    export EDITOR="nano"
    export VISUAL="nano"
fi
