#!/bin/zsh
# This file sets PATH and XDG Base Directory folders

### XDG Base Directory
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# TODO: this should really be set in /etc/profile or something,
# not here lmao
[[ -n "$XDG_DATA_DIRS" ]] || XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_DATA_DIRS="$XDG_DATA_HOME/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"


### Make programs respect XDG Base Directory
export CABAL_DIR="${CABAL_DIR:-$XDG_DATA_HOME/cabal}"
export GHCUP_USE_XDG_DIRS=true

export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
[ -f "$CARGO_HOME/env" ] && source "$CARGO_HOME/env"
export ELAN_HOME="${ELAN_HOME:-$XDG_STATE_HOME/elan}"

export LUAROCKS_CONFIG="$HOME/.config/luarocks/config.lua"

export COOKIECUTTER_CONFIG="${COOKIECUTTER_CONFIG:-$XDG_CONFIG_HOME/cookiecutterrc}"
export FFMPEG_DATADIR="${FFMPEG_DATADIR:-$XDG_CONFIG_HOME/ffmpeg}"
export NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG:-$XDG_CONFIG_HOME/npm/npmrc}"
export RIPGREP_CONFIG_PATH="${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/config}"
export VIRTUALENV_HOME="${VIRTUALENV_HOME:-$XDG_STATE_HOME/venvs}"
export WINEPREFIX="${WINEPREFIX:-$XDG_DATA_HOME/wine}"

if [[ ! "$MANPATH" =~ ":$HOME\\b" ]]; then
    export MANPATH="$MANPATH:$XDG_DATA_HOME/man"
fi

if [[ -d /mnt/indarys ]]; then
    export INDARYS='/mnt/indarys'
else
    export INDARYS="/run/media/$USER/indarys"
fi

if [[ -v XDG_RUNTIME_DIR ]]; then
    export ALT_ZSH_RUNTIME_DIR="${ALT_ZSH_RUNTIME_DIR:-$XDG_RUNTIME_DIR/zsh}"
elif df -TP '/tmp' | grep -q 'tmpfs'; then
    export ALT_ZSH_RUNTIME_DIR="/tmp/zsh-$USER"
else
    echo "Couldn't set a suitable" '$ALT_ZSH_RUNTIME_DIR!' 1>&2
    echo 'Please enable $XDG_RUNTIME_DIR or mount /tmp as tmpfs to fix this.' 1>&2
fi

if [[ -v ALT_ZSH_RUNTIME_DIR && ! -d "$ALT_ZSH_RUNTIME_DIR" ]]; then
    mkdir "$ALT_ZSH_RUNTIME_DIR"
    chmod u+rwx,g-rwx,o-rwx $ALT_ZSH_RUNTIME_DIR
fi

### Set PATH directory
# prevent duplicating keys in subshells
typeset -aU path

# ruby gems
for gem_dir in $(find -maxdepth 4 -name bin "/usr/lib/ruby/gems/" 2>/dev/null); do
    path=("$gem_dir" $path)
done
unset gem_dir

if command -v luarocks &>/dev/null; then
    eval "$(luarocks path)"
fi

prepend_list=("$CABAL_DIR" "$XDG_DATA_HOME/npm" "$ELAN_HOME" "$CARGO_HOME" "$INDARYS/Random/CEDev" "$XDG_DATA_HOME/CEdev" "$HOME/.local")
for prepend_dir in $prepend_list; do
    path=("$prepend_dir/bin" $path)
done
unset prepend_list prepend_dir

export PATH
