if [[ $(current_shell) == "bash" ]]; then
  eval "$(zoxide init bash)"
elif [[ $(current_shell) == "zsh" ]]; then
  eval "$(zoxide init zsh)"
fi
