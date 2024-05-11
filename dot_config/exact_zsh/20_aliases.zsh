#!/bin/zsh

alias ls="ls --color=auto"
alias sizeof="du -sh --"
alias ...=../..

if command -v perl-rename &>/dev/null; then
    alias rename=perl-rename
fi

function cdas {
    if [[ "$#" -eq 0 ]]; then
        pushd; doas $SHELL; popd
    else
        for argument in $@; do
            pushd $argument; doas $SHELL; popd
        done
    fi
}
