if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

source "$HOME/zsh/powerlevel10k.zsh"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
