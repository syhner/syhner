if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  [[ -f "$HOME/repos/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$HOME/repos/zsh-history-substring-search/zsh-history-substring-search.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  [[ -f "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
