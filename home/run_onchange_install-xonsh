#!/bin/sh

set -e

ensure_installed () {
    if ! command -V $1 >/dev/null; then
        xi $2
    fi
}

ensure_installed pipx python3-pipx
ensure_installed jq jq

if pipx list --json | jq -e '.venvs | has("xonsh")' >/dev/null; then
    echo "xonsh already installed through pipx! :)"
else
    pipx install xonsh
fi
