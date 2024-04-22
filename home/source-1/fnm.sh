if [ -d "$HOME/.fnm" ]; then
  export PATH="$HOME/.fnm:$PATH"
elif [ -n "$XDG_DATA_HOME" ]; then
  export PATH="$XDG_DATA_HOME/fnm:$PATH"
else
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

if ! command -v fnm &>/dev/null; then
  return
fi

eval "$(fnm env --use-on-cd)"

# Completions
if [[ $(current_shell) == "bash" ]]; then
  eval "$(fnm completions --shell bash)"
elif [[ $(current_shell) == "zsh" ]]; then
  eval "$(fnm completions --shell zsh)"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
elif [[ "$OSTYPE" == "msys" ]]; then
  export PNPM_HOME="$HOME/AppData/Local/pnpm"
fi
export PATH="$PNPM_HOME:$PATH"

alias pnpx="pnpm dlx"
