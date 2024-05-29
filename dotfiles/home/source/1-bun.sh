if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  export PATH="$HOME/.bun/bin:$PATH"
fi

# Completions
source_if_exists "$HOME/.bun/_bun"
