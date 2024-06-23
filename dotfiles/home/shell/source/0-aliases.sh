#! /usr/bin/env bash

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cmd="command"

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  alias copy_command="xclip -selection clipboard"
  alias paste_command="xclip -selection clipboard -o"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias copy_command="pbcopy"
  alias paste_command="pbpaste"
elif [[ "$OSTYPE" == "msys" ]]; then
  alias copy_command="clip"
  alias paste_command="paste"
fi

alias cwd="pwd | copy_command"
alias exitcode="echo \$?"
alias mkdir="mkdir -p"
alias sudo="sudo " # Allow aliases to be sudoed
alias x="exit"
