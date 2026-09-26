# tests/run.zsh — regression suite for the Zim bootstrap guard.
#
# Seam under test: zim-bootstrap-check <zimrc_path> <zdotdir>
#   (autoloaded function in functions/zim-bootstrap-check)
# Observable behavior: prints red [error] lines to stderr on violation,
# silent otherwise. Assertions check stderr tokens only, never message text
# verbatim beyond the distinguishing phrases.
#
# Run: zsh tests/run.zsh
emulate -L zsh

local root="${0:A:h:h}"
local tmp="${TMPDIR:-/tmp}/zim-guard-tests-$$"
local pass=0 fail=0
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp"

# --- fixtures -----------------------------------------------------------
cat > "$tmp/good.zimrc" <<'EOF'
zmodule input
zmodule fzf
zmodule completion
zmodule hu3rror/zim-zoxide
zmodule hu3rror/zim-mise
EOF

cat > "$tmp/bad.zimrc" <<'EOF'
zmodule input
zmodule hu3rror/zim-mise
zmodule completion
EOF

cat > "$tmp/nocompletion.zimrc" <<'EOF'
zmodule fzf
zmodule hu3rror/zim-mise
EOF

cat > "$tmp/nomise.zimrc" <<'EOF'
zmodule input
zmodule completion
EOF

mkdir -p "$tmp/zdotdir-clean" "$tmp/zdotdir-dirty"
: > "$tmp/zdotdir-dirty/.zcompdump"

# --- runner -------------------------------------------------------------
check() {
    local desc="$1" zimrc="$2" zdotdir="$3"; shift 3
    local -a expect=("$@")
    local err
    err=$(zsh -fc 'autoload -Uz zim-bootstrap-check; fpath=("$1/functions" $fpath); zim-bootstrap-check "$2" "$3"' zsh "$root" "$zimrc" "$zdotdir" 2>&1)
    local ok=1 tok
    if (( ${#expect} == 0 )); then
        [[ -z "$err" ]] || ok=0
    else
        for tok in "${expect[@]}"; do
            [[ $err == *"$tok"* ]] || ok=0
        done
    fi
    if (( ok )); then
        (( ++pass ))
        print -P "%F{green}PASS%f  $desc"
    else
        (( ++fail ))
        print -P "%F{red}FAIL%f  $desc"
        print "        expected: ${expect:-<silent>}"
        print "        got:      $err"
    fi
}

# --- cases ---------------------------------------------------------------
check "completion before mise → silent"          "$tmp/good.zimrc"        "$tmp/zdotdir-clean"
check "mise before completion → order warning"   "$tmp/bad.zimrc"         "$tmp/zdotdir-clean" "must precede"
check "completion missing → order warning"       "$tmp/nocompletion.zimrc" "$tmp/zdotdir-clean" "must precede"
check "mise absent → silent"                     "$tmp/nomise.zimrc"      "$tmp/zdotdir-clean"
check ".zcompdump present → dumpfile warning"    "$tmp/good.zimrc"        "$tmp/zdotdir-dirty" "compinit without -d" "TERM=dumb"
check "bad order + .zcompdump → both warnings"   "$tmp/bad.zimrc"         "$tmp/zdotdir-dirty" "must precede" "compinit without -d"
check "missing .zimrc → silent, no crash"        "$tmp/nonexistent.zimrc" "$tmp/zdotdir-clean"

# --- 10-wsl2 TERM promotion (root cause of the stray .zcompdump) -----------
# Seam: conf.d/10-wsl2.zsh promotes TERM=dumb to xterm-256color so the Zim
# completion module initializes normally instead of letting mise's hook-env
# run compinit without -d. Source it with a fake WSL environment and assert
# the exported TERM.
check_term() {
    local desc="$1" expect="$2" envs="$3"
    local got
    got=$(env ${=envs} zsh -fc 'source "$1/conf.d/00-util.zsh"; source "$1/conf.d/10-wsl2.zsh"; print -r -- "$TERM"' zsh "$root" 2>&1)
    if [[ $got == "$expect" ]]; then
        (( ++pass ))
        print -P "%F{green}PASS%f  $desc"
    else
        (( ++fail ))
        print -P "%F{red}FAIL%f  $desc"
        print "        expected: $expect"
        print "        got:      $got"
    fi
}

check_term "TERM=dumb on WSL → promoted to xterm-256color" xterm-256color 'WSL_DISTRO_NAME=fake TERM=dumb'
check_term "TERM already set → unchanged"                xterm-256color 'WSL_DISTRO_NAME=fake TERM=xterm-256color'

print -P ""
print -P "%B$pass passed, $fail failed%b"
(( fail == 0 ))
