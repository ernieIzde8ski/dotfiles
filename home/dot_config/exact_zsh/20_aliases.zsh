#!/bin/zsh

if lsd_path="$(command -v 'lsd')"; then
    alias ls="$lsd_path"
else
    alias ls="ls --color=auto"
fi

alias ll="ls -l"
alias la="ls -A"
alias info='info --vi-keys'
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
