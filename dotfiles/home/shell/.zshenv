# DEBUG_ZSH_STARTUP=1
[[ -n $DEBUG_ZSH_STARTUP ]] && zmodload zsh/zprof

source "$HOME/source/1-homebrew.zshenv"

# AWSume alias to source the AWSume script
alias awsume="source \$(pyenv which awsume)"
# Auto-Complete function for AWSume
fpath=(~/.awsume/zsh-autocomplete/ $fpath)
