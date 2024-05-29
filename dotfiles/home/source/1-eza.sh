if ! command -v eza &>/dev/null; then
  return
fi

alias ls="eza --group-directories-first"
