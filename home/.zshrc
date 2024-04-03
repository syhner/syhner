if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

source "$HOME/.shrc"
source_home zsh

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
