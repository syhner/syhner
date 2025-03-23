if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
