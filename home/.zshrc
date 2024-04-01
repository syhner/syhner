if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

# config here

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
