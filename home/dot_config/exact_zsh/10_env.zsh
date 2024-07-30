#!/bin/zsh

export GPG_TTY=$TTY             # fix "error: gpg failed to sign the data" in `git commit`
export LESSCHARSET="utf-8"      # fix manual pages rendering some chars incorrectly


editors=("nvim" "vim")
for editor in $editors; do
    if editor=$(command -v ${editor} 2>/dev/null); then
        export EDITOR="${editor}" && break;
    fi
done


ZSH_CACHE_HOME="${ZSH_CACHE_HOME:-$XDG_CACHE_HOME/zsh}"-
[[ -d "$ZSH_CACHE_HOME" ]] || mkdir -p "$ZSH_CACHE_HOME"

HISTFILE="$ZSH_CACHE_HOME/history"
autoload -Uz compinit
compinit -d "$ZSH_CACHE_HOME/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$ZSH_CACHE_HOME/zcompcache"
