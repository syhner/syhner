if ! command -v zoxide &>/dev/null; then
  return
fi

if [[ $(current_shell) == "bash" ]]; then
  eval "$(zoxide init bash)"
elif [[ $(current_shell) == "zsh" ]]; then
  eval "$(zoxide init zsh)"
fi
