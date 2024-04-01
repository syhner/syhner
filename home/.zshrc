if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

autoload -Uz compinit
compinit

source "$HOME/util/functions.sh"

source "$HOME/packages/bat.zshrc"
source "$HOME/packages/bun.zshrc"
source "$HOME/packages/git.zshrc"
source "$HOME/packages/powerlevel10k.zshrc"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
