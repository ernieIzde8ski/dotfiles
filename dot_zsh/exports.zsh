#!/bin/zsh



export PATH="$PATH:$HOME/.local/bin"

# these are all related I think ?
export CLICOLOR=1
export LESSCHARSET="utf-8" # fix man pages not displaying apostrophes
alias ls="ls --color=auto"
 
# setting $EDITOR
# against another's better judgement I have used vscode anyways
vscode="$(which code)"

if [[ -x $vscode && $DISPLAY ]]; then
    # --wait makes it wait for files to close before exiting process
    # - permits reading stdin
    export EDITOR=("$vscode" "--wait" "-")
else
    editors=("micro" "nano" "vim")
    for editor in $editors; do
        fp="$(which $editor)"
        if [[ -x $fp ]]; then
            export EDITOR=$fp
            break
        fi
    done
fi
