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

if [[ $UID -eq 0 ]]; then
  user="$RED$USER$NORMAL"
else
  user="$CYAN$USER$NORMAL"
fi

function colorize_prompt {
  if [[ $? -eq 0 ]]; then
    exit_code="$GREEN$?$NORMAL"
  else
    exit_code="$RED$?$NORMAL"
  fi

  export PS1="[$shlvl ${exit_code}] $user$BLUE@$CYAN%m$BLUE%# $NORMAL"
}

precmd_functions+=( colorize_prompt )
