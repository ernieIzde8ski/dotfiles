#!/bin/zsh

# colors, if the current terminal supports them
if [[ $(tput colors 2>/dev/null) -ge 8 ]]; then
  NORMAL="$(tput sgr0)"
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  MAGENTA="$(tput setaf 5)"
  CYAN="$(tput setaf 6)"
  WHITE="$(tput setaf 7)"
fi

shlvl="$MAGENTA$SHLVL$NORMAL"
venv_notice="$YELLOW(venv) $NORMAL"

if [[ $UID -eq 0 ]]; then
  user="$RED$USER$NORMAL"
else
  user="$CYAN$USER$NORMAL"
fi

function colorize_prompt {
  exit_code="$?"
  if [[ "$exit_code" -eq '0' ]]; then
    exit_code="$GREEN$exit_code$NORMAL"
  else
    exit_code="$RED$exit_code$NORMAL"
  fi

  if [[ -v VIRTUAL_ENV ]]; then
    venv=$venv_notice
  else
    venv=""
  fi

  export PS1="[$shlvl ${exit_code}] $venv$user$BLUE@$CYAN%m$BLUE%# $NORMAL"
}

precmd_functions+=( colorize_prompt )
