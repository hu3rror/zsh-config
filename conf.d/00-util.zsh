# ~/.config/zsh/conf.d/00-util.zsh - Common Utility Functions

command_is_available() {
    (( $+commands[$1] ))
}