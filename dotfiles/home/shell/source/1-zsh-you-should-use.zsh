if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  [[ -f "$HOME/repos/zsh-you-should-use/you-should-use.plugin.zsh" ]] && source "$HOME/repos/zsh-you-should-use/you-should-use.plugin.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  [[ -f "$(brew --prefix)/share/zsh-you-should-use/you-should-use.plugin.zsh" ]] && source "$(brew --prefix)/share/zsh-you-should-use/you-should-use.plugin.zsh"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
