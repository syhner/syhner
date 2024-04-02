if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

source "$HOME/.shrc"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
