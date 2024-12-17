#!/bin/zsh

if [[ -o interactive ]]; then
    # fix "error: gpg failed to sign the data" in `git commit`
    export GPG_TTY=$TTY
fi

# fix manual pages rendering some chars incorrectly
export LESSCHARSET="utf-8"


editors=("nvim" "vim" "vi")
for editor in $editors; do
    if editor=$(command -v ${editor} 2>/dev/null); then
        export EDITOR="${editor}" && break;
    fi
done


ZSH_CACHE_HOME="${ZSH_CACHE_HOME:-$XDG_CACHE_HOME/zsh}"
[[ -d "$ZSH_CACHE_HOME" ]] || mkdir -p "$ZSH_CACHE_HOME"

if [[ -v ALT_ZSH_RUNTIME_DIR ]]; then
    setopt SHARE_HISTORY
    export HISTFILE="$ALT_ZSH_RUNTIME_DIR/histfile"
else
    unset HISTFILE
fi

autoload -Uz compinit
compinit -d "$ZSH_CACHE_HOME/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$ZSH_CACHE_HOME/zcompcache"
