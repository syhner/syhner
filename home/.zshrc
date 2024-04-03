if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

source "$HOME/.shrc"
for file in "$HOME/source-0/"*.zsh; do
  source "$file"
done
for file in "$HOME/source-1/"*.zsh; do
  source "$file"
done

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
