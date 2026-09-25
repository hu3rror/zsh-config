command_is_available() {
    (( $+commands[$1] ))
}