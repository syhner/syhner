if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zmodload zsh/zprof
fi

# Globs that don't match anything should be silent
setopt NULL_GLOB

source "$HOME/.shrc"
for dir in "$HOME/source-"*; do
  for file in "$dir/"*.zsh; do
    if [[ -f "$file" ]]; then
      source "$file"
    fi
  done
done

if [[ -n $DEBUG_ZSH_STARTUP ]]; then
  zprof
fi
