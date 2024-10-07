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

alias choice='shuf -en1'
alias info='info --vi-keys'
alias sizeof="du -sh --"
alias ...=../..
alias prname=perl-rename
alias ccr=cookiecutter

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
