#!/bin/bash

# shellcheck source=/dev/null
source "$HOME/source/0-config.bash"
source "$HOME/source/0-aliases.sh"
source "$HOME/source/0-config.sh"
source "$HOME/source/0-functions.sh"
source "$HOME/source/1-bat.sh"
source "$HOME/source/1-bun.sh"
source "$HOME/source/1-eza.sh"
source "$HOME/source/1-fnm.sh"
source "$HOME/source/1-fzf.sh"
source "$HOME/source/1-git.sh"
source "$HOME/source/1-neovim.sh"
source "$HOME/source/1-pyenv.sh"
source "$HOME/source/1-thefuck.sh"
source "$HOME/source/1-trash-cli.sh"
source "$HOME/source/1-yazi.sh"
source "$HOME/source/1-zellij.sh"
source "$HOME/source/1-zoxide.sh"

#AWSume alias to source the AWSume script
alias awsume="source \$(pyenv which awsume)"

#Auto-Complete function for AWSume
_awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"
    opts=$(awsume-autocomplete)
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0
}
complete -F _awsume awsume
