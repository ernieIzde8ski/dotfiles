#!/bin/zsh

if bpyright="$(command -v 'basedpyright')"; then
    alias pyright="$bpyright"
fi

if lsd_path="$(command -v 'lsd')"; then
    alias ls="$lsd_path --git"
else
    alias ls="ls --color=auto"
fi

alias ll="ls -l"
alias la="ls -A"
alias lA="ls -lA"
alias ld="ls -d"
alias lD="ls -ld"

alias choice='shuf -en1'
alias info='info --vi-keys'
alias sizeof="du -sh --"
alias ...=../..
alias prname=perl-rename
alias ccr=cookiecutter


if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"

    # Alias so that I can use `z` in scripts easily, falling back to `cd`.
    #
    # It would be valid to override the builtins: `alias cd=z`
    # since internally, `__zoxide_cd` is defined as `\builtin cd -- "$@"`,
    # but that's just not something I want to do.
    alias zcd=z

    function __dotfiles_pushz_emit_help() {
        echo -n "usage: $1" 1>&2
        echo -n ' [<pushd-flag | "-h" | "--help" | "--debug">...]' 1>&2
        echo ' [--] [<z-argument>...]\n' 1>&2

        echo 'options:'
        echo "\t pushd-flag"
        echo "\t\t Adds a flag to send to pushd. Must begin with a hyphen."
        echo "\t z-argument"
        echo "\t\t Adds an argument to send to z."
        echo "\t -h, --help"
        echo "\t\t Displays this message."
        echo "\t --debug"
        echo "\t\t Halts evaluation of pushz after option interpretation."
        echo "\t\t Displays arguments that would be used."
    }

    # push directory
    function pushz() {
        local origin="$PWD"
        local target=""
        local pushd_flags=()
        local z_arguments=()

        local debug=false
        local evaluate_flags=true

        for argument in "$@"; do
            if [[ "$evaluate_flags" == false ]]; then
                z_arguments+=("$argument")
            elif [[ "$argument" == "--" ]]; then
                evaluate_flags=false
            elif [[ "$argument" == "-h" || "$argument" == "--help" ]]; then
                __dotfiles_pushz_emit_help "$0"
                return 0
            elif [[ "$argument" == '--debug' ]]; then
                debug=true
            elif [[ "$argument" =~ '[-\+][0123456789]+' ]]; then
                echo 'the `-+{N}` operator is not supported' 1>&2
                return 1
            elif [[ "$argument" == '-'* ]]; then
                pushd_flags+=("$argument")
            else
                z_arguments+=("$argument")
                evaluate_flags=false
            fi
        done

        if [[ $debug == true ]]; then
            echo "origin=${origin}"
            echo "pushd_flags=$(printf '%q ' "${pushd_flags[@]}")"
            echo "z_arguments=$(printf '%q ' "${z_arguments[@]}")"
            return 0
        fi

        z "$z_arguments[@]" && {
            target="$PWD"
            \builtin cd "$origin"
            \builtin pushd "$pushd_flags[@]" "$target"
        }
    }
    # pop directory, complimenting pushz
    alias popz='popd'
else
    alias zcd=cd
    alias pushz=pushd
    alias popz=popd
fi

alias zc=pushz
alias zp=popz

__pyl_reqs='pip list --format=freeze --not-required'
__pyl_filter="sed -r 's/pip\=\=.*\$(\\\n)?//g'"
__pyl_subst="sed -r 's/\b\=\=\b/>=/g'"

alias ls-pip-reqs="$__pyl_reqs | $__pyl_filter | $__pyl_subst"

function test-ls-pip-reqs() {
    ret=0

    if ls-pip-reqs | rg 'pip>=.*'; then
        echo 'error: __pyl_filter is not working properly' 1>&2
        echo '       ls-pip-reqs emits a pip line'
        ret=1
    fi

    if [[ $ret == 0 ]]; then
        echo 'All tests passed!'
    else
        echo
        echo "debug values:"
        echo "  __pyl_reqs=${__pyl_reqs}"
        echo "  __pyl_filter=${__pyl_filter}"
        echo "  __pyl_subst=${__pyl_subst}"
    fi

    return $ret
}

function cdas {
    if [[ "$#" -eq 0 ]]; then
        pushd &>/dev/null; doas $SHELL; popd &>/dev/null
    else
        for argument in $@; do
            pushd $argument; doas $SHELL; popd
        done
    fi
}

function edas {
    if [[ "$#" -eq 0 ]]; then
        pushd &>/dev/null; $EDITOR .; popd &>/dev/null
    else
        for argument in $@; do
            pushd $argument; $EDITOR .; popd
        done
    fi
}

# executes a process in the background, silently
function silent {
    $@ &>/dev/null &!
}

alias si=silent
