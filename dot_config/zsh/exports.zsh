#!/bin/zsh

export PATH="$PATH:$HOME/.local/bin"

# these are all related I think ?
export CLICOLOR=1
export LESSCHARSET="utf-8" # fix man pages not displaying apostrophes
alias ls="ls --color=auto"

### setting EDITOR

# set vscode as $EDITOR when run in a vscode terminal
if [[ "$VSCODE_SHELL_INTEGRATION" == 1 || "$VSCODE_INJECTION" == 1 ]]; then
    # --wait makes it wait for files to close before exiting process
    # - permits reading stdin
    export EDITOR="$(command -v code) --wait -"
# otherwise pick from micro, nano, or vim
else
    editors=("micro" "nano" "vim")
    for editor in $editors; do
        editor="$(command -v ${editor})" && {
            export EDITOR=$editor
            break
        }
    done
fi
