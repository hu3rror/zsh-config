# Terminal title: cwd while idle, running command while executing (OSC 0).
# Terminals without title support silently ignore the sequence.

title_set_cwd() {
    print -Pnr -- $'\e]0;%~\a'
}

title_set_cmd() {
    # ESC/newlines would escape the OSC title or break its single-line form.
    local cmd="${1//[$'\e\n\r']/ }"
    print -rn -- $'\e]0;'"$cmd"$'\a'
}

precmd_functions+=(title_set_cwd)
preexec_functions+=(title_set_cmd)
