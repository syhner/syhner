if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  export PATH="$HOME/.bun/bin:$PATH"
fi

# Completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
