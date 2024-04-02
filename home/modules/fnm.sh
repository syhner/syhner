if [ -d "$HOME/.fnm" ]; then
  export PATH="$HOME/.fnm:$PATH"
elif [ -n "$XDG_DATA_HOME" ]; then
  export PATH="$XDG_DATA_HOME/fnm:$PATH"
else
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

eval "$(fnm env --use-on-cd)"

# Completions
if [[ "$SHELL" == *"bash" ]]; then
  eval "$(fnm completions --shell bash)"
elif [[ "$SHELL" == *"zsh" ]]; then
  eval "$(fnm completions --shell zsh)"
fi
