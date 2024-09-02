source "$HOME/source/0-functions.sh"
source_home zshenv

#AWSume alias to source the AWSume script
alias awsume="source \$(pyenv which awsume)"

#Auto-Complete function for AWSume
#Auto-Complete function for AWSume
fpath=(~/.awsume/zsh-autocomplete/ $fpath)
