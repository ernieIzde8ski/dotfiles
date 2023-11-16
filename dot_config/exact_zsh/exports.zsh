#!/bin/zsh

# useful command--reset a git directory to a clean state
alias gpristine='git reset --hard && git clean -dfx'

# default variables
export WINEPREFIX="${WINEPREFIX:-$HOME/.cache/wine}"
export NEWVOID="${NEWVOID:-/mnt/NEWVOID}"
[[ -v CARGO_HOME ]] || CARGO_HOME="$HOME/.local/share/cargo"
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# updating $PATH to reflect my environment
[[ -d "$CARGO_HOME/bin" ]] && PATH="$CARGO_HOME/bin:$PATH"
mountpoint "$NEWVOID" &>/dev/null && PATH="$NEWVOID/Random/CEDev/bin:$PATH"
gempath="/usr/lib/ruby/gems"
for rbpath in $(ls -r "$gempath" 2>/dev/null); do
    export PATH="$PATH:$gempath/$rbpath/bin"
done
PATH="$HOME/.local/bin:$PATH"
export PATH

# resolving technical issues
export GPG_TTY="${GPG_TTY:-`tty`}"
export CLICOLOR=1
export LESSCHARSET="utf-8" # fix man pages not displaying apostrophes
alias ls="ls --color=auto"


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
