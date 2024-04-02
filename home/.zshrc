if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

autoload -Uz compinit && compinit
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix
# load bashcompinit for some old bash completions
autoload bashcompinit && bashcompinit

source "$HOME/.shrc"

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
