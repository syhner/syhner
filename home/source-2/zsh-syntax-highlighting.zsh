if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  source_if_exists /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source_if_exists $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
