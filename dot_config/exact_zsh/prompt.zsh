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
  GRAY="$(tput setaf 8)"

  # makes sure command output is uncolored
  function preexec {
    echo -n $NORMAL
  }
fi

prompt_shlvl="$MAGENTA$SHLVL$NORMAL"

function prompt_exit_code {
  if [[ $? -eq 0 ]]; then
    echo -n "$GREEN$?$NORMAL"
  else
    echo -n "$RED$?$NORMAL"
  fi
}

function prompt_venv {
  if [[ -v VIRTUAL_ENV ]]; then
    echo -n "$YELLOW(venv) $NORMAL"
  fi
}

function prompt_workstation {
  # printing out red for root, cyan for anyone else
  if [[ $UID -eq 0 ]]; then
    echo -n $RED
  else
    echo -n $CYAN
  fi

  echo -n "$USER$BLUE@$CYAN%m$BLUE%#"
}

# make sure Python venvs don't override the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# with this opt, we can delay evaluation using "\$(command)" syntax
setopt prompt_subst
PROMPT="[${prompt_shlvl} \$(prompt_exit_code)] \$(prompt_venv)$(prompt_workstation) ${GRAY}"
