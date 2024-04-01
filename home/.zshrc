if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

autoload -Uz compinit
compinit

source "$HOME/packages/powerlevel10k.zshrc"
source "$HOME/packages/git.zshrc"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
