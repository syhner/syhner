# Syntax highlighting for man pages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Use bat instead of cat
export NULLCMD=bat
