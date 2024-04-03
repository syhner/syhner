if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

source "$HOME/source-0/functions.sh"
source_home sh
source_home zsh

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
