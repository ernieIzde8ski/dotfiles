#!/bin/zsh


alias cvim="nvim --clean"

function dvim() (
    set -e

    dvim_parent="${XDG_CONFIG_HOME}"
    dvim_caname='nvim-devel'
    dvim_target="${dvim_parent}/${dvim_osname}"
    dvim_source='https://github.com/ernieIzde8ski/dotfiles.nvim'

    nvim_target="${XDG_CONFIG_HOME}/nvim"

    if [[ ! -d "${dvim_target}" ]]; then
        git -C "${dvim_parent}" clone "${dvim_source}" "${dvim_caname}"

        if [[ -d "${nvim_target}" ]]; then
            git -C "${nvim_target}" remote add "file://${dvim_target}"
        fi
    fi

    NVIM_APPNAME="${dvim_caname}" nvim "$@"
)
