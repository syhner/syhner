if ! command -v thefuck &>/dev/null; then
  return
fi

eval $(thefuck --alias fix)
