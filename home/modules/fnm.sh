eval "$(fnm env --use-on-cd)"

# Completions
if [[ "$SHELL" == *"bash" ]]; then
  eval "$(fnm completions --shell bash)"
elif [[ "$SHELL" == *"zsh" ]]; then
  eval "$(fnm completions --shell zsh)"
fi
