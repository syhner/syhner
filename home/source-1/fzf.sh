if ! command -v fzf &>/dev/null; then
  return
fi

# Completions
if [[ $(current_shell) == "bash" ]]; then
  eval "$(fzf --bash)"
elif [[ $(current_shell) == "zsh" ]]; then
  eval "$(fzf --zsh)"
fi
