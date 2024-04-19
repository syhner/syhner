if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  alias bat="batcat"
fi

if ! command -v bat &>/dev/null; then
  return
fi

# Syntax highlighting for man pages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Use bat instead of cat
export NULLCMD=bat

export BAT_THEME="tokyonight_night"
