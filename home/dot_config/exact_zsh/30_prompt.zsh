#!/bin/zsh

# this code heavily relies on prompt expansion, as documented here:
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion

# make sure Python venvs don't override the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

function prompt_venv {
  if [[ -v VIRTUAL_ENV ]]; then
    echo -n "%F{yellow}(venv) %f"
  fi
}

function prompt_workstation {
  # printing out red for root, green for anyone else
  if [[ $UID -eq 0 ]]; then
    user_color="%F{red}"
  else
    user_color="%F{blue}"
  fi

  echo -n "${user_color}%n%F{green}@"
  echo -n "${user_color}%m%F{green}::"
  echo -n "${user_color}%1~%F{green}%# %f"
}

# with this option, we can delay evaluation using "\$(command)" syntax
setopt prompt_subst

precmd() {
  code=$?
  if ! [[ $code -eq 0 || $code -eq 130 ]]; then
    print "Process exited with code $code"
  fi
}

PROMPT="[%F{magenta}%L%f] \$(prompt_venv)$(prompt_workstation)"
