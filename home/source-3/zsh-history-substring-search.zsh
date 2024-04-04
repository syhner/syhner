if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  source_if_exists "$HOME/zsh-history-substring-search/zsh-history-substring-search.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source_if_exists $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
