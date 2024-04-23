if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  source_if_exists "$HOME/repos/zsh-you-should-use/you-should-use.plugin.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source_if_exists $(brew --prefix)/share/zsh-you-should-use/you-should-use.plugin.zsh
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
