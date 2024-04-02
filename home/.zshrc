if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

autoload -Uz compinit
compinit

source "$HOME/util/functions.sh"

source "$HOME/modules/bat.zshrc"
source "$HOME/modules/bun.zshrc"
source "$HOME/modules/fnm.zshrc"
source "$HOME/modules/git.zshrc"
source "$HOME/modules/powerlevel10k.zshrc"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
