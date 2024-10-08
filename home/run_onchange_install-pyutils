#!/bin/sh

set -e

command -V pipx >/dev/null
command -V jq >/dev/null

if pipx list --json | jq -e '.venvs | has("dotfiles-pyutils")' >/dev/null; then
    echo "pyutils already installed through pipx! :)"
else
    cd "$CHEZMOI_WORKING_TREE/pyutils"
    pipx install -e .
fi
