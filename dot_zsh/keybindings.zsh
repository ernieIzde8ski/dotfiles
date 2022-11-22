#!/bin/zsh

## note: "\e" expands out to '^[', I think

# del:        delete forward character
bindkey "\e[3~" delete-char
# ctrl+del:   delete forward word
bindkey "\e[3;5~" kill-word
# ctrl+left:  backwards one word
bindkey "\e[1;5D" backward-word
# ctrl+right: forwards one word
bindkey "\e[1;5C" forward-word
# ctrl+back:  delete backwards one word
bindkey "^H" backward-delete-word
