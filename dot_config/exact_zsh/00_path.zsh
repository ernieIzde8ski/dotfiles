#!/bin/zsh
# Sets $PATH and similar variables

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export CABAL_DIR="$XDG_DATA_HOME/cabal"

export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# updating NEWVOID-related files, depending on if the mountpoint even
# exists yet and if it's mounted at all
if [[ ! -v NEWVOID && -d /mnt/NEWVOID ]]; then
    export NEWVOID="/mnt/NEWVOID"
fi

# appending the binaries of ruby gems
for gem_bin in $(find -maxdepth 4 -name bin "/usr/lib/ruby/gems/" 2>/dev/null); do
    PATH="$gem_bin:$PATH"
done

prepend_list=("$CABAL_DIR" "$CARGO_HOME" "$NEWVOID/Random/CEDev" "$HOME/.local")
for dir in $prepend_list; do
    dir="$dir/bin"
    if [[ -d "$dir" ]]; then
        PATH="$dir:$PATH"
    fi
done

export PATH
