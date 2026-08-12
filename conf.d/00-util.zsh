# ~/.config/zsh/conf.d/00-util.zsh - Common Utility Functions
#
# Loaded first so all downstream modules can use these helpers.
# Keep this file shallow — one function per concern, stable interfaces.

# Check if a command is available in the current PATH.
# Usage: command_is_available <name>
# Returns: 0 (true) if the command exists, 1 (false) otherwise.
command_is_available() {
    (( $+commands[$1] ))
}