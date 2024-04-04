# Completions
if [[ $(current_shell) == "bash" ]]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    source_if_exists "$HOME/.fzf.bash"
  elif command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
  fi
elif [[ $(current_shell) == "zsh" ]]; then
  if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
    source_if_exists "$HOME/.fzf.zsh"
  elif command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
  fi
fi
