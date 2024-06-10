#!/bin/zsh

export GHCUP_USE_XDG_DIRS=true  # move ghcup stuff out of ~/.ghcup
export GPG_TTY=$TTY             # fix "error: gpg failed to sign the data" in `git commit`
export LESSCHARSET="utf-8"      # fix manual pages rendering some chars incorrectly
export WINEPREFIX="${WINEPREFIX:-$XDG_DATA_HOME/wine}"


if [[ ! "$MANPATH" =~ ":$HOME\\b" ]]; then
    export MANPATH="$MANPATH:$XDG_DATA_HOME/man"
fi


editors=("nvim" "vim")
for editor in $editors; do
    export EDITOR="$(command -v ${editor})" && break;
done


ZSH_CACHE_HOME="$XDG_CACHE_HOME/zsh"
[[ -d "$ZSH_CACHE_HOME" ]] || mkdir -p "$ZSH_CACHE_HOME"

HISTFILE="$ZSH_CACHE_HOME/history"
autoload -Uz compinit
compinit -d "$ZSH_CACHE_HOME/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$ZSH_CACHE_HOME/zcompcache"
