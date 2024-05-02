#!/bin/zsh

alias ls="ls --color=auto"
alias sizeof="du -sh --"
alias ...=../..

if command -v perl-rename &>/dev/null; then
    alias rename=perl-rename
fi
