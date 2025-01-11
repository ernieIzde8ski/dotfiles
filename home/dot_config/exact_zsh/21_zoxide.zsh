#!/bin/zsh


if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"

    # Alias so that I can use `z` in scripts easily, falling back to `cd`.
    #
    # It would be valid to override the builtins: `alias cd=z`
    # since internally, `__zoxide_cd` is defined as `\builtin cd -- "$@"`,
    # but that's just not something I want to do.
    alias zcd=z

    function __dotfiles_pushz_emit_help() {
        echo -n "usage: $1" 1>&2
        echo -n ' [<pushd-flag | "-h" | "--help" | "--debug">...]' 1>&2
        echo ' [--] [<z-argument>...]\n' 1>&2

        echo 'options:'
        echo "\t pushd-flag"
        echo "\t\t Adds a flag to send to pushd. Must begin with a hyphen."
        echo "\t z-argument"
        echo "\t\t Adds an argument to send to z."
        echo "\t -h, --help"
        echo "\t\t Displays this message."
        echo "\t --debug"
        echo "\t\t Halts evaluation of pushz after option interpretation."
        echo "\t\t Displays arguments that would be used."
    }

    # push directory
    function pushz() {
        local origin="$PWD"
        local target=""
        local pushd_flags=()
        local z_arguments=()

        local debug=false
        local evaluate_flags=true

        for argument in "$@"; do
            if [[ "$evaluate_flags" == false ]]; then
                z_arguments+=("$argument")
            elif [[ "$argument" == "--" ]]; then
                evaluate_flags=false
            elif [[ "$argument" == "-h" || "$argument" == "--help" ]]; then
                __dotfiles_pushz_emit_help "$0"
                return 0
            elif [[ "$argument" == '--debug' ]]; then
                debug=true
            elif [[ "$argument" =~ '[-\+][0123456789]+' ]]; then
                echo 'the `-+{N}` operator is not supported' 1>&2
                return 1
            elif [[ "$argument" == '-'* ]]; then
                pushd_flags+=("$argument")
            else
                z_arguments+=("$argument")
                evaluate_flags=false
            fi
        done

        if [[ $debug == true ]]; then
            echo "origin=${origin}"
            echo "pushd_flags=$(printf '%q ' "${pushd_flags[@]}")"
            echo "z_arguments=$(printf '%q ' "${z_arguments[@]}")"
            return 0
        fi

        z "$z_arguments[@]" && {
            target="$PWD"
            \builtin cd "$origin"
            \builtin pushd "$pushd_flags[@]" "$target"
        }
    }
    # pop directory, complimenting pushz
    alias popz='popd'
else
    alias zcd=cd
    alias pushz=pushd
    alias popz=popd
fi

alias zc=pushz
alias zp=popz
