if ! command -v trash &>/dev/null; then
  return
fi

# Safer rm
alias rm="trash"
