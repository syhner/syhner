if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  source_if_exists /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source_if_exists $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
