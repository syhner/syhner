if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  source "$HOME/zsh-history-substring-search/zsh-history-substring-search.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
