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
alias l=ls

alias choice='shuf -en1'
alias info='info --vi-keys'
alias sizeof="du -sh --"
alias ...=../..
alias prname=perl-rename
alias cz=chezmoi
alias cza='chezmoi add'
alias cze='chezmoi edit'

# executes a process in the background, silently
function silent {
    $@ &>/dev/null &!
}

alias si=silent
alias si-open='silent xdg-open'
