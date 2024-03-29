#!/bin/zsh

# ----- Command Aliases
alias ls="ls --color=auto"  # make `ls` usually emit color output
if command -v perl-rename &>/dev/null; then
    alias rename=perl-rename
fi

# ----- Miscellaneous exports
export GPG_TTY=$TTY         # fix "error: gpg failed to sign the data" in `git commit`
export LESSCHARSET="utf-8"  # fix manual pages rendering apostrophes (and others) incorrectly

if [[ ! "$MANPATH" =~ ":$HOME\\b" ]]; then
    export MANPATH="$MANPATH:$HOME/.local/share/man"
fi

# ----- $PATH & $PATH-like variables
export WINEPREFIX="${WINEPREFIX:-$HOME/.local/share/wine}"


# rust package manager
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.local/share/rustup}"
export CARGO_HOME="${CARGO_HOME:-$HOME/.local/share/cargo}"
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"
[[ -d "$CARGO_HOME/bin" ]] && PATH="$CARGO_HOME/bin:$PATH"

# updating NEWVOID-related files, depending on if the mountpoint even
# exists yet and if it's mounted at all
if [[ ! -v NEWVOID && -d /mnt/NEWVOID ]]; then
    export NEWVOID="/mnt/NEWVOID"
    if mountpoint "$NEWVOID" &>/dev/null; then
        PATH="$NEWVOID/Random/CEDev/bin:$PATH"
    fi
fi

# prioritizing ~/.local/bin over everything
PATH="$HOME/.local/bin:$PATH"

# appending the binaries of ruby gems
for gem_bin in $(find -maxdepth 4 -name bin "/usr/lib/ruby/gems/" 2>/dev/null); do
    PATH="$PATH:$gem_bin"
done

export PATH

# ----- $EDITOR
editors=("vim" "micro" "nano")
for editor in $editors; do
    export EDITOR="$(command -v ${editor})" && break;
done
