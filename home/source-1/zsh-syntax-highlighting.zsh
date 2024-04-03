if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
