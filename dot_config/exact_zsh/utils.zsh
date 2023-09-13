#!/bin/zsh
# Useful commands and aliases in this file

# size some files
alias sizeof="du -sh --"
# size directory contents, excluding those below a gigabyte
alias sizeup="du -ach --threshold 1G --max-depth 1 --"
# size directory contents, excluding only very small files 
alias sizeupall="du -ach --threshold 40K --max-depth 1 --"
