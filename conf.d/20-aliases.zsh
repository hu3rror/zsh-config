# ~/.config/zsh/conf.d/20-aliases.zsh - Command Aliases & Fallbacks

check_cmd_or_warn() {
    if command_is_available "$1"; then
        return 0
    else
        [[ -o interactive ]] && print -P "%F{yellow}[zsh-warn]%f %U$1%u not found. $2"
        return 1
    fi
}

alias se="sudoedit"
alias grep='grep --color=auto'
alias ':q'='exit'
alias '。。'='..'

if check_cmd_or_warn eza "Falling back to standard ls."; then
    alias ls='eza --classify'
    alias l='ls --long'
    alias l1='l --oneline'
    alias ll='l --all --group'
    alias ll1='ll --oneline'
    alias lt='ll --tree'
    alias la='ll --grid --header --inode --group --links --time-style=long-iso'
else
    alias ls='ls -F'
    alias la='ls -Al'
    alias ll='ls -lh'
fi

if command_is_available git; then
    alias g='git'
    alias ga='git add'
    alias gaa='git add --all'
    alias gb='git branch'
    alias gc='git commit'
    alias gca='git commit --amend'
    alias gcl='git clone'
    alias gcld='git clone --depth=1'
    alias gcm='git commit --message'
    alias gcma='git commit --all --message'
    alias gcn='git clean -f -d'
    alias gco='git checkout'
    alias gd='git diff'
    alias gf='git fetch --all'
    alias gfp='git fetch --all --prune'
    alias gl='git log --oneline --decorate --graph --all'
    alias gll="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
    alias glll="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
    alias gp='git push'
    alias gpf='git push --force'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias gpls='git pull --autostash'
    alias gr='git reset'
    alias grh='git reset --hard'
    alias grm='git rm'
    alias grmc='git rm --cached'
    alias grs='git restore'
    alias gs='git status --short --branch --untracked-files --find-renames'
    alias gsw='git show'
fi

if command_is_available nvim; then
    alias vi='nvim'
    alias v='nvim'
    alias vim='nvim'
    alias edit='nvim'
elif command_is_available vim; then
    alias vi='vim'
    alias v='vim'
    alias edit='vim'
else
    alias vi='nano'
    alias v='nano'
    alias edit='nano'
fi

# flush zsh init caches
alias zsh-flush-cache='rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/"*.zsh && echo "[zsh] Init caches flushed. Please restart shell."'

if command_is_available pacman; then
    # High-frequency aliases
    alias sp='sudo pacman'
    alias spu='sudo pacman -Syu'
    command_is_available paru && alias p="paru"

    # Interactive Pacman wrapper function
    pac() {
        # Dependency pre-check
        if ! command_is_available fzf; then
            print -u2 -P "%F{red}[error]%f 'fzf' is required for the pac function."
            return 1
        fi

        local helper="pacman"
        command_is_available paru && helper="paru"

        # Declare all internal local variables to prevent global scope leakage
        local choice action query results selected pkgs orphans_str orphans pkg cached_pkg confirm aur_confirm cache_files mode

        # Menu options format: "key|display text"
        local actions=(
            "search|🔍 Search and install packages"
            "remove|🗑️ Uninstall packages interactively"
            "orphans|🧹 Clean unused orphan packages"
            "update|🔄 Perform full system update"
            "info|ℹ️ Query installed package details"
            "tree|🌳 View package dependency tree"
            "downgrade|⏪ Downgrade package from cache"
            "clean|📦 Clean package download cache"
        )

        choice=$(printf '%s\n' "${actions[@]}" | fzf --height=45% --layout=reverse --prompt="Pacman Menu > " --delimiter='|' --with-nth=2)
        [[ -z "$choice" ]] && return

        action="${choice%%|*}"
        case "$action" in
            search)
                read -r "query?Enter search keyword: "
                [[ -z "$query" ]] && return

                # Combine two-line search output into single lines for fzf
                results=$(pacman -Ss "$query" 2>/dev/null | paste - -)

                if [[ -n "$results" ]]; then
                    selected=$(echo "$results" | fzf --multi \
                        --delimiter='\t' \
                        --preview 'pkg={1}; pacman -Si "${pkg%% *}" 2>/dev/null' \
                        --preview-window=right:60%:wrap \
                        --prompt="Search Results > " \
                        --header="[Tab: Multi-select | Enter: Confirm]")

                    if [[ -n "$selected" ]]; then
                        # Disable globbing to ensure package names remain intact
                        setopt localoptions noglob
                        pkgs=($(echo "$selected" | awk -F'\t' '{print $1}' | awk '{print $1}' | cut -d/ -f2))
                    fi
                fi

                # AUR fallback if no official packages selected/found and paru exists (Default: No)
                if [[ -z "${pkgs[*]}" ]] && command_is_available paru; then
                    read -r "aur_confirm?Search AUR with paru for '$query'? [y/N] "
                    if [[ "$aur_confirm" =~ ^[Yy]$ ]]; then
                        paru "$query"
                        return
                    fi
                fi

                # Confirm and install (Default: Yes)
                if [[ -n "${pkgs[*]}" ]]; then
                    print -P "%F{cyan}Selected packages for installation:%f\n${(j:\n:)pkgs}"
                    read -r "confirm?Proceed with installation? [Y/n] "
                    if [[ -z "$confirm" || "$confirm" =~ ^[Yy]$ ]]; then
                        if [[ "$helper" == "paru" ]]; then
                            paru -S "${pkgs[@]}"
                        else
                            sudo pacman -S "${pkgs[@]}"
                        fi
                    fi
                fi
                ;;

            remove)
                selected=$(pacman -Qq | fzf --multi --preview 'pacman -Qi {}' --prompt="Select packages to uninstall > ")
                if [[ -n "$selected" ]]; then
                    pkgs=(${(f)selected})
                    print -P "%F{yellow}Selected packages for removal:%f\n${(j:\n:)pkgs}"
                    print -P "%F{yellow}[note]%f Recursive mode (-Rns) removes unneeded dependencies; Safe mode (-R) removes packages only."
                    read -r "mode?Choose removal mode [1: -Rns (default), 2: -R (safe), c: cancel]: "
                    case "$mode" in
                        2)
                            sudo pacman -R "${pkgs[@]}"
                            ;;
                        [cC])
                            return
                            ;;
                        *)
                            sudo pacman -Rns "${pkgs[@]}"
                            ;;
                    esac
                fi
                ;;

            orphans)
                orphans_str=$(pacman -Qtdq)
                if [[ -n "$orphans_str" ]]; then
                    orphans=(${(f)orphans_str})
                    print -P "%F{yellow}Found orphan packages:%f\n${(j:\n:)orphans}"
                    read -r "confirm?Uninstall these orphan packages (-Rns)? [Y/n] "
                    if [[ -z "$confirm" || "$confirm" =~ ^[Yy]$ ]]; then
                        sudo pacman -Rns "${orphans[@]}"
                    fi
                else
                    print -P "%F{green}[info]%f No orphan packages found."
                fi
                ;;

            update)
                if [[ "$helper" == "paru" ]]; then
                    paru
                else
                    sudo pacman -Syu
                fi
                ;;

            info)
                pkg=$(pacman -Qq | fzf --preview 'pacman -Qi {}' --prompt="Select package to view > ")
                [[ -n "$pkg" ]] && pacman -Qi "$pkg"
                ;;

            tree)
                pkg=$(pacman -Qq | fzf --preview 'pacman -Qi {}' --prompt="Select package for dependency tree > ")
                if [[ -n "$pkg" ]]; then
                    if command_is_available pactree; then
                        pactree "$pkg"
                    else
                        print -P "%F{yellow}[note]%f 'pactree' not found (install pacman-contrib). Showing package info instead:"
                        pacman -Qi "$pkg"
                    fi
                fi
                ;;

            downgrade)
                pkg=$(pacman -Qq | fzf --preview 'pacman -Qi {}' --prompt="Select package to downgrade > ")
                if [[ -n "$pkg" ]]; then
                    if command_is_available downgrade; then
                        sudo downgrade "$pkg"
                    else
                        # Use Zsh null-glob array instead of parsing ls output
                        cache_files=(/var/cache/pacman/pkg/${pkg}-*.pkg.tar.*(N))
                        if [[ ${#cache_files} -eq 0 ]]; then
                            print -P "%F{red}[error]%f No cached packages found for '$pkg'."
                        else
                            cached_pkg=$(printf '%s\n' "${cache_files[@]}" | fzf --prompt="Select cached package version > ")
                            if [[ -n "$cached_pkg" ]]; then
                                print -P "%F{yellow}Selected cached package:%f $cached_pkg"
                                read -r "confirm?Install this local package version? [Y/n] "
                                if [[ -z "$confirm" || "$confirm" =~ ^[Yy]$ ]]; then
                                    sudo pacman -U "$cached_pkg"
                                fi
                            fi
                        fi
                    fi
                fi
                ;;

            clean)
                sudo pacman -Sc
                ;;
        esac
    }
fi

command_is_available systemctl && alias sc='systemctl'

if command_is_available xdg-open; then
    if ! command_is_available open; then
        open() {
            if (( $# == 0 )); then
                xdg-open . >/dev/null 2>&1 &!
                return
            fi

            local arg
            for arg in "$@"; do
                xdg-open "$arg" >/dev/null 2>&1 &!
            done
        }
    fi
fi

if [[ -n "$DISPLAY" && -z "$SSH_CONNECTION" ]]; then
    command_is_available nvidia-settings && alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"
fi

