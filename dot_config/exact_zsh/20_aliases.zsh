#!/bin/zsh

alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -a"
alias sizeof="du -sh --"
alias ...=../..

if command -v perl-rename &>/dev/null; then
    alias rename=perl-rename
fi

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
