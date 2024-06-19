#!/bin/zsh

# variables we need for $PATH

export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"


export CABAL_DIR="${CABAL_DIR:-$XDG_DATA_HOME/cabal}"
export INDARYS="/mnt/indarys"

export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"

export FFMPEG_DATADIR="${FFMPEG_DATADIR:-$XDG_CONFIG_HOME/ffmpeg}"
export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG:-$XDG_CONFIG_HOME/npm/npmrc}"
export RIPGREP_CONFIG_PATH="${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/config}"

# actual additions to $PATH

# prevent duplicating keys in subshells
typeset -aU path

# ruby gems
for gem_dir in $(find -maxdepth 4 -name bin "/usr/lib/ruby/gems/" 2>/dev/null); do
    path=("$gem_dir" $path)
done
unset gem_dir

prepend_list=("$CABAL_DIR" "$XDG_DATA_HOME/npm" "$CARGO_HOME" "$INDARYS/Random/CEDev" "$HOME/.local")
for prepend_dir in $prepend_list; do
    path=("$prepend_dir/bin" $path)
done
unset prepend_dir

export PATH
