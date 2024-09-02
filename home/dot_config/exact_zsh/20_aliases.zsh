#!/bin/zsh

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
