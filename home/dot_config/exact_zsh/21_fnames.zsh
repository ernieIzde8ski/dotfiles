#!/bin/zsh

alias __fnames_cmd="functions | rg --text '^([^\s]+) \(\) \{' -r '\$1'"

# TODO:
#   - filtering out names with leading underscores with a switch
#   - `--help`-like commands
function fnames {
    local exit_code=0
    __fnames_cmd
    return $exit_code
}
