#!/bin/zsh

# this code heavily relies on prompt expansion, as documented here:
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion


# make sure Python venvs don't override the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1


function prompt_exit_code {
  if [[ $? -eq 0 ]]; then
    echo -n "%F{green}%?%f"
  else
    echo -n "%F{red}%?%f"
  fi
}

function prompt_venv {
  if [[ -v VIRTUAL_ENV ]]; then
    echo -n "%F{yellow}(venv) %f"
  fi
}

function prompt_workstation {
  # printing out red for root, cyan for anyone else
  if [[ $UID -eq 0 ]]; then
    c_main="%F{cyan}"
    c_alt="%F{red}"
  else
    c_main="%F{blue}"
    c_alt="%F{cyan}"
  fi

  echo -n "${c_main}%n${c_alt}@"
  echo -n "${c_main}%m${c_alt}::"
  echo -n "${c_main}%1~${c_alt}%# %f"
}

# with this option, we can delay evaluation using "\$(command)" syntax
setopt prompt_subst

PROMPT="[%F{magenta}%L%f \$(prompt_exit_code)] \$(prompt_venv)$(prompt_workstation)"
